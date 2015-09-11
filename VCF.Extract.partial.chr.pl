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
my(@fields, $start, $end);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables
$start = 147000000;
$end = 149000000;

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
open(OUT_DATA, ">>", "VCF.extract.partial.chr.txt")
	or die "Cannot open OUT_DATA for output";

# Process VCF file
while(<INFILE>)
{
	#print "Entered loop. Processing file\n";
	@fields = split('\t', $_);

	if(($fields[1]>$start) && ($fields[1]<$end))
	{
	# Print out chromosome range data
	print OUT_DATA "$_";
	}
}

close(INFILE);
close(OUT_DATA);

####################################################################################
# End of Program
####################################################################################
print "Completed VCF.Extract.partial.chr.pl program\n";


