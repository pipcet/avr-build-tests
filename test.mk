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

EXEC_MCUS = atmega32
EXEC_OPTS = 0 1 2 3 s

$(foreach m,$(EXEC_MCUS),$(foreach o,$(EXEC_OPTS),$(eval %.c.{$(m)}.{$(o)}.{ccmode}.exe: %.c ; $${CCMODE_GCC} $(DUMP_RTL) -dumpbase $$@ -O$(o) -mmcu=$(m) -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(EXEC_MCUS),$(foreach o,$(EXEC_OPTS),$(eval %.c.{$(m)}.{$(o)}.{vanilla}.exe: %.c ; $${VANILLA_GCC} $(DUMP_RTL) -dumpbase $$@ -O$(o) -mmcu=$(m) -o $$@ $$< 2> $$@.msg)))

# %.c.{ccmode}.exe.done: %.c $(foreach m,$(EXEC_MCUS),$(foreach o,$(EXEC_OPTS),%.c.{$(m)}.{$(o)}.{ccmode}.exe))
#	touch $@

# %.c.{vanilla}.exe.done: %.c $(foreach m,$(EXEC_MCUS),$(foreach o,$(EXEC_OPTS),%.c.{$(m)}.{$(o)}.{vanilla}.exe))
#	touch $@

%.exe.status: %.exe
	(timeout 3 simulavr -B __stop_program -B abort -d atmega32 --file $< -v && echo success || echo aborted) > $@ 2>&1

%.c.exe.done: $(foreach m,$(EXEC_MCUS),$(foreach o,$(EXEC_OPTS),%.c.{$(m)}.{$(o)}.{ccmode}.exe.status))
	touch $@

%.c.status: %.c.exe.done
	touch $@

$(foreach m,$(EXEC_MCUS),$(foreach o,$(EXEC_OPTS),$(eval %.c.{$(m)}.{$(o)}.diff: %.c.{$(m)}.{$(o)}.{vanilla}.s %.c.{$(m)}.{$(o)}.{ccmode}.s ; diff -u $$^ > $$@ || true)))

%.c.diff: $(foreach m,$(EXEC_MCUS),$(foreach o,$(EXEC_OPTS),%.c.{$(m)}.{$(o)}.diff))
	cat $^ > $@
	cp $@ ../../diff/$(notdir $(shell pwd)).diff

%.c.done: %.c %.c.{ccmode}.done %.c.{vanilla}.done %.c.{ccmode-dP}.done %.c.{vanilla-dP}.done %.c.diff
	touch $@

