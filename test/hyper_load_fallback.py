#!/usr/bin/env python3
"""VICE check for UCI-independent Hyper LOAD fallback through device 11."""

import os
import subprocess
import sys

import harness as H


ROMS = (
    os.path.join(H.ROOT, "kernal", "rom", "dolffy-hyper.rom"),
    os.path.join(H.ROOT, "kernal", "rom", "dolffy-hyper-quickrun.rom"),
)
LOAD_ADDR = 0x4001
PAYLOAD_SIZE = 256
FREERUN = float(os.environ.get("FREERUN", "5"))


def check_rom(rom, empty_disk, target_disk, expected):
    vice = H.Vice(
        empty_disk,
        kernal=rom,
        video="pal",
        extra_args=[
            "-drive11type", "1541",
            "-drive11truedrive",
            "-11", target_disk,
        ],
    )
    try:
        vice.erase(LOAD_ADDR, LOAD_ADDR + PAYLOAD_SIZE)
        vice.type_line("LOAD")
        vice.free_run(FREERUN)
        actual = vice.memget(LOAD_ADDR, LOAD_ADDR + PAYLOAD_SIZE - 1)
        assert actual == expected, "device-less LOAD did not reach device 11"
        assert H.READY in vice.screen(), "device-less LOAD did not return to READY"
    finally:
        vice.close()


def main():
    workdir = H.tempdir()
    empty_disk = os.path.join(workdir, "empty.d64")
    target_disk = os.path.join(workdir, "target.d64")
    subprocess.run(
        [H.C1541, "-format", "empty,01", "d64", empty_disk],
        check=True,
        capture_output=True,
    )
    prg = H.ramp_prg(LOAD_ADDR, PAYLOAD_SIZE)
    H.make_disk(target_disk, prg, name="target")
    expected = prg[2:]

    failed = False
    for rom in ROMS:
        try:
            check_rom(rom, empty_disk, target_disk, expected)
            print(f"PASS: {os.path.basename(rom)} LOAD 8 -> 9 -> 10 -> 11")
        except Exception as error:
            failed = True
            print(f"FAIL: {os.path.basename(rom)}: {error}")
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
