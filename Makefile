MCUS = avr1 avr2 avr25 avr3 avr31 avr35 avr5 avr51 avr6 avrxmega1 avrxmega4 avrxmega7 avrtiny

SOURCES = $(wildcard execute/*/*.c)

all: $(foreach src,$(SOURCES),$(dir $(src))/done)

compile/%/done: compile/%/Makefile
	$(MAKE) -C compile/$* all

compile/%/Makefile: | compile/%
	@echo "-include ../../test.mk" > $@
	@echo "all: $(patsubst compile/$*/%,%,$(wildcard compile/$*/*.c)).done" >> $@

execute/%/done: execute/%/Makefile
	$(MAKE) -C execute/$* all

execute/%/Makefile: | execute/%
	@echo "-include ../../test.mk" > $@
	@echo "all: $(patsubst execute/$*/%,%,$(wildcard execute/$*/*.c)).status" >> $@

clean:
	rm -f compile/*/Makefile
	rm -f execute/*/Makefile
	find compile execute 040-name "*.*.*" | xargs rm -f

differences.diff:
	ls -SSr diff | while read REPLY; do echo "DIRECTORY $$REPLY"; cat diff/$$REPLY; done > $@

.PHONY: clean

.PRECIOUS:
.SECONDARY:
