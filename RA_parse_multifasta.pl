#!/usr/bin/perl
#
# Name: RA_parse_multifasta.pl
# Version: 1.0
# Date: 10/18/2007
# Author: Michael E. Zwick
#--------------------------------------------------------------------------------------------
# 1. The purpose of this script is to copy fasta fragments in a multi-fasta file to a new file
# that contains the same fragment from multiple individuals. 
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
system ("rm *.sort.fasta");

# Collect the names of all the fasta files in a directory
#@fasta_files = glob("*.fasta");
@fasta_files = glob("*.final.fasta");

foreach my $process_file (@fasta_files) {

	print "Processing fasta file: $process_file\n";

	open(FILEHANDLE_FIRST, $process_file)
		or die "Cannot open FILEHANDLE_FIRST - for fasta files";

	while (<FILEHANDLE_FIRST>) {
		chomp($_);
		
		if($_ =~ />/) {
			
			if($count > 0) {
				# Make hash relating fasta label with sequence (from previous loop through)
				$fasta_info{$temp_label[0]} = $temp_seq;
			}
			
			# Reset variables
			$temp_seq = "";
			@temp_label = ();
			$count++;
			
			# Push fasta label onto temporary array
			push (@temp_label, $_);
			
			# Use array fasta_labels later to sort
			push (@fasta_labels, $_);
		}
		else {
		
		# Read DNA sequence into string
		$temp_seq .= $_;
		
		}
	}
	
	# Process last fragment to hash
	$fasta_info{$temp_label[0]} = $temp_seq;
	
	# Output sorted files
	open(OUT_FASTA_SEQUENCES, ">", "$process_file" . '.sort.fasta')
		or die "Cannot open OUT_FASTA_SEQUENCES for sequence output";
	
	# Sort fasta labels
	@fasta_labelss = sort(@fasta_labels);
	
	# Print out all fasta segments in order, get sequence from hash
	foreach my $sorted_labels (@fasta_labelss) {
		print OUT_FASTA_SEQUENCES "$sorted_labels\n";
		print OUT_FASTA_SEQUENCES "$fasta_info{$sorted_labels}\n";
		#print "$sorted_labels\n";
		#print "$fasta_info{$sorted_labels}\n";
	}
	# Prepare to process next file - reset variables, hash
	%fasta_info = ();
	$temp_seq = "";
	@temp_label = ();
	@fasta_labels = ();
	@fasta_labelss = ();
	$count = 0;
	close (FILEHANDLE_FIRST);
	close (OUT_FASTA_SEQUENCES);
}

print "Completed RA_sort_multifasta.pl version $version script\n";