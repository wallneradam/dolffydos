#!/usr/bin/env python3
"""Guard the Ultimate clock handoff for BASIC RUN.

RUN must hand user code a stock/CIA IRQ environment. Leaving the clock IRQ
vector active lets user programs that reuse the clock's RAM state accidentally
re-enter the clock raster path.
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
    0xAD, 0x14, 0x03, 0x8D, 0x00, 0xC1,  # lda $0314 / sta $c100
    0xAD, 0x15, 0x03, 0x8D, 0x01, 0xC1,  # lda $0315 / sta $c101
    0xAD, 0x1A, 0xD0, 0x8D, 0x02, 0xC1,  # lda $d01a / sta $c102
    0xAD, 0x3F, 0x03, 0x8D, 0x03, 0xC1,  # lda $033f / sta $c103
    0xA9, 0x42, 0x8D, 0x04, 0xC1,        # marker
    0x60,                                # rts
])


def run_case(name, kernal, workdir):
    disk = os.path.join(workdir, f"clock_run_handoff_{name}.d64")
    H.make_disk(disk, H.ramp_prg(0x0801, 16), name="dummy")

    v = H.Vice(disk, kernal=kernal, video=os.environ.get("VIDEO", "pal"))
    try:
        v.memset(CODE_ADDR, SNAPSHOT_CODE)
        v.memset(RESULT_ADDR, b"\x00" * 5)
        v.type_line(f"10 SYS{CODE_ADDR}")
        v.free_run(float(os.environ.get("SETTLE", "0.3")))
        v.type_line("RUN")
        v.free_run(float(os.environ.get("SETTLE", "0.5")))
        raw = bytes(v.memget(RESULT_ADDR, RESULT_ADDR + 4))
    finally:
        v.close()

    irq = raw[0] | (raw[1] << 8)
    ok = raw[4] == 0x42 and irq == 0xEA31 and (raw[2] & 0x01) == 0
    return ok, irq, raw


def main():
    workdir = H.tempdir()
    fails = 0
    print(f"work = {workdir}")
    for name, kernal in (("plain", PLAIN_ROM), ("ultimate", ULTIMATE_ROM)):
        ok, irq, raw = run_case(name, kernal, workdir)
        if not ok:
            fails += 1
        print(
            f"{name:<8} {'PASS' if ok else 'FAIL'} "
            f"irq=${irq:04x} d01a=${raw[2]:02x} mode=${raw[3]:02x} "
            f"marker=${raw[4]:02x}"
        )
    sys.exit(1 if fails else 0)


if __name__ == "__main__":
    main()
