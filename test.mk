MCUS = avr2 avr25 avr3 avr31 avr35 avr5 avr51 avr6 avrxmega3 avrxmega4 avrxmega7 avrtiny
OPTS = 2 3 s
DUMP_RTL = # -fdump-rtl-all -fdump-tree-all

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{ccmode}.s: %.c ; $${CCMODE_GCC} $(DUMP_RTL) -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{ccmode-dP}.s: %.c ; $${CCMODE_GCC} -dP -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{vanilla}.s: %.c ; $${VANILLA_GCC} $(DUMP_RTL) -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{vanilla-dP}.s: %.c ; $${VANILLA_GCC} -dP -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

%.c.{ccmode}.done: %.c $(foreach m,$(MCUS),$(foreach o,$(OPTS),%.c.{$(m)}.{$(o)}.{ccmode}.s))
	touch $@

%.c.{vanilla}.done: %.c $(foreach m,$(MCUS),$(foreach o,$(OPTS),%.c.{$(m)}.{$(o)}.{vanilla}.s))
	touch $@

%.c.{ccmode-dP}.done: %.c $(foreach m,$(MCUS),$(foreach o,$(OPTS),%.c.{$(m)}.{$(o)}.{ccmode-dP}.s))
	touch $@

%.c.{vanilla-dP}.done: %.c $(foreach m,$(MCUS),$(foreach o,$(OPTS),%.c.{$(m)}.{$(o)}.{vanilla-dP}.s))
	touch $@

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.diff: %.c.{$(m)}.{$(o)}.{vanilla}.s %.c.{$(m)}.{$(o)}.{ccmode}.s ; diff -u $$^ > $$@ || true)))

%.c.diff: $(foreach m,$(MCUS),$(foreach o,$(OPTS),%.c.{$(m)}.{$(o)}.diff))
	cat $^ > $@
	cp $@ ../../diff/$(notdir $(shell pwd)).diff

%.c.done: %.c %.c.{ccmode}.done %.c.{vanilla}.done %.c.{ccmode-dP}.done %.c.{vanilla-dP}.done %.c.diff
	touch $@

.PRECIOUS:
.SECONDARY:

