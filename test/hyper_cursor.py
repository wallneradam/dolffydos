#!/usr/bin/env python3
"""VICE runtime test for the Hyper three-phase SHIFT cursor."""

import os
from pathlib import Path
import shutil
import subprocess
import sys

import harness as H


ROOT = Path(H.ROOT)
ROMS = (
    ROOT / "kernal" / "rom" / "dolffy-hyper.rom",
    ROOT / "kernal" / "rom" / "dolffy-hyper-quickrun.rom",
)
PROBE_SOURCE = ROOT / "test" / "hyper_cursor_probe.asm"
PROBE_PATH = Path("/tmp/hyper_cursor_probe.prg")
RESULT_ADDR = 0xC100
EXPECTED = bytes.fromhex(
    "c1 0e 01 41 "
    "9e 0e 80 41 "
    "41 05 00 41 "
    "c2 0e 01 42 "
    "42 06 00 42 "
    "a5"
)


def assemble_probe():
    acme = shutil.which("acme") or "/opt/homebrew/bin/acme"
    subprocess.run([acme, str(PROBE_SOURCE)], check=True)
    raw = PROBE_PATH.read_bytes()
    return int.from_bytes(raw[:2], "little"), raw[2:]


def check_rom(rom, disk, load_addr, probe):
    vice = H.Vice(disk, kernal=str(rom), video="pal")
    try:
        vice.memset(load_addr, probe)
        vice.memset(RESULT_ADDR, bytes(len(EXPECTED)))
        vice.type_line(f"SYS{load_addr}")
        vice.free_run(float(os.environ.get("SETTLE", "0.4")))
        return bytes(vice.memget(RESULT_ADDR, RESULT_ADDR + len(EXPECTED) - 1))
    finally:
        vice.close()


def main():
    load_addr, probe = assemble_probe()
    workdir = H.tempdir()
    disk = os.path.join(workdir, "hyper_cursor.d64")
    H.make_disk(disk, H.ramp_prg(0x0801, 16), name="dummy")

    failed = False
    for rom in ROMS:
        try:
            got = check_rom(rom, disk, load_addr, probe)
            assert got == EXPECTED, f"got {got.hex(' ')}, expected {EXPECTED.hex(' ')}"
            print(f"PASS: {rom.name} three-phase SHIFT cursor")
        except Exception as error:
            failed = True
            print(f"FAIL: {rom.name}: {error}")
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
