#!/bin/bash

xinit -- /usr/bin/Xvfb :1 -screen 0 $SIZEH\x$SIZEW\x$CDEPTH &
sleep 5
export DISPLAY=localhost:1 

# 'Parameterization' of the nightly build

curl -SL https://www.unidata.ucar.edu/software/idv/nightly/webstart/IDV/idv.jar -o /home/idv/IDV/idv.jar
curl -SL https://www.unidata.ucar.edu/software/idv/nightly/webstart/IDV/visad.jar -o /home/idv/IDV/visad.jar
curl -SL https://www.unidata.ucar.edu/software/idv/nightly/webstart/IDV/ncIdv.jar -o /home/idv/IDV/ncIdv.jar

# Grab test data
RUN curl -SL \
   http://motherlode.ucar.edu/repository/entry/get/RAMADDA/IDV%20Community%20Resources/Test%20Data/data.tar.bz2?entryid=f024f354-6cca-45ba-aac5-e06143db5b54 \
  -o /tmp/data.tar.bz2

tar xvfj /tmp/data.tar.bz2 -C /tmp

git clone https://github.com/Unidata/idv-test ~/idv-test

cp ~/idv-test/baseline/* ~/test-output/baseline

#/home/idv/IDV/testIDV ~/test-bundles/addeimage1.xidv ~/test-output/results

for file in idv-test/bundles/* ; do
    echo TESTING $file
    /home/idv/IDV/testIDV $file ~/test-output/results
done

python idv-test/compare.py
