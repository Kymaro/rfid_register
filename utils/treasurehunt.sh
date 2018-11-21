#!/bin/bash

SCRIPTNAME=treasurehunt

TMPDIR=/tmp/${SCRIPTNAME}
TMPDB=${TMPDIR}/db.TXT

RMSPACES="s/\ //g"
SELECTPREFIX="/^120/!d"
RMTRAILING="s/.\\r$//g"

usage() {
    echo -e "USAGE :"
    echo -e "  $ $SCRIPTNAME [participantsDB.csv] [badgers.TXT...]"
    exit 1
}

[ $# -le 1 ] && usage

csv=$1
shift
txt=$@

setup() {
    mkdir -p $TMPDIR
    rm -f $TMPDB
}

teardown() {
    rm -rf $TMPDIR
}

mktmpdb() {
    for file in $txt ; do
        tmpfile=${TMPDIR}/`basename $file`
        cp $file $tmpfile

        sed -i $tmpfile \
            -e "${RMSPACES}" \
            -e "${SELECTPREFIX}" \
            -e "${RMTRAILING}"
        sort $tmpfile | uniq >> $TMPDB
    done
}

getwinner() {
    grep `shuf -n 1 $TMPDB` $csv
}

# Prepare
teardown
setup
# Do work
mktmpdb
getwinner
