ACME    ?= acme
ROM      = rom/dolffy.rom
# Upstream byte-exact reference (donnchawp/DolphinDOS2 build). Until the Dolffy
# DOS bake begins (feature removal + JiffyDOS + rebrand) the source must still
# reproduce this exactly; `make verify` proves the relabel is faithful. Once the
# bake diverges from upstream this reference is updated/retired.
REF_MD5  = b3b0fa8410edef1a42dbccf87e798f6e

.PHONY: all verify clean

all: $(ROM)

$(ROM): kernal.asm jd_cal.inc
	@mkdir -p rom
	$(ACME) -o $(ROM) kernal.asm
	@echo "built $(ROM) ($$(stat -f%z $(ROM)) bytes)"

# Confirm the relabeled source still assembles to the upstream ROM byte-for-byte.
verify: $(ROM)
	@got=$$(md5 -q $(ROM)); \
	if [ "$$got" = "$(REF_MD5)" ]; then \
	  echo "OK: byte-exact ($$got)"; \
	else \
	  echo "MISMATCH: got $$got, want $(REF_MD5)"; exit 1; \
	fi

clean:
	rm -f $(ROM)
