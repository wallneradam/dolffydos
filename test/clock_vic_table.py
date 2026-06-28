#!/usr/bin/env python3
"""Reproduce PAW Noir's SPACE-exit use of the KERNAL VIC init table."""
import os
import sys

import harness as H


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PLAIN_ROM = os.path.join(ROOT, "kernal", "rom", "dolffy.rom")
ULTIMATE_ROM = os.path.join(ROOT, "kernal", "rom", "dolffy-ultimate.rom")

CODE_ADDR = 0xC000
RESULT_ADDR = 0xC100

SPACE_EXIT_CODE = bytes([
    0xA9, 0x01, 0x8D, 0x86, 0x02,              # lda #1 / sta $0286
    0x8D, 0x20, 0xD0, 0x8D, 0x21, 0xD0,        # sta $d020 / sta $d021
    0x20, 0x36, 0xE5,                          # jsr $e536
    0xA2, 0x1F,                                # ldx #$1f
    0x20, 0xAA, 0xE5,                          # jsr $e5aa
    0x8D, RESULT_ADDR & 0xFF, RESULT_ADDR >> 8,
    0x8D, 0x20, 0xD0, 0x8D, 0x21, 0xD0,        # sta $d020 / sta $d021
    0xA2, 0x10,                                # ldx #$10
    0xBD, 0x00, 0xD0,                          # lda $d000,x
    0x9D, (RESULT_ADDR + 1) & 0xFF, (RESULT_ADDR + 1) >> 8,
    0xCA,                                      # dex
    0x10, 0xF7,                                # bpl loop
    0x60,                                      # rts
])


def run_case(name, kernal, workdir):
    disk = os.path.join(workdir, f"clock_vic_table_{name}.d64")
    H.make_disk(disk, H.ramp_prg(0x0801, 16), name="dummy")

    v = H.Vice(disk, kernal=kernal, video=os.environ.get("VIDEO", "pal"))
    try:
        v.memset(CODE_ADDR, SPACE_EXIT_CODE)
        v.memset(RESULT_ADDR, b"\xff")
        v.type_line(f"SYS{CODE_ADDR}")
        v.free_run(float(os.environ.get("SETTLE", "0.5")))
        result = v.g(RESULT_ADDR)
        sprite_regs = bytes(v.memget(RESULT_ADDR + 1, RESULT_ADDR + 0x11))
        d020 = v.g(0xD020)
        d021 = v.g(0xD021)
    finally:
        v.close()

    ok = (
        result == 0
        and sprite_regs == bytes([0] * 0x11)
        and (d020 & 0x0F) == 0
        and (d021 & 0x0F) == 0
    )
    return ok, result, sprite_regs, d020, d021


def main():
    workdir = H.tempdir()
    fails = 0
    print(f"work = {workdir}")
    for name, kernal in [("plain", PLAIN_ROM), ("ultimate", ULTIMATE_ROM)]:
        ok, result, sprite_regs, d020, d021 = run_case(name, kernal, workdir)
        if not ok:
            fails += 1
        print(
            f"{name:<8} {'PASS' if ok else 'FAIL'} "
            f"a=${result:02x} d000-d010={sprite_regs.hex(' ')} "
            f"d020/d021=${d020:02x}/${d021:02x}"
        )
    sys.exit(1 if fails else 0)


if __name__ == "__main__":
    main()
