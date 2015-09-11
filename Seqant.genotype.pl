#!/usr/bin/perl
#
# Name: Seqant.genotype.pl
# Version: 1.0
# Date: 8/31/2011
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
@het_one_file, $het_one_file_nmbr, @het_one_split, %het_one_hash, @het_one_temp_split, $het_one_Hom, $het_one_Het, $het_one_missing,
@het_two_file, $het_two_file_nmbr, @het_two_split, %het_two_hash, @het_two_temp_split, $het_two_Hom, $het_two_Het, $het_two_missing);

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
$het_one_Het = 0;
$het_one_Hom = 0;
$het_two_Het = 0;
$het_two_Hom = 0;
$het_one_missing = 0;
$het_two_missing = 0;

####################################################################################################
# Use the directory named Counts
# Read in the candidates from the *.candidates.remove.polymorphic.txt file (already screened for dbSNP and stocks)
# Report genotypes in parents for each homozygous variant in the file above
#
#
####################################################################################################


# Perform directory functions
####################################################################################################
# Test if user included directory name when starting program
if(@ARGV != 1)
{
	die "\n Usage: Seqant.genotype.pl <target directory> \n";
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
open (OUTFILE_0, ">", ("$ARGV[0]" . '.candidates.check.genotypes.txt'));

print OUTFILE_0 "Listing of homozygous mutation candidates obtained by eliminating variants found in dbSNP, Stock 1, or Stock 2\n\n";
print OUTFILE_0 "File\tChromosome\tPosition\tRegion\tGene\tVarType\tCommon_to\tdbSNP ID\tGenotype\n";

Check_Genotypes($dataPath, $file_names[1], $file_names[2]);

close (OUTFILE_0);
print "Completed Seqant.genotype.pl script\n";

####################################################################################################
####################################################################################################
### Subroutines
####################################################################################################
####################################################################################################

####################################################################################################
# Check_Genotypes
# $_[0] = $dataPath - main directory containing SeqAnt files
# $_[1] = $file_names[1] - name of het file being processed
# $_[2] = $file_names[2] - name of het file being processed
####################################################################################################
sub Check_Genotypes {
	print "Subroutine Check_Genotypes\n\n";
	print "Entered the Check_Genotypes subroutine with arguments: $_[0] , $_[1], $_[2]\n\n";
	chdir "$_[0]/Samples/";
	
	@het_one_file = glob "$_[1]" || print "Stock one line file not found\n";
	$het_one_file_nmbr = ($#het_one_file + 1);
	@het_two_file = glob "$_[2]" || print "Stock one line file not found\n";
	$het_two_file_nmbr = ($#het_two_file + 1);
	#print "Name of globbed files are: $het_one_file[0], $het_two_file[0]\n";

	# Make hash for rapid search of @het_one_fie
	open (IN_FILE_HASH, "<", "$het_one_file[0]") or die "Cannot open IN_FILE_HASH filehandle for het one file in subroutine Count_Stocks";
	while (<IN_FILE_HASH>) {
		chomp $_;
		if (/^Chromosome/) {next;}											#Skip header line
		@het_one_split = split('\t', $_);
		if ($het_one_split[6] =~ /^rs/) {next;}							# Test to see if there is a dbSNP ID, if so move to next line
		$het_one_hash{$het_one_split[1]} = $_;							# Make hash for stock_one key position, contains line of info
	}
	
	# Make hash for rapid search of @het_two_file
	open (IN_FILE_HASH, "<", "$het_two_file[0]") or die "Cannot open IN_FILE_HASH filehandle for het one file in subroutine Count_hets";
	while (<IN_FILE_HASH>) {
		chomp $_;
		if (/^Chromosome/) {next;}											#Skip header line
		@het_two_split = split('\t', $_);
		if ($het_two_split[6] =~ /^rs/) {next;}															# Test to see if there is a dbSNP ID, if so move to next line
		$het_two_hash{$het_two_split[1]} = $_;															# Make hash for het_two key position, contains line of info
	}
	
	chdir "$_[0]/Counts/";
	@mutant_file = glob "*.candidates.remove.polymorphic.txt" || die "Cannot find hom mutant candidates file. Exiting.";
	open (IN_FILE, "<", "$mutant_file[0]") or die "Cannot open IN_FILE filehandle in subroutine Check_Genotypes to read file";
	while (<IN_FILE>) {
		chomp $_;
		if (/^Listing/) {next;}
		if (/^Chromosome/) {next;}
		print OUTFILE_0 "Mutant\t$_\n";
		@mutant_split = split('\t', $_);
		####################################################################################################
		# Variant homozygous in mutant line, not found in Stock 1, Stock 2, or dbSNP
		# $mutant_split[1] = Position
		# $mutant_split[2] = Region
		# $mutant_split[4] = VarType
		# $mutant_split[6] = dbSNP ID
		# $mutant_split[7] = Genotype
		# For a mutant genotype, get the genotypes from het_one and het_two
		####################################################################################################
		if (exists $het_one_hash{"$mutant_split[1]"}) {
			@het_one_temp_split = split('\t', $het_one_hash{"$mutant_split[1]"});
			print OUTFILE_0 "Het 1\t\t$het_one_temp_split[1]\t$het_one_temp_split[2]\t$het_one_temp_split[3]\t$het_one_temp_split[4]\t$het_one_temp_split[5]\t$het_one_temp_split[6]\t$het_one_temp_split[7]\n";
			if ($het_one_temp_split[7] eq 'Het') {$het_one_Het++;}
			if ($het_one_temp_split[7] eq 'Hom') {$het_one_Hom++;}
			@het_one_temp_split = "";
		} else {
			print OUTFILE_0 "Variant site not found in het one file\n";
			$het_one_missing++;
			@het_one_temp_split = "";
		}

		if (exists $het_two_hash{"$mutant_split[1]"}) {
			@het_two_temp_split = split('\t', $het_two_hash{"$mutant_split[1]"});
			print OUTFILE_0 "Het 2\t\t$het_two_temp_split[1]\t$het_two_temp_split[2]\t$het_two_temp_split[3]\t$het_two_temp_split[4]\t$het_two_temp_split[5]\t$het_two_temp_split[6]\t$het_two_temp_split[7]\n\n";
			if ($het_two_temp_split[7] eq 'Het') {$het_two_Het++;}
			if ($het_two_temp_split[7] eq 'Hom') {$het_two_Hom++;}
			@het_two_temp_split = "";
		} else {
			print OUTFILE_0 "Variant site not found in het two file\n\n";
			$het_two_missing++;
			@het_two_temp_split = "";
		}
	}
	# Output Summary Statistics
	print OUTFILE_0 "\n\nSummary Statistics\n";
	print OUTFILE_0 "File\tHet calls\tHom calls\tMissing Data\n";
	print OUTFILE_0 "Het One\t$het_one_Het\t$het_one_Hom\t$het_one_missing\n";
	print OUTFILE_0 "Het Two\t$het_two_Het\t$het_two_Hom\t$het_two_missing\n";
}

