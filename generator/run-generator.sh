#!/bin/bash


function convert {
    target=$1
    module=$2
    
    output="../src/Halogen/Bootstrap5/$module.purs"
    header="module Halogen.Bootstrap5.$module where\n\nimport Halogen.HTML.Core (ClassName(..))\n\n"

    # Regex-fu
    CLASSES_TXT="classes-$target.txt"
    AUX_TXT="aux-$target.txt"

    cp "$target.css" $CLASSES_TXT

    for i in \
        's/^\s*\.(.+)/$1/g' \
        's/^[^a-z].*\n//g' \
        's/,/\n/g' \
        's/ \./\n/g' \
        's/^\.//g' \
        's/^(\w+)/.$1/g' \
        's/\.([\w-]+)/?$1?/g' \
        's/\?\?/?\n?/g' \
        's/^\?([\w-]+)\?.*/$1/g' \
        's/^[^\w].*//g'
        do
        perl -i -pe "$i" $CLASSES_TXT;
    done
    
    sort $CLASSES_TXT | uniq > $AUX_TXT
    mv $AUX_TXT $CLASSES_TXT
    
    NAMES_TXT="names-$target.txt"
    printf "$header" > $NAMES_TXT
    perl gen.pl $CLASSES_TXT >> $NAMES_TXT

    rm $CLASSES_TXT
    mv $NAMES_TXT $output
}

mkdir -p "../src/Halogen/Bootstrap5"

convert "bootstrap.min" "Bootstrap"
convert "bootstrap-icons" "Icons"