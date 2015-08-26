PREFIX ?= /usr/local

install: bin/kill-list
	mkdir -p $(PREFIX)/$(dir $<)
	cp $< $(PREFIX)/$<

uninstall:
	rm -f $(PREFIX)/bin/kill-list

.PHONY: install uninstall