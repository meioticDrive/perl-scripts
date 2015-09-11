#!/usr/bin/perl
##############################################################################
### Name: RA_count_multifasta_multi.pl
### Version: 1.1
### Date: 04/09/2007
### Author: Michael E. Zwick
##############################################################################
### 1. The purpose of this script is to count all the called and uncalled 
### bases in a multifasta file.
### 2. Run the program from the directory above - requires the name of the
### target directory.
##############################################################################
use warnings;
use strict;
use Cwd;

my ($dirname, $version, $temp_seq,  @files, @filess, @fasta_files, @fasta_labels, $temp_label, @temp_seq, %fasta_info, @fasta_labelss, $count, @seq_count, $count_A, $count_N, $total_seq, $total_called);

my $total_all_fasta_seq = 0;
my $total_all_fasta_called = 0;

# Initialize variables
$version = "1.0";
$dirname = ".";
$temp_seq = "";
$temp_label = "";
$count = 0;
$count_A = 0;
$count_N = 0;

# Change to directory entered by user when calling the program
##############################################################################
chdir $ARGV[0] or die "Cannot change to directory $ARGV[0]\n";

# Remove old sort files
system ("rm *.count.multifasta.txt");

# Output sorted files
open(OUT_FASTA_SEQUENCES, ">", 'RA_count.multifasta.txt')
	or die "Cannot open OUT_FASTA_SEQUENCES for sequence output";

# Collect the names of all the fasta files in a directory
# @fasta_files = glob("*.popgen.fasta");
@fasta_files = glob("*.fasta");

# Add code to check to see if any files are found

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
				    # Called Bases
					if ($base_call =~ m/A|C|G|T|K|M|R|S|W|Y/) {$count_A++};
					if ($base_call =~ m/N/) {$count_N++};
				}
				# Determine total sequence
				$total_seq = ($count_A + $count_N);
				$total_called = $count_A;
                # Determine total sequence for single fasta file
                $total_all_fasta_seq = $total_all_fasta_seq + $total_seq;
                $total_all_fasta_called = $total_all_fasta_called + $total_called;
				#Output Data
				print OUT_FASTA_SEQUENCES "$temp_label\t $total_called\t $total_seq\t" . $total_called/$total_seq . "\n";
				
				# Reset variables
				@seq_count = ();
				$temp_seq = "";
				$count_A = 0;
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
    if ($base_call =~ m/A|C|G|T|K|M|R|S|W|Y/) {$count_A++};
    if ($base_call =~ m/N/) {$count_N++};
}
# Determine total sequence for single fragment
$total_seq = ($count_A + $count_N);
$total_called = $count_A;

# Determine total sequence for single fasta file
$total_all_fasta_seq = $total_all_fasta_seq + $total_seq;
$total_all_fasta_called = $total_all_fasta_called + $total_called;

#Output data for last fasta fragment
print OUT_FASTA_SEQUENCES "$temp_label\t $total_called\t $total_seq\t" . $total_called/$total_seq . "\n\n";

# Output summary data for file
print OUT_FASTA_SEQUENCES "$process_file\n";
print OUT_FASTA_SEQUENCES "Total\t";
print OUT_FASTA_SEQUENCES "$total_all_fasta_called\t$total_all_fasta_seq\t";
print OUT_FASTA_SEQUENCES $total_all_fasta_called/$total_all_fasta_seq;
print OUT_FASTA_SEQUENCES "\n\n\n";

close (FILEHANDLE_FIRST);

# Reset variables before processing next file
@seq_count = ();
$temp_seq = "";
$count_A = 0;
$count_N = 0;
$total_seq = 0;
$total_called = 0;
$count = 0;
$total_all_fasta_seq = 0;
$total_all_fasta_called = 0;
}

close (OUT_FASTA_SEQUENCES);
print "Completed RA_count_multifasta.pl version $version script\n";

























