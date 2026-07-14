"""VICE binary-monitor test harness for Dolffy DOS regression tests.

Black-box only: the harness pokes a known payload into C64 RAM, issues a BASIC
LOAD/SAVE, runs the emulator free, and compares the result byte-for-byte. Drive
ROMs are referenced solely as opaque test targets (file paths supplied by the
user); no drive or KERNAL code is read or embedded here.

Configuration (all via environment, sensible defaults for a homebrew macOS VICE):

  X64SC              path to x64sc (default: PATH / /opt/homebrew/bin/x64sc)
  C1541              path to c1541 (default: PATH / /opt/homebrew/bin/c1541)
  DOLFFY_ROM         C64 KERNAL under test (default: <repo>/kernal/rom/dolffy.rom)
  VICE_C64_DIR       dir with basic-901226-01.bin + chargen-901225-01.bin
                     (default: /opt/homebrew/share/vice/C64; auto-skipped if absent)
  JIFFY_DRIVE_ROM    JiffyDOS 1541 drive ROM (proprietary; user-supplied). Empty -> skip jiffy tests.
  DOLPHIN_DRIVE_ROM  DolphinDOS 1541 drive ROM (proprietary; user-supplied). Empty -> skip parallel tests.

The stock-serial mode needs no external ROM (VICE's bundled 1541 DOS is used).
"""
import os, socket, struct, subprocess, time, tempfile, shutil

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def _load_dotenv():
    """Load test/.env (KEY=VALUE per line) into os.environ without overriding
    values already set in the environment. Lets a user keep their proprietary
    drive-ROM paths in a local, gitignored test/.env."""
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)), ".env")
    if not os.path.exists(path):
        return
    for line in open(path):
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        k, v = line.split("=", 1)
        os.environ.setdefault(k.strip(), v.strip().strip('"').strip("'"))


_load_dotenv()


def _which(name, *fallbacks):
    p = shutil.which(name)
    if p:
        return p
    for f in fallbacks:
        if os.path.exists(f):
            return f
    return name

X64SC = os.environ.get("X64SC", _which("x64sc", "/opt/homebrew/bin/x64sc"))
C1541 = os.environ.get("C1541", _which("c1541", "/opt/homebrew/bin/c1541"))
DOLFFY_ROM = os.environ.get("DOLFFY_ROM", os.path.join(ROOT, "kernal", "rom", "dolffy.rom"))
VICE_C64_DIR = os.environ.get("VICE_C64_DIR", "/opt/homebrew/share/vice/C64")
JIFFY_DRIVE_ROM = os.environ.get("JIFFY_DRIVE_ROM", "")
DOLPHIN_DRIVE_ROM = os.environ.get("DOLPHIN_DRIVE_ROM", "")

READY = b"\x12\x05\x01\x04\x19"   # "READY" in screen codes (row scan marker)


def ramp_prg(load_addr, n):
    """A deterministic test PRG: 2-byte load address + marker block + ramp body."""
    markers = bytes([0x55, 0xaa, 0x0f, 0xf0, 0x01, 0x02, 0x04, 0x08,
                     0x10, 0x20, 0x40, 0x80, 0x00, 0xff, 0xe4, 0x3c])
    body = markers + bytes([(i * 7 + 3) & 0xff for i in range(n - len(markers))])
    return struct.pack("<H", load_addr) + body


def make_disk(path, prg, name="test"):
    """Format a fresh d64 at `path` and write `prg` as file `name`."""
    subprocess.run([C1541, "-format", f"{name},01", "d64", path], capture_output=True)
    tmp = path + ".prg"
    with open(tmp, "wb") as f:
        f.write(prg)
    subprocess.run([C1541, "-attach", path, "-write", tmp, name], capture_output=True)
    os.remove(tmp)


def read_disk_file(path, name, tries=4):
    """Extract file `name` from d64 `path`; return its bytes (incl. 2-byte load addr) or None.
    Retries briefly: VICE's d64 write-back can lag the emulator quit by a moment."""
    out = path + ".out"
    last = ""
    for attempt in range(tries):
        if os.path.exists(out):
            os.remove(out)
        r = subprocess.run([C1541, "-attach", path, "-read", name.lower(), out],
                           capture_output=True, text=True)
        if os.path.exists(out) and os.path.getsize(out) > 0:
            data = open(out, "rb").read()
            os.remove(out)
            return data, ""
        last = (r.stdout + r.stderr).strip().splitlines()[-1:] or [""]
        last = last[0]
        time.sleep(0.4)
    return None, last


class Vice:
    """One VICE x64sc session driven over the binary monitor.

    mode args:
      cable       "0" none / "1" standard parallel cable (DolphinDOS) / "2" DD3
      drive_rom   path to a -dos1541 ROM, or None to use VICE's bundled stock 1541
      drive_ram   True -> add the DolphinDOS drive RAM expansion ($2000/$4000/$6000)
      extra_args  additional VICE arguments, used by multi-drive route tests
    """
    _next_port = 6700

    def __init__(self, disk, kernal=None, drive_rom=None, cable="0",
                 drive_ram=False, userport_cable=False, port=None, video="pal",
                 extra_args=None):
        self.disk = disk
        self.port = port or Vice._alloc_port()
        kernal = kernal or DOLFFY_ROM
        args = [X64SC, "-default", "-kernal", kernal]
        if video == "ntsc":
            args += ["-ntsc"]
        elif video == "pal":
            args += ["-pal"]
        basic = os.path.join(VICE_C64_DIR, "basic-901226-01.bin")
        chargen = os.path.join(VICE_C64_DIR, "chargen-901225-01.bin")
        if os.path.exists(basic) and os.path.exists(chargen):
            args += ["-basic", basic, "-chargen", chargen]
        args += ["-drive8type", "1541", "-drive8truedrive"]
        if drive_rom:
            args += ["-dos1541", drive_rom]
        if cable != "0":
            args += ["-parallel8", cable]
        if userport_cable:
            args += ["-userportdevice", "21"]
        if drive_ram:
            args += ["-drive8ram2000", "-drive8ram4000", "-drive8ram6000"]
        if extra_args:
            args += extra_args
        args += ["-8", disk, "-warp",
                 "-binarymonitor", "-binarymonitoraddress", f"ip4://127.0.0.1:{self.port}"]
        self.args = args
        self.proc = subprocess.Popen(args, stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT)
        self.s = self._connect()
        self._rid = 0
        self.drain(2.5)   # let the C64 boot

    @classmethod
    def _alloc_port(cls):
        p = cls._next_port
        cls._next_port += 1
        return p

    def _connect(self):
        for _ in range(200):
            try:
                return socket.create_connection(("127.0.0.1", self.port), timeout=0.5)
            except OSError:
                time.sleep(0.1)
        raise SystemExit(f"no monitor connection on :{self.port}")

    def cmd(self, ct, body=b""):
        self._rid += 1
        self.s.sendall(struct.pack("<BBIIB", 0x02, 0x02, len(body), self._rid, ct) + body)

    def drain(self, t=0.2):
        self.s.settimeout(t)
        out = b""
        try:
            while True:
                c = self.s.recv(65536)
                if not c:
                    break
                out += c
        except socket.timeout:
            pass
        return out

    def memset(self, a, d):
        self.cmd(0x02, struct.pack("<BHHBH", 0, a, a + len(d) - 1, 0, 0) + d)

    def memget(self, a0, a1):
        self.cmd(0x01, struct.pack("<BHHBH", 0, a0, a1, 0, 0))
        time.sleep(0.005)
        d = self.drain(0.2)
        i = 0
        while i + 12 <= len(d):
            if d[i] != 0x02:
                i += 1
                continue
            ln = struct.unpack("<I", d[i + 2:i + 6])[0]
            rt = d[i + 6]
            body = d[i + 12:i + 12 + ln]
            if rt == 0x01:
                bl = struct.unpack("<H", body[0:2])[0]
                return body[2:2 + bl]
            i += 12 + ln
        return b""

    def g(self, a):
        d = self.memget(a, a)
        return d[0] if d else -1

    def erase(self, lo, hi, fill=0xee):
        for a in range(lo, hi, 256):
            self.memset(a, bytes([fill]) * min(256, hi - a))

    def type_line(self, text):
        """Inject a BASIC line via the keyboard buffer, waiting for each chunk to drain."""
        b = (text + "\r").encode()
        for ch in [b[i:i + 9] for i in range(0, len(b), 9)]:
            self.memset(0x0277, ch)
            self.memset(0x00C6, bytes([len(ch)]))
            self.cmd(0xaa)
            for _ in range(40):
                self.drain(0.04)
                if self.g(0x00C6) == 0:
                    break

    def free_run(self, seconds):
        """Resume and run undisturbed (no monitor stops): required for the
        cycle-critical DolphinDOS parallel / JiffyDOS transfers."""
        self.cmd(0xaa)
        t0 = time.time()
        while time.time() - t0 < seconds:
            self.drain(0.2)

    def screen(self):
        return bytes(self.memget(0x0400, 0x07e7))

    def quit_flush(self):
        """Resume, settle, then MON_CMD_QUIT so VICE writes back the d64."""
        self.cmd(0xaa)
        time.sleep(1.0)
        try:
            self.cmd(0xbb)
        except OSError:
            pass
        try:
            self.proc.wait(timeout=5)
        except Exception:
            self.proc.kill()

    def close(self):
        try:
            self.proc.terminate()
            self.proc.wait(timeout=3)
        except Exception:
            self.proc.kill()


def tempdir():
    return tempfile.mkdtemp(prefix="dolffy_test_")
