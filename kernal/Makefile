ACME    ?= acme
ROM_PLAIN    = rom/dolffy.rom
ROM_ULTIMATE = rom/dolffy-ultimate.rom
ROM_LEGACY_PLAIN = rom/dolffy-plain.rom
# Upstream byte-exact reference (donnchawp/DolphinDOS2 build). Until the Dolffy
# DOS bake begins (feature removal + JiffyDOS + rebrand) the source must still
# reproduce this exactly; `make verify` proves the relabel is faithful. Once the
# bake diverges from upstream this reference is updated/retired.
REF_MD5  = b3b0fa8410edef1a42dbccf87e798f6e

.PHONY: all ultimate plain verify clean

all: plain ultimate

ultimate: $(ROM_ULTIMATE)

plain: $(ROM_PLAIN)

$(ROM_PLAIN): kernal.asm jd_cal.inc
	@mkdir -p rom
	$(ACME) -DULTIMATE_BUILD=0 -o $(ROM_PLAIN) kernal.asm
	@echo "built $(ROM_PLAIN) ($$(stat -f%z $(ROM_PLAIN)) bytes)"

$(ROM_ULTIMATE): kernal.asm jd_cal.inc
	@mkdir -p rom
	$(ACME) -DULTIMATE_BUILD=1 -o $(ROM_ULTIMATE) kernal.asm
	@echo "built $(ROM_ULTIMATE) ($$(stat -f%z $(ROM_ULTIMATE)) bytes)"

# Confirm the relabeled source still assembles to the upstream ROM byte-for-byte.
verify: $(ROM_PLAIN)
	@got=$$(md5 -q $(ROM_PLAIN)); \
	if [ "$$got" = "$(REF_MD5)" ]; then \
	  echo "OK: byte-exact ($$got)"; \
	else \
	  echo "MISMATCH: got $$got, want $(REF_MD5)"; exit 1; \
	fi

clean:
	rm -f $(ROM_PLAIN) $(ROM_ULTIMATE) $(ROM_LEGACY_PLAIN)
