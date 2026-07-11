#!/usr/bin/env python3
"""Reproduce the PAW Noir crack's collision with clock-owned RAM.

The PAW Noir Laxity crack uses $C300-$C3FF, $CD00-$CD7F and $CFE0-$CFFF while
its intro is active. The old clock ROM also stored state at $CFF3-$CFF7, so
KERNAL hooks could alter crack-owned bytes before user ML code even started.
"""
import os
import sys

import harness as H


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PLAIN_ROM = os.path.join(ROOT, "kernal", "rom", "dolffy.rom")
ULTIMATE_ROM = os.path.join(ROOT, "kernal", "rom", "dolffy-ultimate.rom")

CODE_ADDR = 0xC000
RESULT_ADDR = 0x02F0
PAW_STATE_ADDR = 0xCFF3
PAW_STATE = bytes([0x1A, 0x49, 0x09, 0x4D, 0x18])

SNAPSHOT_CODE = bytes([
    0xA2, 0x00,                                      # ldx #0
    0xBD, PAW_STATE_ADDR & 0xFF, PAW_STATE_ADDR >> 8, # lda $cff3,x
    0x9D, RESULT_ADDR & 0xFF, RESULT_ADDR >> 8,       # sta result,x
    0xE8,                                            # inx
    0xE0, len(PAW_STATE),                            # cpx #len
    0xD0, 0xF5,                                      # bne loop
    0x60,                                            # rts
])


def run_case(name, kernal, workdir, expect_clock):
    disk = os.path.join(workdir, f"clock_paw_collision_{name}.d64")
    H.make_disk(disk, H.ramp_prg(0x0801, 16), name="dummy")

    v = H.Vice(disk, kernal=kernal, video=os.environ.get("VIDEO", "pal"))
    try:
        v.memset(CODE_ADDR, SNAPSHOT_CODE)
        v.memset(RESULT_ADDR, b"\x00" * len(PAW_STATE))

        v.memset(0xC300, bytes((i * 17 + 3) & 0xFF for i in range(0x100)))
        v.memset(0xCD00, bytes((i * 29 + 5) & 0xFF for i in range(0x80)))
        v.memset(0xCFE0, bytes((i * 7 + 0x31) & 0xFF for i in range(0x20)))
        v.memset(PAW_STATE_ADDR, PAW_STATE)

        v.type_line(f"SYS{CODE_ADDR}")
        v.free_run(H.env_float("SETTLE", 0.5))
        got = bytes(v.memget(RESULT_ADDR, RESULT_ADDR + len(PAW_STATE) - 1))
        live = bytes(v.memget(PAW_STATE_ADDR, PAW_STATE_ADDR + len(PAW_STATE) - 1))
        # Positive precondition: on the Ultimate build the clock must actually be
        # running (sprites on, raster IRQ armed) for "did not touch $CFF3" to mean
        # anything. A build whose clock never runs cannot pass this.
        clock_live = v.g(0xD015) != 0 and (v.g(0xD01A) & 0x01) != 0
    finally:
        v.close()

    intact = got == PAW_STATE and live == PAW_STATE
    ok = intact and (clock_live or not expect_clock)
    return ok, got, live, clock_live


def main():
    workdir = H.tempdir()
    fails = 0
    print(f"work = {workdir}")
    for name, kernal, expect_clock in [("plain", PLAIN_ROM, False), ("ultimate", ULTIMATE_ROM, True)]:
        ok, got, live, clock_live = run_case(name, kernal, workdir, expect_clock)
        if not ok:
            fails += 1
        clock = "live" if clock_live else ("off" if not expect_clock else "NOT-LIVE")
        print(
            f"{name:<8} {'PASS' if ok else 'FAIL'} clock={clock} "
            f"saw={got.hex(' ')} live={live.hex(' ')}"
        )
    sys.exit(1 if fails else 0)


if __name__ == "__main__":
    main()
