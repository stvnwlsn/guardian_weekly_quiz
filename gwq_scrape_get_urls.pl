#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/ say /;
use WWW::Mechanize ();

my @numbers = 1 .. 1;
my %urls;

for my $number (@numbers) {
    my $url
        = "https://www.theguardian.com/theguardian/series/the-quiz-thomas-eaton?page=$number";
    my $mech = WWW::Mechanize->new();
    $mech->get($url);

    my @links = $mech->find_all_links();

    foreach my $link (@links) {
        my %attrs = %{ $link->attrs() };
        if ( exists $attrs{'data-link-name'}
            && $attrs{'data-link-name'} eq 'article' )
        {
            $urls{ $attrs{'href'} } = 1;
        }
    }
}

foreach my $url ( sort keys %urls ) {
    say $url;
}
