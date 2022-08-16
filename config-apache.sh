#!/bin/bash

CFLAGS="-Os -pipe -fforce-addr -fomit-frame-pointer -fexpensive-optimizations -funroll-loops -ffast-math";export CFLAGS
CCOPTS="-Os -pipe -fforce-addr -fomit-frame-pointer -fexpensive-optimizations -funroll-loops -ffast-math";export CCOPTS
./configure --disable-module=negotiation --disable-module=include --disable-module=setenvif --disable-module=status --disable-module=actions --disable-module=asis --disable-module=userdir --disable-module=autoindex --disable-module=imap --enable-module=rewrite --enable-module=expires --enable-rule=INET6 --activate-module=src/modules/php5/libphp5.a
