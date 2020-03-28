#!/bin/bash

/usr/bin/kickass -bytedump -bytedumpfile ./dump.byte -symbolfile -vicesymbols -debugdump -showmem ./start.asm -o main.prg
