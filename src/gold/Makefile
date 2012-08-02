# @Copyright@
#

PKGROOT = /opt/gold
SOURCE = gold-$(VERSION)
REDHAT.ROOT = $(PWD)/../../

# One of mysql Oracle Pg SQLite
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

include $(ROCKSROOT)/etc/Rules.mk

build::
	grep '^gold:' /etc/passwd; \
	if test $$? -ne 0; then \
	  useradd -M -u420 -c "Accounting,SDSC,,,{system}," -d /opt/gold gold; \
	fi
	tar zxvf $(SOURCE).tar.gz
	( \
	  cd $(SOURCE); \
	  ./configure --prefix=$(PKGROOT) --with-db=$(DB) \
	              --with-user=gold --with-cgi-bin=/var/www/html/gold; \
	  make \
	)

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/perldeps
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/dbsetup
	( \
	  cd $(SOURCE); \
	  for M in $(BUNDLED_PERL_MODULES); do \
	    cp src/$$M.tar.gz $(ROOT)/$(PKGROOT)/perldeps/; \
	    echo $$M >> $(ROOT)/$(PKGROOT)/perldeps/buildorder; \
	  done; \
	  make build_root=$(ROOT) install; \
	  for S in $(SQL_FILES); do \
	    install -m644 $$S $(ROOT)/$(PKGROOT)/dbsetup; \
	  done; \
	)

clean::
	rm -rf $(SOURCE)
