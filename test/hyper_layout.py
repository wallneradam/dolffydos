#!/usr/bin/env python3
"""Static ROM-layout checks for the two SoftwareIEC DMA variants."""

from hashlib import md5
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ROM = ROOT / "kernal" / "rom"
ORIGIN = 0xE000

BASELINE_MD5 = {
    "dolffy.rom": "1733d39137e9c23e4ec66bdcacd049ec",
    "dolffy-quickrun.rom": "9cd7e060c1b506f8700545bf943cba71",
    "dolffy-ultimate.rom": "b8d213b79715793dbf1df287a40dd7e9",
}

HYPER_RANGES = (
    (0xE429, 0xE42F),
    (0xE475, 0xE497),
    (0xEA40, 0xEA60),
    (0xF075, 0xF08D),
    (0xF187, 0xF195),
    (0xF1DF, 0xF20D),
    (0xF227, 0xF234),
    (0xF26C, 0xF278),
    (0xF387, 0xF3AB),
    (0xF3AE, 0xF3D4),
    (0xF409, 0xF42A),
    (0xF487, 0xF494),
    (0xF533, 0xF554),
    (0xF662, 0xF675),
    (0xF72C, 0xF735),
    (0xF775, 0xF816),
    (0xF8AF, 0xF8CA),
    (0xFA37, 0xFA6A),
    (0xFAF7, 0xFB10),
    (0xFB1A, 0xFB2D),
    (0xFB61, 0xFB8D),
    (0xFB97, 0xFB9D),
    (0xFC1B, 0xFC3E),
    (0xFCAA, 0xFCC9),
    (0xFD4C, 0xFD4F),
    (0xFECB, 0xFF3A),
)


def read(name):
    data = (ROM / name).read_bytes()
    assert len(data) == 8192, f"{name}: expected 8192 bytes, got {len(data)}"
    return data


def allowed(addr):
    return any(first <= addr <= last for first, last in HYPER_RANGES)


def check_pair(base_name, hyper_name):
    base = read(base_name)
    hyper = read(hyper_name)
    unexpected = [
        ORIGIN + offset
        for offset, (before, after) in enumerate(zip(base, hyper))
        if before != after and not allowed(ORIGIN + offset)
    ]
    assert not unexpected, (
        f"{hyper_name}: differences outside reserved Hyper holes: "
        + ", ".join(f"${addr:04x}" for addr in unexpected[:16])
    )
    assert hyper[0x1D4C:0x1D50] == bytes.fromhex("cb fe 61 fb"), (
        f"{hyper_name}: ILOAD/ISAVE vectors do not point to HLOAD/HSAVE"
    )
    assert hyper[0x0429:0x0430] == bytes.fromhex("a9 73 a0 e4 20 1e ab"), (
        f"{hyper_name}: startup does not use the fixed Ultimate banner"
    )
    assert hyper[0x0475:0x0498].decode("ascii") == "    **** COMMODORE 64 ULTIMATE ****", (
        f"{hyper_name}: startup banner text is not Ultimate-specific"
    )
    assert hyper[0x0A40:0x0A48] == bytes.fromhex("a4 d3 ae 87 02 20 09 f4"), (
        f"{hyper_name}: cursor IRQ does not call HCURSOR"
    )
    assert hyper[0x1409:0x140D] == bytes.fromhex("a5 cf d0 03"), (
        f"{hyper_name}: three-phase cursor state machine is missing"
    )
    assert hyper[0x1C35:0x1C3C] == bytes.fromhex("ad 1c df 4a b0 fa 60"), (
        f"{hyper_name}: UCI empty-command wait does not poll CMD_BUSY"
    )
    assert hyper[0x1187:0x1193] == bytes.fromhex(
        "a9 01 8d 1c df 20 35 fc ee 37 03 60"
    ), f"{hyper_name}: CHKIN launch does not preserve its first response"
    assert hyper[0x1227:0x1235] == bytes.fromhex(
        "86 90 20 1a fb 88 a2 15 20 97 fb 4c 87 f1"
    ), f"{hyper_name}: OPEN-to-CHKIN transition does not restore SA=0"


def main():
    for name, expected in BASELINE_MD5.items():
        actual = md5(read(name)).hexdigest()
        assert actual == expected, f"{name}: baseline changed: {actual} != {expected}"

    check_pair("dolffy.rom", "dolffy-hyper.rom")
    check_pair("dolffy-quickrun.rom", "dolffy-hyper-quickrun.rom")
    print("PASS: legacy hashes, ROM sizes, vectors, and Hyper diff boundaries")


if __name__ == "__main__":
    main()
