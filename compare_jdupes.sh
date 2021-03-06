#!/bin/sh

# Runs the installed *dupes* binary and the built binary and compares
# the output for sameness. Also displays timing statistics.

ERR=0

# Detect installed program type (fdupes or jdupes)
ORIG_DUPE=false
jdupes -v 2>/dev/null >/dev/null && ORIG_DUPE=jdupes
fdupes-jody -v 2>/dev/null >/dev/null && ORIG_DUPE=fdupes-jody
fdupes -v 2>/dev/null >/dev/null && ORIG_DUPE=fdupes
if [ ! $ORIG_DUPE -v 2>/dev/null >/dev/null ]
	then echo "Cannot run installed jdupes, fdupes-jody, or fdupes"
	exit 1
fi

test ! -e ./jdupes && echo "Build jdupes first, silly" && exit 1

echo -n "Installed '$ORIG_DUPE':"
sync
time $ORIG_DUPE -nrq "$@" > foo || ERR=1
echo -en "\nBuilt jdupes:"
sync
time ./jdupes -nrq "$@" > bar || ERR=1
diff -Nau foo bar
rm foo bar
test "$ERR" != "0" && echo "Errors were returned during execution"
