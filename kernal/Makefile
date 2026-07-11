ACME    ?= acme
ROM_PLAIN    = rom/dolffy.rom
ROM_ULTIMATE = rom/dolffy-ultimate.rom
ROM_QUICKRUN = rom/dolffy-quickrun.rom
ROM_LEGACY_PLAIN = rom/dolffy-plain.rom

# Pristine upstream reference (donnchawp/DolphinDOS2 build). The live kernal.asm
# has diverged from it (the Dolffy bake: feature removal + JiffyDOS + rebrand),
# so `make verify` assembles the preserved reference source and proves that IT
# still reproduces the faithful ROM byte for byte.
REF_SRC  = reference/kernal.orig.asm
REF_ROM  = rom/dolffy-reference.rom
REF_MD5  = b3b0fa8410edef1a42dbccf87e798f6e

# Portable helpers: GNU/coreutils on Linux, BSD tools on macOS.
fsize = $$(wc -c < "$(1)" | tr -d '[:space:]')
fmd5  = $$(if command -v md5sum >/dev/null 2>&1; then md5sum "$(1)" | cut -d' ' -f1; else md5 -q "$(1)"; fi)

.PHONY: all ultimate plain quickrun verify clean

all: plain ultimate quickrun

ultimate: $(ROM_ULTIMATE)

plain: $(ROM_PLAIN)

quickrun: $(ROM_QUICKRUN)

$(ROM_PLAIN): kernal.asm jd_cal.inc
	@mkdir -p rom
	$(ACME) -DULTIMATE_BUILD=0 -o $(ROM_PLAIN) kernal.asm
	@echo "built $(ROM_PLAIN) ($(call fsize,$(ROM_PLAIN)) bytes)"

$(ROM_ULTIMATE): kernal.asm jd_cal.inc
	@mkdir -p rom
	$(ACME) -DULTIMATE_BUILD=1 -o $(ROM_ULTIMATE) kernal.asm
	@echo "built $(ROM_ULTIMATE) ($(call fsize,$(ROM_ULTIMATE)) bytes)"

$(ROM_QUICKRUN): kernal.asm jd_cal.inc
	@mkdir -p rom
	$(ACME) -DULTIMATE_BUILD=0 -DQUICKRUN_BUILD=1 -o $(ROM_QUICKRUN) kernal.asm
	@echo "built $(ROM_QUICKRUN) ($(call fsize,$(ROM_QUICKRUN)) bytes)"

# Confirm the preserved reference source still assembles to the pristine
# upstream ROM byte for byte. (The live kernal.asm has intentionally diverged.)
verify:
	@mkdir -p rom
	$(ACME) -o $(REF_ROM) $(REF_SRC)
	@got=$(call fmd5,$(REF_ROM)); \
	if [ "$$got" = "$(REF_MD5)" ]; then \
	  echo "OK: reference source assembles byte-exact ($$got)"; \
	else \
	  echo "MISMATCH: got $$got, want $(REF_MD5)"; exit 1; \
	fi

clean:
	rm -f $(ROM_PLAIN) $(ROM_ULTIMATE) $(ROM_QUICKRUN) $(ROM_LEGACY_PLAIN) $(REF_ROM) rom/dolffy-quick*.rom
