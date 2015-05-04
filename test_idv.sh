#!/bin/bash
#
# Convienence script to launch a docker container version of the IDV with all of the appropriate arguments.

# Note: If running with boot2docker, the output dir may have to be at or below ~

if [ $# -ne 1 ]
then
    echo "Syntax: $(basename $0) <output dir>"
    exit 1
fi

set -x

d=$1

if [ ! -d $d ]; then
    mkdir -p $d
fi

docker run -v $d:/home/idv/test-output -p 5901:5901 --rm -it unidata/idv-test bash -c "/home/idv/starttest.sh master"
