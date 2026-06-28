#!/usr/bin/env python3
"""Guard against full clock reinit on an empty BASIC RETURN.

The BASIC main-loop hook must restore the clock after a real BASIC-to-user-code
handoff, but an empty prompt RETURN should not run the full sprite initializer.
"""
import os
import sys

import harness as H


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ULTIMATE_ROM = os.path.join(ROOT, "kernal", "rom", "dolffy-ultimate.rom")

CODE_ADDR = 0xC000
SPRITE_PTR = 0xC7FD


def main():
    workdir = H.tempdir()
    disk = os.path.join(workdir, "clock_empty_return.d64")
    H.make_disk(disk, H.ramp_prg(0x0801, 16), name="dummy")

    v = H.Vice(disk, kernal=ULTIMATE_ROM, video=os.environ.get("VIDEO", "pal"))
    try:
        v.memset(CODE_ADDR, b"\x60")  # RTS

        v.memset(SPRITE_PTR, b"\x55")
        v.type_line("")
        v.free_run(float(os.environ.get("SETTLE", "0.3")))
        after_empty = v.g(SPRITE_PTR)

        v.memset(SPRITE_PTR, b"\x55")
        v.type_line(f"SYS{CODE_ADDR}")
        v.free_run(float(os.environ.get("SETTLE", "0.5")))
        after_sys = v.g(SPRITE_PTR)
    finally:
        v.close()

    ok = after_empty == 0x55 and after_sys == 0x0D
    print(f"work = {workdir}")
    print(
        f"{'PASS' if ok else 'FAIL'} "
        f"empty_return_ptr=${after_empty:02x} sys_rearm_ptr=${after_sys:02x}"
    )
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
