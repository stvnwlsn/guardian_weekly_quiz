#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/ say /;
use HTML::FormatText;

# Write seperate csv files for regular and what links questions.
open( my $fh_q, '>', "questions.csv" );
open( my $fh_l, '>', "what_links.csv" );
my $header = "Category#Question#Answer#Regex";
say $fh_q $header;
say $fh_l $header;

opendir my $dirh, "pages/";

PAGE: while (my $file = readdir $dirh){
    next if $file =~ /^\./;
    my $string = HTML::FormatText->format_file(
        "pages/$file",
        leftmargin  => 0,
        rightmargin => 500
    );
    my @lines = split /\n/, $string;
    my @qa;
    my $what_links;
    my $question_number;

    for my $line (@lines) {
        if ( $line =~ /^(\d{1,2})/ ) {
            $question_number = $1;
            chomp $line;
            $line =~ s/^\d{1,2} //;
            $line =~ s/\.$//;
            push @qa, $line;
        }
        elsif ( $line =~ /^what links\:?$/i ) {
            $what_links = $question_number + 1;
        }
    }
    if ( ( $question_number * 2 ) != scalar @qa ) {
        say "skipping $file";
        next PAGE;
    }
    # Use # as a delimiter
    foreach ( 1 .. $question_number ) {
        if ( $_ < $what_links ) {
            say $fh_q "#"
                . $qa[ $_ - 1 ] . "#"
                . $qa[ $_ + $question_number - 1 ] . "#"
                . $qa[ $_ + $question_number - 1 ];
        }
        else {
            say $fh_l "What links?" . "#"
                . $qa[ $_ - 1 ] . "#"
                . $qa[ $_ + $question_number - 1 ] . "#"
                . $qa[ $_ + $question_number - 1 ];

        }
    }
}

close $fh_q;
close $fh_l;
closedir $dirh;
