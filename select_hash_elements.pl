#!/usr/bin/perl
# Program is designed to take a list of items from a Tag file, seach a data file for
# those tags. If the tag is found, output the line to a text file.

use warnings;
use strict;
my(%first_file, %second_file, @line1, @line2, @this_not_that, $tag_file, $data_file, $k, $v, $elements_found);

#Initialize Variables
%first_file = ();
%second_file = ();
@line1 = ();
@line2 = ();
@this_not_that = ();


open (OUTFILE, ">>Morris_out.txt");

# Data File to Match On for hash1
print "Enter Data file name: ";
$data_file = <STDIN>;
chomp $data_file;
unless   ( open (DATAFILE, $data_file)  )  {
	print 'cannot open $data_file\n';
	exit;
}

# Tag file for hash2
print "Enter Tag file name: ";
$tag_file = <STDIN>;
chomp $tag_file;
unless   ( open (TAGFILE, $tag_file)  )  {
	print 'cannot open $tag_file\n';
	exit;
}	

# Make Hash out of Data File
open (DATAFILE, $data_file);
while ($_ = <DATAFILE>) {
	@line1 = split("\t", $_);
	#Assign Key (fourth element) to Value (entire line) to generate data hash1
	$first_file{$line1[3]} = $_;
}
close (DATAFILE);

open (TAGFILE, $tag_file);
while ($_ = <TAGFILE>) {
	@line2 = split("\t", $_);
	#Assign Key (first element) to Value (entire line) to generate tag hash 2
	$second_file{$line2[3]} = $_;
}
close (TAGFILE);

# Find Keys From One Hash That Aren't in Both
# Code from Perl Cookbook
foreach (keys %first_file) {
	push(@this_not_that, $_) unless exists $second_file{$_};
}

# Output values from %first_file hash, using keys from
# Obtain keys from @this_not_that array
$elements_found = ($#this_not_that + 1);
for (my $i = 0; $i < $elements_found; $i++) {
	print OUTFILE "$first_file{$this_not_that[$i]}";
	}

$v = @this_not_that;
print "\n";
print "Total Number of elements found is: $v\n";



