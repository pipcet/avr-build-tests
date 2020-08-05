MCUS = avr1 avr2 avr25 avr3 avr31 avr35 avr5 avr51 avr6 avrxmega1 avrxmega4 avrxmega7 avrtiny

SOURCES = $(wildcard execute/*/*.c compile/*/*.c)

all: $(foreach src,$(SOURCES),$(dir $(src))/done)

makefiles: $(foreach src,$(SOURCES),$(dir $(src))/Makefile)

env:
	@echo "export CCMODE_GCC=$$HOME/avr-ccmode/bin/avr-gcc"
	@echo "export VANILLA_GCC=$$HOME/avr-vanilla/bin/avr-gcc"

compile/%/done: compile/%/Makefile
	$(MAKE) -C compile/$* all

compile/%/Makefile: | compile/%
	@echo "-include ../../test.mk" > $@
	@echo "all: $(patsubst compile/$*/%,%,$(wildcard compile/$*/*.c)).compile" >> $@
	@echo "rtl: $(patsubst compile/$*/%,%,$(wildcard compile/$*/*.c)).rtl" >> $@
	@echo "tree: $(patsubst compile/$*/%,%,$(wildcard compile/$*/*.c)).tree" >> $@

execute/%/done: execute/%/Makefile
	$(MAKE) -C execute/$* all

execute/%/Makefile: | execute/%
	@echo "-include ../../test.mk" > $@
	@echo "all: $(patsubst execute/$*/%,%,$(wildcard execute/$*/*.c)).execute $(patsubst execute/$*/%,%,$(wildcard execute/$*/*.c)).compile" >> $@
	@echo "rtl: $(patsubst execute/$*/%,%,$(wildcard execute/$*/*.c)).execute $(patsubst execute/$*/%,%,$(wildcard execute/$*/*.c)).rtl" >> $@

clean:
	rm -f compile/*/Makefile
	rm -f execute/*/Makefile
	find compile execute -name "*.*.*" | xargs rm -f

differences.diff:
	rm -f diffhash-candidates/*
	ls -SSr diff | while read REPLY; do HASH=`perl ./diffhash.pl diff/$$REPLY`; [ -f diffhash/$$HASH.diff ] || ((echo "DIR $$REPLY $$HASH"; cat diff/$$REPLY); (echo "DIR $$REPLY $$HASH"; cat diff/$$REPLY) > diffhash-candidates/$$HASH.diff); done > $@

status-differences.diff:
	find -name '*.status.diff' -size '+0' | xargs ls -SSr | xargs more | head -100000 > status-differences.diff
.PHONY: clean

.SECONDARY:
