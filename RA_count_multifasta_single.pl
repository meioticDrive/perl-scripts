#!/usr/bin/perl
#
# Name: RA_count_multifasta_single.pl
# Version: 1.0
# Date: 04/09/2007
# Author: Michael E. Zwick
#--------------------------------------------------------------------------------------------
# 1. The purpose of this script is to count all the called and uncalled bases in a multifasta file
# obtained from a single individual. The file name is assumed to related to the identity of the 
# individual sample analyzed.
# 2. Run the program from the directory above - requires the name of the target directory.
#--------------------------------------------------------------------------------------------
use warnings;
use strict;
use Cwd;

my ($dirname, $version, $temp_seq,  @files, @filess, @fasta_files, @fasta_labels, $temp_label, @temp_seq, %fasta_info, @fasta_labelss, $count, @seq_count, $count_A, $count_C, $count_G, $count_T, $count_N, $total_seq, $total_called);

# Initialize variables
$version = "1.0";
$dirname = ".";
$temp_seq = "";
$temp_label = "";
$count = 0;

$count_A = 0;
$count_C = 0;
$count_G = 0;
$count_T = 0;
$count_N = 0;

# Change to directory entered by user when calling the program
#--------------------------------------------------------------------------------------------
chdir $ARGV[0] or die "Cannot change to directory $ARGV[0]\n";

# Remove old sort files
system ("rm *.count.multifasta.txt");

	# Output sorted files
	open(OUT_FASTA_SEQUENCES, ">", 'RA_count.multifasta.txt')
		or die "Cannot open OUT_FASTA_SEQUENCES for sequence output";

# Collect the names of all the fasta files in a directory
@fasta_files = glob("*.fasta");

foreach my $process_file (@fasta_files) {

	print "Processing fasta file: $process_file\n";
	print OUT_FASTA_SEQUENCES "$process_file\n";
	print OUT_FASTA_SEQUENCES "FASTA_ID\tBases Called\tTotal Bases\tPercent Bases Called\n";

	open(FILEHANDLE_FIRST, $process_file)
		or die "Cannot open FILEHANDLE_FIRST - for fasta files";

	while (<FILEHANDLE_FIRST>) {
		chomp($_);
		
		if($_ =~ />/) {
			if($count > 0) {
				# Count sequence in @seq_count
				@seq_count = split ('',$temp_seq);
				foreach my $base_call (@seq_count) {
					if ($base_call eq "A") {$count_A++};
					if ($base_call eq "C") {$count_C++};
					if ($base_call eq "G") {$count_G++};
					if ($base_call eq "T") {$count_T++};
					if ($base_call eq "N") {$count_N++};
				}
				# Determine total sequence
				$total_seq = ($count_A + $count_C + $count_G + $count_T + $count_N);
				$total_called = ($count_A + $count_C + $count_G + $count_T);
				
				#Output Data
				print OUT_FASTA_SEQUENCES "$temp_label\t $total_called\t $total_seq\t" . $total_called/$total_seq . "\n";
				
				# Reset variables
				@seq_count = ();
				$temp_seq = "";
				$count_A = 0;
				$count_C = 0;
				$count_G = 0;
				$count_T = 0;
				$count_N = 0;
				$total_seq = 0;
				$total_called = 0;
			}
			# Collect next fasta header
			$temp_label = $_;
			$count++;
		}
		else {
			# Read DNA sequence into string
			$temp_seq .= $_;
		}
	}
	
# Process last fragment
# Count sequence in @seq_count
@seq_count = split ('',$temp_seq);
foreach my $base_call (@seq_count) {
	if ($base_call eq "A") {$count_A++};
	if ($base_call eq "C") {$count_C++};
	if ($base_call eq "G") {$count_G++};
	if ($base_call eq "T") {$count_T++};
	if ($base_call eq "N") {$count_N++};
	}
# Determine total sequence
$total_seq = ($count_A + $count_C + $count_G + $count_T + $count_N);
$total_called = ($count_A + $count_C + $count_G + $count_T);

#Output Data
print OUT_FASTA_SEQUENCES "$temp_label\t $total_called\t $total_seq\t" . $total_called/$total_seq . "\n\n\n";
close (FILEHANDLE_FIRST);

# Reset variables before processing next file
@seq_count = ();
$temp_seq = "";
$count_A = 0;
$count_C = 0;
$count_G = 0;
$count_T = 0;
$count_N = 0;
$total_seq = 0;
$total_called = 0;
$count = 0;
}

close (OUT_FASTA_SEQUENCES);
print "Completed RA_count_multifasta.pl version $version script\n";

























