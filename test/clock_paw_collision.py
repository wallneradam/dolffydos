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


def run_case(name, kernal, workdir):
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
        v.free_run(float(os.environ.get("SETTLE", "0.5")))
        got = bytes(v.memget(RESULT_ADDR, RESULT_ADDR + len(PAW_STATE) - 1))
        live = bytes(v.memget(PAW_STATE_ADDR, PAW_STATE_ADDR + len(PAW_STATE) - 1))
    finally:
        v.close()

    return got == PAW_STATE and live == PAW_STATE, got, live


def main():
    workdir = H.tempdir()
    fails = 0
    print(f"work = {workdir}")
    for name, kernal in [("plain", PLAIN_ROM), ("ultimate", ULTIMATE_ROM)]:
        ok, got, live = run_case(name, kernal, workdir)
        if not ok:
            fails += 1
        print(
            f"{name:<8} {'PASS' if ok else 'FAIL'} "
            f"saw={got.hex(' ')} live={live.hex(' ')}"
        )
    sys.exit(1 if fails else 0)


if __name__ == "__main__":
    main()
