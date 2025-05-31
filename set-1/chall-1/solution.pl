#!/usr/bin/env perl

use strict;
use warnings;

my $hex = $ARGV[0];

my %hex_map = (
    '0' => 0,  '1' => 1,  '2' => 2,  '3' => 3,
    '4' => 4,  '5' => 5,  '6' => 6,  '7' => 7,
    '8' => 8,  '9' => 9,  'A' => 10, 'B' => 11,
    'C' => 12, 'D' => 13, 'E' => 14, 'F' => 15,
    'a' => 10, 'b' => 11, 'c' => 12, 'd' => 13,
    'e' => 14, 'f' => 15
);

my @base64_chars = ('A'..'Z', 'a'..'z', 0..9, '+', '/');

my $binary = '';

for (my $i = 0; $i < length($hex); $i += 2) {
    my $h1 = substr($hex, $i, 1);
    my $h2 = substr($hex, $i + 1, 1);
    my $val = $hex_map{$h1} * 16 + $hex_map{$h2};
   
    for (my $j = 7; $j >= 0; $j--) {
        $binary .= ($val & (1 << $j)) ? '1' : '0';
    }
}

$binary .= '0' x ((6 - length($binary) % 6) % 6);

my $base64 = '';

for (my $i = 0; $i < length($binary); $i += 6) {
    my $chunk = substr($binary, $i, 6);
    my $index = bin_to_dec($chunk);
    
    $base64 .= $base64_chars[$index];
}

my $pad = (3 - (length($hex) / 2) % 3) % 3;

$base64 .= '=' x $pad;

print "$base64\n";

sub bin_to_dec {
    my ($bin) = @_;
    my $val = 0;
    $val = $val * 2 + $_ for split //, $bin;
    return $val;
}