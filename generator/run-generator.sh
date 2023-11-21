#!/usr/bin/env sh
set -e

CLASSES_TXT=classes.txt

# Regex foo
cssbeautify-cli -f bootstrap.min.css >$CLASSES_TXT
perl -i -pe 's/^\s*\.(.+)/\1/g' $CLASSES_TXT
grep -E '^\w' $CLASSES_TXT >aux.txt
mv aux.txt $CLASSES_TXT
perl -i -pe 's/,/\n/g' $CLASSES_TXT
perl -i -pe 's/>\./\n/g' $CLASSES_TXT
perl -i -pe 's/ \./\n/g' $CLASSES_TXT
perl -i -pe 's/^\.//g' $CLASSES_TXT
perl -i -pe 's/([^ :>+[.~]+).*/\1/g' $CLASSES_TXT
sed -i '/^\w/!d' $CLASSES_TXT
sort $CLASSES_TXT | uniq >aux.txt
mv aux.txt $CLASSES_TXT

# Create the file
./generator.hs $CLASSES_TXT >../src/Halogen/Themes/Bootstrap5.purs
