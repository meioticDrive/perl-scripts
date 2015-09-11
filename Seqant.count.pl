#!/usr/bin/perl
#
# Name: Seqant.count.pl
# Version: 1.0
# Date: 8/25/2011
################################################################################
# The purpose of this script:
# 1. Summarize the number of variants identified among six mouse files located in the Samples directory
# 2. Read the mutant individual and the two heterozygous individuals, identify variants homozygous in mutant,
# heterozygous in other two lines.
################################################################################
use warnings;
use strict;
use Cwd;

# Local variable definitions
################################################################################
my ($dataPath, $count, @file_names, $file_names_nmbr, @unique_file, $unique_file_nmbr, @unique_split,
$hom_replacement, $hom_silent, $hom_utr, $hom_intronic, $hom_intergenic,
$het_replacement, $het_silent, $het_utr, $het_intronic, $het_intergenic,
@mutant_file, $mutant_file_nmbr, @mutant_split,
@stock_one_file, $stock_one_file_nmbr, @stock_one_split, %stock_one_hash,
@stock_two_file, $stock_two_file_nmbr, @stock_two_split, %stock_two_hash,
@stock_temp_split, @stock_one_temp_split, @stock_two_temp_split);

# Initialize variable values
################################################################################
$dataPath = "";
$count = 0;
$file_names_nmbr = 0;
$hom_replacement = 0;
$hom_silent = 0;
$hom_utr = 0;
$hom_intronic = 0;
$hom_intergenic = 0;
$het_replacement = 0;
$het_silent = 0;
$het_utr = 0;
$het_intronic = 0;
$het_intergenic = 0;

####################################################################################################
# Make a directory named Counts, put all files in there
# Categories to count
# Total number of variants in all files
# Heterozygous and Homozygous in each sample
# Variant Type in dbSNP
# Variant Type not in dbSNP
# Variants Homozygous 
####################################################################################################


# Perform directory functions
####################################################################################################
# Test if user included directory name when starting program
if(@ARGV != 1)
{
	die "\n Usage: Seqant.count.pl <target directory> \n";
}
# Change to user provided directory containing data files
chdir "$ARGV[0]";
$dataPath = getcwd();
mkdir "$dataPath/Counts/";

####################################################################################################
# This document contains file names for homozygous mouse line and two heterozygous mouse lines
# Name order is: mutant, het1, het2, BL6-strain1, FVB-strain2, positive control
####################################################################################################
open (IN_FILE_IN, "<", "$dataPath/Samples/in.file.in") or die "Cannot open IN_FILE_IN filehandle to read file";

while (<IN_FILE_IN>) {
	chomp $_;
	push(@file_names, $_);
}
close(IN_FILE_IN);
$file_names_nmbr = ($#file_names + 1);
#print "Processing a total of $file_names_nmbr files\n";
chdir "$dataPath/Counts/";
open (OUTFILE_0, ">", ("$file_names[0]" . '.counts.txt'));
open (OUTFILE_1, ">", ("$file_names[1]" . '.counts.txt'));
open (OUTFILE_2, ">", ("$file_names[2]" . '.counts.txt'));
open (OUTFILE_3, ">", ("$file_names[3]" . '.counts.txt'));
open (OUTFILE_4, ">", ("$file_names[4]" . '.counts.txt'));
open (OUTFILE_5, ">", ("$file_names[5]" . '.counts.txt'));
open (OUTFILE_6, ">", ("$ARGV[0]" . '.summary.counts.txt'));
open (OUTFILE_7, ">", ("$ARGV[0]" . '.candidates.remove.polymorphic.txt'));

print OUTFILE_0 "Analysis Type\tSampleID\tHom: Replacement\tHom: Silent\tHom: UTR\tHom: Intronic\tHom: Intergenic\tHet: Replacement\tHet: Silent\tHet: UTR\tHet: Intronic\tHet: Intergenic\n";
print OUTFILE_1 "Analysis Type\tSampleID\tHom: Replacement\tHom: Silent\tHom: UTR\tHom: Intronic\tHom: Intergenic\tHet: Replacement\tHet: Silent\tHet: UTR\tHet: Intronic\tHet: Intergenic\n";
print OUTFILE_2 "Analysis Type\tSampleID\tHom: Replacement\tHom: Silent\tHom: UTR\tHom: Intronic\tHom: Intergenic\tHet: Replacement\tHet: Silent\tHet: UTR\tHet: Intronic\tHet: Intergenic\n";
print OUTFILE_3 "Analysis Type\tSampleID\tHom: Replacement\tHom: Silent\tHom: UTR\tHom: Intronic\tHom: Intergenic\tHet: Replacement\tHet: Silent\tHet: UTR\tHet: Intronic\tHet: Intergenic\n";
print OUTFILE_4 "Analysis Type\tSampleID\tHom: Replacement\tHom: Silent\tHom: UTR\tHom: Intronic\tHom: Intergenic\tHet: Replacement\tHet: Silent\tHet: UTR\tHet: Intronic\tHet: Intergenic\n";
print OUTFILE_5 "Analysis Type\tSampleID\tHom: Replacement\tHom: Silent\tHom: UTR\tHom: Intronic\tHom: Intergenic\tHet: Replacement\tHet: Silent\tHet: UTR\tHet: Intronic\tHet: Intergenic\n";
print OUTFILE_6 "Analysis Type\tSampleID\tHom: Replacement\tHom: Silent\tHom: UTR\tHom: Intronic\tHom: Intergenic\tHet: Replacement\tHet: Silent\tHet: UTR\tHet: Intronic\tHet: Intergenic\n";
print OUTFILE_7 "Listing of homozygous mutation candidates obtained by eliminating variants found in dbSNP, Stock 1, or Stock 2\n";
print OUTFILE_7 "Chromosome\tPosition\tRegion\tGene\tVarType\tCommon_to\tdbSNP ID\tGenotype\n";

# Count Total Variants
# Count mutant line variants that are Het in parents
####################################################################################################
for ($count = 0; $count < $file_names_nmbr; $count++) {
	Count_Variants($dataPath, $file_names[$count], $count);
}

# For mutant line only
Count_dbSNP($dataPath, $file_names[0]);
Count_Stocks($dataPath, $file_names[0], $file_names[3], $file_names[4]);

# Count Genotypes

close (OUTFILE_0);
close (OUTFILE_1);
close (OUTFILE_2);
close (OUTFILE_3);
close (OUTFILE_4);
close (OUTFILE_5);
close (OUTFILE_6);
close (OUTFILE_7);
print "Completed Seqant.count.pl script\n";

####################################################################################################
####################################################################################################
### Subroutines
####################################################################################################
####################################################################################################


####################################################################################################
# Count Variants
# $_[0] = $dataPath - main directory containing SeqAnt files
# $_[1] = $filenames[$count] - name of file being processed
# $_[2] = $count - number of file being processed
####################################################################################################
sub Count_Variants {
	#print "Subroutine Count_Variants\n";
	#print "Entered the Count_Variants subroutine with arguments: $_[0], $_[1], $_[2]\n";
	chdir "$_[0]/Samples/";
	@unique_file = glob "$_[1]" || print "Variant file not found\n";
	$unique_file_nmbr = ($#unique_file + 1);
	#print "Processing $unique_file_nmbr file.\n";
	#print "Name of globbed file is: $unique_file[0]\n";
	
	open (IN_FILE, "<", "$unique_file[0]") or die "Cannot open IN_FILE filehandle to read file";
	while (<IN_FILE>) {
		chomp $_;
		if (/^Chromosome/) {next;}
		# Split the line
		# Push the second value into an array named @unique_position
		@unique_split = split('\t', $_);
		
		# $unique_split[1] = Position
		# $unique_split[2] = Region
		# $unique_split[4] = VarType
		# $unique_split[7] = Genotype
		# Sum over VarType and Genotype
		
		if (($unique_split[4] eq 'Replacement') and ( $unique_split[7] eq 'Hom')) {$hom_replacement++;}
		if (($unique_split[4] eq 'Silent') and ( $unique_split[7] eq 'Hom')) {$hom_silent++;}
		if (($unique_split[2] eq 'UTR') and ( $unique_split[7] eq 'Hom')) {$hom_utr++;}
		if (($unique_split[2] eq 'Intronic') and ( $unique_split[7] eq 'Hom')) {$hom_intronic++;}
		if (($unique_split[2] eq 'Intergenic') and ( $unique_split[7] eq 'Hom')) {$hom_intergenic++;}
		
		if (($unique_split[4] eq 'Replacement') and ( $unique_split[7] eq 'Het')) {$het_replacement++;}
		if (($unique_split[4] eq 'Silent') and ( $unique_split[7] eq 'Het')) {$het_silent++;}
		if (($unique_split[2] eq 'UTR') and ( $unique_split[7] eq 'Het')) {$het_utr++;}
		if (($unique_split[2] eq 'Intronic') and ( $unique_split[7] eq 'Het')) {$het_intronic++;}
		if (($unique_split[2] eq 'Intergenic') and ( $unique_split[7] eq 'Het')) {$het_intergenic++;}
	}
		close IN_FILE;
	if($_[2] == 0) {print OUTFILE_0 "All SNVs\t$_[1]\t$hom_replacement\t$hom_silent\t$hom_utr\t$hom_intronic\t$hom_intergenic\t$het_replacement\t$het_silent\t$het_utr\t$het_intronic\t$het_intergenic\n";}
	if($_[2] == 1) {print OUTFILE_1 "All SNVs\t$_[1]\t$hom_replacement\t$hom_silent\t$hom_utr\t$hom_intronic\t$hom_intergenic\t$het_replacement\t$het_silent\t$het_utr\t$het_intronic\t$het_intergenic\n";}
	if($_[2] == 2) {print OUTFILE_2 "All SNVs\t$_[1]\t$hom_replacement\t$hom_silent\t$hom_utr\t$hom_intronic\t$hom_intergenic\t$het_replacement\t$het_silent\t$het_utr\t$het_intronic\t$het_intergenic\n";}
	if($_[2] == 3) {print OUTFILE_3 "All SNVs\t$_[1]\t$hom_replacement\t$hom_silent\t$hom_utr\t$hom_intronic\t$hom_intergenic\t$het_replacement\t$het_silent\t$het_utr\t$het_intronic\t$het_intergenic\n";}
	if($_[2] == 4) {print OUTFILE_4 "All SNVs\t$_[1]\t$hom_replacement\t$hom_silent\t$hom_utr\t$hom_intronic\t$hom_intergenic\t$het_replacement\t$het_silent\t$het_utr\t$het_intronic\t$het_intergenic\n";}
	if($_[2] == 5) {print OUTFILE_5 "All SNVs\t$_[1]\t$hom_replacement\t$hom_silent\t$hom_utr\t$hom_intronic\t$hom_intergenic\t$het_replacement\t$het_silent\t$het_utr\t$het_intronic\t$het_intergenic\n";}
	print OUTFILE_6 "All SNVs\t$_[1]\t$hom_replacement\t$hom_silent\t$hom_utr\t$hom_intronic\t$hom_intergenic\t$het_replacement\t$het_silent\t$het_utr\t$het_intronic\t$het_intergenic\n";
	
	#Reset variables
	@unique_file = "";
	$unique_file_nmbr = 0;
	$hom_replacement = 0;
	$hom_silent = 0;
	$hom_utr = 0;
	$hom_intronic = 0;
	$hom_intergenic = 0;
	$het_replacement = 0;
	$het_silent = 0;
	$het_utr = 0;
	$het_intronic = 0;
	$het_intergenic = 0;
}

####################################################################################################
# Count dbSNP
# $_[0] = $dataPath - main directory containing SeqAnt files
# $_[1] = $filenames[0] - name of mutant line file
# Print header homozygous in mutant
# Note Variant in Mutant Line
# Is variant in mutant line in dbSNP
# All categories for all lines
# Found in dbSNP
####################################################################################################
sub Count_dbSNP { 
	#print "Subroutine Count_dbSNP\n";
	#print "Entered the Count_dbSNP subroutine with arguments: $_[0] , $_[1]\n";
	chdir "$_[0]/Samples/";
	@mutant_file = glob "$_[1]" || print "Variant file not found\n";
	$mutant_file_nmbr = ($#mutant_file + 1);
	#print "Processing $mutant_file_nmbr file.\n";
	#print "Name of globbed file is: $mutant_file[0]\n";
	
	open (IN_FILE, "<", "$mutant_file[0]") or die "Cannot open IN_FILE filehandle to read file";
	while (<IN_FILE>) {
		chomp $_;
		if (/^Chromosome/) {next;}
		
		# Split the line
		# Push the second value into an array named @mutant_position
		@mutant_split = split('\t', $_);
		
		# $mutant_split[1] = Position
		# $mutant_split[2] = Region
		# $mutant_split[4] = VarType
		# $mutant_split[6] = dbSNP ID
		# $mutant_split[7] = Genotype
		
		# Test to see if there is a dbSNP ID
		if ($mutant_split[6] =~ /^rs/) {
			#print "Found a dbSNP match\n";
			# Sum over VarType and Genotype
			if (($mutant_split[4] eq 'Replacement') and ( $mutant_split[7] eq 'Hom')) {$hom_replacement++;}
			if (($mutant_split[4] eq 'Silent') and ( $mutant_split[7] eq 'Hom')) {$hom_silent++;}
			if (($mutant_split[2] eq 'UTR') and ( $mutant_split[7] eq 'Hom')) {$hom_utr++;}
			if (($mutant_split[2] eq 'Intronic') and ( $mutant_split[7] eq 'Hom')) {$hom_intronic++;}
			if (($mutant_split[2] eq 'Intergenic') and ( $mutant_split[7] eq 'Hom')) {$hom_intergenic++;}
		
			if (($mutant_split[4] eq 'Replacement') and ( $mutant_split[7] eq 'Het')) {$het_replacement++;}
			if (($mutant_split[4] eq 'Silent') and ( $mutant_split[7] eq 'Het')) {$het_silent++;}
			if (($mutant_split[2] eq 'UTR') and ( $mutant_split[7] eq 'Het')) {$het_utr++;}
			if (($mutant_split[2] eq 'Intronic') and ( $mutant_split[7] eq 'Het')) {$het_intronic++;}
			if (($mutant_split[2] eq 'Intergenic') and ( $mutant_split[7] eq 'Het')) {$het_intergenic++;}
		} else { next; }
	}
	close IN_FILE;
	print OUTFILE_0 "in dbSNP\t$_[1]\t$hom_replacement\t$hom_silent\t$hom_utr\t$hom_intronic\t$hom_intergenic\t$het_replacement\t$het_silent\t$het_utr\t$het_intronic\t$het_intergenic\n";

	#Reset variables
	@mutant_file = "";
	$mutant_file_nmbr = 0;
	$hom_replacement = 0;
	$hom_silent = 0;
	$hom_utr = 0;
	$hom_intronic = 0;
	$hom_intergenic = 0;
	$het_replacement = 0;
	$het_silent = 0;
	$het_utr = 0;
	$het_intronic = 0;
	$het_intergenic = 0;
}

####################################################################################################
# Count Stocks
# $_[0] = $dataPath - main directory containing SeqAnt files
# $_[1] = $filenames[0] - name of mutant line file
# $_[2] = $filenames[3] - name of stock line file
# $_[3] = $filenames[4] - name of stock line file
# Subroutine determines if a variant from the mutant line is present in a stock line but not in dbSNP
####################################################################################################
sub Count_Stocks {
	# SNVs present in stocks, but not found in dbSNP
	#print "Subroutine Count_Stocks\n\n";
	#print "Entered the Count_Stocks subroutine with arguments: $_[0] , $_[1], $_[2], $_[3]\n\n\n";
	chdir "$_[0]/Samples/";
	
	@mutant_file = glob "$_[1]" || print "Mutant line file not found\n";
	$mutant_file_nmbr = ($#mutant_file + 1);
	@stock_one_file = glob "$_[2]" || print "Stock one line file not found\n";
	$stock_one_file_nmbr = ($#stock_one_file + 1);
	@stock_two_file = glob "$_[3]" || print "Stock one line file not found\n";
	$stock_two_file_nmbr = ($#stock_two_file + 1);
	#print "Name of globbed files are: $mutant_file[0], $stock_one[0], $stock_two[0]\n";
	
	# Make hash for rapid search of @stock_one_fie
	open (IN_FILE_HASH, "<", "$stock_one_file[0]") or die "Cannot open IN_FILE_HASH filehandle for stock one in subroutine Count_Stocks";
	while (<IN_FILE_HASH>) {
		chomp $_;
		if (/^Chromosome/) {next;}											#Skip header line
		@stock_one_split = split('\t', $_);
		if ($stock_one_split[6] =~ /^rs/) {next;}							# Test to see if there is a dbSNP ID, if so move to next line
		$stock_one_hash{$stock_one_split[1]} = $_;							# Make hash for stock_one key position, contains line of info
	}
	
	# Make hash for rapid search of @stock_two_file
	open (IN_FILE_HASH, "<", "$stock_two_file[0]") or die "Cannot open IN_FILE_HASH filehandle for stock one in subroutine Count_Stocks";
	while (<IN_FILE_HASH>) {
		chomp $_;
		if (/^Chromosome/) {next;}											#Skip header line
		@stock_two_split = split('\t', $_);
		if ($stock_two_split[6] =~ /^rs/) {next;}															# Test to see if there is a dbSNP ID, if so move to next line
		$stock_two_hash{$stock_two_split[1]} = $_;															# Make hash for stock_two key position, contains line of info
	}
	
	####################################################################################################
	# Variant homozygous in mutant line, found in Stock 1, but not in Stock 2, not in dbSNP
	# $mutant_split[1] = Position
	# $mutant_split[2] = Region
	# $mutant_split[4] = VarType
	# $mutant_split[6] = dbSNP ID
	# $mutant_split[7] = Genotype
	####################################################################################################
	open (IN_FILE, "<", "$mutant_file[0]") or die "Cannot open IN_FILE filehandle in subroutine Count_Stocks to read file";
	while (<IN_FILE>) {
		chomp $_;
		if (/^Chromosome/) {next;}
		@mutant_split = split('\t', $_);
		if ($mutant_split[6] =~ /^rs/) {next;}																# Test to see if there is a dbSNP ID, if so move to next line
		if ((exists $stock_one_hash{"$mutant_split[1]"}) and (exists $stock_two_hash{"$mutant_split[1]"}) and ($mutant_split[7] eq "Hom")) {next;}	# Ignore variants found in both stocks
		if ((exists $stock_one_hash{"$mutant_split[1]"}) and ($mutant_split[7] eq "Hom")) {					# Check is that position is defined in @stock_one_file, not @stock_two_file
			#print "Found a match with stock 1.\n";
			#print "Match is $mutant_split[1]\n";
			@stock_temp_split = @mutant_split;
			# Fixed bug below
			#@stock_temp_split = split('\t', $stock_one_hash{"$mutant_split[1]"});
			#print "$stock_temp_split[1]\t$stock_temp_split[4]\t$stock_temp_split[7]\t$stock_temp_split[2]\n";				# Sum over VarType and Genotype
			if (($stock_temp_split[4] eq 'Replacement') and ($stock_temp_split[7] eq 'Hom')) {$hom_replacement++;}
			if (($stock_temp_split[4] eq 'Silent') and ($stock_temp_split[7] eq 'Hom')) {$hom_silent++;}
			if (($stock_temp_split[2] eq 'UTR') and ($stock_temp_split[7] eq 'Hom')) {$hom_utr++;}
			if (($stock_temp_split[2] eq 'Intronic') and ($stock_temp_split[7] eq 'Hom')) {$hom_intronic++;}
			if (($stock_temp_split[2] eq 'Intergenic') and ($stock_temp_split[7] eq 'Hom')) {$hom_intergenic++;}
		}
	}
	close IN_FILE;
	print OUTFILE_0 "In Stock 1, not Stock 2 and not dbSNP\t$_[1]\t$hom_replacement\t$hom_silent\t$hom_utr\t$hom_intronic\t$hom_intergenic\t$het_replacement\t$het_silent\t$het_utr\t$het_intronic\t$het_intergenic\n";
	#Reset variables
	@stock_temp_split = "";
	@mutant_split = "";
	$mutant_file_nmbr = 0;
	$hom_replacement = 0;
	$hom_silent = 0;
	$hom_utr = 0;
	$hom_intronic = 0;
	$hom_intergenic = 0;
	$het_replacement = 0;
	$het_silent = 0;
	$het_utr = 0;
	$het_intronic = 0;
	$het_intergenic = 0;
	
	####################################################################################################
	# Variant homozygous in mutant line, found in Stock 2, but not in Stock 1, not in dbSNP
	####################################################################################################
	open (IN_FILE, "<", "$mutant_file[0]") or die "Cannot open IN_FILE filehandle in subroutine Count_Stocks, stock file 2, to read file";
	while (<IN_FILE>) {
		chomp $_;
		if (/^Chromosome/) {next;}
		@mutant_split = split('\t', $_);
		if ($mutant_split[6] =~ /^rs/) {next;}																# Test to see if there is a dbSNP ID, if so move to next line
		# $mutant_split[1] = Position
		# $mutant_split[2] = Region
		# $mutant_split[4] = VarType
		# $mutant_split[6] = dbSNP ID
		# $mutant_split[7] = Genotype
		if ((exists $stock_one_hash{"$mutant_split[1]"}) and (exists $stock_two_hash{"$mutant_split[1]"}) and ($mutant_split[7] eq "Hom")) {next;}	# Ignore variants found in both stocks
		if ((exists $stock_two_hash{"$mutant_split[1]"}) and ($mutant_split[7] eq "Hom")) {					# Check is that position is defined in @stock_one_file, not @stock_two_file
			#print "Found a match with stock 2.\n";
			#print "Match is $mutant_split[1]\n";
			@stock_temp_split = @mutant_split;
			#@stock_temp_split = split('\t', $stock_two_hash{"$mutant_split[1]"});
			#print "$stock_temp_split[1]\t$stock_temp_split[4]\t$stock_temp_split[7]\t$stock_temp_split[2]\n";				# Sum over VarType and Genotype
			if (($stock_temp_split[4] eq 'Replacement') and ($stock_temp_split[7] eq 'Hom')) {$hom_replacement++;}
			if (($stock_temp_split[4] eq 'Silent') and ($stock_temp_split[7] eq 'Hom')) {$hom_silent++;}
			if (($stock_temp_split[2] eq 'UTR') and ($stock_temp_split[7] eq 'Hom')) {$hom_utr++;}
			if (($stock_temp_split[2] eq 'Intronic') and ($stock_temp_split[7] eq 'Hom')) {$hom_intronic++;}
			if (($stock_temp_split[2] eq 'Intergenic') and ($stock_temp_split[7] eq 'Hom')) {$hom_intergenic++;}
					
			if (($stock_temp_split[4] eq 'Replacement') and ($stock_temp_split[7] eq 'Het')) {$het_replacement++;}
			if (($stock_temp_split[4] eq 'Silent') and ($stock_temp_split[7] eq 'Het')) {$het_silent++;}
			if (($stock_temp_split[2] eq 'UTR') and ($stock_temp_split[7] eq 'Het')) {$het_utr++;}
			if (($stock_temp_split[2] eq 'Intronic') and ($stock_temp_split[7] eq 'Het')) {$het_intronic++;}
			if (($stock_temp_split[2] eq 'Intergenic') and ($stock_temp_split[7] eq 'Het')) {$het_intergenic++;}
			}
	}
	close IN_FILE;
	print OUTFILE_0 "In Stock 2, not Stock 1 and not dbSNP\t$_[1]\t$hom_replacement\t$hom_silent\t$hom_utr\t$hom_intronic\t$hom_intergenic\t$het_replacement\t$het_silent\t$het_utr\t$het_intronic\t$het_intergenic\n";
	#Reset variables
	@stock_temp_split = "";
	@mutant_split = "";
	$mutant_file_nmbr = 0;
	$hom_replacement = 0;
	$hom_silent = 0;
	$hom_utr = 0;
	$hom_intronic = 0;
	$hom_intergenic = 0;
	$het_replacement = 0;
	$het_silent = 0;
	$het_utr = 0;
	$het_intronic = 0;
	$het_intergenic = 0;
	
	####################################################################################################
	# Variant homozygous in mutant line, found in Stock 1 and Stock 2, not in dbSNP
	####################################################################################################
	open (IN_FILE, "<", "$mutant_file[0]") or die "Cannot open IN_FILE filehandle in subroutine Count_Stocks, stock files 1 and 2, to read file";
	while (<IN_FILE>) {
		chomp $_;
		if (/^Chromosome/) {next;}
		@mutant_split = split('\t', $_);
		if ($mutant_split[6] =~ /^rs/) {next;}		# Test to see if there is a dbSNP ID, if so move to next line
		# $mutant_split[1] = Position
		# $mutant_split[2] = Region
		# $mutant_split[4] = VarType
		# $mutant_split[6] = dbSNP ID
		# $mutant_split[7] = Genotype
		if (((exists $stock_one_hash{"$mutant_split[1]"}) and (exists $stock_two_hash{"$mutant_split[1]"})) and ($mutant_split[7] eq "Hom")) {
			#print "Found a match with both stocks 1 and 2.\n";
			#print "Match is $mutant_split[1]\n";
			if ($mutant_split[1] == 141450093) {print "Found the last value 141450093 - $mutant_split[1]\n";}
			
			@stock_temp_split = @mutant_split;
			#@stock_temp_split = split('\t', $stock_one_hash{"$mutant_split[1]"});
			
			if ($mutant_split[1] == 141450093) {print "$stock_temp_split[1]\t$stock_temp_split[4]\t$stock_temp_split[7]\t$stock_temp_split[2]\n";}
			# Why is this genotype showing as het? This is not right 141450093
			
			#print "$stock_temp_split[1]\t$stock_temp_split[4]\t$stock_temp_split[7]\t$stock_temp_split[2]\n";
			if (($stock_temp_split[4] eq 'Replacement') and ($stock_temp_split[7] eq 'Hom')) {
			print "Made it into the replacement counting loop\n";
			print "$stock_temp_split[1]\t$stock_temp_split[4]\t$stock_temp_split[7]\t$stock_temp_split[2]\n";
			$hom_replacement++;}
			if (($stock_temp_split[4] eq 'Silent') and ($stock_temp_split[7] eq 'Hom')) {$hom_silent++;}
			if (($stock_temp_split[2] eq 'UTR') and ($stock_temp_split[7] eq 'Hom')) {$hom_utr++;}
			if (($stock_temp_split[2] eq 'Intronic') and ($stock_temp_split[7] eq 'Hom')) {$hom_intronic++;}
			if (($stock_temp_split[2] eq 'Intergenic') and ($stock_temp_split[7] eq 'Hom')) {$hom_intergenic++;}
			
			if (($stock_temp_split[4] eq 'Replacement') and ($stock_temp_split[7] eq 'Het')) {$het_replacement++;}
			if (($stock_temp_split[4] eq 'Silent') and ($stock_temp_split[7] eq 'Het')) {$het_silent++;}
			if (($stock_temp_split[2] eq 'UTR') and ($stock_temp_split[7] eq 'Het')) {$het_utr++;}
			if (($stock_temp_split[2] eq 'Intronic') and ($stock_temp_split[7] eq 'Het')) {$het_intronic++;}
			if (($stock_temp_split[2] eq 'Intergenic') and ($stock_temp_split[7] eq 'Het')) {$het_intergenic++;}
			
			}
	}
	close IN_FILE;
	print OUTFILE_0 "In Stock 1 and 2, but not dbSNP\t$_[1]\t$hom_replacement\t$hom_silent\t$hom_utr\t$hom_intronic\t$hom_intergenic\t$het_replacement\t$het_silent\t$het_utr\t$het_intronic\t$het_intergenic\n";
	#Reset variables
	@stock_temp_split = "";
	@mutant_split = "";
	$mutant_file_nmbr = 0;
	$hom_replacement = 0;
	$hom_silent = 0;
	$hom_utr = 0;
	$hom_intronic = 0;
	$hom_intergenic = 0;
	$het_replacement = 0;
	$het_silent = 0;
	$het_utr = 0;
	$het_intronic = 0;
	$het_intergenic = 0;
	
	####################################################################################################
	# Variant homozygous in mutant line, not found in Stock 1, Stock 2, or dbSNP
	####################################################################################################
	open (IN_FILE, "<", "$mutant_file[0]") or die "Cannot open IN_FILE filehandle in subroutine Count_Stocks, stock files 1 and 2, to read file";
	while (<IN_FILE>) {
		chomp $_;
		if (/^Chromosome/) {next;}
		@mutant_split = split('\t', $_);
		if ($mutant_split[6] =~ /^rs/) {next;}			# Test to see if there is a dbSNP ID, if so move to next line
		# $mutant_split[1] = Position
		# $mutant_split[2] = Region
		# $mutant_split[4] = VarType
		# $mutant_split[6] = dbSNP ID
		# $mutant_split[7] = Genotype
		
		if ($mutant_split[7] eq "Hom") {
			# Remove all variants already in dbSNP, Stock 1, Stock 2
			if ((exists $stock_one_hash{"$mutant_split[1]"}) and (exists $stock_two_hash{"$mutant_split[1]"})) {next;}
			if ((exists $stock_one_hash{"$mutant_split[1]"}) and ($mutant_split[7] eq "Hom")) {next;}
			if ((exists $stock_two_hash{"$mutant_split[1]"}) and ($mutant_split[7] eq "Hom")) {next;}
			# Print candidates to Outfile_7
			print OUTFILE_7 "$_\n";
		}
	}
	close IN_FILE;
	#Reset variables
	@stock_temp_split = "";
	@mutant_split = "";
	@mutant_file = "";
	$mutant_file_nmbr = 0;
	$hom_replacement = 0;
	$hom_silent = 0;
	$hom_utr = 0;
	$hom_intronic = 0;
	$hom_intergenic = 0;
	$het_replacement = 0;
	$het_silent = 0;
	$het_utr = 0;
	$het_intronic = 0;
	$het_intergenic = 0;
	
}

