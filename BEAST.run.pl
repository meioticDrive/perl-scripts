#!/usr/bin/perl
use warnings;
use strict 'vars';
use Cwd;
####################################################################################################
# Michael E. Zwick
# 6/23/2011
# Version 1.0
# 1. Launch program from directory above the one that contains the files of interest
# 2. This script runs a compiled fortran version of BEAST (binary name: cnv.beast.out)
# 3. This script generates a config file for each chromosome, runs BEAST, and outputs the results
#    into separate files (by chromosome).
#
####################################################################################################
my (@aCNCHP, @aCNCHPs, $sInput, $chr, @aSamples,  @aFiles, $aFiles_file_number, $sRefnum);
my ($sPath, $sRef, $sChr, $FP, $sName, @aTemp, @aChrToSort, @aSorted, $Probe, @aTemp2, $j, $n);
my ($sSample);

# Test if user included directory name when starting program
if(@ARGV != 1)
{
	die "\n Usage: Run_CNCHP_to_CHROMOSOMES_20110620.pl <target directory> \n";
}

# Perform directory functions
####################################################################################################
# Change to user provided directory containing data files
chdir "$ARGV[0]";

# Directory name is same as sample ID
$sSample = "$ARGV[0]";

# Path to data files
$sPath = getcwd();
chdir ("$sPath");

# Make directories
mkdir "$sPath/Input_Files";
mkdir	"$sPath/BEAST_Output_Files";

# Obtain names of chromosome log 2 data files
# These files should be split by chromosome for analysis with BEAST
####################################################################################################
@aFiles = glob ("*.chr*");
# Check to see if files are detected
$aFiles_file_number = ($#aFiles + 1);
if ($aFiles_file_number == 0) {
	die "$aFiles_file_number *.chr* files detected.\n
		Check directory. Exiting program";
}
print "\nDetected $aFiles_file_number chr files\n\n";

# Primary loop over all possible data files in the directory
####################################################################################################
foreach $sChr (@aFiles)
{
	#print OUTPUT "Chromosome\tStart\tEnd\tHeight\tWidth\tType\tScore\n";
	
	# Change directory to Input_Files
	#chdir "$sPath/Input_Files";
	
	# Generate config file
	##################################################################################################
	open (INPUT, ">", "$sChr.input.txt") 
	|| die "Cannot open \"$sSample.$sRef.Chr$sChr.input.txt\" for input!: $!\n";
	
	print INPUT "10         min_gap\n";
	print INPUT "30         max_gap\n";
	print INPUT "0.2        ratio_min\n";
	print INPUT "1000000    block_size\n";
	print INPUT "3          number of tabs before location column\n";
	print INPUT "4          number of tabs before logratio column\n";
	print INPUT "$sChr\n";  #Path to chromosome file
	print INPUT "1          indicator for whether file is sorted, 1 if sorted 0 otherwise\n";
	print INPUT "0.5        exponent for score function, default=0.5\n";
	print INPUT "9          ascii value of delimiter character\n";
	print INPUT	"1          quantile normalize unless value of normalize is 0\n";
	print INPUT	"0          output file with predicted values at each probe if 1\n";
	print INPUT	"$sPath/$sChr.cnv.summary.res\n";
	print INPUT	"$sPath/$sChr.cnv.pred.res\n";
	close(INPUT);
	
	# Run BEAST using config file
	system ("~/Scripts/cnv.beast.out $sChr.input.txt");

}

print "Completed BEAST.run.pl script\n";


