#!/usr/bin/perl -w
# Name: VCF.to.SeqAnt.pl
# Version 1.0
# Michael E. Zwick
# 5/18/2011
####################################################################################
# Program designed to:
# 1. Convert variation from VCF file to SeqAnt list of variants format
####################################################################################
use strict;
use Cwd;

####################################################################################
# Local variable definitions
####################################################################################
# Define local variables
my(@fields);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables

####################################################################################
# Program Overview
####################################################################################

# Test if user included file when starting program
if(@ARGV != 1)
{
	die "\n Usage: ${0} VCF 4.0 data file\n";
}

open (INFILE,"$ARGV[0]") || die "\n Can not open $ARGV[0] which be the VCF file\n";

# Open for output for documentation
open(OUT_DATA, ">>", "VCF.to.SeqAnt.data.txt")
	or die "Cannot open OUT_DOCUMENTATION for output";

# Print out headers for file
print OUT_DATA "Fragment\tPosition\tReference\tMinor_allele\tType\n";

# Process VCF file
while(<INFILE>)
{
	#print "Entered loop. Processing file\n";
	@fields = split('\t', $_);

	# Print out data in SeqAnt format
	print OUT_DATA "chr" . "$fields[0]\t$fields[1]\t$fields[3]\t$fields[4]\tSNP\t$fields[4]\n";
}

close(INFILE);
close(OUT_DATA);

####################################################################################
# End of Program
####################################################################################
print "Completed VCF.4.0.Extract.chromosome.pl program\n";


