#!/usr/bin/env python3
"""Reproduce stale stock IRQ vector leakage at the BASIC prompt.

The test models a user program that restores the normal KERNAL IRQ vector and
then returns to BASIC. The clock ROM may re-enable its raster IRQ at READY, but
it must first restore the IRQ vector to the clock handler; otherwise the VIC
raster interrupt enters the stock CIA IRQ handler, leaves $D019 uncleared, and
the machine stops making BASIC progress.
"""
import os
import sys

import harness as H


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PLAIN_ROM = os.path.join(ROOT, "kernal", "rom", "dolffy.rom")
ULTIMATE_ROM = os.path.join(ROOT, "kernal", "rom", "dolffy-ultimate.rom")

INSTALL_ADDR = 0xC000
RESULT_ADDR = 0xC100

INSTALL_CODE = bytes([
    0xA9, 0x31, 0x8D, 0x14, 0x03,                  # lda #<$ea31 / sta $0314
    0xA9, 0xEA, 0x8D, 0x15, 0x03,                  # lda #>$ea31 / sta $0315
    0xA9, 0x00, 0x8D, 0x1A, 0xD0,                  # lda #0 / sta $d01a
    0xA9, 0x01, 0x8D, 0x19, 0xD0,                  # lda #1 / sta $d019
    0xA9, 0x00, 0x8D, RESULT_ADDR & 0xFF, RESULT_ADDR >> 8,
    0x60,                                          # rts
])


def run_case(name, kernal, workdir):
    disk = os.path.join(workdir, f"clock_irq_vector_{name}.d64")
    H.make_disk(disk, H.ramp_prg(0x0801, 16), name="dummy")

    v = H.Vice(disk, kernal=kernal, video=os.environ.get("VIDEO", "pal"))
    try:
        v.memset(INSTALL_ADDR, INSTALL_CODE)
        v.memset(RESULT_ADDR, b"\x00")

        v.type_line(f"SYS{INSTALL_ADDR}")
        v.free_run(float(os.environ.get("SETTLE", "0.5")))

        v.type_line(f"POKE{RESULT_ADDR},85")
        v.free_run(float(os.environ.get("SETTLE", "0.5")))
        result = v.g(RESULT_ADDR)
        d01a = v.g(0xD01A)
        irq_lo = v.g(0x0314)
        irq_hi = v.g(0x0315)
    finally:
        v.close()

    return result == 85, result, d01a, (irq_hi << 8) | irq_lo


def main():
    workdir = H.tempdir()
    cases = [
        ("plain", PLAIN_ROM),
        ("ultimate", ULTIMATE_ROM),
    ]
    fails = 0
    print(f"work = {workdir}")
    for name, kernal in cases:
        ok, result, d01a, irq = run_case(name, kernal, workdir)
        if not ok:
            fails += 1
        print(
            f"{name:<8} {'PASS' if ok else 'FAIL'} "
            f"result=${result:02x} d01a=${d01a:02x} irq=${irq:04x}"
        )
    sys.exit(1 if fails else 0)


if __name__ == "__main__":
    main()
