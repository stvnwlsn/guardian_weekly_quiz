#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/ say /;

# Write seperate csv files for regular and what links questions.
open( my $fh_q, '>', "skipped_questions.csv" );
open( my $fh_l, '>', "skipped_what_links.csv" );
my $header = "Category#Question#Answer#Regex";
say $fh_q $header;
say $fh_l $header;

opendir my $dirh, "skipped/";

PAGE: while ( my $file = readdir $dirh ) {
    next if $file =~ /^\./;
    open my $fh, '<', "skipped/$file";
    chomp( my @lines = <$fh> );
    close $fh;
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
