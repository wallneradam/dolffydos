#!/usr/bin/env python3
"""Reproduce clock re-arming itself after an I/O watchdog timeout.

The clock may switch to stock/CIA IRQ mode around disk I/O, but the timeout must
not re-enable the raster clock while a user program is still active. Re-arming
belongs to the BASIC main-loop hook only.
"""
import os
import sys

import harness as H


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ULTIMATE_ROM = os.path.join(ROOT, "kernal", "rom", "dolffy-ultimate.rom")

CLK_MODE = 0x033F
CLK_BUSY = 0x0340
CLK_IRQ = 0xFECB


def main():
    workdir = H.tempdir()
    disk = os.path.join(workdir, "clock_watchdog_lock.d64")
    H.make_disk(disk, H.ramp_prg(0x0801, 16), name="dummy")

    v = H.Vice(disk, kernal=ULTIMATE_ROM, video=os.environ.get("VIDEO", "pal"))
    try:
        v.memset(0xD020, b"\x00")           # user program wants black border
        v.memset(0xD021, b"\x00")           # and black background
        v.memset(0xD015, b"\x00")           # with sprites off
        v.memset(0xD01A, b"\x00")           # stock/CIA mode: no VIC IRQ enable
        v.memset(0xD019, b"\x01")
        v.memset(0x0314, bytes([CLK_IRQ & 0xFF, CLK_IRQ >> 8]))
        v.memset(CLK_MODE, b"\x01")         # simulate CLK_ENTER's stock/I/O mode
        v.memset(CLK_BUSY, b"\x01")         # expire on the next CIA IRQ tick
        v.memset(0xDC0D, b"\x81")           # enable CIA Timer-A IRQ

        v.free_run(float(os.environ.get("SETTLE", "0.5")))

        mode = v.g(CLK_MODE)
        d01a = v.g(0xD01A)
        d020 = v.g(0xD020)
        d021 = v.g(0xD021)
        d015 = v.g(0xD015)
        irq = v.g(0x0314) | (v.g(0x0315) << 8)
    finally:
        v.close()

    ok = (mode & 0x80) != 0 and (d01a & 0x01) == 0 and (d020 & 0x0F) == 0 and (d021 & 0x0F) == 0 and d015 == 0
    print(f"work = {workdir}")
    print(
        f"{'PASS' if ok else 'FAIL'} "
        f"mode=${mode:02x} d01a=${d01a:02x} d020/d021=${d020:02x}/${d021:02x} "
        f"d015=${d015:02x} irq=${irq:04x}"
    )
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
