##
##  Apache Makefile, automatically generated by Configure script.
##  Hand-edited changes will be lost if the Configure script is re-run.
##  Sources: - ../../Makefile.config (via Configuration.apaci)
##           - ./Makefile.tmpl
##

##
##  Inherited Makefile options from Configure script
##  (Begin of automatically generated section)
##
SRCDIR=../..
EXTRA_CFLAGS=-Os -pipe -mfpmath=sse -ffixed-ebp -fforce-addr -fomit-frame-pointer -fexpensive-optimizations -funroll-loops -ffast-math `$(SRCDIR)/apaci`
EXTRA_LDFLAGS=
EXTRA_LIBS=
EXTRA_INCLUDES=
EXTRA_DEPS=
OSDIR=$(SRCDIR)/os/unix
INCDIR=$(SRCDIR)/include
INCLUDES0=-I$(OSDIR) -I$(INCDIR)
SHELL=/bin/sh
OS=Linux
CC=gcc
CPP=gcc -E
TARGET=httpd
OPTIM=
PHP_CFLAGS= -DLINUX=22 -DHAVE_SET_DUMPABLE -DINET6 -Dss_family=__ss_family -Dss_len=__ss_len -DNO_DBM_REWRITEMAP -I/usr/include -I/usr/src/php-5.6.40/main -I/usr/src/php-5.6.40/Zend -I/usr/src/php-5.6.40/TSRM -I/usr/src/php-5.6.40 -I/usr/src/php-5.6.40/sapi/apache -I/usr/src/php-5.6.40/main -I/usr/src/php-5.6.40/Zend -I/usr/src/php-5.6.40/TSRM
PHP_LIBS=  -rdynamic -Lmodules/php5 -L../modules/php5 -L../../modules/php5 -lmodphp5    -rdynamic -lcrypt   -lresolv -lcrypt -lmcrypt -lltdl -lpng -lz -ljpeg -lcurl -lbz2 -lz -lrt -lm -ldl -lnsl  -lxml2 -lz -lm -ldl -lssl -lcrypto -lcurl -lxml2 -lz -lm -ldl -lssl -lcrypto -lxml2 -lz -lm -ldl -lcrypt -lxml2 -lz -lm -ldl -lssl -lcrypto -lcrypt   -lm -lcrypt
CFLAGS1= -DLINUX=22 -DHAVE_SET_DUMPABLE -DINET6 -Dss_family=__ss_family -Dss_len=__ss_len -DNO_DBM_REWRITEMAP -DNO_DL_NEEDED
INCLUDES1=
LIBS_SHLIB=
LDFLAGS1=
MFLAGS_STATIC=--no-print-directory
REGLIB=
EXPATLIB=
RANLIB=ranlib
LIBS1=   -rdynamic -Lmodules/php5 -L../modules/php5 -L../../modules/php5 -lmodphp5    -rdynamic -lcrypt   -lresolv -lcrypt -lmcrypt -lltdl -lpng -lz -ljpeg -lcurl -lbz2 -lz -lrt -lm -ldl -lnsl  -lxml2 -lz -lm -ldl -lssl -lcrypto -lcurl -lxml2 -lz -lm -ldl -lssl -lcrypto -lxml2 -lz -lm -ldl -lcrypt -lxml2 -lz -lm -ldl -lssl -lcrypto -lcrypt   -lm -lcrypt -lexpat
##
##  (End of automatically generated section)
##

##
##  Default Makefile options from Configure script
##  (Begin of automatically generated section)
##
CFLAGS=$(OPTIM) $(CFLAGS1) $(EXTRA_CFLAGS)
LIBS=$(EXTRA_LIBS) $(LIBS1)
INCLUDES=$(INCLUDES1) $(INCLUDES0) $(EXTRA_INCLUDES)
LDFLAGS=$(LDFLAGS1) $(EXTRA_LDFLAGS)
INCDIR=$(SRCDIR)/include
LIBEXT=a
##
##  (End of automatically generated section)
##
##
##  Apache 1.3 Makefile template for PHP 5.0 Module
##  [src/modules/php5/Makefile.tmpl]
##

#   the parametrized target
LIB=libphp5.$(LIBEXT)

#   objects for building the static library
OBJS=mod_php5.o
OBJS_LIB=libmodphp5.a

#   objects for building the shared object library
SHLIB_OBJS=mod_php5.so-o
SHLIB_OBJS_LIB=libmodphp5.a

#   the general targets
all: lib
lib: $(LIB)

#   build the static library by merging the object files
libphp5.a: $(OBJS) $(OBJS_LIB)
	cp $(OBJS_LIB) $@
	ar r $@ $(OBJS)
	$(RANLIB) $@

#   ugly hack to support older Apache-1.3 betas that don't set $LIBEXT
libphp5.: $(OBJS) $(OBJS_LIB)
	cp $(OBJS_LIB) $@
	ar r $@ $(OBJS)
	$(RANLIB) $@
	cp libphp5. libphp5.a

#   build the shared object library by linking the object files
libphp5.so: $(SHLIB_OBJS) $(SHLIB_OBJS_LIB)
	rm -f $@
	$(LD_SHLIB) $(LDFLAGS_SHLIB) -o $@ $(SHLIB_OBJS) $(SHLIB_OBJS_LIB) $(LIBS) $(PHP_LIBS) 

# 1. extension .o for shared objects cannot be used here because
#    first these files aren't still shared objects and second we
#    have to use a different name to trigger the different
#    implicit Make rule
# 2. extension -so.o (as used elsewhere) cannot be used because
#    the suffix feature of Make really wants just .x, so we use
#    extension .so-o
.SUFFIXES: .o .so-o
.c.o:
	$(CC) -c $(INCLUDES) $(CFLAGS) $(PHP_CFLAGS) $(CPPFLAGS) $(SPACER) $<
.c.so-o:
	$(CC) -c $(INCLUDES) $(CFLAGS) $(CFLAGS_SHLIB) $(PHP_CFLAGS) $(CPPFLAGS) $(SPACER) $< && mv $*.o $*.so-o

#   cleanup
clean:
	-rm -f $(OBJS) $(SHLIB_OBJS) $(LIB)

# We really don't expect end users to use this rule.  It works only with
# gcc, and rebuilds Makefile.tmpl.  You have to re-run Configure after
# using it.
depend:
	cp Makefile.tmpl Makefile.tmpl.bak \
	    && sed -ne '1,/^# DO NOT REMOVE/p' Makefile.tmpl > Makefile.new \
	    && gcc -MM $(INCLUDES) $(CFLAGS) $(PHP_CFLAGS) $(CPPFLAGS) *.c >> Makefile.new \
	    && sed -e '1,$$s: $(INCDIR)/: $$(INCDIR)/:g' Makefile.new \
		> Makefile.tmpl \
	    && rm Makefile.new

#Dependencies

$(OBJS): Makefile

# DO NOT REMOVE
mod_php5.o: mod_php5.c $(INCDIR)/httpd.h $(INCDIR)/conf.h \
 $(INCDIR)/buff.h \
 $(INCDIR)/http_config.h \
 $(INCDIR)/http_core.h $(INCDIR)/http_main.h \
 $(INCDIR)/http_protocol.h $(INCDIR)/http_request.h \
 $(INCDIR)/http_log.h $(INCDIR)/util_script.h mod_php5.h
