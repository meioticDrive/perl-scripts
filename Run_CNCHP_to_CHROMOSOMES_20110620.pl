#!/usr/bin/perl
use warnings;
use strict 'vars';
use Cwd;
####################################################################################################
# Version 1.1
# 1. Launch program directory above that contains files of interest
# 2. Provide script name and directory name to execute the script.
#
#
#
####################################################################################################
my (@aCNCHP, @aCNCHPs, $sInput, $chr, @aSamples,  @aFiles, $aFiles_file_number, $sRefnum);
my ($sPath, $sRef, $sChr, $FP, $sName, @aTemp, @aChrToSort, @aSorted, $Probe, @aTemp2, $j, $n);
my ($skey, %hProbes);

# Test if user included directory name when starting program
if(@ARGV != 1)
{
	die "\n Usage: Run_CNCHP_to_CHROMOSOMES_20110620.pl <target directory> \n";
}


# Perform directory functions
####################################################################################################
# Change to user provided directory containing data files
chdir "$ARGV[0]";

# Path to data files
$sPath = getcwd();

# Get name of reference file
# Obtain names of data files
####################################################################################################
print "What reference sample would you like to use to create CNCHP files?\n1 for HapMap\n2 for Mulle\n3 for GAIN\n4 for DS_CHD\n5 for BIHAP\n";
$sRefnum = <STDIN>;
chomp $sRefnum;

if ($sRefnum == 1) {
	$sRef = "HapMap";
}

elsif ($sRefnum == 2) {
	$sRef = "GAIN";
}

elsif ($sRefnum == 3) {
	$sRef = "Mulle";
}

elsif ($sRefnum == 4) {
	$sRef = "DSCHD";
}

elsif ($sRefnum == 5) {
	$sRef = "BIHAP";
}

else {
	print STDOUT "You have selected an undefined reference. Please select a different dataset.\n";
	exit;
}

chdir ("$sPath");
@aFiles = glob ("*.CNCHP.txt");
# Check to see if files are detected
$aFiles_file_number = ($#aFiles + 1);
if ($aFiles_file_number == 0) {
	die "$aFiles_file_number CNCHP.txt files detected.\n
		Check directory. Exiting program";
}
print "\nDetected $aFiles_file_number CNCHP.txt files\n\n";

# Primary loop over all possible data files in the directory
####################################################################################################
foreach $FP (@aFiles)
{
	# Process each file
	# Assign input file name to $sInput
	$sInput = $FP;
	print "Processing file name: $sInput\n";

	# Obtain Sample ID from file name
	$sInput=~ /^(.*)_\(GenomeWideSNP_/;
	$sName = $1;
	print "Current Path: $sPath\n";
	print "Current Sample ID: $sName\n";
	# Make directory structure to store files
	mkdir ("$sPath/$sName/");

	# Loop over chromosomes 1 - 22 for a given data file
	for ($chr = 1; $chr < 23; $chr++)
	{
	$sChr = $chr;
	print "Starting processing probes for chr $sChr.\n";
	# This part splits the normalized.txt file into files with data for individual chromosomes. 
	# The normalized.txt file is way too large to process otherwise.
	# The individual chromosome files are then formatted for daglad.
	# This section reads in all data and puts all the probe data into a hash of arrays
	##################################################################################################
		open (NORM, "$sInput");
		while (<NORM>)
		{
			chomp;
			# Lines to skip in Affymetrix file
			if (/#%/) {next;}
			if (/ProbeSet/)  {next;}
		
			# Split remaining lines
			@aTemp = split('\t', $_);
		
			# Skip X and Y chromosome
			if ($aTemp[1] eq 'X' or $aTemp[1] eq 'Y') {next;}

			# Generate a hash for each chromosome
			if ($aTemp[1] == $chr)
			{
				#Obtain probe information from file
				$skey = $aTemp[2];
				$hProbes{$skey}[0] = $aTemp[1];	# Chromosome
				$hProbes{$skey}[1] = $aTemp[0];	# ProbeSetName
				$hProbes{$skey}[2] = $aTemp[2];	# Position
				$hProbes{$skey}[3] = $aTemp[4];	# Log2Ratio
			
				#print "$hProbes{$skey}[0]\t";
				#print "$hProbes{$skey}[1]\t";
				#print "$hProbes{$skey}[2]\t";
				#print "$hProbes{$skey}[3]\n";
				}
		}
		close NORM;
		
		# Now output probes by chromosome
		# Open an output file
		# Sort and number probes
		# Write to output file
		###############################################################################################
		open (OUTFILE, ">", "$sPath/$sName/$sName.chr$sChr.$sRef.txt");
		print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
		print "Sorting probes for chromosome $sChr.\n";
		
		$j = 1;
		foreach $skey (sort by_number (keys %hProbes))
			{
			#print OUTFILE "$skey\n";
			#print "$skey\n";
			print OUTFILE "$j\t$hProbes{$skey}[0]\t$hProbes{$skey}[1]\t$hProbes{$skey}[2]\t$hProbes{$skey}[3]\n";
			$j++;
			}
		close (OUTFILE);
		# Empty hash in preparation for next chromosome data
		print "Finished probes for chromosome $sChr.\n\n";
		%hProbes = ();
	}
}

##################################################################################################
# Subroutine for sorting hash %hProbes
#sub by_number { $hProbes{$a}[2] <=> $hProbes{$b}[2] }
sub by_number { $a <=> $b }
