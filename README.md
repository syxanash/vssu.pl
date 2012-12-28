## vssu.pl
### a very simple screenshot uploader dot pl

vssu.pl allows you to make screenshots of your system and upload them automatically on imageshack.com.

##Synopsis

```
perl vssu.pl [--options] <parameters>

Capture Options:
  --delay                   Add a delay before taking the screenshot
  --save                    Allows the user to save the screenshot into a specific path
 
Other Options:
 --response                Shows the whole XML response under Data::Dumper format
 --apikey=NEW_API_KEY      Allows the user to use a different API key
 --help                    Show this very useful help!
```

##Description

vssu.pl allows you to make a screenshot of your system
and upload it automatically on imageshack.com using their API service.
This script uses also zenity for getting various data from the
user. It requires also the tool scrot in order to catch
the screenshot of your system.
Remember that you can also specify your own API key of imageshack.com
simply by passing it as an ARGV parameter to --apikey.

##Installation

This script obviously requires the tools **scrot** and **zenity**, which can be
easily installed (if you're on a Debian-like distro), by the following command:

```sh
apt-get install scrot zenity
```

otherwise if you're using a different distro, these tools will probably
be listed into the relative package manager.

You also need various Perl modules to make this script work, here's the list:

* [LWP::UserAgent](http://search.cpan.org/~gaas/libwww-perl-6.04/lib/LWP/UserAgent.pm) -- (already installed)
* [HTTP::Request::Common](http://search.cpan.org/~gaas/HTTP-Message-6.06/lib/HTTP/Request/Common.pm) -- (already installed)
* [XML::Simple](http://search.cpan.org/~grantm/XML-Simple-2.20/lib/XML/Simple.pm) -- (probably installation required)
* [Getopt::Long](http://search.cpan.org/~enrys/POD2-IT-Getopt-Long/lib/POD2/IT/Getopt/Long.pm) -- (probably installation required)
* [Pod::Usage](http://perldoc.perl.org/Pod/Usage.html) -- (already installed)
* [version](http://search.cpan.org/~jpeacock/version-0.99/lib/version.pod) -- (already installed)
* [Data::Dumper](http://search.cpan.org/~smueller/Data-Dumper-2.139/Dumper.pm) -- (don't remember, probably installation required)

After installing all the required libraries, type the command:

```sh
make install
```

and the script vssu.pl, contained into this package, will be automatically copied into /usr/bin/

## License
### vssu.pl is released under the [GNU General Public License (GPL3)](https://www.gnu.org/licenses/gpl-3.0.html):
Copyright (C) 2012 syxanash <syxanash@gmail.com>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

On Debian systems, the complete text of the GNU General Public License
can be found in /usr/share/common-licenses/GPL-3.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

##About

This script was developed by Simone 'syxanash', if you have any kind of suggestions, criticisms, or bug fixes please let me know in some ways :-)