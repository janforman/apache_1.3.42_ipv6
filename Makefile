# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


##
##  Makefile -- Apache Autoconf-style Interface (APACI)
##              top-level control Makefile for out-of-the-box
##              build and installation procedure.
##
##  Written by Ralf S. Engelschall <rse@apache.org>
##

## ==================================================================
##                              Options
## ==================================================================

#   safe environment
SHELL           = /bin/sh

#   what platform are we on
PLATFORM	= x86_64-whatever-linux22

#   paths to the source tree parts
TOP             = .
SRC             = src
MKF             = Makefile
AUX             = src/helpers

#   build tools
CP              = cp
LN              = ln
RM              = rm -f
MKDIR           = $(TOP)/$(AUX)/mkdir.sh
INSTALL         = $(TOP)/$(AUX)/install.sh -c
IFLAGS_PROGRAM  = -m 755 -s
IFLAGS_CORE     = -m 755
IFLAGS_DSO      = -m 755
IFLAGS_SCRIPT   = -m 755
IFLAGS_DATA     = -m 644
INSTALL_PROGRAM = $(INSTALL) $(IFLAGS_PROGRAM)
INSTALL_CORE    = $(INSTALL) $(IFLAGS_CORE)
INSTALL_DSO     = $(INSTALL) $(IFLAGS_DSO)
INSTALL_SCRIPT  = $(INSTALL) $(IFLAGS_SCRIPT)
INSTALL_DATA    = $(INSTALL) $(IFLAGS_DATA)
PERL            = /usr/bin/perl
TAR		= /usr/bin/gtar
TAROPT		= -hcf

#   installation name of Apache webserver
TARGET          = httpd

#   installation root 
#   (overrideable by package maintainers for
#   rolling packages without bristling the system)
root            =

#   installation paths
prefix          = /usr/local/apache
exec_prefix     = /usr/local/apache
bindir          = /usr/local/apache/bin
sbindir         = /usr/local/apache/bin
libexecdir      = /usr/local/apache/libexec
mandir          = /usr/local/apache/man
sysconfdir      = /usr/local/apache/conf
datadir         = /usr/local/apache
iconsdir        = /usr/local/apache/icons
htdocsdir       = /usr/local/apache/htdocs
manualdir       = /usr/local/apache/htdocs/manual
cgidir          = /usr/local/apache/cgi-bin
includedir      = /usr/local/apache/include
localstatedir   = /usr/local/apache
runtimedir      = /usr/local/apache/logs
logfiledir      = /usr/local/apache/logs
proxycachedir   = /usr/local/apache/proxy

libexecdir_relative   = libexec/

#   suexec details (optional)
suexec          = 0
suexec_caller   = www
suexec_docroot  = /usr/local/apache/htdocs
suexec_logexec  = /usr/local/apache/logs/suexec_log
suexec_userdir  = public_html
suexec_uidmin   = 100
suexec_gidmin   = 100
suexec_safepath = /usr/local/bin:/usr/bin:/bin
suexec_umask    = 

#   some substituted configuration parameters
conf_user        = nobody
conf_group       = nobody
conf_port        = 80
conf_serveradmin = root@d4107-1714
conf_servername  = d4107-1714

#   usage of src/support stuff
build-support     = build-support
install-support   = install-support
clean-support     = clean-support
distclean-support = distclean-support

#   forwarding arguments
MFWD = root=$(root)

## ==================================================================
##                              Targets
## ==================================================================

#   default target
all: build

## ------------------------------------------------------------------
##                           Build Target
## ------------------------------------------------------------------

#   build the package
build:
	@echo "===> $(SRC)"
	@$(MAKE) -f $(TOP)/$(MKF) $(MFLAGS) $(MFWD) build-std
	@if [ "x$(build-support)" != "x" ]; then \
	    $(MAKE) -f $(TOP)/$(MKF) $(MFLAGS) $(MFWD) $(build-support); \
        fi
	@touch $(TOP)/$(SRC)/.apaci.build.ok
	@echo "<=== $(SRC)"

#   the non-verbose variant for package maintainers
build-quiet:
	@$(MAKE) -f $(TOP)/$(MKF) $(MFLAGS) $(MFWD) QUIET=1 build

#   build the standard stuff
build-std:
	@case "x$(PLATFORM)" in \
	  x*390*) _C89_STEPS="0xffffffff"; export _C89_STEPS;; \
	esac; \
	cd $(TOP)/$(SRC); $(MAKE) $(MFLAGS) SDP=$(SRC)/ all

#   build the additional support stuff
build-support:
	@echo "===> $(SRC)/support"; \
	case "x$(PLATFORM)" in \
	  x*390*) _C89_STEPS="0xffffffff"; export _C89_STEPS;; \
	esac; \
	cd $(TOP)/$(SRC)/support; $(MAKE) $(MFLAGS) all || exit 1; \
	if [ ".$(suexec)" = .1 ]; then \
	    $(MAKE) $(MFLAGS) \
		EXTRA_CFLAGS='\
			$(suexec_umask) \
			-DHTTPD_USER=\"$(suexec_caller)\" \
			-DUID_MIN=$(suexec_uidmin) \
			-DGID_MIN=$(suexec_gidmin) \
			-DUSERDIR_SUFFIX=\"$(suexec_userdir)\" \
			-DLOG_EXEC=\"$(suexec_logexec)\" \
			-DDOC_ROOT=\"$(suexec_docroot)\" \
			-DSAFE_PATH=\"$(suexec_safepath)\"' \
		suexec; \
	fi
	@echo "<=== $(SRC)/support"

## ------------------------------------------------------------------
##                       Installation Targets
## ------------------------------------------------------------------

#   indirection step to avoid conflict with INSTALL document 
#   on case-insenstive filesystems, for instance on OS/2
install: install-all

#   the install target for installing the complete Apache
#   package. This is implemented by running subtargets for the
#   separate parts of the installation process.
install-all:
	@if [ ! -f $(TOP)/$(SRC)/.apaci.build.ok ]; then \
		$(MAKE) -f $(TOP)/$(MKF) $(MFLAGS) $(MFWD) build; \
	else \
		:; \
	fi
	@$(MAKE) -f $(TOP)/$(MKF) $(MFLAGS) $(MFWD) \
		install-mktree install-programs $(install-support) \
		install-include install-data install-config
	-@$(RM) $(SRC)/.apaci.install.tmp
	-@$(RM) $(SRC)/.apaci.install.conf
	-@if [ ".$(QUIET)" != .1 ]; then \
		if [ ".$(TARGET)" = .httpd ]; then \
			apachectl='apachectl'; \
		else \
			apachectl="$(TARGET)ctl"; \
		fi; \
		echo "+--------------------------------------------------------+"; \
		echo "| You now have successfully built and installed the      |"; \
		echo "| Apache 1.3 HTTP server. To verify that Apache actually |"; \
		echo "| works correctly you now should first check the         |"; \
		echo "| (initially created or preserved) configuration files   |"; \
		echo "|                                                        |"; \
		echo "|   $(sysconfdir)/$(TARGET).conf"; \
		echo "|                                                        |"; \
		echo "| and then you should be able to immediately fire up     |"; \
		echo "| Apache the first time by running:                      |"; \
		echo "|                                                        |"; \
		echo "|   $(sbindir)/$${apachectl} start"; \
		echo "|                                                        |"; \
		echo "| Thanks for using Apache.       The Apache Group        |"; \
		echo "|                                http://www.apache.org/  |"; \
		echo "+--------------------------------------------------------+"; \
	fi

#   the non-verbose variant for package maintainers
install-quiet:
	@$(MAKE) -f $(TOP)/$(MKF) $(MFLAGS) $(MFWD) QUIET=1 install-all

#   create the installation tree
install-mktree:
	@echo "===> [mktree: Creating Apache installation tree]"
	$(MKDIR) $(root)$(bindir)
	$(MKDIR) $(root)$(sbindir)
	$(MKDIR) $(root)$(libexecdir)
	$(MKDIR) $(root)$(mandir)/man1
	$(MKDIR) $(root)$(mandir)/man8
	$(MKDIR) $(root)$(sysconfdir)
	$(MKDIR) $(root)$(htdocsdir)
	$(MKDIR) $(root)$(manualdir)
	$(MKDIR) $(root)$(iconsdir)
	$(MKDIR) $(root)$(cgidir)
	$(MKDIR) $(root)$(includedir)
	$(MKDIR) $(root)$(includedir)/xml
	$(MKDIR) $(root)$(runtimedir)
	$(MKDIR) $(root)$(logfiledir)
	$(MKDIR) $(root)$(proxycachedir)
	-@if [ "x`$(AUX)/getuid.sh`" = "x0" ]; then \
		echo "chown $(conf_user) $(root)$(proxycachedir)"; \
		chown $(conf_user) $(root)$(proxycachedir); \
		echo "chgrp $(conf_group) $(root)$(proxycachedir)"; \
		chgrp "$(conf_group)" $(root)$(proxycachedir); \
	fi
	@echo "<=== [mktree]"

#   install the server program and optionally corresponding
#   shared object files.
install-programs:
	@echo "===> [programs: Installing Apache $(TARGET) program and shared objects]"
	-@if [ ".`grep '^[ 	]*AddModule.*mod_so\.o' $(TOP)/$(SRC)/Configuration.apaci`" != . ]; then \
		echo "$(INSTALL_CORE) $(TOP)/$(SRC)/$(TARGET) $(root)$(sbindir)/$(TARGET)"; \
		$(INSTALL_CORE) $(TOP)/$(SRC)/$(TARGET) $(root)$(sbindir)/$(TARGET); \
		SHLIB_EXPORT_FILES="`grep '^SHLIB_EXPORT_FILES=' $(TOP)/$(SRC)/Makefile | sed -e 's:^.*=::'`"; \
		if [ ".$${SHLIB_EXPORT_FILES}" != . ]; then \
			$(CP) $(TOP)/$(SRC)/support/httpd.exp $(root)$(libexecdir)/; \
			chmod 644 $(root)$(libexecdir)/httpd.exp; \
		fi; \
	else \
		echo "$(INSTALL_PROGRAM) $(TOP)/$(SRC)/$(TARGET) $(root)$(sbindir)/$(TARGET)"; \
		$(INSTALL_PROGRAM) $(TOP)/$(SRC)/$(TARGET) $(root)$(sbindir)/$(TARGET); \
	fi
	-@if [ ".`grep 'SUBTARGET=target_shared' $(TOP)/$(SRC)/Makefile`" != . ]; then \
		SHLIB_SUFFIX_NAME="`grep '^SHLIB_SUFFIX_NAME=' $(TOP)/$(SRC)/Makefile | sed -e 's:^.*=::'`"; \
		SHLIB_SUFFIX_LIST="`grep '^SHLIB_SUFFIX_LIST=' $(TOP)/$(SRC)/Makefile | sed -e 's:^.*=::'`"; \
		echo "$(INSTALL_CORE) $(TOP)/$(SRC)/lib$(TARGET).ep $(root)$(libexecdir)/lib$(TARGET).ep"; \
		$(INSTALL_CORE) $(TOP)/$(SRC)/lib$(TARGET).ep $(root)$(libexecdir)/lib$(TARGET).ep; \
		echo "$(INSTALL_DSO) $(TOP)/$(SRC)/lib$(TARGET).$${SHLIB_SUFFIX_NAME} $(root)$(libexecdir)/lib$(TARGET).$${SHLIB_SUFFIX_NAME}"; \
		$(INSTALL_DSO) $(TOP)/$(SRC)/lib$(TARGET).$${SHLIB_SUFFIX_NAME} $(root)$(libexecdir)/lib$(TARGET).$${SHLIB_SUFFIX_NAME}; \
		if [ ".$${SHLIB_SUFFIX_LIST}" != . ]; then \
			echo "$(RM) $(libexecdir)/lib$(TARGET).$${SHLIB_SUFFIX_NAME}.*"; \
			$(RM) $(libexecdir)/lib$(TARGET).$${SHLIB_SUFFIX_NAME}.*; \
			for suffix in $${SHLIB_SUFFIX_LIST} ""; do \
				[ ".$${suffix}" = . ] && continue; \
				echo "$(LN) $(root)$(libexecdir)/lib$(TARGET).$${SHLIB_SUFFIX_NAME} $(root)$(libexecdir)/lib$(TARGET).$${SHLIB_SUFFIX_NAME}.$${suffix}"; \
				$(LN) $(root)$(libexecdir)/lib$(TARGET).$${SHLIB_SUFFIX_NAME} $(root)$(libexecdir)/lib$(TARGET).$${SHLIB_SUFFIX_NAME}.$${suffix}; \
			done; \
		fi; \
	fi
	$(INSTALL_DATA) $(TOP)/$(SRC)/support/httpd.8 $(root)$(mandir)/man8/$(TARGET).8
	-@$(RM) $(SRC)/.apaci.install.conf; touch $(SRC)/.apaci.install.conf
	-@if [ ".`grep '^[ 	]*SharedModule' $(TOP)/$(SRC)/Configuration.apaci`" != . ]; then \
		for mod in `egrep '^[ 	]*SharedModule' $(TOP)/$(SRC)/Configuration.apaci |\
	                sed -e 's/^[ 	]*SharedModule[ 	]*//'`; do \
			file=`echo $${mod} | sed -e 's;^.*/\([^/]*\);\1;'`; \
			echo "$(INSTALL_DSO) $(TOP)/$(SRC)/$${mod} $(root)$(libexecdir)/$${file}"; \
			$(INSTALL_DSO) $(TOP)/$(SRC)/$${mod} $(root)$(libexecdir)/$${file}; \
			name=`$(TOP)/$(AUX)/fmn.sh $(TOP)/$(SRC)/$${mod}`; \
			echo dummy | awk '{ printf("LoadModule %-18s %s\n", modname, modpath); }' \
			modname="$${name}" modpath="$(libexecdir_relative)$${file}" >>$(SRC)/.apaci.install.conf; \
		done; \
		echo "" >>$(SRC)/.apaci.install.conf; \
		echo "#  Reconstruction of the complete module list from all available modules" >>$(SRC)/.apaci.install.conf; \
		echo "#  (static and shared ones) to achieve correct module execution order." >>$(SRC)/.apaci.install.conf; \
		echo "#  [WHENEVER YOU CHANGE THE LOADMODULE SECTION ABOVE UPDATE THIS, TOO]" >>$(SRC)/.apaci.install.conf; \
		echo "ClearModuleList" >>$(SRC)/.apaci.install.conf; \
		egrep "^[ 	]*(Add|Shared)Module" $(SRC)/Configuration.apaci |\
		sed	-e 's:SharedModule:AddModule:' \
			-e 's:modules/[^/]*/::' \
			-e 's:[ 	]lib: mod_:' \
			-e 's:\.[dsoam].*$$:.c:' >>$(SRC)/.apaci.install.conf; \
	fi
	@echo "<=== [programs]"

#   install the support programs and scripts
install-support:
	@echo "===> [support: Installing Apache support programs and scripts]"
	$(INSTALL_PROGRAM) $(TOP)/$(SRC)/support/ab $(root)$(sbindir)/ab
	$(INSTALL_DATA) $(TOP)/$(SRC)/support/ab.8 $(root)$(mandir)/man8/ab.8
	@if [ ".$(TARGET)" = .httpd ]; then \
		apachectl='apachectl'; \
	else \
		apachectl="$(TARGET)ctl"; \
	fi; \
	echo "$(INSTALL_SCRIPT) $(TOP)/$(SRC)/support/apachectl[*] $(root)$(sbindir)/$${apachectl}"; \
	sed -e 's;PIDFILE=.*;PIDFILE=$(runtimedir)/$(TARGET).pid;' \
		-e 's;HTTPD=.*;HTTPD=$(sbindir)/$(TARGET);' \
		< $(TOP)/$(SRC)/support/apachectl > $(TOP)/$(SRC)/.apaci.install.tmp && \
		$(INSTALL_SCRIPT) $(TOP)/$(SRC)/.apaci.install.tmp $(root)$(sbindir)/$${apachectl}; \
	echo "$(INSTALL_DATA) $(TOP)/$(SRC)/support/apachectl.8 $(root)$(mandir)/man8/$${apachectl}.8"; \
	$(INSTALL_DATA) $(TOP)/$(SRC)/support/apachectl.8 $(root)$(mandir)/man8/$${apachectl}.8
	$(INSTALL_PROGRAM) $(TOP)/$(SRC)/support/checkgid $(root)$(bindir)/checkgid
	$(INSTALL_PROGRAM) $(TOP)/$(SRC)/support/htpasswd $(root)$(bindir)/htpasswd
	$(INSTALL_DATA) $(TOP)/$(SRC)/support/htpasswd.1 $(root)$(mandir)/man1/htpasswd.1
	$(INSTALL_PROGRAM) $(TOP)/$(SRC)/support/htdigest $(root)$(bindir)/htdigest
	$(INSTALL_DATA) $(TOP)/$(SRC)/support/htdigest.1 $(root)$(mandir)/man1/htdigest.1
	@echo "$(INSTALL_SCRIPT) $(TOP)/$(SRC)/support/dbmmanage[*] $(root)$(bindir)/dbmmanage"; \
	sed -e 's;^#!/.*;#!$(PERL);' \
		< $(TOP)/$(SRC)/support/dbmmanage > $(TOP)/$(SRC)/.apaci.install.tmp && \
		$(INSTALL_SCRIPT) $(TOP)/$(SRC)/.apaci.install.tmp $(root)$(bindir)/dbmmanage
	$(INSTALL_DATA) $(TOP)/$(SRC)/support/dbmmanage.1 $(root)$(mandir)/man1/dbmmanage.1
	$(INSTALL_PROGRAM) $(TOP)/$(SRC)/support/logresolve $(root)$(sbindir)/logresolve
	$(INSTALL_DATA) $(TOP)/$(SRC)/support/logresolve.8 $(root)$(mandir)/man8/logresolve.8
	$(INSTALL_PROGRAM) $(TOP)/$(SRC)/support/rotatelogs $(root)$(sbindir)/rotatelogs
	$(INSTALL_DATA) $(TOP)/$(SRC)/support/rotatelogs.8 $(root)$(mandir)/man8/rotatelogs.8
	@echo "$(INSTALL_SCRIPT) $(TOP)/$(SRC)/support/apxs[*] $(root)$(sbindir)/apxs"; \
	sed -e 's;^#!/.*;#!$(PERL);' \
		-e 's;\@prefix\@;$(prefix);' \
		-e 's;\@sbindir\@;$(sbindir);' \
		-e 's;\@libexecdir\@;$(libexecdir);' \
		-e 's;\@includedir\@;$(includedir);' \
		-e 's;\@sysconfdir\@;$(sysconfdir);' \
		< $(TOP)/$(SRC)/support/apxs > $(TOP)/$(SRC)/.apaci.install.tmp && \
		$(INSTALL_SCRIPT) $(TOP)/$(SRC)/.apaci.install.tmp $(root)$(sbindir)/apxs
	$(INSTALL_DATA) $(TOP)/$(SRC)/support/apxs.8 $(root)$(mandir)/man8/apxs.8
	-@if [ ".$(suexec)" = .1 ]; then \
	    echo "$(INSTALL_PROGRAM) $(TOP)/$(SRC)/support/suexec $(root)$(sbindir)/suexec"; \
	    $(INSTALL_PROGRAM) $(TOP)/$(SRC)/support/suexec $(root)$(sbindir)/suexec; \
	    echo "chown root $(root)$(sbindir)/suexec"; \
	    chown root $(root)$(sbindir)/suexec; \
	    echo "chmod 4711 $(root)$(sbindir)/suexec"; \
	    chmod 4711 $(root)$(sbindir)/suexec; \
	    echo "$(INSTALL_DATA) $(TOP)/$(SRC)/support/suexec.8 $(root)$(mandir)/man8/suexec.8"; \
	    $(INSTALL_DATA) $(TOP)/$(SRC)/support/suexec.8 $(root)$(mandir)/man8/suexec.8; \
	fi
	@echo "<=== [support]"

#   install the support programs and scripts for binary distribution
install-binsupport:
	@echo "===> [support: Installing Apache support programs and scripts for binary distribution]"
	$(INSTALL_PROGRAM) $(TOP)/$(SRC)/support/ab $(root)$(sbindir)/ab
	$(INSTALL_DATA) $(TOP)/$(SRC)/support/ab.8 $(root)$(mandir)/man8/ab.8
	@if [ ".$(TARGET)" = .httpd ]; then \
		apachectl='apachectl'; \
	else \
		apachectl="$(TARGET)ctl"; \
	fi; \
	echo "$(INSTALL_SCRIPT) $(TOP)/$(SRC)/support/apachectl[*] $(root)$(sbindir)/$${apachectl}"; \
	sed -e 's;PIDFILE=.*;PIDFILE=$(runtimedir)/$(TARGET).pid;' \
		-e 's;HTTPD=.*;HTTPD=$(sbindir)/$(TARGET);' \
		< $(TOP)/$(SRC)/support/apachectl > $(TOP)/$(SRC)/.apaci.install.tmp && \
		$(INSTALL_SCRIPT) $(TOP)/$(SRC)/.apaci.install.tmp $(root)$(sbindir)/$${apachectl}; \
	echo "$(INSTALL_DATA) $(TOP)/$(SRC)/support/apachectl.8 $(root)$(mandir)/man8/$${apachectl}.8"; \
	$(INSTALL_DATA) $(TOP)/$(SRC)/support/apachectl.8 $(root)$(mandir)/man8/$${apachectl}.8
	$(INSTALL_PROGRAM) $(TOP)/$(SRC)/support/checkgid $(root)$(bindir)/checkgid
	$(INSTALL_PROGRAM) $(TOP)/$(SRC)/support/htpasswd $(root)$(bindir)/htpasswd
	$(INSTALL_DATA) $(TOP)/$(SRC)/support/htpasswd.1 $(root)$(mandir)/man1/htpasswd.1
	$(INSTALL_PROGRAM) $(TOP)/$(SRC)/support/htdigest $(root)$(bindir)/htdigest
	$(INSTALL_DATA) $(TOP)/$(SRC)/support/htdigest.1 $(root)$(mandir)/man1/htdigest.1
	@echo "$(INSTALL_SCRIPT) $(TOP)/$(SRC)/support/dbmmanage[*] $(root)$(bindir)/dbmmanage"; \
	$(INSTALL_SCRIPT) $(TOP)/$(SRC)/support/dbmmanage $(root)$(bindir)/dbmmanage
	$(INSTALL_DATA) $(TOP)/$(SRC)/support/dbmmanage.1 $(root)$(mandir)/man1/dbmmanage.1
	$(INSTALL_PROGRAM) $(TOP)/$(SRC)/support/logresolve $(root)$(sbindir)/logresolve
	$(INSTALL_DATA) $(TOP)/$(SRC)/support/logresolve.8 $(root)$(mandir)/man8/logresolve.8
	$(INSTALL_PROGRAM) $(TOP)/$(SRC)/support/rotatelogs $(root)$(sbindir)/rotatelogs
	$(INSTALL_DATA) $(TOP)/$(SRC)/support/rotatelogs.8 $(root)$(mandir)/man8/rotatelogs.8
	@echo "$(INSTALL_SCRIPT) $(TOP)/$(SRC)/support/apxs[*] $(root)$(sbindir)/apxs"; \
	$(INSTALL_SCRIPT) $(TOP)/$(SRC)/support/apxs $(root)$(sbindir)/apxs
	$(INSTALL_DATA) $(TOP)/$(SRC)/support/apxs.8 $(root)$(mandir)/man8/apxs.8
	-@if [ ".$(suexec)" = .1 ]; then \
	    echo "$(INSTALL_PROGRAM) $(TOP)/$(SRC)/support/suexec $(root)$(sbindir)/suexec"; \
	    $(INSTALL_PROGRAM) $(TOP)/$(SRC)/support/suexec $(root)$(sbindir)/suexec; \
	    echo "chown root $(root)$(sbindir)/suexec"; \
	    chown root $(root)$(sbindir)/suexec; \
	    echo "chmod 4711 $(root)$(sbindir)/suexec"; \
	    chmod 4711 $(root)$(sbindir)/suexec; \
	    echo "$(INSTALL_DATA) $(TOP)/$(SRC)/support/suexec.8 $(root)$(mandir)/man8/suexec.8"; \
	    $(INSTALL_DATA) $(TOP)/$(SRC)/support/suexec.8 $(root)$(mandir)/man8/suexec.8; \
	fi
	@echo "<=== [support]"

#   install the Apache C header files
install-include:
	@echo "===> [include: Installing Apache C header files]"
	$(CP) $(TOP)/$(SRC)/include/*.h $(root)$(includedir)/
	$(CP) $(TOP)/$(SRC)/lib/expat-lite/*.h $(root)$(includedir)/xml/
	@osdir=`grep '^OSDIR=' $(TOP)/$(SRC)/Makefile.config | sed -e 's:^OSDIR=.*/os/:os/:'`; \
		echo "$(CP) $(TOP)/$(SRC)/$${osdir}/os.h $(root)$(includedir)/"; \
		$(CP) $(TOP)/$(SRC)/$${osdir}/os.h $(root)$(includedir)/; \
		echo "$(CP) $(TOP)/$(SRC)/$${osdir}/os-inline.c $(root)$(includedir)/"; \
		$(CP) $(TOP)/$(SRC)/$${osdir}/os-inline.c $(root)$(includedir)/
	chmod 644 $(root)$(includedir)/*.h $(root)$(includedir)/xml/*.h
	@echo "<=== [include]"

#   create an initial document root containing the Apache manual,
#   icons and distributed CGI scripts.
install-data:
	@echo "===> [data: Installing initial data files]"
	-@if [ -f $(root)$(htdocsdir)/index.html ] || [ -f $(root)$(htdocsdir)/index.html.en ]; then \
		echo "[PRESERVING EXISTING DATA SUBDIR: $(root)$(htdocsdir)/]"; \
	else \
		echo "Copying tree $(TOP)/htdocs/ -> $(root)$(htdocsdir)/"; \
		(cd $(TOP)/htdocs/ && $(TAR) $(TAROPT) - index* apache_pb.* ) |\
		(cd $(root)$(htdocsdir)/ && $(TAR) -xf -); \
		find $(root)$(htdocsdir)/ -type d -exec chmod a+rx {} \; ; \
		find $(root)$(htdocsdir)/ -type f -print | xargs chmod a+r ; \
	fi
	-@if [ -d $(TOP)/htdocs/manual ]; then \
		echo "Copying tree $(TOP)/htdocs/manual -> $(root)/$(manualdir)/"; \
		(cd $(TOP)/htdocs/manual/ && $(TAR) $(TAROPT) - *) |\
		(cd $(root)$(manualdir)/ && $(TAR) -xf -); \
		find $(root)$(manualdir)/ -type d -exec chmod a+rx {} \; ; \
		find $(root)$(manualdir)/ -type f -print | xargs chmod a+r ; \
	fi
	-@if [ -f $(root)$(cgidir)/printenv ]; then \
		echo "[PRESERVING EXISTING CGI SUBDIR: $(root)$(cgidir)/]"; \
	else \
		for script in printenv test-cgi; do \
			cat $(TOP)/cgi-bin/$${script} |\
			sed -e 's;^#!/.*perl;#!$(PERL);' \
			> $(TOP)/$(SRC)/.apaci.install.tmp; \
			echo "$(INSTALL_DATA) $(TOP)/conf/$${script}[*] $(root)$(cgidir)/$${script}"; \
			$(INSTALL_DATA) $(TOP)/$(SRC)/.apaci.install.tmp $(root)$(cgidir)/$${script}; \
		done; \
	fi
	@echo "Copying tree $(TOP)/icons/ -> $(root)$(iconsdir)/"; \
	(cd $(TOP)/icons/ && $(TAR) $(TAROPT) - *) |\
	(cd $(root)$(iconsdir)/ && $(TAR) -xf -); \
	find $(root)$(iconsdir)/ -type d -exec chmod a+rx {} \; ;\
	find $(root)$(iconsdir)/ -type f -exec chmod a+r {} \;
	@echo "<=== [data]"

#   create the initial configuration by providing default files
#   and initial config files while preserving existing ones.
install-config:
	@echo "===> [config: Installing Apache configuration files]"
	-@for conf in httpd.conf access.conf srm.conf; do \
		if [ .$$conf = .httpd.conf ]; then \
			target_conf="$(TARGET).conf"; \
		else \
			target_conf="$$conf"; \
		fi; \
		if [ ".$(TARGET)" = .httpd ]; then \
			target_prefix=""; \
		else \
			target_prefix="$(TARGET)_"; \
		fi; \
		(echo "##"; \
		 echo "## $${target_conf} -- Apache HTTP server configuration file"; \
		 echo "##"; \
		 echo ""; \
		 cat $(TOP)/conf/$${conf}-dist ) |\
		 sed -e '/# LoadModule/r $(TOP)/$(SRC)/.apaci.install.conf' \
			-e 's;@@ServerRoot@@/htdocs/manual;$(manualdir);' \
			-e 's;@@ServerRoot@@/htdocs;$(htdocsdir);' \
			-e 's;@@ServerRoot@@/icons;$(iconsdir);' \
			-e 's;@@ServerRoot@@/cgi-bin;$(cgidir);' \
			-e 's;@@ServerRoot@@/proxy;$(proxycachedir);' \
			-e 's;@@ServerRoot@@;$(prefix);g' \
			-e 's;httpd\.conf;$(TARGET).conf;' \
			-e 's;logs/accept\.lock;$(runtimedir)/$(TARGET).lock;' \
			-e 's;logs/apache_runtime_status;$(runtimedir)/$(TARGET).scoreboard;' \
			-e 's;logs/httpd\.pid;$(runtimedir)/$(TARGET).pid;' \
			-e "s;logs/access_log;$(logfiledir)/$${target_prefix}access_log;" \
			-e "s;logs/error_log;$(logfiledir)/$${target_prefix}error_log;" \
			-e "s;logs/referer_log;$(logfiledir)/$${target_prefix}referer_log;" \
			-e "s;logs/agent_log;$(logfiledir)/$${target_prefix}agent_log;" \
			-e 's;conf/magic;$(sysconfdir)/magic;' \
			-e 's;conf/srm.conf;$(sysconfdir)/srm.conf;' \
			-e 's;conf/access.conf;$(sysconfdir)/access.conf;' \
			-e 's;conf/mime\.types;$(sysconfdir)/mime.types;' \
			-e 's;User nobody;User $(conf_user);' \
			-e 's;Group #-1;Group $(conf_group);' \
			-e 's;^Group "#-1";Group $(conf_group);' \
			-e 's;Port 80;Port $(conf_port);' \
			-e 's;ServerAdmin you@your.address;ServerAdmin $(conf_serveradmin);' \
			-e 's;ServerName new.host.name;ServerName $(conf_servername);' \
			> $(TOP)/$(SRC)/.apaci.install.tmp && \
		echo "$(INSTALL_DATA) $(TOP)/conf/$${conf}-dist[*] $(root)$(sysconfdir)/$${target_conf}.default"; \
		$(INSTALL_DATA) $(TOP)/$(SRC)/.apaci.install.tmp $(root)$(sysconfdir)/$${target_conf}.default; \
		if [ ! -f "$(root)$(sysconfdir)/$${target_conf}" ]; then \
			echo "$(INSTALL_DATA) $(TOP)/conf/$${conf}-dist[*] $(root)$(sysconfdir)/$${target_conf}"; \
			$(INSTALL_DATA) $(TOP)/$(SRC)/.apaci.install.tmp $(root)$(sysconfdir)/$${target_conf}; \
		else \
			echo "[PRESERVING EXISTING CONFIG FILE: $(root)$(sysconfdir)/$${target_conf}]"; \
		fi; \
	done
	-@for conf in mime.types magic; do \
		echo "$(INSTALL_DATA) $(TOP)/conf/$${conf} $(root)$(sysconfdir)/$${conf}.default"; \
		$(INSTALL_DATA) $(TOP)/conf/$${conf} $(root)$(sysconfdir)/$${conf}.default; \
		if [ ! -f "$(root)$(sysconfdir)/$${conf}" ]; then \
			echo "$(INSTALL_DATA) $(TOP)/conf/$${conf} $(root)$(sysconfdir)/$${conf}"; \
			$(INSTALL_DATA) $(TOP)/conf/$${conf} $(root)$(sysconfdir)/$${conf}; \
		else \
			echo "[PRESERVING EXISTING CONFIG FILE: $(root)$(sysconfdir)/$${conf}]"; \
		fi; \
	done
	@echo "<=== [config]"


## ------------------------------------------------------------------
##                       Cleanup Targets
## ------------------------------------------------------------------

#   cleanup the source tree by removing anything which was
#   created by the build target
clean:
	@echo "===> $(SRC)"
	@$(MAKE) -f $(TOP)/$(MKF) $(MFLAGS) $(MFWD) clean-std $(clean-support)
	@echo "<=== $(SRC)"
	@$(RM) $(TOP)/$(SRC)/.apaci.build.ok

#   clean the standard stuff
clean-std:
	@cd $(TOP)/$(SRC); $(MAKE) $(MFLAGS) SDP=$(SRC)/ clean

#   clean additional support stuff
clean-support:
	@echo "===> $(SRC)/support"; \
	cd $(TOP)/$(SRC)/support; $(MAKE) $(MFLAGS) clean; \
	if [ ".$(suexec)" = .1 ]; then \
		echo "$(RM) suexec"; \
		$(RM) suexec; \
	fi; \
	echo "<=== $(SRC)/support"

#   cleanup the source tree by removing anything which was
#   created by the configure step and the build target.
#   When --shadow is used we just remove the complete shadow tree.
distclean:
	@if [ ".$(SRC)" = .src ]; then \
		$(MAKE) -f $(TOP)/$(MKF) $(MFLAGS) $(MFWD) distclean-normal; \
	else \
		$(MAKE) -f $(TOP)/$(MKF) $(MFLAGS) $(MFWD) distclean-shadow; \
	fi

distclean-normal:
	@echo "===> $(SRC)"
	@$(MAKE) -f $(TOP)/$(MKF) $(MFLAGS) $(MFWD) distclean-std $(distclean-support)
	@echo "<=== $(SRC)"
	-$(RM) $(SRC)/Configuration.apaci
	-$(RM) $(SRC)/apaci
	@$(RM) $(SRC)/.apaci.build.ok
	-$(RM) Makefile
	-$(RM) config.status

#   clean the standard stuff
distclean-std:
	@cd $(TOP)/$(SRC); $(MAKE) $(MFLAGS) SDP=$(SRC)/ distclean

distclean-support:
	@echo "===> $(SRC)/support"; \
	cd $(TOP)/$(SRC)/support; $(MAKE) $(MFLAGS) distclean; \
	if [ ".$(suexec)" = .1 ]; then \
	    echo "$(RM) suexec"; \
	    $(RM) suexec; \
	fi; \
	echo "<=== $(SRC)/support"

distclean-shadow:
	$(RM) -r $(SRC)
	$(RM) $(TOP)/$(MKF)
	-@if [ ".`ls $(TOP)/src.* 2>/dev/null`" = . ]; then \
		echo "$(RM) Makefile"; \
		$(RM) Makefile; \
	fi

