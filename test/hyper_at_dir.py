#!/usr/bin/env python3
"""VICE smoke test for the Hyper @ directory parser and IEC fallback."""

import os
import sys

import harness as H


ROMS = (
    os.path.join(H.ROOT, "kernal", "rom", "dolffy-hyper.rom"),
    os.path.join(H.ROOT, "kernal", "rom", "dolffy-hyper-quickrun.rom"),
)
FREERUN = float(os.environ.get("FREERUN", "2"))
SCREEN_SPACE = bytes([0x20]) * 1000


def screen_codes(text):
    return bytes(ord(char) - 64 if "A" <= char <= "Z" else ord(char) for char in text)


def run_command(vice, command):
    vice.memset(0x0400, SCREEN_SPACE)
    vice.type_line(command)
    vice.free_run(FREERUN)
    return vice.screen()


def check_rom(rom, disk):
    vice = H.Vice(disk, kernal=rom, video="pal")
    try:
        screen = run_command(vice, "@$")
        assert H.READY in screen, "@$ did not return to READY"
        assert screen_codes("TEST") in screen, "@$ did not show the test directory"

        for device in (9, 10, 11):
            command = f"@${device}"
            screen = run_command(vice, command)
            assert H.READY in screen, f"{command} did not return to READY"
            assert screen_codes("DEVICE NOT PRESENT") in screen, (
                f"{command} did not take the normal IEC missing-device path"
            )
    finally:
        vice.close()


def main():
    workdir = H.tempdir()
    disk = os.path.join(workdir, "at_dir.d64")
    H.make_disk(disk, H.ramp_prg(0x0801, 64), name="test")

    failed = False
    for rom in ROMS:
        try:
            check_rom(rom, disk)
            print(f"PASS: {os.path.basename(rom)} @$, @$9, @$10, @$11")
        except Exception as error:
            failed = True
            print(f"FAIL: {os.path.basename(rom)}: {error}")
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
