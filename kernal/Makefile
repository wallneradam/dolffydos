ACME    ?= acme
ROM_PLAIN    = rom/dolffy.rom
ROM_ULTIMATE = rom/dolffy-ultimate.rom
ROM_QUICKRUN = rom/dolffy-quickrun.rom
ROM_HYPER    = rom/dolffy-hyper.rom
ROM_HYPER_QUICKRUN = rom/dolffy-hyper-quickrun.rom
ROM_LEGACY_PLAIN = rom/dolffy-plain.rom
# Upstream byte-exact reference (donnchawp/DolphinDOS2 build). Until the Dolffy
# DOS bake begins (feature removal + JiffyDOS + rebrand) the source must still
# reproduce this exactly; `make verify` proves the relabel is faithful. Once the
# bake diverges from upstream this reference is updated/retired.
REF_MD5  = b3b0fa8410edef1a42dbccf87e798f6e

.PHONY: all ultimate plain quickrun hyper hyper-quickrun verify clean

all: plain ultimate quickrun hyper hyper-quickrun

ultimate: $(ROM_ULTIMATE)

plain: $(ROM_PLAIN)

quickrun: $(ROM_QUICKRUN)

hyper: $(ROM_HYPER)

hyper-quickrun: $(ROM_HYPER_QUICKRUN)

$(ROM_PLAIN): kernal.asm jd_cal.inc
	@mkdir -p rom
	$(ACME) -DULTIMATE_BUILD=0 -o $(ROM_PLAIN) kernal.asm
	@echo "built $(ROM_PLAIN) ($$(stat -f%z $(ROM_PLAIN)) bytes)"

$(ROM_ULTIMATE): kernal.asm jd_cal.inc
	@mkdir -p rom
	$(ACME) -DULTIMATE_BUILD=1 -o $(ROM_ULTIMATE) kernal.asm
	@echo "built $(ROM_ULTIMATE) ($$(stat -f%z $(ROM_ULTIMATE)) bytes)"

$(ROM_QUICKRUN): kernal.asm jd_cal.inc
	@mkdir -p rom
	$(ACME) -DULTIMATE_BUILD=0 -DQUICKRUN_BUILD=1 -o $(ROM_QUICKRUN) kernal.asm
	@echo "built $(ROM_QUICKRUN) ($$(stat -f%z $(ROM_QUICKRUN)) bytes)"

$(ROM_HYPER): kernal.asm jd_cal.inc
	@mkdir -p rom
	$(ACME) -DULTIMATE_BUILD=0 -DHYPER_BUILD=1 -o $(ROM_HYPER) kernal.asm
	@echo "built $(ROM_HYPER) ($$(stat -f%z $(ROM_HYPER)) bytes)"

$(ROM_HYPER_QUICKRUN): kernal.asm jd_cal.inc
	@mkdir -p rom
	$(ACME) -DULTIMATE_BUILD=0 -DHYPER_BUILD=1 -DQUICKRUN_BUILD=1 -o $(ROM_HYPER_QUICKRUN) kernal.asm
	@echo "built $(ROM_HYPER_QUICKRUN) ($$(stat -f%z $(ROM_HYPER_QUICKRUN)) bytes)"

# Confirm the relabeled source still assembles to the upstream ROM byte-for-byte.
verify: $(ROM_PLAIN)
	@got=$$(md5 -q $(ROM_PLAIN)); \
	if [ "$$got" = "$(REF_MD5)" ]; then \
	  echo "OK: byte-exact ($$got)"; \
	else \
	  echo "MISMATCH: got $$got, want $(REF_MD5)"; exit 1; \
	fi

clean:
	rm -f $(ROM_PLAIN) $(ROM_ULTIMATE) $(ROM_QUICKRUN) $(ROM_HYPER) $(ROM_HYPER_QUICKRUN) $(ROM_LEGACY_PLAIN) rom/dolffy-quick*.rom
