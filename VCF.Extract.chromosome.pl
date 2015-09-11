#!/usr/bin/perl -w
# Name: VCF.4.0.Extract.chromosome.pl
# Version 1.0
# Michael E. Zwick
# 5/17/2011
####################################################################################
# Program designed to:
# 1. Extract variation info from a single chromosome from a VCF file
####################################################################################
use strict;
use Cwd;

####################################################################################
# Local variable definitions
####################################################################################
# Define local variables
my(@popgen_file, $popgen_file_number);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables
@popgen_file = ();
$popgen_file_number = 0;

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
open(OUT_DOCUMENTATION, ">>", "VCF.documentation.txt")
	or die "Cannot open OUT_DOCUMENTATION for output";

# Open for output for documentation
open(OUT_DATA, ">>", "VCF.data.txt")
	or die "Cannot open OUT_DOCUMENTATION for output";

# Process VCF file
while(<INFILE>)
{
	#print "Entered loop. Processing file\n";
	
	# Print out documentation header
	if ($_ =~ /^#/)
	{
		print OUT_DOCUMENTATION $_;
	}	

	# Print out chromosome specific data
	if ($_ =~ /^X/)
	{
		print OUT_DATA $_;
	}	

}
close(INFILE);
close(OUT_DOCUMENTATION);
close(OUT_DATA);

print "Completed VCF.4.0.Extract.chromosome.pl program\n";


