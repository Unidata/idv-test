#!/bin/bash

IDV_HOME=/home/idv

if [ $# -gt 1 ]
then
    echo "Syntax: $(basename $0) <optional git testing branch>"
    exit 1
fi

branch="master"
if [ $# -eq 1 ]
then
    branch=$1
fi

echo $branch

xinit -- /usr/bin/Xvfb :1 -screen 0 $SIZEH\x$SIZEW\x$CDEPTH &
sleep 5
export DISPLAY=localhost:1 

# 'Parameterization' of the nightly build

curl -SL https://www.unidata.ucar.edu/software/idv/nightly/webstart/IDV/idv.jar -o $IDV_HOME/IDV/idv.jar
curl -SL https://www.unidata.ucar.edu/software/idv/nightly/webstart/IDV/visad.jar -o $IDV_HOME/IDV/visad.jar
curl -SL https://www.unidata.ucar.edu/software/idv/nightly/webstart/IDV/ncIdv.jar -o $IDV_HOME/IDV/ncIdv.jar

# Grab test data
curl -SL http://motherlode.ucar.edu/repository/entry/get/RAMADDA/IDV%20Community%20Resources/Test%20Data/data.tar.bz2?entryid=f024f354-6cca-45ba-aac5-e06143db5b54 -o /tmp/data.tar.bz2

tar xvfj /tmp/data.tar.bz2 -C /tmp

#update repo since Docker image file formation
cd $IDV_HOME/idv-test && git pull && git checkout $branch && cd $IDV_HOME

# Setting up test directories

mkdir -p $IDV_HOME/test-output/results

mkdir $IDV_HOME/test-output/baseline

cp $IDV_HOME/idv-test/baseline/* $IDV_HOME/test-output/baseline

#$IDV_HOME/IDV/testIDV $IDV_HOME/idv-test/bundles/addeimage1.xidv $IDV_HOME/test-output/results

for file in idv-test/bundles/* ; do
    echo TESTING $file
    b=$IDV_HOME/test-output/results/$(basename $file).out
    $IDV_HOME/IDV/testIDV $file $IDV_HOME/test-output/results >& $b
done

python idv-test/compare.py
