#!/usr/bin/env python3
"""Dolffy DOS LOAD/SAVE regression matrix (VICE, black-box, byte-exact).

Runs the per-device transfer paths that must all stay byte-exact:

  jiffy-serial      JiffyDOS fast serial   (drive 8, no cable, JiffyDOS drive ROM)
  dolphin-parallel  DolphinDOS parallel    (drive 8 + cable, DolphinDOS drive ROM + drive RAM)
  stock-serial      stock Commodore serial (VICE's bundled 1541 DOS, no external ROM)

For each available mode it checks:
  LOAD  LOAD"*",8,1 of a known PRG saved at $4001 -> bytes land byte-exact at $4001.
        (Also guards the secondary-address ",1" path: a mis-relocate to $0801 leaves
        $4001 unwritten and fails -- this is the check that caught the X-register
        clobber regression in the JiffyDOS detection probe.)
  SAVE  SAVE"T",8 of a known payload -> extracted file is byte-exact.

A mode is skipped (not failed) when its proprietary drive ROM is not configured.

Usage:
  python3 test/regress.py                 # full matrix
  python3 test/regress.py jiffy-serial    # one or more named modes
  python3 test/regress.py --save          # only SAVE checks
  python3 test/regress.py --load          # only LOAD checks
Exit code is non-zero if any executed check fails.
"""
import os, sys, struct, time
import harness as H

LOAD_N = int(os.environ.get("LOAD_N", "16384"))
SAVE_N = int(os.environ.get("SAVE_N", "2000"))
LOAD_ADDR = 0x4001

MODES = {
    "jiffy-serial":     dict(drive_rom=H.JIFFY_DRIVE_ROM,   cable="0",
                             drive_ram=False, userport_cable=False, need="JIFFY_DRIVE_ROM"),
    "dolphin-parallel": dict(drive_rom=H.DOLPHIN_DRIVE_ROM, cable="1",
                             drive_ram=True,  userport_cable=True,  need="DOLPHIN_DRIVE_ROM"),
    "stock-serial":     dict(drive_rom=None,                cable="0",
                             drive_ram=False, userport_cable=False, need=None),
}


VIDEO = os.environ.get("VIDEO", "pal")


def _vice(mode, disk):
    m = MODES[mode]
    return H.Vice(disk, drive_rom=m["drive_rom"], cable=m["cable"],
                  drive_ram=m["drive_ram"], userport_cable=m["userport_cable"], video=VIDEO)


def test_load(mode, workdir):
    prg = H.ramp_prg(LOAD_ADDR, LOAD_N)
    body = prg[2:]
    disk = os.path.join(workdir, f"load_{mode}.d64")
    H.make_disk(disk, prg, name="test")
    v = _vice(mode, disk)
    try:
        v.erase(0x0801, LOAD_ADDR + len(body))     # clear both relocate + header targets
        v.type_line('LOAD"*",8,1')
        v.free_run(float(os.environ.get("FREERUN", "6")))
        got = bytearray()
        a = LOAD_ADDR
        while a < LOAD_ADDR + len(body):
            n = min(256, LOAD_ADDR + len(body) - a)
            got += v.memget(a, a + n - 1)
            a += n
    finally:
        v.close()
    miss = [i for i in range(min(len(got), len(body))) if got[i] != body[i]]
    ok = (not miss) and len(got) >= len(body)
    detail = "byte-exact" if ok else f"{len(miss)} mismatches (first @ ${LOAD_ADDR + (miss[0] if miss else 0):04x})"
    return ok, f"{len(body)}B -> ${LOAD_ADDR:04x}: {detail}"


def test_save(mode, workdir):
    payload = H.ramp_prg(0x0801, SAVE_N)[2:]    # body only; saved from $0801
    end = 0x0801 + len(payload)
    disk = os.path.join(workdir, f"save_{mode}.d64")
    H.make_disk(disk, b"", name="placeholder")   # fresh formatted disk
    v = _vice(mode, disk)
    try:
        v.memset(0x0801, payload)
        v.memset(0x002b, struct.pack("<H", 0x0801))
        for p in (0x002d, 0x002f, 0x0031):
            v.memset(p, struct.pack("<H", end))
        v.type_line('SAVE"T",8')
        v.free_run(float(os.environ.get("FREERUN", "6")))
        v.quit_flush()
    finally:
        pass
    got, err = H.read_disk_file(disk, "t")
    if got is None:
        return False, f"extract failed: {err}"
    body = got[2:]
    ok = (body == payload)
    if ok:
        return True, f"{len(payload)}B round-trip byte-exact"
    n = min(len(body), len(payload))
    miss = [i for i in range(n) if body[i] != payload[i]]
    return False, f"len got={len(body)} want={len(payload)}, {len(miss)} mismatches"


def main():
    argv = sys.argv[1:]
    do_load = "--save" not in argv
    do_save = "--load" not in argv
    global VIDEO
    if "--ntsc" in argv:
        VIDEO = "ntsc"
    elif "--pal" in argv:
        VIDEO = "pal"
    named = [a for a in argv if not a.startswith("--")]
    modes = named or list(MODES)

    workdir = H.tempdir()
    print(f"KERNAL = {H.DOLFFY_ROM}")
    print(f"x64sc  = {H.X64SC}")
    print(f"video  = {VIDEO}")
    print(f"work   = {workdir}\n")

    rows = []
    fails = 0
    for mode in modes:
        if mode not in MODES:
            print(f"  ! unknown mode '{mode}'"); continue
        need = MODES[mode]["need"]
        rom = MODES[mode]["drive_rom"]
        if need and not (rom and os.path.exists(rom)):
            rows.append((mode, "LOAD", "SKIP", f"{need} not set/found"))
            rows.append((mode, "SAVE", "SKIP", f"{need} not set/found"))
            continue
        for op, enabled, fn in (("LOAD", do_load, test_load), ("SAVE", do_save, test_save)):
            if not enabled:
                continue
            t0 = time.time()
            try:
                ok, detail = fn(mode, workdir)
            except Exception as e:
                ok, detail = False, f"exception: {e}"
            rows.append((mode, op, "PASS" if ok else "FAIL", f"{detail}  ({time.time()-t0:.1f}s)"))
            if not ok:
                fails += 1

    print("=" * 72)
    for mode, op, status, detail in rows:
        mark = {"PASS": "  ✓", "FAIL": "  ✗", "SKIP": "  -"}[status]
        print(f"{mark} {mode:<18} {op:<5} {status:<5} {detail}")
    print("=" * 72)
    executed = [r for r in rows if r[2] != "SKIP"]
    print(f"{len(executed)} checks, {fails} failed, {len(rows)-len(executed)} skipped")
    sys.exit(1 if fails else 0)


if __name__ == "__main__":
    main()
