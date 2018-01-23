#!/bin/bash

set -x

DISPLAY=:1

IDV_HOME=${HOME}

# Grab test data
curl -SL http://motherlode.ucar.edu/repository/entry/get/RAMADDA/IDV%20Community%20Resources/Test%20Data/data.tar.bz2?entryid=f024f354-6cca-45ba-aac5-e06143db5b54 -o /tmp/data.tar.bz2

tar xvfj /tmp/data.tar.bz2 -C /tmp

mkdir -p ${HOME}/test-output/results

mkdir -p ${HOME}/test-output/baseline

git clone https://github.com/Unidata/idv-test  ${IDV_HOME}/idv-test

cp $IDV_HOME/idv-test/baseline/* ${HOME}/test-output/baseline

for file in idv-test/bundles/*.xidv ; do
    echo TESTING $file
    b=$IDV_HOME/test-output/results/$(basename $file).out
    $IDV_HOME/IDV/testIDV $file $IDV_HOME/test-output/results >& $b
done

python idv-test/compare.py