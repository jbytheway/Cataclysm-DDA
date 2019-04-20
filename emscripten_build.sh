#!/bin/bash

set -e
set -u
set -x

if [ $# != 1 ]
then
    printf "Usage: %s EM_SDK_PATH\n" "$0" >&2
    exit 1
fi

em_sdk_path=$1
env_script="$em_sdk_path/emsdk_env.sh"

if [ ! -r "$env_script" ]
then
    printf "Expected environment script at %s not found\n" "$env_script" >&2
    exit 1
fi

unset CFLAGS
unset CXXFLAGS

. "$env_script"

cd $(dirname $0)

rm -rf build_em
mkdir build_em
cd build_em

emconfigure cmake -DCMAKE_BUILD_TYPE=Debug -DTILES=1 -DBACKTRACE=0 ..
emmake make -j9 VERBOSE=1
