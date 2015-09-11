#!/usr/bin/perl -w
# Version 1.0
# Michael E. Zwick
# 05/13/2014
################################################################################
# PLINK_combineTDT-GWAS.pl
# This program is designed to combine the output from a PLINK TDT analysis of 
# trios with a PLINK GWAS analysis. Input files for this analysis are the \
# standard output files from PLINK. Here we assume that the complete list of 
# SNPs are identical and included in both the TDT and GWAS datasets.
# Structure of Program
# 1. Import TDT file into a hash. Use SNP ID as a key, value is line
# 2. Loop over lines in GWAS file, using only ADD association values.
# 3. Check if minor (A1) allele is identical in GWAS and TDT
	# if true, then determine of Odds Ratios are both >1 or <1
		# if true, then calculate combined p-value by Fisher's exact method
		# if false, then set combined P value to 1 (no evidence to reject null)
		# Output to files
		
	# if false, then determine if OR of GWAS and the TDT 1/OR are both >1 or <1
		# if true, then calculate combined p-value by Fisher's exact method
		# if false, then set combined P value to 1 (no evidence to reject null)
		# Output to file
# 4. Output values: Chromosome, SNP ID, position, GWAS p-values, TDT p-values, combined p-value
################################################################################
use strict;
use Cwd;
use Statistics::Distributions;

################################################################################
# Local variable definitions
################################################################################
# Define local variables
my(%tdt_output, @tdt_file, @gwas_file, $tdt_file_number, $gwas_file_number, @temp_line, $tdt_temp, @tdt_parse_temp, $ln_tdt, $ln_logistic, $chi, $chi_p, $logPscore);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables
%tdt_output = ();
@tdt_file = ();
@gwas_file = ();
@temp_line = ();
$tdt_temp = "";
@tdt_parse_temp = ();
$ln_tdt = 0;
$ln_logistic = 0;
$chi = 0;
$chi_p = 0;
$logPscore = 0;




################################################################################
# Main Program
################################################################################

# Remove old files
unlink("log.TDT-GWAS.txt");
unlink("gwas-tdt.txt");

# Open for output of log files
open(OUT_LOG, ">>", "log.TDT-GWAS.txt")
	or die "Cannot open OUT_LOG for TDT-GWAS output file";

# Open output file for complete association data
open (OUT_ANNOT, ">>", "gwas-tdt.txt")
	or die "Cannot open OUT_ANNOT filehandle to parsed output file info";

# Obtain TDT file name
@tdt_file = glob("*.tdt");
$tdt_file_number = ($#tdt_file + 1);
if (($tdt_file_number == 0) || ($tdt_file_number > 1)) {
	die "$tdt_file_number PLINK *.tdt files detected.\n
		Check directory. Exiting program";
}

# Obtain GWAS file name
@gwas_file = glob("*.assoc.logistic");
$gwas_file_number = ($#gwas_file + 1);
if (($gwas_file_number == 0) || ($gwas_file_number > 1)) {
	die "$gwas_file_number PLINK *.assoc.logistic files detected.\n
		Check directory. Exiting program";
}

# Process TDT data into %tdt_output hash
foreach my $tfiles (@tdt_file) {
	open (IN_TDT_DATA, "<", "$tfiles")
		or die "Cannot open IN_TDT_DATA filehandle to read tdt file";
	
	while (<IN_TDT_DATA>) {
		chomp $_;
		#print "$_\n";
		@temp_line = split(/\s+/, $_);
		if ($temp_line[1] eq "CHR") {next;}		 # Drop header line
		$tdt_output{"$temp_line[2]"} = "$_";		# Store lines into tdt hash
	}
}
print "Completed loading tdt data into hash\n";
print OUT_LOG "Completed loading tdt data into hash";
@temp_line = ();									# Reset @temp_line

# Output header row
print OUT_ANNOT 
"CHR\tSNP\tBP\tTDT_P\tLOGISTIC_P\tLN(TDT)\tLN(LOGISTIC)\tCHI\tCHI_P\t-10logP\n";

# Process GWAS data by matching with TDT data into %tdt_output hash
foreach my $gfiles (@gwas_file) {

	open (IN_GWAS_DATA, "<", "$gfiles")
		or die "Cannot open IN_TDT_DATA filehandle to read tdt file";

	while (<IN_GWAS_DATA>) {
		chomp $_;
		@temp_line = split(/\s+/, $_);
		
		if (($temp_line[5] eq "ADD") & ($temp_line[7] ne "NA")) {
			###########################################################
			# Logic for case where GWAS SNP is not in TDT hash
			# Only want SNPs included in both GWAS and TDT
			###########################################################
			if (exists $tdt_output{"$temp_line[2]"}) {
				# Process data from tdt hash
				$tdt_temp = $tdt_output{"$temp_line[2]"};	  # Line from tdt
				@tdt_parse_temp = split(/\s+/, $tdt_temp);
				
				###########################################################
				###########################################################
				# Logic for when minor alleles match
				###########################################################
				###########################################################
				
				if ("$temp_line[4]" eq "$tdt_parse_temp[4]") {
					#print "Minor alleles match\n"
					###########################################################
					# Minor alleles match and ORs match
					# Both ORs are >= 1.0 (option 1)
					###########################################################
					if (($temp_line[7] >= 1.0) && ($tdt_parse_temp[8] >= 1.0)) {
						#print "ORs match and are greater than 1\n";
						$ln_tdt = log($tdt_parse_temp[12]);
						$ln_logistic = log($temp_line[12]);
						$chi = -2 * ($ln_tdt + $ln_logistic);
						$chi_p = Statistics::Distributions::chisqrprob (4, $chi);
						$logPscore = (-1 * log10($chi_p));  # Calculate -1LogP
						print OUT_ANNOT "$temp_line[1]\t$temp_line[2]\t" .
						"$temp_line[3]\t$tdt_parse_temp[12]\t$temp_line[12]\t" .
						"$ln_tdt\t$ln_logistic\t$chi\t$chi_p\t$logPscore\n";
						
						#Reset variables
						$ln_tdt = 0;
						$ln_logistic = 0;
						$chi = 0;
						$chi_p = 0;
						$logPscore = 0;
					}
					###########################################################
					# Minor alleles match and ORs match
					# Both ORs are < 1.0 (option 2)
					###########################################################
					if (($temp_line[7] < 1.0) && ($tdt_parse_temp[8] < 1.0)) {
						#print "ORs match and are less than 1\n";
						$ln_tdt = log($tdt_parse_temp[12]);
						$ln_logistic = log($temp_line[12]);
						$chi = -2 * ($ln_tdt + $ln_logistic);
						$chi_p = Statistics::Distributions::chisqrprob (4, $chi);
						$logPscore = (-1 * log10($chi_p));  # Calculate -1LogP
						print OUT_ANNOT "$temp_line[1]\t$temp_line[2]\t" .
						"$temp_line[3]\t$tdt_parse_temp[12]\t$temp_line[12]\t" .
						"$ln_tdt\t$ln_logistic\t$chi\t$chi_p\t$logPscore\n";
						
						#Reset variables
						$ln_tdt = 0;
						$ln_logistic = 0;
						$chi = 0;
						$chi_p = 0;
						$logPscore = 0;
					}
					###########################################################
					# ORs do not match
					# Minor alleles match, but ORs do not match (option 1)
					###########################################################
					if (($temp_line[7] < 1.0) && ($tdt_parse_temp[8] >= 1.0)) {
						# print "ORs $temp_line[7], $tdt_parse_temp[8]" . 
						#"do not match. Set p value to 1\n";
						print OUT_ANNOT "$temp_line[1]\t$temp_line[2]\t" .
						"$temp_line[3]\t$tdt_parse_temp[12]\t$temp_line[12]\t" .
						"$ln_tdt\t$ln_logistic\t0.008\t1\t0\n";
					}
					###########################################################
					# ORs do not match
					# Minor alleles match, but ORs do not match (option 2)
					###########################################################
					if (($temp_line[7] >= 1.0) && ($tdt_parse_temp[8] < 1.0)) {
						#print "ORs - $temp_line[7], $tdt_parse_temp[8]" .
						#"do not match. Set p value to 1 \n";
						print OUT_ANNOT "$temp_line[1]\t$temp_line[2]\t" .
						"$temp_line[3]\t$tdt_parse_temp[12]\t$temp_line[12]\t" .
						"$ln_tdt\t$ln_logistic\t0.008\t1\t0\n";
					}
				}
				###########################################################
				###########################################################
				# Logic where minor alleles to not match
				###########################################################
				###########################################################
				
				if (("$temp_line[4]" ne "$tdt_parse_temp[4]") && ("$temp_line[4]" eq "$tdt_parse_temp[5]")) {
					#print "Minor alleles do not match." . 
					#"But same alleles are at locus.\n";
					
					###########################################################
					# Minor alleles do not match, ORs match
					# GWAS >= 1.0; TDT >= 1.0
					###########################################################
					if (($temp_line[7] >= 1.0) && ((1/ $tdt_parse_temp[8]) >= 1.0)) {
						#print "ORs are greater than 1\n";
						$ln_tdt = log($tdt_parse_temp[12]);
						$ln_logistic = log($temp_line[12]);
						$chi = -2 * ($ln_tdt + $ln_logistic);
						$chi_p = Statistics::Distributions::chisqrprob (4, $chi);
						$logPscore = (-1 * log10($chi_p));  # Calculate -1LogP
						print OUT_ANNOT "$temp_line[1]\t$temp_line[2]\t" .
						"$temp_line[3]\t$tdt_parse_temp[12]\t$temp_line[12]\t" .
						"$ln_tdt\t$ln_logistic\t$chi\t$chi_p\t$logPscore\n";
						
						#Reset variables
						$ln_tdt = 0;
						$ln_logistic = 0;
						$chi = 0;
						$chi_p = 0;
						$logPscore = 0;
					}
					
					###########################################################
					# Minor alleles do not match, ORs match
					# GWAS < 1.0; TDT < 1.0
					###########################################################
						if (($temp_line[7] < 1.0) && ((1 / $tdt_parse_temp[8]) < 1.0)) {
						#print "ORs match and are less than 1\n";
						$ln_tdt = log($tdt_parse_temp[12]);
						$ln_logistic = log($temp_line[12]);
						$chi = -2 * ($ln_tdt + $ln_logistic);
						$chi_p = Statistics::Distributions::chisqrprob (4, $chi);
						$logPscore = (-1 * log10($chi_p));  # Calculate -1LogP
						print OUT_ANNOT "$temp_line[1]\t$temp_line[2]\t" .
						"$temp_line[3]\t$tdt_parse_temp[12]\t$temp_line[12]\t" .
						"$ln_tdt\t$ln_logistic\t$chi\t$chi_p\t$logPscore\n";
						
						#Reset variables
						$ln_tdt = 0;
						$ln_logistic = 0;
						$chi = 0;
						$chi_p = 0;
						$logPscore = 0;
					}
					
					###########################################################
					# Minor alleles do not match, ORs do not match (option 1)
					# GWAS < 1.0; TDT >= 1.0
					###########################################################
						if (($temp_line[7] < 1.0) && ((1 / $tdt_parse_temp[8]) >= 1.0)) {
						# print "ORs $temp_line[7], $tdt_parse_temp[8]" . 
						#"do not match. Set p value to 1\n";
						print OUT_ANNOT "$temp_line[1]\t$temp_line[2]\t" .
						"$temp_line[3]\t$tdt_parse_temp[12]\t$temp_line[12]\t" .
						"$ln_tdt\t$ln_logistic\t0.008\t1\t0\n";
					}
					
					###########################################################
					# Minor alleles do not match, ORs do not match (option 2)
					# GWAS >= 1.0; TDT < 1.0
					###########################################################
					if (($temp_line[7] >= 1.0) && ((1 / $tdt_parse_temp[8]) < 1.0)) {
						#print "ORs - $temp_line[7], $tdt_parse_temp[8]" .
						#"do not match. Set p value to 1 \n";
						print OUT_ANNOT "$temp_line[1]\t$temp_line[2]\t" .
						"$temp_line[3]\t$tdt_parse_temp[12]\t$temp_line[12]\t" .
						"$ln_tdt\t$ln_logistic\t0.008\t1\t0\n";
					}
				}
				
				# Need to include case where alleles at locus do not match
				# Set probability to 1
					if (("$temp_line[4]" ne "$tdt_parse_temp[4]") && ("$temp_line[4]" ne "$tdt_parse_temp[5]")) {
					print "Bad locus identified!" . 
					"Different alleles locus in GWAS and TDT.\n";
					}
			}
		}
			#$logPscore = (-1 * log10($temp_line[12]));  # Calculate -1LogP
	}
}

print "Made to the end of PLINK_combineTDT-GWAS.pl\n";
print OUT_LOG "Made to the end of PLINK_combineTDT-GWAS.pl\n";


################################################################################
### Subroutines ###
################################################################################
# Calculates log10 of number passed via @_
sub log10 {
	my $n = shift;
	return log($n)/log(10);
	}