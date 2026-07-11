#!/usr/bin/env python3
"""Apply BLANK/STUB ops to kernal.asm by byte-exact line replacement.
No labels exist in the source, so correctness == byte-exactness. The script
ALSO predicts the exact resulting ROM (baseline + ops) so the ACME build can be
proven correct by an exact compare.

One-shot historical tool that produced the original bake. Paths resolve next to
this script by default; override the working directory with DOLFFY_SCRATCH."""
import os, re

SCR   = os.environ.get("DOLFFY_SCRATCH", os.path.dirname(os.path.abspath(__file__)))
ASM   = SCR+"/kernal.orig.asm"   # pristine source (clean address map)
BASE  = SCR+"/baseline.rom"
OUTA  = SCR+"/kernal.all.asm"
OUTR  = SCR+"/expected.all.rom"
ORIG  = 0xE000
SHIFT = 0x897C

# ---- PHASE 1 operations -------------------------------------------------
# (start, end, kind, payload, note)
#   kind 'fill': payload = fill byte
#   kind 'bytes': payload = list of exact bytes (len must == end-start+1)
EA, ZZ = 0xEA, 0x00
OPS = [
 (0xF178,0xF186,'fill',EA,'wedge $-dir serial X-print helper'),
 (0xF187,0xF195,'fill',EA,'monitor hex-dump helper'),
 (0xF1AA,0xF1AC,'fill',EA,'dir char-printer thunk'),
 (0xF1DF,0xF20D,'fill',EA,'monitor filename parser'),
 (0xF26C,0xF278,'fill',EA,'monitor byte-store helper (embedded in CKOUT)'),
 (0xF387,0xF3AB,'fill',ZZ,'F-key macro strings part1'),
 (0xF3AE,0xF3B3,'fill',ZZ,'F-key macro strings part2'),
 (0xF3B4,0xF3D4,'fill',EA,'F7/UCI-menu hook'),
 (0xF409,0xF494,'fill',EA,'ML-monitor command handlers'),
 (0xF533,0xF554,'fill',EA,'F-key dispatch (E5E7 now bypasses)'),
 (0xF9E2,0xFA53,'fill',EA,'directory display renderer'),
 (0xFA54,0xFA6A,'fill',EA,'directory continue-dump'),
 (0xFAC0,0xFB01,'fill',EA,'directory decimal block-count printer'),
 (0xFB02,0xFB10,'fill',ZZ,'F-key hardcopy fake-return data table'),
 (0xFB2E,0xFB8D,'fill',EA,'screen-to-printer hardcopy'),
 (0xFB97,0xFB9D,'fill',EA,'directory line-number printer'),
 (0xFBA6,0xFC3E,'fill',EA,'LOAD"$"/directory read+list engine'),
 (0xFCAA,0xFCC9,'fill',EA,'W monitor handler'),
 # stubs / rewrites
 (0xE5E7,0xE5E9,'bytes',[0x20,0xB4,0xE5],'REWRITE jsr $f533 -> jsr $e5b4 (#1)'),
 (0xE591,0xE593,'bytes',[0x18,0x60,0xEA],'STUB @ handler: clc/rts/nop (#4)'),
 (0xFB11,0xFB2D,'bytes',[0x8D,0x8C,0x02, 0x84,0xC5, 0xAD,0x8C,0x02, 0x60]
                        +[EA]*20,'SCNKEY stub (keeps Z contract) + EA pad'),
 (0xFECA,0xFECB,'bytes',[0x60,0xEA],'STUB-RTS $-dir-load entry'),
 # ---- PHASE 2: monitor core + BRK/NMI neutralization ----
 (0xF005,0xF08D,'fill',EA,'ML-monitor prologue + command loop'),
 (0xF227,0xF234,'fill',ZZ,'monitor command-char table'),
 (0xF72C,0xF735,'fill',EA,'monitor helper (dead island, callers blanked)'),
 (0xF8AF,0xF8CA,'fill',ZZ,'monitor handler-address table'),
 (0xFF55,0xFF57,'bytes',[0x6C,0x16,0x03],'BRK dispatch: jmp $f01d -> jmp ($0316) stock (#3)'),
 (0xFEA0,0xFEA2,'bytes',[0x6C,0x02,0xA0],'RESTORE/NMI monitor entry -> jmp ($a002) warm start (#3)'),
]

lines = open(ASM).read().split("\n")
rom = bytearray(open(BASE,"rb").read())
assert len(rom)==8192
addr_re = re.compile(r';\s*\$([0-9a-fA-F]{4})')

# entries: (file_idx, true_addr)
ent=[]
for i,ln in enumerate(lines):
    m=addr_re.search(ln)
    if m:
        a=int(m.group(1),16)
        if a<ORIG: a+=SHIFT
        ent.append((i,a))
# lengths
addr_of={i:a for i,a in ent}
ent_sorted=ent  # already file order == addr order (verified monotonic)
length={}
for k in range(len(ent_sorted)-1):
    length[ent_sorted[k][0]] = ent_sorted[k+1][1]-ent_sorted[k][1]
length[ent_sorted[-1][0]] = (ORIG+8192) - ent_sorted[-1][1]

# byte interval per addr-bearing file line
interval={}  # file_idx -> (start, end_inclusive)
for i,a in ent:
    interval[i]=(a, a+length[i]-1)

# validate + compute file-index span and head/tail for each op
def find_line_containing(addr):
    for i,a in ent:
        s,e=interval[i]
        if s<=addr<=e: return i
    raise SystemExit(f"addr ${addr:04x} not covered by any line")

plan=[]  # (op, first_idx, last_idx, head_bytes, tail_bytes)
for (s,e,kind,pl,note) in OPS:
    blen=e-s+1
    if kind=='bytes':
        assert len(pl)==blen, f"op ${s:04x}: payload {len(pl)} != range {blen}"
    fi=find_line_containing(s)
    li=find_line_containing(e)
    fs,_=interval[fi]; _,le=interval[li]
    head = bytes(rom[fs-ORIG:s-ORIG])      # kept bytes before s in first line
    tail = bytes(rom[e+1-ORIG:le+1-ORIG])  # kept bytes after e in last line
    plan.append((s,e,kind,pl,note,fi,li,head,tail))
    # apply to predicted rom
    if kind=='fill':
        for off in range(s-ORIG,e+1-ORIG): rom[off]=pl
    else:
        for j,b in enumerate(pl): rom[s-ORIG+j]=b

# build output: replace file-index spans [fi..li] with head/dir/tail
replace={}  # first_idx -> list of new lines ; and mark idx in (fi,li] for deletion
delete=set()
for (s,e,kind,pl,note,fi,li,head,tail) in plan:
    out=[]
    if head:
        out.append("    !byte "+",".join(f"${b:02x}" for b in head)+f"   ; ${interval[fi][0]:04x} kept head")
    if kind=='fill':
        out.append(f"    !fill ${e-s+1:x}, ${pl:02x}   ; ${s:04x}-${e:04x} BLANK {note}")
    else:
        # chunk bytes for readability, 8 per line, first line carries the note
        chunks=[pl[x:x+8] for x in range(0,len(pl),8)]
        for ci,ch in enumerate(chunks):
            c="    !byte "+",".join(f"${b:02x}" for b in ch)
            if ci==0: c+=f"   ; ${s:04x}-${e:04x} {note}"
            out.append(c)
    if tail:
        out.append("    !byte "+",".join(f"${b:02x}" for b in tail)+f"   ; ${e+1:04x} kept tail")
    replace[fi]=out
    for k in range(fi+1, li+1):
        delete.add(k)

new=[]
for i,ln in enumerate(lines):
    if i in delete:
        continue
    if i in replace:
        new.extend(replace[i])
    else:
        new.append(ln)

open(OUTA,"w").write("\n".join(new))
open(OUTR,"wb").write(bytes(rom))

# report
print("PHASE 1 ops:", len(OPS))
tot=0
for (s,e,kind,pl,note,fi,li,head,tail) in plan:
    tot+= (e-s+1) if kind=='fill' else 0
    print(f"  ${s:04x}-${e:04x} {kind:5} L{fi+1}..L{li+1} head={len(head)} tail={len(tail)}  {note}")
print(f"freed (fills only) = {tot} bytes")
print(f"wrote {OUTA}")
print(f"wrote {OUTR}  md5sum below")
import hashlib
print("expected.p1.rom md5 =", hashlib.md5(bytes(rom)).hexdigest())
