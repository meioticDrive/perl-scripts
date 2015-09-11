#!/usr/bin/perl
#
# Name: RA_output_multifasta_label.pl
# Version: 1.0
# Date: 03/16/2007
# Author: Michael E. Zwick
#--------------------------------------------------------------------------------------------
# 1. The purpose of this script is to obtain the fasta labels from an multifasta file
# and output them into a single file. They are output in the order that they are read in by the file
#
#--------------------------------------------------------------------------------------------
use warnings;
use strict;
use Cwd;

my ($dirname, $version, $temp_seq,  @files, @filess, @fasta_files, @fasta_labels, @temp_label, @temp_seq, %fasta_info, @fasta_labelss, $count);

# Initialize variables
$version = "1.0";
$dirname = ".";
$temp_seq = "";
@temp_label = ();
$count = 0;

# Change to directory entered by user when calling the program
#--------------------------------------------------------------------------------------------
chdir $ARGV[0] or die "Cannot change to directory $ARGV[0]\n";

# Remove old sort files
system ("rm *.labels.txt");

# Collect the names of all the fasta files in a directory
# Need to add code to address if this fails
@fasta_files = glob("*.popgen.fasta");

foreach my $process_file (@fasta_files) {

	print "Processing fasta file: $process_file\n";

	open(FILEHANDLE_FIRST, $process_file)
		or die "Cannot open FILEHANDLE_FIRST - for fasta files";

	# Output fasta labels
	open(OUT_FASTA_SEQUENCES, ">", "$process_file" . '.labels.txt')
		or die "Cannot open OUT_FASTA_SEQUENCES for sequence output";

	while (<FILEHANDLE_FIRST>) {
		chomp($_);
		
		if($_ =~ />/) {
			
			print OUT_FASTA_SEQUENCES "$_\n";
		}
		else {
		next;
		}
	}
	close (FILEHANDLE_FIRST);
	close (OUT_FASTA_SEQUENCES);
}

print "Completed RA_output_multifasta_label.pl version $version script\n";