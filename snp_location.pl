#!/usr/bin/perl -w
# Program designed to read names of all .DAT files (pass through multiple
# directories), place into a text file
# The directory structure assumed as follows:
# Chip_Design_Scanned_Chips[FOLDER]
#    Date[FOLDER]
#       .DAT[FILES]
#        EXP_Files[FOLDER]
# Program should:
# 1. Read the names of all Date[FOLDER]
# 2. For each Date[FOLDER], read the names of all .DAT[FILES]
# Populate hash relating SNP ref location with genetic element containing SNP?
# Need to diffferentiate between pxo1, pxo2, main_chromosome
# Better: Figure boundaries of SNPs (remember 20Ns)
# These numbers wrong - there were spaces in there
# pxo1 - 181,654 number of characters (range 0 <181,655)
# pxo2 - 96,231 number of characters (range 181,698  <277,929)
# Calculate pxo2 positions (- (20 + 181,677))
# main_chromosome - 5,227,293 nunmber of characters (range 
# How do I rapidly get SNP type from excel?
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use strict;

#-------------------------------------------------------------------------------
# Variable Definitions
#-------------------------------------------------------------------------------
my(@files, @snps_found, $file_number, @fasta_first, $file_first_lines, $fasta_first_seq, $file_first_size, $count, $i, $j, $snp_nmbr, @snp_pos, @ref_fasta, $snp_out_txt);

#-------------------------------------------------------------------------------
# Assign number of SNPs
# Assign name of SNP output file
# SNP Information from anthrax.popgen.xls file, from composite fasta files
# Clear old output file
#-------------------------------------------------------------------------------
$snp_nmbr = 37;
@snp_pos = qw(129567 132396 132398 132400 132436 132632 133691 133763 135261 230830 231160 232881 233325 233845 234679 235203 235375 235765 236255 4377582 4377773 4378229 4379182 4383141 382345 385885 386053 386104 386674 386909 387228  388076 789100 789687 790977 793036 793636);
#system("rm snps_fasta.txt");

#-------------------------------------------------------------------------------
# Read in anthrax ref file - containing Pxo1, Pxo2 and main chromosome
# Use split/join procedure to put into an array (remove whitespace)
# Translate coordinates between my file - and genbank files for pxo1, pxo2 and main chromosome
# Use hash of SNP id? location?
# Output array of sequence 100bp upstream and downstream of SNP
# Configure final file output in format required for Jacques
#-------------------------------------------------------------------------------

@files = glob("b_anthracis_comp.genomic.fasta");
$file_number = ($#files + 1);

#-------------------------------------------------------------------------------
# Make sure file exists
#-------------------------------------------------------------------------------
if ($file_number == 0) {
    die "Error! No ref.fasta file present. Check directory. Exiting program";
}
if ($file_number > 1) {
    die "Error! Too many ref.fasta files present. Check directory. Exiting program";
}

#-------------------------------------------------------------------------------
# FileHandle For Reading from ref.fasta file
# Read sequence by lines into array
#-------------------------------------------------------------------------------
open(FILEHANDLE_FIRST, "<", $files[0]) 
	|| die "Cannot open FILEHANDLE_FIRST";
@ref_fasta = <FILEHANDLE_FIRST>;
close(FILEHANDLE_FIRST);

#-------------------------------------------------------------------------------
# Determines file size (lines)
# Joins lines into a single scalar
# Removes spaces/returns - leaves just DNA sequence
# Puts string back into array
# Calculates size of array
#-------------------------------------------------------------------------------
$file_first_lines = ($#ref_fasta + 1);
print "The size of the file, in lines is $file_first_lines\n";
$fasta_first_seq = join( '', @ref_fasta);
$fasta_first_seq =~ s/\s//g;
@ref_fasta = split( '', $fasta_first_seq);
$file_first_size = ($#ref_fasta + 1);
print "The size of the array is $file_first_size\n";

#-------------------------------------------------------------------------------
# Open Data Output Filehandles
#-------------------------------------------------------------------------------
open(FILEHANDLE_OUT_1, ">", "snps_fasta.txt") 
	|| die "Cannot open FILEHANDLE_OUT_1";
	
for($i = 0; $i < $snp_nmbr; $i++) {

	#---------------------------------------------------------------------------
	# pXO1 SNPs
	#---------------------------------------------------------------------------
	if($snp_pos[$i] < 181678) {
		print FILEHANDLE_OUT_1 ">SNP" . ($i + 1) . " " .
		($snp_pos[$i]) . "\n";
		#($snp_pos[$i] + 1) . "\n";
		# Get surrounding sequence
		#-----------------------------------------------------------------------
		for(my $j = 0; $j <41; $j++) {
			print FILEHANDLE_OUT_1 "$ref_fasta[($snp_pos[$i] - 20 + $j)]";
		}
		print FILEHANDLE_OUT_1 "\n";
	}
	
	#---------------------------------------------------------------------------
	# pXO2 SNPs
	#---------------------------------------------------------------------------
	if(($snp_pos[$i] >= 181678) && ($snp_pos[$i] < 277930)) {
		print FILEHANDLE_OUT_1 ">SNP" . ($i + 1) . " "
		. (($snp_pos[$i]) - (20+181654)) . "\n";
		#. (($snp_pos[$i] + 1) - (20+181654)) . "\n";
		# Get surrounding sequence
		#-----------------------------------------------------------------------
		for(my $j = 0; $j <41; $j++) {
			print FILEHANDLE_OUT_1 "$ref_fasta[($snp_pos[$i] - 20 + $j)]";
		}
		print FILEHANDLE_OUT_1 "\n";
	}
	
	#---------------------------------------------------------------------------
	# B. anthracic main SNPs
	#---------------------------------------------------------------------------
	if($snp_pos[$i] >= 277930) {
		print FILEHANDLE_OUT_1 ">SNP" . ($i + 1) . " "
		. (($snp_pos[$i]) - (181654 + 20 + 96231 + 20)) . "\n";
		#. (($snp_pos[$i] + 1) - (181654 + 20 + 96231 + 20)) . "\n";
		# Get surrounding sequence
		#-----------------------------------------------------------------------
		for(my $j = 0; $j <41; $j++) {
			print FILEHANDLE_OUT_1 "$ref_fasta[($snp_pos[$i] - 20 + $j)]";
		}
		print FILEHANDLE_OUT_1 "\n";
	}
}
close(FILEHANDLE_OUT_1);

#-------------------------------------------------------------------------------
# Read genomic.ref.fasta file into array @ref_fasta
# Use positions in array to output SNP positions
# Translate coordinates
#-------------------------------------------------------------------------------





print "Reached end of snp_location.pl script.\n";
