#!/usr/bin/perl
#
# Name: RA_output_selected_multifasta.pl
# Version: 1.0
# Date: 8/31/2007
# Author: Michael E. Zwick
#--------------------------------------------------------------------------------------------
# 1. The purpose of this script is to output a subsample of fasta formated sequences from a multi-fasta file
#--------------------------------------------------------------------------------------------
use warnings;
use strict;
use Cwd;

my ($dirname, $version, $temp_seq,  @files, @filess, @fasta_files, @fasta_labels, @temp_label, @temp_seq, %fasta_info, @fasta_labelss, $count, $get_fasta_seq, %chip_strain);

# Initialize variables
$version = "1.0";
$dirname = ".";
$temp_seq = "";
@temp_label = ();
$count = 0;
$get_fasta_seq = "NO";

# Populate the %chip_strain hash with fasta labels that you want to select
%chip_strain = (
'>BAN_001' => '>BAN_001',
'>BAN_002' => '>BAN_002',
'>BAN_003' => '>BAN_003',
'>BAN_004' => '>BAN_004',
'>BCE_002' => '>BCE_002',
'>BCE_003' => '>BCE_003',
'>BCE_004' => '>BCE_004',
'>BCE_005' => '>BCE_005',
'>BCE_006' => '>BCE_006',
'>BCE_007' => '>BCE_007',
'>BCE_013' => '>BCE_013',
'>BCE_014' => '>BCE_014',
'>BCE_016' => '>BCE_016',
'>BCE_017' => '>BCE_017',
'>BCE_018' => '>BCE_018',
'>BCE_019' => '>BCE_019',
'>BCE_022' => '>BCE_022',
'>BCE_023' => '>BCE_023',
'>BCE_025' => '>BCE_025',
'>BCE_026' => '>BCE_026',
'>BTU_004' => '>BTU_004',
);


# Change to directory entered by user when calling the program
#--------------------------------------------------------------------------------------------
chdir $ARGV[0] or die "Cannot change to directory $ARGV[0]\n";

# Remove old sort files
system ("rm *.selected.txt");

# Collect the names of all the fasta files in a directory
@fasta_files = glob("*fasta.out.txt");

foreach my $process_file (@fasta_files) {

	print "Processing fasta file: $process_file\n";

	open(FILEHANDLE_FIRST, $process_file)
		or die "Cannot open FILEHANDLE_FIRST - for fasta files";

	# Output fasta labels
	open(OUT_FASTA_SEQUENCES, ">", "$process_file" . '.selected.txt')
		or die "Cannot open OUT_FASTA_SEQUENCES for sequence output";

	while (<FILEHANDLE_FIRST>) {
		chomp($_);
		
		if ($get_fasta_seq eq "YES") {
		print OUT_FASTA_SEQUENCES "$_\n";
		$get_fasta_seq = "NO"; # Set output indicator to no
		}
		
		if($_ =~ />/) {
		# Check to see if hash contains key. If so, process fasta sequence
		if (exists $chip_strain{$_}) {
			print OUT_FASTA_SEQUENCES "$_\n"; # Output fasta label
			$get_fasta_seq = "YES"; # Set out indicator to yes
			
		# Output label
		# Output DNA sequence (next line)
		# Read next label
		}
		else {
		next;
		}
		}
	}
}
close (FILEHANDLE_FIRST);
close (OUT_FASTA_SEQUENCES);
print "Completed RA_output_selected_multifasta.pl version $version script\n";