#!/usr/bin/perl
#
# Name: RA_conformance
# Version: 1.0
# Date: 02/01/2007
# Author: Michael E. Zwick
#--------------------------------------------------------------------------------------------
# 1. The purpose of this script is to extract the chip identification and final conformance values
# for each RA analyzed by RATools. This will allow the user to determine instances where their chip # fails to align well. Chips with low conformance values will call only a low proportion of bases. 
# Possible explanations for low conformance: experimental failure (too little DNA added to the RA, 
# PCR failure, over digestion of DNA, poor labelling of DNA, insufficient signal at hybridization 
# controls etc.) or grid alignment failure (for other unknown reason). Visual inspection of the RA 
# can often diagnose patterns of experimental failure.
# 2. Alignment.txt file format: For each .DAT file, this program will first fine the file name 
# information, and then extract the final conformance information. Information is output into a tab 
# delimited file - one line per .DAT file
#--------------------------------------------------------------------------------------------
use warnings;
use strict;
use Cwd;

my ($dirname, $ra_data, $version, @files, @filess, @dat_file, @conformance);


# Initialize variables
$version = "1.0";
$dirname = ".";

# Obtain directory name entered by user, contains directories of param_folders for subsequent 
# analysis. Standard directory location used in RATools for other scripts
#---------------------------------------------------------------------------------------------------
opendir(DIR,$dirname) || die "Cannot open $dirname";
@files = grep {/$ARGV[0]/} readdir(DIR);
@filess = sort @files;
close(DIR);

# Change to user provided directory for output
chdir $filess[0] or die "Cannot change to directory $filess[0]\n";

# Remove old conformance file
system("rm *conformance.txt");

# Open filehandle to output .DAT file and conformance information
open(OUT_CONFORMANCE, ">", "$ARGV[0]" . '.' . "conformance.txt")
	|| die "Cannot open filehandle OUT_CONFORMANCE for data output";

foreach $ra_data (@filess) {

	# Open alignment.txt file
	open (ALIGN_FILE, "<", "alignment.txt") or die "Cannot open alignment.txt file";
	
	# Print header
	print OUT_CONFORMANCE "DAT file number\tDAT file name\tConformance\tNumber of Passes\n";
	
	# Process alignment.txt file
	while(<ALIGN_FILE>) {
		chomp($_);
		# Obtain file name information
		if ($_ =~ /^ I am now working/) {
			@dat_file = split /\s/, $_;
			print OUT_CONFORMANCE "$dat_file[8]\t$dat_file[11]\t";
		}
		# Obtain final conformance information
		if ($_ =~ /^ Absolute final conformance/) {
			@conformance = split /\s/, $_;
			print OUT_CONFORMANCE "$conformance[5]\t$conformance[8]\n";
		}
	}
}

close (ALIGN_FILE);
close (OUT_CONFORMANCE);
print "Completed RA_conformance.pl version $version script\n";
