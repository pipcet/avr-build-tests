MCUS = atmega128 # avr2 avr25 avr3 avr31 avr35 avr5 avr51 avr6 avrxmega3 avrxmega4 avrxmega7 avrtiny 
OPTS = 0 1 2 3 s
COMPARE_OPTS = 2 3 s
DUMP_RTL = # -fdump-rtl-all -fdump-tree-all
VARIANTS = ccmode lra
VARIANTS2 = vanilla $(VARIANTS)

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{ccmode}.s: %.c ; $${CCMODE_GCC} $(DUMP_RTL) -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{ccmode-rtl}.s: %.c ; $${CCMODE_GCC} -fdump-rtl-all -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{ccmode-tree}.s: %.c ; $${CCMODE_GCC} -fdump-tree-all -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{ccmode-dP}.s: %.c ; $${CCMODE_GCC} -dP -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{lra}.s: %.c ; $${LRA_GCC} $(DUMP_RTL) -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{lra-rtl}.s: %.c ; $${LRA_GCC} -fdump-rtl-all -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{lra-tree}.s: %.c ; $${LRA_GCC} -fdump-tree-all -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{lra-dP}.s: %.c ; $${LRA_GCC} -dP -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{vanilla-rtl}.s: %.c ; $${VANILLA_GCC} -fdump-rtl-all -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{vanilla-tree}.s: %.c ; $${VANILLA_GCC} -fdump-tree-all -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{vanilla}.s: %.c ; $${VANILLA_GCC} $(DUMP_RTL) -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{vanilla-dP}.s: %.c ; $${VANILLA_GCC} -dP -dumpbase $$@ -O$(o) -mmcu=$(m) -S -o $$@ $$< 2> $$@.msg)))

$(foreach v,$(VARIANTS2),$(eval %.c.{$(v)}.done: %.c $(foreach m,$(MCUS),$(foreach o,$(OPTS),%.c.{$(m)}.{$(o)}.{$(v)}.s)) ; touch $$@))

$(foreach v,$(VARIANTS2),$(eval %.c.{$(v)}.rtl: %.c $(foreach m,$(MCUS),$(foreach o,$(OPTS),%.c.{$(m)}.{$(o)}.{$(v)-rtl}.s)) ; touch $$@))

$(foreach v,$(VARIANTS2),$(eval %.c.{$(v)}.tree: %.c $(foreach m,$(MCUS),$(foreach o,$(OPTS),%.c.{$(m)}.{$(o)}.{$(v)-tree}.s)) ; touch $$@))

$(foreach v,$(VARIANTS2),$(eval %.c.{$(v)-dP}.done: %.c $(foreach m,$(MCUS),$(foreach o,$(OPTS),%.c.{$(m)}.{$(o)}.{$(v)-dP}.s)) ; touch $$@))

$(foreach v,$(VARIANTS),$(foreach m,$(MCUS),$(foreach o,$(OPTS),$(eval %.c.{$(m)}.{$(o)}.{$(v)}.diff: %.c.{$(m)}.{$(o)}.{vanilla}.s %.c.{$(m)}.{$(o)}.{$(v)}.s ; (echo DIR $(notdir $(shell pwd)); diff -I '\.ident' -u $$^) > $$@ || true))))

%.c.compile: %.c $(foreach v,$(VARIANTS2),%.c.{$(v)}.done %.c.{$(v)-dP}.done) $(foreach v,$(VARIANTS),%.c.{$(v)}.diff)
	touch $@

%.c.rtl: %.c $(foreach v,$(VARIANTS2),%.c.{$(v)}.rtl)
	touch $@

%.c.tree: %.c $(foreach v,$(VARIANTS2),%.c.{$(v)}.tree)
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

$(foreach m,$(EXEC_MCUS),$(foreach o,$(EXEC_OPTS),$(eval %.c.{$(m)}.{$(o)}.{ccmode}.diff: %.c.{$(m)}.{$(o)}.{vanilla}.s %.c.{$(m)}.{$(o)}.{ccmode}.s ; (echo DIR $(notdir $(shell pwd)); diff -I '\.ident' -u $$^) > $$@ || true)))

%.c.{ccmode}.diff: $(foreach m,$(MCUS),$(foreach o,$(COMPARE_OPTS),%.c.{$(m)}.{$(o)}.{ccmode}.diff))
	cat $^ > $@
	for D in $^; do \
	    HASH=`perl ../../diffhash.pl $$D`; \
	    if ! [ -f ../../classified-diff/*/$$HASH.diff ]; then \
	        cp $$D ../../diff/$$HASH.diff; \
	    fi; \
	done

%.c.{ccmode}.diff: $(foreach m,$(EXEC_MCUS),$(foreach o,$(EXEC_OPTS),%.c.{$(m)}.{$(o)}.{ccmode}.diff))
	cat $^ > $@
	for D in $^; do \
	    HASH=`perl ../../diffhash.pl $$D`; \
	    if ! [ -f ../../classified-diff/*/$$HASH.diff ]; then \
	        cp $$D ../../diff/$$HASH.diff; \
	    fi; \
	done

%.c.{lra}.diff: $(foreach m,$(MCUS),$(foreach o,$(COMPARE_OPTS),%.c.{$(m)}.{$(o)}.{lra}.diff))
	cat $^ > $@
	for D in $^; do \
	    HASH=`perl ../../diffhash.pl $$D`; \
	    if ! [ -f ../../classified-diff/*/$$HASH.diff ]; then \
	        cp $$D ../../diff-lra/$$HASH.diff; \
	    fi; \
	done

%.c.{lra}.diff: $(foreach m,$(EXEC_MCUS),$(foreach o,$(EXEC_OPTS),%.c.{$(m)}.{$(o)}.{lra}.diff))
	cat $^ > $@
	for D in $^; do \
	    HASH=`perl ../../diffhash.pl $$D`; \
	    if ! [ -f ../../classified-diff/*/$$HASH.diff ]; then \
	        cp $$D ../../diff-lra/$$HASH.diff; \
	    fi; \
	done
