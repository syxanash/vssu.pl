#!/usr/bin/perl

use strict;
use warnings;

use MIME::Base64;
use File::Slurp;
use LWP::UserAgent;
use JSON;
use Getopt::Long;
use Pod::Usage;
use version;

our $VERSION = qv('0.1.1');

my $api_key = 'YOUR API KEY HERE'; # insert here your API key

my $filename       = 'shot_' . time() . '.png';
my $temporary_path = '/tmp/deshare/';

my $screen_delay = 0;

my $response;

my $picture_encoded;

my %actions = (
    apikey => '',
    delay  => '',
    save   => '',
    help   => '',
);

# check if all the tools have been installed into the system

if ( $ENV{"PATH"} ne q{} ) {
    unless ( check_env_path() ) {
        die '[!] Please install the tools required, before running this script!', "\n";
    }
}

# getting the various ARGVs parameters

GetOptions(
    'apikey=s' => \$actions{apikey},
    'delay'    => \$actions{delay},
    'save'     => \$actions{save},
    'help'     => \$actions{help},
);

# check if the user need to save the picture
# in a specific path

if ( $actions{save} ) {

    my $private_path;

    do {
        chomp( $private_path = `zenity --file-selection --title="Select the folder where to save the screenshot..." --directory` );

        if ( $private_path ne q{} ) {
            $temporary_path = $private_path . '/';
        }
        else {
            system 'zenity --info --text="Please select a correct directory!"';
            print "[!] Please select a correct folder!\n";
        }
    } while ( $private_path eq q{} );
}

# make a dir into the tmp path in order
# to put all the temporary screenshots into a
# specific folder

mkdir '/tmp/deshare'
  unless ( -d $temporary_path );

if ( $actions{help} ) {
    pod2usage(1);
}

# check if the user selected a different API key

if ( $actions{apikey} ) {
    $api_key = $actions{apikey};
}

# set the delay selected by the user

if ( $actions{delay} ) {
    chomp( $screen_delay = `zenity --scale --title="Screenshot delay" --text="Set a delay before taking the screenshot" --min-value=0 --max-value=99 --value=4` );

    if ( $screen_delay eq q{} ) {
        system 'zenity --error --text="No value selected!"';
        die "[!] No value selected for the delay!\n";
    }   
}

system( "scrot -s -d $screen_delay " . $temporary_path . $filename ) == 0
  or die '[?] The capture was halted!', "\n";

$picture_encoded = encode_base64( read_file( $temporary_path . $filename ) );

$response = uploading_picture($picture_encoded);

# after uploading the picture to imgur.com, check if the connection
# was correctly established, if true send the URL in a msgbox

if ( $response->is_success ) {
    my $web_content = $response->content;

    my $json_hash_decoded = decode_json($web_content);

    system( 'zenity --info --title="Here\'s your URL" --text="Original link: '
          . $json_hash_decoded->{upload}{links}{original}
          . '\nImgur page: '
          . $json_hash_decoded->{upload}{links}{imgur_page}
          . '\nDelete page: '
          . $json_hash_decoded->{upload}{links}{delete_page}
          . '"' );

    print "\n",
      'Original Link: ', $json_hash_decoded->{upload}{links}{original},   "\n",
      'Imgur page: ',    $json_hash_decoded->{upload}{links}{imgur_page}, "\n",
      'Delete page: ', $json_hash_decoded->{upload}{links}{delete_page}, "\n\n";
}
else {
    system 'zenity --error --text="Can\'t establish the connection!"';
    die "[!] Error establishing the connection!\n";
}

sub uploading_picture {
    my $picture = shift;

    my $lwp_useragent;
    my $lwp_response;

    # sending a notification on the desktop

    system 'zenity --notification --window-icon="info" --text="Uploading the screenshot to imgur.com ..." &';
    print '[?] Uploading the screenshot to imgur.com ...', "\n";

    $lwp_useragent = LWP::UserAgent->new();

    $lwp_response = $lwp_useragent->post(
        'http://api.imgur.com/2/upload.json',
        [
            key   => $api_key,
            image => $picture,
        ]
    );

    return $lwp_response;
}

sub check_env_path {

    my $value_to_return = 0;

    my %check_flag = (
        scrot  => 0,
        zenity => 0,
    );

    my %binaries = (
        scrot  => 'scrot',
        zenity => 'zenity',
    );

    foreach my $path ( split /:/, $ENV{"PATH"} ) {
        if ( -e ( $path . '/' . $binaries{scrot} ) ) {
            $check_flag{scrot} = 1;
        }

        if ( -e ( $path . '/' . $binaries{zenity} ) ) {
            $check_flag{zenity} = 1;
        }

        if ( $check_flag{zenity} == 1 and $check_flag{scrot} == 1 ) {
            $value_to_return = 1;

            last;
        }
    }

    print '[!] Please install ', $binaries{zenity}, ' first!', "\n"
        unless ( $check_flag{zenity} );

    print '[!] Please install ', $binaries{scrot}, ' first!', "\n"
        unless ( $check_flag{scrot} );

    return $value_to_return;
}

__END__

=pod

=head1 NAME

vssu.pl - a very simple screenshot uploader dot pl

=head1 SYNOPSIS

perl vssu.pl [--options] <parameters>

 Capture Options:
  --delay                   Add a delay before taking the screenshot
  --save                    Allows the user to save the screenshot into a specific path
 
 Other Options:
  --apikey=NEW_API_KEY      Allows the user to use a different API key
  --help                    Show this very useful help!

=head1 DESCRIPTION

vssu.pl allows you to make a screenshot of your system
and upload it automatically on imgur.com using their API service.
This script uses also zenity for getting various data from the
user. It requires also the tool scrot in order to catch
the screenshot of your system.
If you're on Ubuntu or Debian-like distro, simply type the
following command into the command line:

  sudo apt-get install scrot zenity libfile-slurp-perl

Remember that you can also specify your own API key of imgur.com
simply by passing it as an ARGV parameter to --apikey.

=head1 DEPENDENCIES

Getopt::Long ~ http://search.cpan.org/~enrys/POD2-IT-Getopt-Long/lib/POD2/IT/Getopt/Long.pm

MIME::Base64 ~ http://search.cpan.org/~gaas/MIME-Base64-3.13/Base64.pm

File::Slurp ~ http://search.cpan.org/~uri/File-Slurp-9999.19/lib/File/Slurp.pm

LWP::UserAgent ~ http://search.cpan.org/~gaas/libwww-perl-6.04/lib/LWP/UserAgent.pm

JSON ~ http://search.cpan.org/~makamaka/JSON-2.53/lib/JSON.pm

version ~ http://search.cpan.org/~jpeacock/version-0.99/lib/version.pod

Pod::Usage ~ http://perldoc.perl.org/Pod/Usage.html

=head1 SEE ALSO

Zenity manual at http://library.gnome.org/users/zenity/stable/

Getopt::Long and Pod::Usage http://perldoc.perl.org/Getopt/Long.html#Documentation-and-help-texts

=head1 LICENSE AND COPYRIGHT

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

=head1 AUTHOR

@syxanash with his mind - <syxanash ( at ) gmail ( dot ) com>

=cut
