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

CFLAGS=$(OPTIM) $(CFLAGS1) $(EXTRA_CFLAGS)
LIBS=$(EXTRA_LIBS) $(LIBS1)
INCLUDES=$(INCLUDES1) $(INCLUDES0) $(EXTRA_INCLUDES)
LDFLAGS=$(LDFLAGS1) $(EXTRA_LDFLAGS)

OBJS=	os.o os-inline.o

LIB=	libos.a

all:	$(LIB)

$(LIB): $(OBJS)
	rm -f $@
	ar cr $@ $(OBJS)
	$(RANLIB) $@

.c.o:
	$(CC) -c $(INCLUDES) $(CFLAGS) $<

clean:
	rm -f $(OBJS) $(LIB)

distclean: clean
	-rm -f Makefile

# We really don't expect end users to use this rule.  It works only with
# gcc, and rebuilds Makefile.tmpl.  You have to re-run Configure after
# using it.
depend:
	cp Makefile.tmpl Makefile.tmpl.bak \
	    && sed -ne '1,/^# DO NOT REMOVE/p' Makefile.tmpl > Makefile.new \
	    && gcc -MM $(INCLUDES) $(CFLAGS) *.c >> Makefile.new \
	    && sed -e '1,$$s: $(INCDIR)/: $$(INCDIR)/:g' \
	           -e '1,$$s: $(OSDIR)/: $$(OSDIR)/:g' Makefile.new \
		> Makefile.tmpl \
	    && rm Makefile.new

$(OBJS): Makefile

# DO NOT REMOVE
os-aix-dso.o: os-aix-dso.c
os-inline.o: os-inline.c $(INCDIR)/ap_config.h \
 $(INCDIR)/ap_mmn.h $(INCDIR)/ap_config_auto.h \
 $(OSDIR)/os.h $(INCDIR)/ap_ctype.h $(INCDIR)/hsregex.h
os.o: os.c $(INCDIR)/ap_config.h $(INCDIR)/ap_mmn.h \
 $(INCDIR)/ap_config_auto.h $(OSDIR)/os.h \
 $(INCDIR)/ap_ctype.h $(INCDIR)/hsregex.h os.h
