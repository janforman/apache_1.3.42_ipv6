##
##  Apache Makefile, automatically generated by Configure script.
##  Hand-edited changes will be lost if the Configure script is re-run.
##  Sources: - ./Makefile.config (via Configuration.apaci)
##           - ./Makefile.tmpl
##

MODULES= \
  modules/standard/libstandard.a \
  modules/php5/libphp5.a

SUBDIRS=os/unix ap main lib modules
SUBTARGET=target_static
SHLIB_SUFFIX_NAME=
SHMOD_SUFFIX_NAME=
SHLIB_SUFFIX_LIST=
SHLIB_EXPORT_FILES=

##
##  Inherited Makefile options from Configure script
##  (Begin of automatically generated section)
##
SRCDIR=.
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

OBJS= \
  modules.o \
  $(MODULES) \
  main/libmain.a \
  $(OSDIR)/libos.a \
  ap/libap.a

.c.o:
	$(CC) -c $(INCLUDES) $(CFLAGS) $<

# Used to generate import library for OS/2
.SUFFIXES: .def
.def.a:
	emximp -o $@ $<

all: Configuration.apaci $(TARGET)

Configuration.apaci: Configuration.tmpl
	@echo "++ File 'Configuration.apaci' older than 'Configuration.tmpl',"
	@echo "++ or still doesn't exist. Please consider copying 'Configuration.tmpl'"
	@echo "++ to 'Configuration.apaci', editing and rerunning 'Configure'."
	@echo "++ If not, you will at least have to touch 'Configuration.apaci'."
	@false

$(TARGET): $(EXTRA_DEPS) $(SUBTARGET)

target_static: subdirs modules.o
	$(CC) -c $(INCLUDES) $(CFLAGS) buildmark.c
	$(CC) $(CFLAGS) $(LDFLAGS) $(LDFLAGS_SHLIB_EXPORT) \
	      -o $(TARGET) buildmark.o $(OBJS) $(REGLIB) $(EXPATLIB) $(LIBS)

target_compile_only: subdirs modules.o
	$(CC) -c $(INCLUDES) $(CFLAGS) buildmark.c

target_shared: $(SHCORE_IMPLIB) $(SHARED_CORE_EP) lib$(TARGET).$(SHLIB_SUFFIX_NAME)
	$(CC) $(INCLUDES) $(CFLAGS) $(LDFLAGS) $(LDFLAGS_SHLIB_EXPORT) \
	      -o $(TARGET) -DSHARED_CORE_BOOTSTRAP main/http_main.c \
	      ap/libap.a $(LIBS) $(SHCORE_IMPLIB)

lib$(TARGET).ep: lib$(TARGET).$(SHLIB_SUFFIX_NAME)
	$(CC) $(INCLUDES) $(CFLAGS) $(LDFLAGS) $(LDFLAGS_SHLIB_EXPORT) \
	      -o lib$(TARGET).ep -DSHARED_CORE_TIESTATIC main/http_main.c \
		  -L. -l$(TARGET) $(LIBS)

lib$(TARGET).$(SHLIB_SUFFIX_NAME): subdirs modules.o
	$(CC) -c $(INCLUDES) $(CFLAGS) buildmark.c
	$(LD_SHLIB) $(LDFLAGS_SHLIB) -o lib$(TARGET).$(SHLIB_SUFFIX_NAME) buildmark.o $(OBJS) $(REGLIB) $(EXPATLIB) $(LD_SHCORE_DEF) $(LD_SHCORE_LIBS)
	@if [ ".$(SHLIB_SUFFIX_LIST)" != . ]; then \
		rm -f lib$(TARGET).$(SHLIB_SUFFIX_NAME).*; \
		for suffix in $(SHLIB_SUFFIX_LIST) ""; do \
			[ ".$$suffix" = . ] && continue; \
		    echo "ln lib$(TARGET).$(SHLIB_SUFFIX_NAME) lib$(TARGET).$(SHLIB_SUFFIX_NAME).$$suffix"; \
		    ln lib$(TARGET).$(SHLIB_SUFFIX_NAME) lib$(TARGET).$(SHLIB_SUFFIX_NAME).$$suffix; \
		done; \
	fi

subdirs:
	@for i in $(SUBDIRS); do \
		echo "===> $(SDP)$$i"; \
		case ".$(OS)" in \
		  .OS390 | .TPF) ( cd $$i && $(MAKE) SDP='$(SDP)' OPTIM='$(OPTIM)') || exit 1;; \
		              *) ( cd $$i && $(MAKE) $(MFLAGS_STATIC) SDP='$(SDP)' CC='$(CC)' AUX_CFLAGS='$(CFLAGS)' RANLIB='$(RANLIB)' OPTIM='$(OPTIM)') || exit 1;; \
		esac; \
		echo "<=== $(SDP)$$i"; \
	done

support: support-dir

support-dir:
	@echo "===> $(SDP)support"; \
	cd support; $(MAKE) $(MFLAGS_STATIC) SDP='$(SDP)' CC='$(CC)' AUX_CFLAGS='$(CFLAGS)' RANLIB='$(RANLIB)' OPTIM='$(OPTIM)' || exit 1; \
	echo "<=== $(SDP)support"

clean:
	-rm -f $(TARGET) lib$(TARGET).* *.o
	@for i in $(SUBDIRS); do \
		echo "===> $(SDP)$$i"; \
		( cd $$i && $(MAKE) $(MFLAGS_STATIC) SDP='$(SDP)' OPTIM='$(OPTIM)' $@ ) || exit 1; \
		echo "<=== $(SDP)$$i"; \
	done

distclean:
	-rm -f $(TARGET) lib$(TARGET).* *.o
	@for i in $(SUBDIRS); do \
		echo "===> $(SDP)$$i"; \
		( cd $$i && $(MAKE) $(MFLAGS_STATIC) SDP='$(SDP)' $@ ) || exit 1; \
		echo "<=== $(SDP)$$i"; \
	done
	-rm -f include/ap_config_auto.h
	-rm -f modules.c
	-rm -f modules/Makefile
	-rm -f regex/Makefile
	-rm -f lib/Makefile
	-rm -f Makefile.config
	-rm -f Makefile

install:
	@echo "++ Sorry, no installation procedure available at this level."
	@echo "++ Go to the parent directory for an 'install' target."

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
	for i in $(SUBDIRS); do \
	    ( cd $$i && $(MAKE) CC='$(CC)' AUX_CFLAGS='$(CFLAGS)' RANLIB='$(RANLIB)' OPTIM='$(OPTIM)' depend ) || exit 1; \
	done

#Dependencies

$(OBJS): Makefile subdirs

# DO NOT REMOVE
buildmark.o: buildmark.c include/ap_config.h include/ap_mmn.h \
 include/ap_config_auto.h $(OSDIR)/os.h include/ap_ctype.h \
 include/hsregex.h include/httpd.h include/ap_alloc.h include/buff.h \
 include/ap.h include/util_uri.h
modules.o: modules.c include/httpd.h include/ap_config.h \
 include/ap_mmn.h include/ap_config_auto.h $(OSDIR)/os.h \
 include/ap_ctype.h include/hsregex.h include/ap_alloc.h include/buff.h \
 include/ap.h include/util_uri.h include/http_config.h
