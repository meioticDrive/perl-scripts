#!/usr/bin/perl
#
# Name: RA.screen.SNPs.pl
# Version: 1.0
# Date: 09/23/2010
# Author: Michael E. Zwick
##############################################################################################
# 1. The purpose of this script is to screen SNP output files from the popgen program. And
# output only those SNPs exceeding a user defined threshold (count) in gff format. Wrote this
# quickly to deal with B. anthracis RA SNP calls.
# 2. Execute this program by calling directory containing files.
# 3. Thresholds examined for this paper
# 39 samples - set threshold as number of N's
# 95% = 2 N's
# 90% = 4 N's
# 85% = 6 N's
# 80% = 8 N's
##############################################################################################
use warnings;
use strict;
use Cwd;

my ($dirname, $version, @fields, @files, @snp_files, $fields_number, $nmbr_nocalls,
$i, $user_threshold, $user_level);

# Initialize variables
$version = "1.0";
$nmbr_nocalls = 0;

##User Set Threshold here!!
$user_threshold = 2;
$user_level = "95";

# Change to directory entered by user when calling the program
##############################################################################################
chdir $ARGV[0] or die "Cannot change to directory $ARGV[0]\n";

# Remove old sort files
system ("rm *.SNPs.txt");
system ("rm *.SNPs.gff");

# Collect the name of SNP file in directory
# Need to add code to address if this fails
@snp_files = glob("*.SNPs.unmask.txt");

foreach my $process_file (@snp_files) {
	
	print "Processing SNP file: $process_file\n";
	
	open(FILEHANDLE_FIRST, $process_file)
		or die "Cannot open FILEHANDLE_FIRST - to read SNP file!";
	
	# Output good screened SNP file
	open(OUT_SCREENED_SNPS, ">", "$process_file" . ".$user_level" . '.screen.good.SNPs.txt')
		or die "Cannot open OUT_SCREENED_SNPS for sequence output";
	
		# Output good screened SNP file
	open(OUT_REJECTED_SNPS, ">", "$process_file" . ".$user_level" . '.screen.bad.SNPs.txt')
		or die "Cannot open OUT_SCREENED_SNPS for sequence output";
	
	# Output SNP .gff file
	open(OUT_SCREENED_SNPS_GFF, ">", "$process_file" . ".$user_level" . '.screen.SNPs.gff')
		or die "Cannot open OUT_SCREENED_SNPS_GFF for sequence output";
		
	# Process SNP file
	while (<FILEHANDLE_FIRST>) {
		chomp($_);
		
		# Split line of SNPdata
		@fields = split /\t/, $_;
		$fields_number = ($#fields + 1);
    
    # Count number of N's for a single SNP
    for($i = 4; $i < $fields_number; $i++) {
      if ($fields[$i] eq "N") {
        $nmbr_nocalls = $nmbr_nocalls + 1;
      } else {
        next;
        }
    }
    # Debug code
    print "The number of nocalls for SNP $fields[0] $fields[2] is $nmbr_nocalls\n";
    print "User threshold is $user_threshold\n";
    
    # Determine numbr_calls is less than user-defined threshold
    if ($nmbr_nocalls < $user_threshold) {
      
      # Print SNP to SNP file
      print OUT_SCREENED_SNPS "$_";
      print OUT_SCREENED_SNPS "\n";
      $nmbr_nocalls = 0;
      next;
    } else {
      
      # Print to Bad SNPs file
      print OUT_REJECTED_SNPS "$_";
      print OUT_REJECTED_SNPS "\n";
      
      # Print to GFF File - bad SNPs
      # Use this file to screen SNPs in fasta files
      print OUT_SCREENED_SNPS_GFF "Screen_SNP\t". "$fields[0]\t" . "repeat_region\t" . "$fields[2]\t" . "$fields[2]\t" . ".\t" . ".\t" . ".\t" ."repeat_region";
      print OUT_SCREENED_SNPS_GFF "\n";
      
      $nmbr_nocalls = 0;
      next;
      }
  }
		
		
		# If yes, then do not output and move to next line
		# If no, then output line to OUT_SCREENED_SNPS and OUT_SCREENED_SNPS_GFF

	close (FILEHANDLE_FIRST);
	close (OUT_SCREENED_SNPS);
	close (OUT_SCREENED_SNPS_GFF);
}
print "Completed RA.screen.SNPs.pl version $version script\n";