#!/usr/bin/perl
#
# Name: RA_select_subsample_multifasta.pl
# Version: 1.0
# Date: 12/18/2007
# Author: Michael E. Zwick
#--------------------------------------------------------------------------------------------
# 1. The purpose of this script is to obtain the fasta labels from an multifasta file
# and output them into a single file. They are output in the order that they are read in by the file
#
#--------------------------------------------------------------------------------------------
use warnings;
use strict;
use Cwd;

my ($dirname, $version, $temp_seq,  @files, @filess, @fasta_files, @fasta_labels, @temp_label, @temp_seq, %fasta_info, @fasta_labelss, $count, $temp_fasta_label, $temp_fasta_seq);

# Initialize variables
$version = "1.0";
$dirname = ".";
$temp_seq = "";
@temp_label = ();
$count = 0;
$temp_fasta_label = "";
$temp_fasta_seq = "";

# Create HASH table to change test for if fasta names exist later in code
#--------------------------------------------------------------------------------------------
my (%nameTable) = (	# initialized hash table
# Defining keys and value for renaming files
	">BAN_001" => ">BAN_001",
	">BAN_002" => ">BAN_002",
	">BAN_003" => ">BAN_003",
	">BAN_004" => ">BAN_004",
	">BCE_002" => ">BCE_002",
	">BCE_003" => ">BCE_003",
	">BCE_004" => ">BCE_004",
	">BCE_005" => ">BCE_005",
	">BCE_006" => ">BCE_006",
	">BCE_007" => ">BCE_007",
	">BCE_013" => ">BCE_013",
	">BCE_016" => ">BCE_016",
	">BCE_017" => ">BCE_017",
	">BCE_018" => ">BCE_018",
	">BCE_021" => ">BCE_021",
	">BCE_022" => ">BCE_022",
	">BCE_023" => ">BCE_023",
	">BCE_026" => ">BCE_026",
	">BTU_001" => ">BTU_001",
	">BTU_004" => ">BTU_004",
);

# Change to directory entered by user when calling the program
#--------------------------------------------------------------------------------------------
chdir $ARGV[0] or die "Cannot change to directory $ARGV[0]\n";

# Remove old sort files
system ("rm *.20Strains.txt");

# Collect the names of all the fasta files in a directory
@fasta_files = glob("*fasta.out.txt");

foreach my $process_file (@fasta_files) {

	print "Processing fasta file: $process_file\n";

	open(FILEHANDLE_FIRST, $process_file)
		or die "Cannot open FILEHANDLE_FIRST - for fasta files";

	# Output fasta labels
	open(OUT_FASTA_SEQUENCES, ">", "$process_file" . '.20Strains.txt')
		or die "Cannot open OUT_FASTA_SEQUENCES for sequence output";

	while (<FILEHANDLE_FIRST>) {
		
		chomp($_);
		
		if($_ =~ />/) {
			print "entering the if loop with line equal to $_\n";
			# Assign new fasta label
			$temp_fasta_label = "$_";
			
			
			
			
			
			
			
			
			
			
			
		}
		else {
			$temp_fasta_seq .= $_;
			#print OUT_FASTA_SEQUENCES "$temp_fasta_seq\n";
		}
		
		
		# Test to see if hash contains key. If so, output fasta header and sequence.
		if (exists $nameTable{$temp_fasta_label}) {	
			print OUT_FASTA_SEQUENCES "$temp_fasta_label\n";
			print OUT_FASTA_SEQUENCES "$temp_fasta_seq\n";
				$temp_fasta_label = "";
				$temp_fasta_seq = "";
		}
	}
	close (FILEHANDLE_FIRST);
	close (OUT_FASTA_SEQUENCES);
}

print "Completed RA_select_subsample_multifasta.pl version $version script\n";