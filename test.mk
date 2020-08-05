MCUS = atmega128 # avr2 avr25 avr3 avr31 avr35 avr5 avr51 avr6 avrxmega3 avrxmega4 avrxmega7 avrtiny 
OPTS = 0 1 2 3 s
COMPARE_OPTS = 2 3 s
DUMP_RTL = # -fdump-rtl-all -fdump-tree-all

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{ccmode}.s: %.c ; $${CCMODE_GCC} $(DUMP_RTL) -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{ccmode-rtl}.s: %.c ; $${CCMODE_GCC} -fdump-rtl-all -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{ccmode-tree}.s: %.c ; $${CCMODE_GCC} -fdump-tree-all -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{ccmode-dP}.s: %.c ; $${CCMODE_GCC} -dP -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{vanilla-rtl}.s: %.c ; $${VANILLA_GCC} -fdump-rtl-all -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{vanilla-tree}.s: %.c ; $${VANILLA_GCC} -fdump-tree-all -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{vanilla}.s: %.c ; $${VANILLA_GCC} $(DUMP_RTL) -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{vanilla-dP}.s: %.c ; $${VANILLA_GCC} -dP -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

%.c.{ccmode}.done: %.c $(foreach m,$(MCUS),$(foreach o,$(OPTS),%.c.{$(m)}.{$(o)}.{ccmode}.s))
	touch $@

%.c.{vanilla}.done: %.c $(foreach m,$(MCUS),$(foreach o,$(OPTS),%.c.{$(m)}.{$(o)}.{vanilla}.s))
	touch $@

%.c.{ccmode}.rtl: %.c $(foreach m,$(MCUS),$(foreach o,$(OPTS),%.c.{$(m)}.{$(o)}.{ccmode-rtl}.s))
	touch $@

%.c.{ccmode}.tree: %.c $(foreach m,$(MCUS),$(foreach o,$(OPTS),%.c.{$(m)}.{$(o)}.{ccmode-tree}.s))
	touch $@

%.c.{vanilla}.rtl: %.c $(foreach m,$(MCUS),$(foreach o,$(OPTS),%.c.{$(m)}.{$(o)}.{vanilla-rtl}.s))
	touch $@

%.c.{vanilla}.tree: %.c $(foreach m,$(MCUS),$(foreach o,$(OPTS),%.c.{$(m)}.{$(o)}.{vanilla-tree}.s))
	touch $@

%.c.{ccmode-dP}.done: %.c $(foreach m,$(MCUS),$(foreach o,$(OPTS),%.c.{$(m)}.{$(o)}.{ccmode-dP}.s))
	touch $@

%.c.{vanilla-dP}.done: %.c $(foreach m,$(MCUS),$(foreach o,$(OPTS),%.c.{$(m)}.{$(o)}.{vanilla-dP}.s))
	touch $@

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.diff: %.c.{$(m)}.{$(o)}.{vanilla}.s %.c.{$(m)}.{$(o)}.{ccmode}.s ; diff -I '\.ident' -u $$^ > $$@ || true)))

%.c.diff: $(foreach m,$(MCUS),$(foreach o,$(COMPARE_OPTS),%.c.{$(m)}.{$(o)}.diff))
	cat $^ > $@
	cp $@ ../../diff/$(notdir $(shell pwd)).diff

%.c.compile: %.c %.c.{ccmode}.done %.c.{vanilla}.done %.c.{ccmode-dP}.done %.c.{vanilla-dP}.done %.c.diff
	touch $@

%.c.rtl: %.c %.c.{ccmode}.rtl %.c.{vanilla}.rtl
	touch $@

%.c.tree: %.c %.c.{ccmode}.tree %.c.{vanilla}.tree
	touch $@

.PRECIOUS:
.SECONDARY:

EXEC_MCUS = atmega128
EXEC_OPTS = 0 1 2 3 s

$(foreach m,$(EXEC_MCUS),$(foreach o,$(EXEC_OPTS),$(eval %.c.{$(m)}.{$(o)}.{ccmode}.exe: %.c ; $${CCMODE_GCC} $(DUMP_RTL) -dumpbase $$@ -O$(o) -mmcu=$(m) -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(EXEC_MCUS),$(foreach o,$(EXEC_OPTS),$(eval %.c.{$(m)}.{$(o)}.{vanilla}.exe: %.c ; $${VANILLA_GCC} $(DUMP_RTL) -dumpbase $$@ -O$(o) -mmcu=$(m) -o $$@ $$< 2> $$@.msg)))

# %.c.{ccmode}.exe.done: %.c $(foreach m,$(EXEC_MCUS),$(foreach o,$(EXEC_OPTS),%.c.{$(m)}.{$(o)}.{ccmode}.exe))
#	touch $@

# %.c.{vanilla}.exe.done: %.c $(foreach m,$(EXEC_MCUS),$(foreach o,$(EXEC_OPTS),%.c.{$(m)}.{$(o)}.{vanilla}.exe))
#	touch $@

%.exe.status: %.exe
	(timeout 10 simulavr -B __stop_program -B abort -d atmega32 --file $< -v && echo success || echo aborted) > $@ 2>&1

%.status.diff: %.{vanilla}.exe.status %.{ccmode}.exe.status
	diff -u $^ > $@ || true

%.c.exe.done: $(foreach m,$(EXEC_MCUS),$(foreach o,$(EXEC_OPTS),%.c.{$(m)}.{$(o)}.{ccmode}.exe.status %.c.{$(m)}.{$(o)}.{vanilla}.exe.status %.c.{$(m)}.{$(o)}.status.diff))
	touch $@

%.c.execute: %.c.exe.done
	touch $@

$(foreach m,$(EXEC_MCUS),$(foreach o,$(EXEC_OPTS),$(eval %.c.{$(m)}.{$(o)}.diff: %.c.{$(m)}.{$(o)}.{vanilla}.s %.c.{$(m)}.{$(o)}.{ccmode}.s ; diff -I '\.ident' -u $$^ > $$@ || true)))

%.c.diff: $(foreach m,$(EXEC_MCUS),$(foreach o,$(EXEC_OPTS),%.c.{$(m)}.{$(o)}.diff))
	cat $^ > $@
	cp $@ ../../diff/$(notdir $(shell pwd)).diff
