PREFIX = $(DESTDIR)/usr/local
BINDIR = $(PREFIX)/bin

install:
	install mail-to-filter $(BINDIR)/mail-to-filter
	install xls2txt.py $(BINDIR)/xls2txt
	install mutt-search.sh $(BINDIR)/mutt-search
	install index-mail.sh $(BINDIR)/
	install monitor-offlineimap.sh $(BINDIR)/monitor-offlineimap

install-arch: install
	install view_attachment_convert-arch.sh $(BINDIR)/view_attachment_convert.sh

install-mac: install
	install view_attachment_convert.sh view_attachment.sh offlineimap-pass.py $(BINDIR)/
	install networkstatus-mac.sh $(BINDIR)/networkstatus

uninstall:
	-rm -f $(BINDIR)/{mail-to-filter,xls2txt,view_attachment_convert.sh,view_attachment.sh}
	-rm -f $(BINDIR)/{offlineimap-pass.py,index-mail.sh,monitor-offlineimap,networkstatus,mutt-search}
