#!/usr/bin/perl -w
# Version 1.0
# Michael E. Zwick
# 06/28/05
# Program designed to:
# 1. Run over multiple folders (multi) containing fasta sequences,annotation # files (.genpos.txt, 
# .msg.txt, .coding.txt), and *.popgen.* files
# 2. 
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use strict;
use Cwd;
#-------------------------------------------------------------------------------
# Local variable definitions
#-------------------------------------------------------------------------------
# Define local variables

my(@data_directories, $data_dir_number, @popgen_file, $popgen_file_number, @genpos_file, $genpos_file_number, @message_file, $message_file_number, @coding_file, $coding_file_number, @ref_file, $ref_file_number, $oligo_size, $oligo_sequence, $position, $oligo_temp);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables

#-------------------------------------------------------------------------------
# Program Overview:
# Start in a folder containing a set of folders, each with data from a single 
# genomic region
# Glob the names of all the directories
# Descend into the first directory
# Read in the name of the correct popgen file
# Pull out the information about theta estimates
#-------------------------------------------------------------------------------

# Open for output of log files
open(OUT_LOG, ">", "log.theta_multi.popgen.out")
	or die "Cannot open OUT_FASTA for data output";

# Open for output of theta information
open(OUT_POPGEN_OUT,">>","/Users/michaelzwick/Desktop/Final_Analysis_Autosome/theta.autosome.popgen.out")
	or die "Cannot open theta.popgen.out for data output";

# Obtain names of all folders containing data files
@data_directories = glob("[0-9]*");
$data_dir_number = ($#data_directories + 1);
if ($data_dir_number == 0) {
	die "$data_dir_number data directories detected.\n
	Check directory. Exiting program";
}
print OUT_LOG "Detected $data_dir_number data folders\n\n";

# Loop over each of the data directories
foreach my $folders (@data_directories) {

	print OUT_LOG "The directory name is $folders\n";
	# Change to data folder
	chdir("$folders");
		
	# Obtain name of numbered .fasta sequence files
	@popgen_file = glob("*.popgen.txt");
	$popgen_file_number = ($#popgen_file + 1);
	if ($popgen_file_number == 0) {
		die "$popgen_file_number sequence files detected.\n
			Check directory. Exiting program";
	}
	print OUT_LOG "Detected $popgen_file_number popgen files\n";
	print OUT_LOG "\n";
	
	# Open popgen file to be read
	open (IN_ANNOT, "<", "$popgen_file[0]")
		or die "Cannot open IN_ANNOT filehandle to read file";

	# Output genome region name
	print OUT_POPGEN_OUT "$folders\n";
	
	while(<IN_ANNOT>) {
		
		chomp($_);
		
		# Collect and output theta data
		if ($_ =~ /^Total Region All Sites	My way Theta_w/) {
			print OUT_POPGEN_OUT "$_\n";
		}
		if ($_ =~ /^UTR All Sites	My way Theta_w/) {
			print OUT_POPGEN_OUT "$_\n";
		}
		if ($_ =~ /^Silent All Sites	My way Theta_w/) {
			print OUT_POPGEN_OUT "$_\n";
		}
		if ($_ =~ /^Replacement All Sites	My way Theta_w/) {
			print OUT_POPGEN_OUT "$_\n";
		}
		if ($_ =~ /^Introns All Sites	My way Theta_w/) {
			print OUT_POPGEN_OUT "$_\n";
		}
		if ($_ =~ /^Intergenic All Sites	My way Theta_w/) {
			print OUT_POPGEN_OUT "$_\n";
		}
	# Return back to starting directory
	}
	print OUT_POPGEN_OUT "\n";
	print OUT_LOG "Leaving file $popgen_file[0]\n\n";
	chdir "../";
}

close(OUT_POPGEN_OUT);
close(OUT_LOG);
print "Completed theta_multi_popgen_ver1.1.pl program.\n";
