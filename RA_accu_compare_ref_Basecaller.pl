#!/usr/bin/perl
#
# Name: RA_accu_compare_ref.pl
# Version 1.1
# Date: 09/08/2006
# Author: Michael E. Zwick
#--------------------------------------------------------------------------------------------
# 1. The purpose of this script is to compare reference_sequences to experimental fasta files 
# generated by RATools.
# 2. The names of the fasta file and their corresponding reference file are hard coded in the 
# %chip_strain hash
# 3. Using the RATools folder structure, execute the script on a folder containing files previously # analyzed with RATools. User needs to provide name of folder containing all files (same as done for # RATools)
#
# Comments below need to be updated:
# B) The script will then enter a folder - whose name starts with a number. Typically, these folders # are the output of a parameter search - i.e. RA_run_param_srch.pl
# C) Fasta files present in the directory will be compared to a reference fasta file.
# D) Output will consist of the RATools parameters (from the folder name), the total number of bases # called, and the number of disrepancies in a tab delimited text file.
# The reference.chip.fasta file is generated from a high-quality (or at least 
# quality known) genbank reference sequence or alternative shotgun sequence data.
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use warnings;
use strict;
use Cwd;

#-------------------------------------------------------------------------------
# Local variable definitions
#-------------------------------------------------------------------------------
# Define local variable

my(%chip_strain, @files, @filess, @experimental_files, @reference_files, @ref_seq, $exp_file_number, $ref_file_number, $reference_seq, $reference_seq_size, @ref_compare, $experiment_sequence, $experiment_sequence_size, @experiment_compare, $bases_identical, $bases_different, $total_bases, $bases_called_N, $check_total, $chip_reference_sequence, $chip_reference_sequence_size, $LQvsCDF, $outputFasta, $haploid, $primersUsed, $numSegs, $offset, $maxSites, $rewriteFasta, $dirname, $nInvalidateBase, $nInvalidateFrag, $winSize, $failThresh, @primer_file, $primer_file_nmbr, @genpos_file, $genpos_file_nmbr, @param_dirs, @param_dirss, @fasta_files, @fasta_filess, $z, $zz, $nofiles, $test, $dir, $dir_final, $param_dir_nmbr, $yy, $dir_1, $dir_2, $dir_3, $ref_count, @Ames_ref_seq, $Ames_ref_seq_size, @Australia_ref_seq, $Australia_ref_seq_size, @KrugerB_ref_seq, $KrugerB_ref_seq_size, @Vollum_ref_seq, $Vollum_ref_seq_size, @fasta_seq, $fasta_exp_seq, $fasta_seq_size, $grand_total_bases_called_N, $grand_total_bases_identical, $grand_total_bases_different, $grand_total_check_total);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);
#-------------------------------------------------------------------------------
# Initialize global variable values
#-------------------------------------------------------------------------------
$total_bases = 0;
$bases_identical = 0;
$bases_called_N = 0;
$bases_different = 0;
$check_total = 0;
$grand_total_bases_called_N = 0;
$grand_total_bases_identical = 0;
$grand_total_bases_different = 0;
$grand_total_check_total = 0;
$dirname = ".";

# Populate the %chip_strain hash with chip names and reference file to use for comparison
%chip_strain = (
'ASC004_2003_0820_BDRD-01r510999_S1_R1.DAT.fasta' => 'BDRD_01.vollum.reference.shotgun.sequence',
#'ASC004_2003_0822_BDRD-01r510999_S1_R2.DAT.fasta' => 'BDRD_01.vollum.reference.shotgun.sequence',
#'ASC006_2003_0618_BDRD01_S1_R1.DAT.fasta' => 'BDRD_01.vollum.reference.shotgun.sequence',
'ASC006_2003_0618_BDRD01_S1_R2.DAT.fasta' => 'BDRD_01.vollum.reference.shotgun.sequence',
'ASC159_2003_0821_BDRD-01r510999_S1_R1.DAT.fasta' => 'BDRD_01.Ames.reference.sequence',
#'ASC159_2003_0822_BDRD-01r510999_S1_R2.DAT.fasta' => 'BDRD_01.Ames.reference.sequence',
'ASC161_2003_0820_BDRD-01r510999_S1_R1.DAT.fasta' => 'BDRD_01.Ames.reference.sequence',
#'ASC161_2003_0822_BDRD-01r510999_S1_R2.DAT.fasta' => 'BDRD_01.Ames.reference.sequence',
#'ASC165_2003_0820_BDRD-01r510999_S1_R1.DAT.fasta' => 'BDRD_01.Ames.reference.sequence',
'ASC165_2003_0822_BDRD-01r510999_S1_R2.DAT.fasta' => 'BDRD_01.Ames.reference.sequence',
#'ASC330_2003_0820_BDRD-01r510999_S1_R1.DAT.fasta' => 'BDRD_01.Ames.reference.sequence',
'ASC330A_2003_0822_BDRD-01r510999_S1_R2.DAT.fasta' => 'BDRD_01.Ames.reference.sequence',
'ASC386_2003_0820_BDRD-01r510999_S1_R1.DAT.fasta' => 'BDRD_01.Ames.reference.sequence',
#'ASC386_2003_0822_BDRD-01r510999_S1_R2.DAT.fasta' => 'BDRD_01.Ames.reference.sequence',
'ASC386A_2003_0820_BDRD-01r510999_S1_R1.DAT.fasta' => 'BDRD_01.Ames.reference.sequence',
#'ASC386A_2003_0822_BDRD-01r510999_S1_R2.DAT.fasta' => 'BDRD_01.Ames.reference.sequence',
'ASC394_2003_0909_BDRD-01r510999_S1_R1.DAT.fasta' => 'BDRD_01.Ames.reference.sequence',
#'ASC394_2003_0910_BDRD-01r510999_S1_R2.DAT.fasta' => 'BDRD_01.Ames.reference.sequence',
#'ASC398_2003_0820_BDRD-01r510999_S1_R1.DAT.fasta' => 'BDRD_01.Ames.reference.sequence',
'ASC398_2003_0822_BDRD-01r510999_S1_R2.DAT.fasta' => 'BDRD_01.Ames.reference.sequence',
'LSU-A0039_2003_1205_BDRD-01r510999_S1_R1.DAT.fasta' => 'BDRD_01.Australia94.reference.sequence',
'LSU442_2003_1028_BDRD-01r510999_S1_R1.DAT.fasta' => 'BDRD_01.KrugerB.reference.shotgun.sequence',
#'LSU442_2003_1029_BDRD-01r510999_S1_R2.DAT.fasta' => 'BDRD_01.KrugerB.reference.shotgun.sequence',
#'LSU462_2003_0530_BDRD01_S1_R1.DAT.fasta' => 'BDRD_01.Ames.reference.sequence',
'LSU462_2003_0530_BDRD01_S1_R2.DAT.fasta' => 'BDRD_01.Ames.reference.sequence',
'LSU462_2003_0618_BDRD01_S1_R1.DAT.fasta' => 'BDRD_01.Ames.reference.sequence',
#'LSU462_2003_0618_BDRD01_S1_R2.DAT.fasta' => 'BDRD_01.Ames.reference.sequence',
#'LSU488_2003_0530_BDRD01_S1_R1.DAT.fasta' => 'BDRD_01.vollum.reference.shotgun.sequence',
'LSU488_2003_0530_BDRD01_S1_R2.DAT.fasta' => 'BDRD_01.vollum.reference.shotgun.sequence',
'LSU488_2003_0618_BDRD01_S1_R1.DAT.fasta' => 'BDRD_01.vollum.reference.shotgun.sequence',
);

#-------------------------------------------------------------------------------
#Update required

# Enter into the reference sequence directory
# Read in all the reference sequences
# Remove all fasta headers and spaces
# Place reference sequence into a string
# Read reference sequences into an array
# Put into an array for comparison




# Loop over experimental files
# Read experimental files into arrays one at a time
# Perform comparison with .reference.chip file
# Count number of bases that are N, identical, different


# Update
# Loop over all folders
# 	Loop over all files in a given folder
# 		Selected Chip File Name
# 		Change directory to reference_sequences
# 		Use hash to select correct comparison file
# 		Compare sequences
# 		Add up results
# 		Output results
# 		

# Obtain directory name entered by user, contains directories of param_folders for subsequent 
# analysis. Standard directory location used in RATools for other scripts
#---------------------------------------------------------------------------------------------------
opendir(DIR,$dirname) || die "Cannot open $dirname";
@files = grep {/$ARGV[0]/} readdir(DIR);
@filess = sort @files;
close(DIR);


# Read in all directory names, process reference files
foreach $z (@filess) {
	chdir $z || die "Cannot change to directory $z";
	
	#Open output file for number of discrepancies
	open(OUT_DISCREPANCIES, ">", "accuracy.discrepancy.count") 
		or die "Cannot open OUT_FASTA for data output";
	
	# Get list of all parameter named folders holding fasta files to be analyzed
	# Only selects directories starting with a number
	#-------------------------------------------------------------------------------
	opendir(DIR,$dirname) || die "Cannot open $dirname";
	@param_dirs = grep {/^\d\d/} readdir(DIR);
	@param_dirss = sort @param_dirs;
	$param_dir_nmbr = ($#param_dirs + 1);
	#print "The number of folders is $param_dir_nmbr\n";
	close(DIR);
	
	# Get primer file name, check for single primer file
	#-------------------------------------------------------------------------------
	@primer_file = glob("*.primers.txt") || print "\nNo primer file found\n";
	$primer_file_nmbr = ($#primer_file + 1);
	if ($primer_file_nmbr > 1) {
		die "Too many primer files" }

	# Get genpos file name, check for single genpos file
	#-------------------------------------------------------------------------------
	@genpos_file = glob("*.genpos.txt") || print "\nNo genpos file found\n";
	$genpos_file_nmbr = ($#genpos_file + 1);
	if ($genpos_file_nmbr > 1) { 
		die "Too many genpos files" }
	
	# Process reference sequence files for comparison
	#-------------------------------------------------------------------------------
	# Change to directory containing reference sequences
	$dir = getcwd();
	#print "Current directory is $dir\n";
	chdir ("$dir/reference_sequences");
	# Obtain the names of the reference sequence files
	@reference_files = glob("*.sequence"); #glob reference file here
	$ref_file_number = ($#reference_files + 1);
	print "Processing a total of $ref_file_number reference files\n\n";
	if ($ref_file_number == 0) {
		die "$ref_file_number .sequence files detected.\n
		Check reference_sequences directory. Exiting program";
	}

	# Process reference files to generate single DNA sequence file
	# Read file in line by line, discard fasta header
	# Remove spaces, put string into arrays for each different reference sequence
	$ref_count = 0;
	foreach my $ref_chip_file (@reference_files) {
		$ref_count++;
		open(FILEHANDLE_FIRST, $ref_chip_file)
			or die "Cannot open FILEHANDLE_FIRST";
		while (<FILEHANDLE_FIRST>) {
			if ($_ =~ /^>/) {
				next;
			}
			else {
				$reference_seq .= $_;
			}
		}	
		close FILEHANDLE_FIRST;
		$reference_seq =~ s/\s//g;
		
		if ($ref_chip_file eq "BDRD_01.Ames.reference.sequence") {
			print OUT_DISCREPANCIES "Found the Ames file\n";
			print "Found the Ames file\n";
			#print "ref_count is equal to $ref_count\n";
			@Ames_ref_seq = split( '', $reference_seq);
			$Ames_ref_seq_size = ($#Ames_ref_seq + 1);
			}
		
		if ($ref_chip_file eq "BDRD_01.Australia94.reference.sequence") {
			print OUT_DISCREPANCIES "Found the Australia94 file\n";
			print "Found the Australia94 file\n";
			#print "ref_count is equal to $ref_count\n";
			@Australia_ref_seq = split( '', $reference_seq);
			$Australia_ref_seq_size = ($#Australia_ref_seq + 1);
			}
		
			if ($ref_chip_file eq "BDRD_01.KrugerB.reference.shotgun.sequence") {
			print OUT_DISCREPANCIES "Found the Kruger file\n";
			print "Found the Kruger file\n";
			#print "ref_count is equal to $ref_count\n";
			@KrugerB_ref_seq = split( '', $reference_seq);
			$KrugerB_ref_seq_size = ($#KrugerB_ref_seq + 1);
			}
		
			if ($ref_chip_file eq "BDRD_01.vollum.reference.shotgun.sequence") {
			print OUT_DISCREPANCIES "Found the Vollum file\n";
			print "Found the Vollum file\n";
			#print "ref_count is equal to $ref_count\n";
			@Vollum_ref_seq = split( '', $reference_seq);
			$Vollum_ref_seq_size = ($#Vollum_ref_seq + 1);
			}
	}
	print OUT_DISCREPANCIES "Finished processing the reference files\n";
	print OUT_DISCREPANCIES "---------------------------------------------------------------------------\n";
	print OUT_DISCREPANCIES "\n";
	
	# Screen output
	print "Finished processing the reference files\n";
	print "---------------------------------------------------------------------------\n";
	print "\n";
	
	chdir ("../");
	# Change directory to data directory
	# Open output file
	# Loop over all fasta files
	# Read a fasta file, determine the number of discrepancies
	# Output results of comparison to discrepancy file
	#---------------------------------------------------------------------------
	foreach $zz (@param_dirss) {
	
		print OUT_DISCREPANCIES "\nProcessing files from directory: $zz\n";
		# Get .fasta file names, number of files
		
		opendir(DIR,$zz) || die "Cannot open $zz";
		
		# Remove extra .ref.fasta files from directory, before reading fasta files
		# Change to directory containing data
		$dir = getcwd();
		#print "Current directory is $dir\n";
		#print "Current value of zz is $zz\n";
		chdir ("$dir/$zz") || die "Cannot change to directory $dir/$zz";
		#system("rm *.ref.fasta");
		unlink glob("*.ref.fasta");
		chdir	("$dir");
	
		# Get fasta files
		@fasta_files = grep {/\.fasta/} readdir(DIR);
		#print "Files found include:\n";
		#print "@fasta_files\n\n";
		close(DIR);
		@fasta_filess = sort @fasta_files;
		$nofiles = @fasta_filess;
		#print "@fasta_files\n";
		print OUT_DISCREPANCIES "$nofiles files found in directory $zz\n";
		print "$nofiles files found in directory $zz\n";
		
		# Change to directory containing data
		$dir = getcwd();
		print "Current directory is $dir\n";
		print "Current value of zz is $zz\n";
		chdir ("$dir/$zz") || die "Cannot change to directory $dir/$zz";
		
		#Process fasta files in arrays
		foreach my $yy (@fasta_filess) {
			print OUT_DISCREPANCIES "File being processed: $yy\n";
			open(FILEHANDLE_SECOND, $yy)
				or die "Cannot open FILEHANDLE_SECOND in fasta file loop";
			while (<FILEHANDLE_SECOND>) {
				if ($_ =~ /^>/) {
					next;
				}
				else {
				$fasta_exp_seq .= $_;
				}
			}
			close FILEHANDLE_SECOND;
			$fasta_exp_seq =~ s/\s//g;
			@fasta_seq = split( '', $fasta_exp_seq);
			$fasta_seq_size = ($#fasta_seq + 1);
			print OUT_DISCREPANCIES "Size of file being processed: $fasta_seq_size\n";
		
			# Perform file comparison at all chars in reference array and array experiment.
			#---------------------------------------------------------------------------
			#print OUT_DISCREPANCIES "\n";
			#print OUT_DISCREPANCIES "$nofiles\n";
			#print OUT_DISCREPANCIES "$ref_seq_size\n";
	
	# Skip Files that are not in hash chip_strain
	if (exists $chip_strain{$yy}) {
		print "Key, $yy, exists\n";
		}
		else {
			print "Key, $yy, does not exist\n";
			
			# Reset variable values
			#print "Reseting variables\n";
			@fasta_seq = ();
			$fasta_exp_seq = '';
			$fasta_seq_size = 0;
			
			#Reset Variables
			$bases_called_N = 0;
			$bases_identical = 0;
			$bases_different = 0;
			$check_total = 0;
			next;
			}
	
	# Compare with Ames reference sequence
	if ($chip_strain{$yy} eq "BDRD_01.Ames.reference.sequence") {
		print "Entered the Ames loop\n";
		for (my $i = 0; $i < $fasta_seq_size; $i++) {
			$total_bases++;

			# Count bases not called in experiment
			if ($fasta_seq[$i] eq "N") {
				$bases_called_N++;
			}
			# Count bases called and identical
			elsif ($fasta_seq[$i] eq $Ames_ref_seq[$i]) {
				$bases_identical++;
			}
			# Count discrepancies
			else {
				#print OUT_DISCREPANCIES " Discrepancy at position $i\t Chip call: $fasta_seq[$i], Ref seq: $Ames_ref_seq[$i]\n";
				$bases_different++;
			}
		}
	# Reset variable values
	#print "Reseting variables\n";
	@fasta_seq = ();
	$fasta_exp_seq = '';
	$fasta_seq_size = 0;
	
		# Collect summary data for a single fasta chip file
		$check_total = ($bases_identical + $bases_different + $bases_called_N);
		#Summary Statistics
		print OUT_DISCREPANCIES "Number of bases called N: $bases_called_N\n";
		print OUT_DISCREPANCIES "Number of based called identically: $bases_identical\n";
		print OUT_DISCREPANCIES "Number of discrepant bases: $bases_different\n";
		print OUT_DISCREPANCIES "Total Bases this chip: $check_total\n\n";

		#if ($ref_seq_size != $check_total) {
			#print OUT_DISCREPANCIES "Warning. Reference bases, $ref_seq_size, does not match $check_total\n";
			#print "Warning. Reference bases, $ref_seq_size, does not match $check_total\n\n";
		#}
		
		# Collect grand total information for a given set of parameters (directory)
		#---------------------------------------------------------------------------
		$grand_total_bases_called_N = $grand_total_bases_called_N + $bases_called_N;
		$grand_total_bases_identical = $grand_total_bases_identical + $bases_identical;
		$grand_total_bases_different = $grand_total_bases_different + $bases_different;
		$grand_total_check_total = $grand_total_check_total + $check_total;
		
		#Reset Variables
		$bases_called_N = 0;
		$bases_identical = 0;
		$bases_different = 0;
		$check_total = 0;
	
	next;
	}
	
	if ($chip_strain{$yy} eq "BDRD_01.Australia94.reference.sequence") {
		#print "Entered the Australia loop\n";
		# Compare with Australia94 reference sequence
		for (my $k = 0; $k < $fasta_seq_size; $k++) {
			$total_bases++;

			# Count bases not called in experiment
			if ($fasta_seq[$k] eq "N") {
				$bases_called_N++;
			}
			# Count bases called and identical
			elsif ($fasta_seq[$k] eq $Australia_ref_seq[$k]) {
				$bases_identical++;
			}
			# Count discrepancies
			else {
				#print OUT_DISCREPANCIES " Discrepancy at position $k\t Chip call: $fasta_seq[$k], Ref seq: $Australia_ref_seq[$k]\n";
				$bases_different++;
			}
		}
	# Reset variable values
	#print "Reseting variables\n";
	@fasta_seq = ();
	$fasta_exp_seq = '';
	$fasta_seq_size = 0;
	
		# Collect summary data for a single fasta chip file
		$check_total = ($bases_identical + $bases_different + $bases_called_N);
		#Summary Statistics
		print OUT_DISCREPANCIES "Number of bases called N: $bases_called_N\n";
		print OUT_DISCREPANCIES "Number of based called identically: $bases_identical\n";
		print OUT_DISCREPANCIES "Number of discrepant bases: $bases_different\n";
		print OUT_DISCREPANCIES "Total Bases this chip: $check_total\n\n";

		#if ($ref_seq_size != $check_total) {
			#print OUT_DISCREPANCIES "Warning. Reference bases, $ref_seq_size, does not match $check_total\n";
			#print "Warning. Reference bases, $ref_seq_size, does not match $check_total\n\n";
		#}
		
		# Collect grand total information for a given set of parameters (directory)
		#---------------------------------------------------------------------------
		$grand_total_bases_called_N = $grand_total_bases_called_N + $bases_called_N;
		$grand_total_bases_identical = $grand_total_bases_identical + $bases_identical;
		$grand_total_bases_different = $grand_total_bases_different + $bases_different;
		$grand_total_check_total = $grand_total_check_total + $check_total;
		
		#Reset Variables
		$bases_called_N = 0;
		$bases_identical = 0;
		$bases_different = 0;
		$check_total = 0;

	next;
	}
	
	if ($chip_strain{$yy} eq "BDRD_01.KrugerB.reference.shotgun.sequence") {
		#print "Entered the KrugerB loop\n";
		# Compare with KrugerB reference sequence
		for (my $l = 0; $l < $fasta_seq_size; $l++) {
			$total_bases++;

			# Count bases not called in experiment
			if ($fasta_seq[$l] eq "N") {
				$bases_called_N++;
			}
			# Count bases called and identical
			elsif ($fasta_seq[$l] eq $KrugerB_ref_seq[$l]) {
				$bases_identical++;
			}
			# Count discrepancies
			else {
				#print OUT_DISCREPANCIES " Discrepancy at position $l\t Chip call: $fasta_seq[$l], Ref seq: $KrugerB_ref_seq[$l]\n";
				$bases_different++;
			}
		}
	# Reset variable values
	#print "Reseting variables\n";
	@fasta_seq = ();
	$fasta_exp_seq = '';
	$fasta_seq_size = 0;
	
		# Collect summary data for a single fasta chip file
		$check_total = ($bases_identical + $bases_different + $bases_called_N);
		#Summary Statistics
		print OUT_DISCREPANCIES "Number of bases called N: $bases_called_N\n";
		print OUT_DISCREPANCIES "Number of based called identically: $bases_identical\n";
		print OUT_DISCREPANCIES "Number of discrepant bases: $bases_different\n";
		print OUT_DISCREPANCIES "Total Bases this chip: $check_total\n\n";

		#if ($ref_seq_size != $check_total) {
			#print OUT_DISCREPANCIES "Warning. Reference bases, $ref_seq_size, does not match $check_total\n";
			#print "Warning. Reference bases, $ref_seq_size, does not match $check_total\n\n";
		#}
		
		# Collect grand total information for a given set of parameters (directory)
		#---------------------------------------------------------------------------
		$grand_total_bases_called_N = $grand_total_bases_called_N + $bases_called_N;
		$grand_total_bases_identical = $grand_total_bases_identical + $bases_identical;
		$grand_total_bases_different = $grand_total_bases_different + $bases_different;
		$grand_total_check_total = $grand_total_check_total + $check_total;
		
		#Reset Variables
		$bases_called_N = 0;
		$bases_identical = 0;
		$bases_different = 0;
		$check_total = 0;

	next;
	}
	
	if ($chip_strain{$yy} eq "BDRD_01.vollum.reference.shotgun.sequence") {
		#print "Entered the Vollum loop\n";
			# Compare with Vollum reference sequence
		for (my $m = 0; $m < $fasta_seq_size; $m++) {
			$total_bases++;

			# Count bases not called in experiment
			if ($fasta_seq[$m] eq "N") {
				$bases_called_N++;
			}
			# Count bases called and identical
			elsif ($fasta_seq[$m] eq $Vollum_ref_seq[$m]) {
				$bases_identical++;
			}
			# Count discrepancies
			else {
				#print OUT_DISCREPANCIES " Discrepancy at position $m\t Chip call: $fasta_seq[$m], Ref seq: $Vollum_ref_seq[$m]\n";
				$bases_different++;
			}
		}
	# Reset variable values
	#print "Reseting variables\n";
	@fasta_seq = ();
	$fasta_exp_seq = '';
	$fasta_seq_size = 0;
	
			# Collect summary data for a single fasta chip file
		$check_total = ($bases_identical + $bases_different + $bases_called_N);
		#Summary Statistics
		print OUT_DISCREPANCIES "Number of bases called N: $bases_called_N\n";
		print OUT_DISCREPANCIES "Number of based called identically: $bases_identical\n";
		print OUT_DISCREPANCIES "Number of discrepant bases: $bases_different\n";
		print OUT_DISCREPANCIES "Total Bases this chip: $check_total\n\n";

		#if ($ref_seq_size != $check_total) {
			#print OUT_DISCREPANCIES "Warning. Reference bases, $ref_seq_size, does not match $check_total\n";
			#print "Warning. Reference bases, $ref_seq_size, does not match $check_total\n\n";
		#}
		
		# Collect grand total information for a given set of parameters (directory)
		#---------------------------------------------------------------------------
		$grand_total_bases_called_N = $grand_total_bases_called_N + $bases_called_N;
		$grand_total_bases_identical = $grand_total_bases_identical + $bases_identical;
		$grand_total_bases_different = $grand_total_bases_different + $bases_different;
		$grand_total_check_total = $grand_total_check_total + $check_total;
		
		#Reset Variables
		$bases_called_N = 0;
		$bases_identical = 0;
		$bases_different = 0;
		$check_total = 0;
		
	next;
	}
	
		# Collect grand total information for a given set of parameters (directory)
		#---------------------------------------------------------------------------
		#$grand_total_bases_called_N = $grand_total_bases_called_N + $bases_called_N;
		#$grand_total_bases_identical = $grand_total_bases_identical + $bases_identical;
		#$grand_total_bases_different = $grand_total_bases_different + $bases_different;
		#$grand_total_check_total = $grand_total_check_total + $check_total;
	}
			
		# Debug Codef
		print "Called N: $grand_total_bases_called_N\n";
		print "Called Identical: $grand_total_bases_identical\n";
		print "Called Different: $grand_total_bases_different\n";
		print "Total: $grand_total_check_total\n";

		# Output grand_total information for a given set of parameters (directory)
		#---------------------------------------------------------------------------
		print OUT_DISCREPANCIES "---------------------------------------------------------------------------\n";
		print OUT_DISCREPANCIES "Parameter Values: $zz\n";
		print OUT_DISCREPANCIES "Grand total number of bases called N: $grand_total_bases_called_N\n";
		print OUT_DISCREPANCIES "Grand total number of based called identically: $grand_total_bases_identical\n";
		print OUT_DISCREPANCIES "Grand total number of discrepant bases: $grand_total_bases_different\n";
		print OUT_DISCREPANCIES "Grand total number of bases: $grand_total_check_total\n";
		print OUT_DISCREPANCIES "---------------------------------------------------------------------------\n";
		# Collect grand total information for a given set of parameters (directory)
		#---------------------------------------------------------------------------
		$grand_total_bases_called_N = 0;
		$grand_total_bases_identical = 0;
		$grand_total_bases_different = 0;
		$grand_total_check_total = 0;

		# Return to working directory
		chdir ("$dir");

}



		
		close OUT_DISCREPANCIES;
		chdir ("../");
	}
print ("Exiting RA_accu_compare_ref_Basecaller.pl script\n");

#--------------------------------------------------------------------------
#--------------------------------------------------------------------------
# Subroutines
#--------------------------------------------------------------------------
#--------------------------------------------------------------------------

sub accuracy_compare {

return;
}
