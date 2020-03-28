#!/bin/bash

dir=`pwd`
./make.sh && c64debugger -symbols "${dir}/start.sym" -breakpoints "${dir}/main.dbg" -prg "${dir}/main.prg" -alwaysjmp
