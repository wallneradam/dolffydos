#!/usr/bin/env python3
# Relabel donnchawp DolphinDOS2 kernal.asm from the disassembly origin $5684 to
# the true runtime origin $E000, byte-exact. Only RELATIVE-branch operands and
# the trailing "; $xxxx" PC-annotation comments are remapped (+$897C); absolute
# operands and data are left untouched (origin-independent -> bytes unchanged).
import re, sys

WIN_LO, WIN_HI = 0x5684, 0x7683
DELTA = 0xE000 - 0x5684  # 0x897C
BRANCHES = {"bcc", "bcs", "beq", "bne", "bpl", "bmi", "bvc", "bvs"}

src, dst = sys.argv[1], sys.argv[2]

# code part:  <ws><mnemonic><ws>$hhhh<rest>
code_re = re.compile(r"^(\s*)([a-z]{3})(\s+)\$([0-9a-f]{4})(.*)$")
# pure PC-annotation comment at end of line: "; $hhhh"
pc_re = re.compile(r"^(\s*; )\$([0-9a-f]{4})(\s*)$")

n_branch = n_comment = n_origin = 0
out = []
with open(src) as f:
    for line in f:
        line = line.rstrip("\n")

        # origin directive
        if line.strip() == "* = $5684":
            out.append("* = $e000")
            n_origin += 1
            continue

        # split off a trailing comment so we never touch addresses inside prose
        # (we re-handle the comment separately below)
        if "; " in line:
            code, comment = line.split("; ", 1)
            comment = "; " + comment
        else:
            code, comment = line, ""

        # remap branch operand in the code part
        m = code_re.match(code)
        if m and m.group(2) in BRANCHES:
            val = int(m.group(4), 16)
            if WIN_LO <= val <= WIN_HI:
                code = f"{m.group(1)}{m.group(2)}{m.group(3)}${val + DELTA:04x}{m.group(5)}"
                n_branch += 1

        # remap a pure PC-annotation comment ("; $hhhh") only
        if comment:
            cm = pc_re.match(comment)
            if cm:
                val = int(cm.group(2), 16)
                if WIN_LO <= val <= WIN_HI:
                    comment = f"{cm.group(1)}${val + DELTA:04x}{cm.group(3)}"
                    n_comment += 1

        out.append(code + comment)

with open(dst, "w") as f:
    f.write("\n".join(out) + "\n")

print(f"origin lines changed : {n_origin}")
print(f"branch operands remapped : {n_branch}")
print(f"PC-comment addresses remapped : {n_comment}")
