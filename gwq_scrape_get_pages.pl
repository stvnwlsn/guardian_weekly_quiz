#!/usr/bin/env perl

use strict;
use warnings;
use WWW::Mechanize ();
use File::Basename;

my $filename = "urls.txt";
open( my $fh, "<", $filename )
    or die "Can't open < $filename: $!";

while (<$fh>) {
    chomp;
    my $url  = $_;
    my $mech = WWW::Mechanize->new();
    $mech->get($url);
    my $filename = fileparse($url);
    $url =~ m/\/(\d{4})\/([a-z]{3})\/(\d{2})/;
    my $prefix = "$1-$2-$3";
    $mech->save_content( $prefix . "-$filename" . ".html", binary => 1 );
}

close $fh;
