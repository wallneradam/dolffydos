#!/usr/bin/env python3
"""Reproduce clock-ROM state leakage with a minimal user program.

The test models a normal BASIC-to-ML handoff, not a specific game:

  1. BASIC code sets the user's VIC colors to black.
  2. A later BASIC line enters ML through SYS.
  3. The ML code immediately snapshots VIC/IRQ state.

The KERNAL must not restore the clock's saved background color or otherwise
reassert visible clock state while handing control to user code.
"""
import os
import sys

import harness as H


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PLAIN_ROM = os.path.join(ROOT, "kernal", "rom", "dolffy.rom")
ULTIMATE_ROM = os.path.join(ROOT, "kernal", "rom", "dolffy-ultimate.rom")

CODE_ADDR = 0xC000
RESULT_ADDR = 0xC100

SNAPSHOT_CODE = bytes([
    0xAD, 0x20, 0xD0, 0x8D, 0x00, 0xC1,  # lda $d020 / sta $c100
    0xAD, 0x21, 0xD0, 0x8D, 0x01, 0xC1,  # lda $d021 / sta $c101
    0xAD, 0x11, 0xD0, 0x8D, 0x02, 0xC1,  # lda $d011 / sta $c102
    0xAD, 0x15, 0xD0, 0x8D, 0x03, 0xC1,  # lda $d015 / sta $c103
    0xAD, 0x1A, 0xD0, 0x8D, 0x04, 0xC1,  # lda $d01a / sta $c104
    0xAD, 0x14, 0x03, 0x8D, 0x05, 0xC1,  # lda $0314 / sta $c105
    0xAD, 0x15, 0x03, 0x8D, 0x06, 0xC1,  # lda $0315 / sta $c106
    0xA9, 0x42, 0x8D, 0x07, 0xC1,        # marker
    0x60,                                # rts
])


FIELDS = ("d020", "d021", "d011", "d015", "d01a", "irq_lo", "irq_hi", "marker")


def run_case(name, kernal, workdir, expect_clock):
    disk = os.path.join(workdir, f"clock_state_{name}.d64")
    H.make_disk(disk, H.ramp_prg(0x0801, 16), name="dummy")

    v = H.Vice(disk, kernal=kernal, video=os.environ.get("VIDEO", "pal"))
    try:
        v.memset(CODE_ADDR, SNAPSHOT_CODE)
        v.memset(RESULT_ADDR, bytes([0]) * len(FIELDS))

        v.type_line("POKE53280,0:POKE53281,0")
        v.free_run(H.env_float("SETTLE", 0.5))
        before = {"d020": v.g(0xD020), "d021": v.g(0xD021)}

        v.type_line(f"SYS{CODE_ADDR}")
        v.free_run(H.env_float("SETTLE", 0.5))
        raw = bytes(v.memget(RESULT_ADDR, RESULT_ADDR + len(FIELDS) - 1))
    finally:
        v.close()

    got = dict(zip(FIELDS, raw))
    # Positive precondition: on the Ultimate build the border clock must actually
    # be live (sprites enabled and the raster IRQ armed) at handoff. Without this
    # the "colors untouched" check below would pass on a build whose clock never
    # runs, proving nothing.
    clock_live = got.get("d015", 0) != 0 and (got.get("d01a", 0) & 0x01) != 0
    handoff_ok = (
        got.get("marker") == 0x42
        and (got.get("d020", 0) & 0x0F) == 0
        and (got.get("d021", 0) & 0x0F) == 0
    )
    ok = handoff_ok and (clock_live or not expect_clock)
    return ok, before, got, clock_live


def main():
    workdir = H.tempdir()
    cases = [
        ("plain", PLAIN_ROM, False),
        ("ultimate", ULTIMATE_ROM, True),
    ]
    fails = 0
    print(f"work = {workdir}")
    for name, kernal, expect_clock in cases:
        ok, before, got, clock_live = run_case(name, kernal, workdir, expect_clock)
        if not ok:
            fails += 1
        irq = (got.get("irq_hi", 0) << 8) | got.get("irq_lo", 0)
        clock = "live" if clock_live else ("off" if not expect_clock else "NOT-LIVE")
        print(
            f"{name:<8} {'PASS' if ok else 'FAIL'} clock={clock} "
            f"before d020/d021=${before['d020']:02x}/${before['d021']:02x} "
            f"sys d020/d021=${got.get('d020', 0):02x}/${got.get('d021', 0):02x} "
            f"colors={got.get('d020', 0) & 0x0f}/{got.get('d021', 0) & 0x0f} "
            f"d011=${got.get('d011', 0):02x} d015=${got.get('d015', 0):02x} "
            f"d01a=${got.get('d01a', 0):02x} irq=${irq:04x} "
            f"marker=${got.get('marker', 0):02x}"
        )
    sys.exit(1 if fails else 0)


if __name__ == "__main__":
    main()
