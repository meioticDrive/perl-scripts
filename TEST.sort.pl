#!/usr/bin/perl
# Written by Michael Zwick
# Version 1.0
# June 17, 2010
# Purpose is to play around with the sort command using a simple example
####################################################################################################
use warnings;
use strict 'vars';

# Test Hashes of Arrays
my %score = (
	1000 => [195, 196, 197, 0],
	1500 => [205, 10, 340, 1],
	2000 => [30, 50, 32, 3],
);


my @winners = sort by_score keys %score;

print "@winners\n";




# Subroutine for sorting hash
sub by_score { $score{$b}[3] <=> $score{$a}[3] }
