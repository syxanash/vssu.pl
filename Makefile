VERSION = 0.1.0

MAINFILE = "vssu.pl"

all:
	echo Hi mom!

install:
	cp bin/$(MAINFILE) /usr/bin/$(MAINFILE)
	chmod 775 /usr/bin/$(MAINFILE)

clean:
	rm -f $(MAINFILE)
