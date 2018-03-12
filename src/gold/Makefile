# $Id$
#
# @Copyright@
#
# 				Rocks(r)
# 		         www.rocksclusters.org
# 		         version 7.0 (Manzanita)
#
# Copyright (c) 2000 - 2017 The Regents of the University of California.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
# notice unmodified and in its entirety, this list of conditions and the
# following disclaimer in the documentation and/or other materials provided
# with the distribution.
#
# 3. All advertising and press materials, printed or electronic, mentioning
# features or use of this software must display the following acknowledgement:
#
# 	"This product includes software developed by the Rocks(r)
# 	Cluster Group at the San Diego Supercomputer Center at the
# 	University of California, San Diego and its contributors."
#
# 4. Except as permitted for the purposes of acknowledgment in paragraph 3,
# neither the name or logo of this software nor the names of its
# authors may be used to endorse or promote products derived from this
# software without specific prior written permission.  The name of the
# software includes the following terms, and any derivatives thereof:
# "Rocks", "Rocks Clusters", and "Avalanche Installer".  For licensing of
# the associated name, interested parties should contact Technology
# Transfer & Intellectual Property Services, University of California,
# San Diego, 9500 Gilman Drive, Mail Code 0910, La Jolla, CA 92093-0910,
# Ph: (858) 534-5815, FAX: (858) 534-7345, E-MAIL:invent@ucsd.edu
#
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS''
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# @Copyright@
#
# $Log$

REDHAT.ROOT = $(CURDIR)/../../

DB = Pg
SQL_FILES = base.sql bank.sql
BUNDLED_PERL_MODULES = \
  DBI-1.53 \
  Data-Properties-0.02 \
  Digest-1.05 \
  Digest-SHA1-2.07 \
  Digest-HMAC-1.01 \
  Error-0.15 \
  Date-Manip-5.48 \
  Params-Validate-0.89 \
  Time-HiRes-1.65 \
  Log-Log4perl-1.14 \
  Module-Build-0.2808 \
  Log-Dispatch-2.21 \
  Log-Dispatch-FileRotate-1.16 \
  MIME-Base64-3.01 \
  Term-ReadLine-Gnu-1.15 \
  XML-NamespaceSupport-1.08 \
  XML-SAX-0.12 \
  XML-LibXML-Common-0.13 \
  XML-LibXML-1.58_1 \
  Digest-MD5-2.36 \
  Crypt-DES-2.05 \
  Crypt-DES_EDE3-0.01 \
  Crypt-CBC-2.24 \
  Compress-Zlib-1.33 \
  DBD-mysql-2.9004 \
  DBD-Oracle-1.16 \
  DBD-Pg-1.32_2gold \
  DBD-SQLite-1.08 \
  CGI.pm-3.10 \
  CGI-Session-3.95

-include $(ROCKSROOT)/etc/Rules.mk
include $(SDSCDEVEL)/Pull.mk
include $(SDSCDEVEL)/Rules.mk

$(NAME).spec: DESCRIPTION LICENSE

DESCRIPTION:
	( \
	  $(DESCRIBE_PKG) \
	) > $@

LICENSE: $(SRC_DIRS)
	$(CHECK_LICENSE_FILES)
	echo BSD > $@

build:: $(SRC_DIRS)
	grep '^gold:' /etc/passwd; \
	if test $$? -ne 0; then \
	  useradd -M -u420 -c "Accounting,SDSC,,,{system}," -d /opt/gold gold; \
	fi
	( \
	  cd $(SOURCE_DIR); \
	  ./configure --prefix=$(PKGROOT) --with-db=$(DB) \
	              --with-user=gold --with-cgi-bin=/var/www/html/gold; \
	  $(MAKE) \
	)
	@echo "::: Package $(NAME) build complete :::"
	
install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/perldeps
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/dbsetup
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/etc
	( \
	  cd $(SOURCE_DIR); \
	  for M in $(BUNDLED_PERL_MODULES); do \
	    cp src/$$M.tar.gz $(ROOT)/$(PKGROOT)/perldeps/; \
	    echo $$M >> $(ROOT)/$(PKGROOT)/perldeps/buildorder; \
	  done; \
	  $(MAKE) build_root=$(ROOT) install; \
	  for S in $(SQL_FILES); do \
	    install -m644 $$S $(ROOT)/$(PKGROOT)/dbsetup; \
	  done \
	)
	cp patch-files/*.conf patch-files/auth_key $(ROOT)/$(PKGROOT)/etc/
	$(INSTALL_LICENSE_FILES)
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR) DESCRIPTION LICENSE

