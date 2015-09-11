#!/usr/bin/perl
use warnings;
use strict 'vars';
use Cwd;
####################################################################################################
# BEAST.merge.chr.data.pl
# Michael E. Zwick
# June 24, 2011
# Version 1.0
# 1. Launch program from directory above the one that contains the files of interest
# 2. Merge BEAST CNV calls from each chromosome into a single file that can be opened in a spreadsheet
####################################################################################################
my (@aCNCHP, @aCNCHPs, $sInput, $chr, @aSamples,  @aFiles, $aFiles_file_number, $sRefnum);
my ($sPath, $sRef, $sChr, $FP, $sName, @aTemp, @aChrToSort, @aSorted, $Probe, @aTemp2, $j, $n);
my ($sSample, @sCNV, $sChrName);

# Test if user included directory name when starting program
if(@ARGV != 1)
{
	die "\n Usage: BEAST.merge.chr.data.pl <target directory> \n";
}

# Perform directory functions
####################################################################################################
# Change to user provided directory containing data files
chdir "$ARGV[0]";

# Directory name is same as sample ID
$sSample = "$ARGV[0]";

# Remove lagging / from $sSample - if present
$sSample =~ s/\/$//;


# Path to data files
$sPath = getcwd();
chdir ("$sPath");

# Obtain names of BEAST cnv.summary.res files containing CNV calls
####################################################################################################
@aFiles = glob ("*.cnv.summary.res");
# Check to see if files are detected
$aFiles_file_number = ($#aFiles + 1);
if ($aFiles_file_number == 0) {
	die "$aFiles_file_number *.cnv.summary.res files detected.\n
		Check directory. Exiting program";
}
print "\nDetected $aFiles_file_number *.cnv.summary.res files\n\n";

# Open file to collect summary CNV data
	open (OUT_FILE, ">", "$sSample.all.BEAST.cnv.summary.txt") 
	|| die "Cannot open $sSample.BEAST.cnv.summary.all.txt for output!: $!\n";

# Print out header for file
print OUT_FILE "chromosome\tstart\tend\theight\tlength\ttype\tscore\tstart_probe\tend_probe\n";

# Primary loop over all possible BEAST chromosome data files in the directory
####################################################################################################
foreach $sChr (@aFiles)
{
	#Track file being processed
	print "Processing file: $sChr\n";

	#Extract chromosome name from file name
	$sChrName = $sChr;
	$sChrName =~/(chr\d+)/;
	$sChrName = $1; 					# Capture chromosome ID substring
	#print "Found $sChrName\n";

	open (IN_FILE, "$sChr");
	#Loop over all lines in $sCHR file
	while (<IN_FILE>)
	{
		chomp;
		
		# Discard header lines
		if($_=~/\s+start/) {next;}
		
		# Remove leading spaces from $_
		$_ =~ s/^\s+//;
		
		# Split line by space
		@sCNV = split('\s+',$_); 
		
		# Output values for a given line
		print OUT_FILE "$sChrName\t";
		print OUT_FILE "$sCNV[0]\t";	#start
		print OUT_FILE "$sCNV[1]\t";	#end
		print OUT_FILE "$sCNV[2]\t";	#height
		print OUT_FILE "$sCNV[3]\t";	#length
		print OUT_FILE "$sCNV[4]\t";	#type
		print OUT_FILE "$sCNV[5]\t";	#score
		print OUT_FILE "$sCNV[6]\t";	#start_probe
		print OUT_FILE "$sCNV[7]\n";	#end_probe
	}
}

print "Finished script BEAST.merge.chr.data.pl\n";

