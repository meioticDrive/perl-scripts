#!/usr/bin/perl
#
### Name: MLST_fasta_format.pl
### Version: 1.0
### Date: 04/01/2007
### Author: Michael E. Zwick
##############################################################################
### 1. The purpose of this script is to read in a multi-fasta file and convert ### the output
### (namely end of lines) so that they can be imported into excel and easily ### merged together.
### 2. Requires the following files:
###  - RA multifasta file with sequence
##############################################################################
use warnings;
use strict;
use Cwd;

my ($dirname, $version, $temp_seq, @label_count, $temp_label, $count, @fasta_files, @label_genpos, @hapmap_files, @temp_genpos, @genpos_name, @genpos_start, @genpos_end, @temp_hapmap, $nmbr_genpos_name, $nmbr_genpos_start, $nmbr_genpos_end, @temp_ra_seq, $temp_location, @files, @filess, @fasta_labels, @temp_seq, %fasta_info, $file_name, $i, @fasta_label_sequence, $fasta_fragment_nmbr, @fasta_label, @fasta_sequence, $files_processed, $record_number, $final_fasta_nmbr);

# Initialize variables
$version = "1.0";
$dirname = ".";
$temp_seq = "";
$temp_label = "";
$count = 0;
$file_name = "";
$temp_location = 0;

# Set the number of fasta fragments (number of strains)
$final_fasta_nmbr = 38;

# Change to directory entered by user when calling the program
#-----------------------------------------------------------------------------
chdir $ARGV[0] or die "Cannot change to directory $ARGV[0]\n";

# Remove old sort files
system ("rm *.mlst.fasta");

# Collect the names of files for processing
@fasta_files = glob("*.fasta") 					# Individual fasta files
	or die "No fasta file found\n";				
$files_processed = ($#fasta_files + 1);

	# Output fasta sequence information in merged format
	open(OUT_FASTA_SEQUENCES, ">", "MLST.30kb_strains.mlst.fasta")
		or die "Cannot open OUT_FASTA_SEQUENCES for sequence output";

# Process fasta file, make hash relating fasta labels to sequence
#-----------------------------------------------------------------------------
foreach my $process_file (@fasta_files) {
	print "Processing fasta file: $process_file\n";
	$file_name = $process_file;
	open(FILEHANDLE_FIRST, $process_file)
		or die "Cannot open FILEHANDLE_FIRST - for fasta file";

	
	while (<FILEHANDLE_FIRST>) {		#Process .fasta file
		chomp($_);
		
		
		if($_ =~ />/) {
			
			if($count > 0) {									# Add fasta label and fasta sequence to array
				push (@fasta_label, $temp_label);
				push (@fasta_sequence, $temp_seq);
				push (@label_count, $temp_label);							# Collect all fasta labels to count later 
			}
			# Reset variables
			$temp_seq = "";			#Reset sequence collection variable
			$temp_label = $_;		#Collect next fasta label
			$count++;
		}
		else {
		# Read DNA sequence into string
		$temp_seq .= $_;
		}
	}
	
	# Process the last fasta fragment
	push (@fasta_label, $temp_label);
	push (@fasta_sequence, $temp_seq);
	push (@label_count, $temp_label);							# Collect all fasta labels to count later 
	
	# Determine number of fasta fragments
	$fasta_fragment_nmbr = ($#label_count + 1);
	

	
	print "Fasta file $process_file had $fasta_fragment_nmbr fasta fragments\n";
	#print "@label_count\n";
	
	# Reset variables
	$temp_seq = "";
	$temp_label = "";
	$count = 0;
	@label_count = ();
	$fasta_fragment_nmbr = 0;
	close(FILEHANDLE_FIRST);
}

print "Final fasta number is $final_fasta_nmbr\n";


# Outputs concatenated file
for (my $i = 0; $i < $final_fasta_nmbr; $i++) {
	# Print out fasta label
	print OUT_FASTA_SEQUENCES "\n$fasta_label[$i]\n";
	# Print out sequence from multiple files
	# Loop over number of files processed (calculates array indexes based upon number of files, number # of fasta fragments)
	for (my $j = 0; $j < $files_processed; $j++) {
		# Record number calculations loops over number of files processed and number of fasta fragments
		# per file
		$record_number = ($i +($j * $final_fasta_nmbr));
		#print "Record number is $record_number\n";
		print OUT_FASTA_SEQUENCES "$fasta_sequence[$record_number]";
		}
}

close (OUT_FASTA_SEQUENCES);
print "Completed MLST_fasta_format.pl version $version script\n";














































































