MCUS = avr1 avr2 avr25 avr3 avr31 avr35 avr5 avr51 avr6 avrxmega1 avrxmega4 avrxmega7 avrtiny

SOURCES = $(wildcard src-exec/*/*.c)

all: $(foreach src,$(SOURCES),$(dir $(src))/done)

src/%/done: src/%/Makefile
	$(MAKE) -C src/$* all

src/%/Makefile: | src/%
	@echo "-include ../../test.mk" > $@
	@echo "all: $(patsubst src/$*/%,%,$(wildcard src/$*/*.c)).done" >> $@

src-exec/%/done: src-exec/%/Makefile
	$(MAKE) -C src-exec/$* all

src-exec/%/Makefile: | src-exec/%
	@echo "-include ../../test.mk" > $@
	@echo "all: $(patsubst src-exec/$*/%,%,$(wildcard src-exec/$*/*.c)).status" >> $@

clean:
	rm -f src/*/Makefile
	find src -name "*.*.*" | xargs rm -f

differences.diff:
	ls -SSr diff | while read REPLY; do echo "DIRECTORY $$REPLY"; cat diff/$$REPLY; done > $@

.PHONY: clean

.PRECIOUS:
.SECONDARY:
