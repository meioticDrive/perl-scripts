#!/usr/bin/perl
#
# Name: EmoryMapper.regions.summary
# Version: 1.0
# Date: 3/7/2011
##############################################################################
##############################################################################
# The purpose of this script is to"
#		1. Read in a fragments, regions.txt file, in format chr start stop
#		2. Read in a bases and avg coverage, region_counts.txt file, in format chr base_position avgDepth
#		3. Calculate an average coverage by fragment (average over bases in fragment)
##############################################################################
##############################################################################
use warnings;
use strict;
use Cwd;

# Local variable definitions
##############################################################################
my (@regions_file, $regions_file_nmbr, @regions_counts_file, $regions_counts_file_nmbr,);

# Read regions.txt file
@regions_file = glob("regions.txt") || print "\nNo regions.txt file found\n";
$regions_file_nmbr = ($#regions_file + 1);
if ($regions_file_nmbr > 1) {
	die "Too many regions.txt files" }
	
# Read region_counts.txt file
@regions_counts_file = glob("regions_counts.txt") || print "\nNo regions.txt file found\n";
$regions_counts_file_nmbr = ($#regions_counts_file + 1);
if ($regions_file_nmbr > 1) {
	die "Too many regions.txt files" }
