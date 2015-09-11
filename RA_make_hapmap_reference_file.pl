#!/usr/bin/perl
#
# Name: RA_compare_hapmap.pl
# Version: 1.0
# Date: 03/20/2007
# Author: Michael E. Zwick
#--------------------------------------------------------------------------------------------
# 1. The purpose of this script is to determine a series of SNPs from the hapmap, extract the 
# identical bases from a RA, and output the data for comparison.
# 2. Requires the following files:
#  - RA multifasta file with sequence
#  - genpos.txt corresponding to the RA file
#  - hapmap genotype file for individual
#--------------------------------------------------------------------------------------------
use warnings;
use strict;
use Cwd;

my ($dirname, $version, $temp_seq, @temp_label, $count, @fasta_files, @label_genpos, @hapmap_files, 
@temp_genpos, @genpos_name, @genpos_start, @genpos_end, @temp_hapmap, $nmbr_genpos_name, 
$nmbr_genpos_start, $nmbr_genpos_end, @temp_ra_seq, $temp_location, @files, @filess, @fasta_labels, 
@temp_seq, %fasta_info, $file_name, $i);

# Initialize variables
$version = "1.0";
$dirname = ".";
$temp_seq = "";
@temp_label = ();
$count = 0;
$file_name = "";
$temp_location = 0;

# Change to directory entered by user when calling the program
#--------------------------------------------------------------------------------------------
chdir $ARGV[0] or die "Cannot change to directory $ARGV[0]\n";

# Remove old sort files
system ("rm *.seq_compare.txt");

# Collect the names of files for processing
@fasta_files = glob("*.fasta") 					# Individual RA sequence
	or die "No fasta file found\n";				
@label_genpos = glob("*.label.genpos.txt")	# Fasta labels genpos of reference sequences
	or die "No label.genpos.txt file found\n";
@hapmap_files = glob("*.hapmap.txt")		# Genotypes from hapmap individual
	or die "No hapmap.txt file found\n";


# Process fasta file, make hash relating fasta labels to sequence
#--------------------------------------------------------------------------------------------
foreach my $process_file (@fasta_files) {
	print "Processing fasta file: $process_file\n";
	$file_name = $process_file;
	#print "$process_file\n";
	open(FILEHANDLE_FIRST, $process_file)
		or die "Cannot open FILEHANDLE_FIRST - for fasta file";

	while (<FILEHANDLE_FIRST>) {
		chomp($_);
		
		if($_ =~ />/) {
			
			if($count > 0) {
				# Make hash relating fasta label with sequence (from previous loop through)
				#print "$temp_seq\n";
				#print "$temp_label[0]\n";
				$fasta_info{$temp_label[0]} = $temp_seq;
				#print "$temp_label[0]\n$fasta_info{$temp_label[0]}\n";
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
	
	# Process last fasta fragment to hash
	$fasta_info{$temp_label[0]} = $temp_seq;
	}
# Reset variables
$temp_seq = "";
@temp_label = ();
$count = 0;
close(FILEHANDLE_FIRST);

	# Output sequence information
	open(OUT_FASTA_SEQUENCES, ">", "$file_name" . '.seq_compare.txt')
		or die "Cannot open OUT_FASTA_SEQUENCES for sequence output";
	# Print out headers

# Read in label.genpos information
# Make three arrays that have the fasta label, fasta start
#--------------------------------------------------------------------------------------------
foreach my $process_label_genpos (@label_genpos) {
	print "Processing label_genpos.txt file: $process_label_genpos\n";
	open(FILEHANDLE_SECOND, $process_label_genpos)
		or die "Cannot open FILEHANDLE_SECOND - for genpos.txt file";

	while (<FILEHANDLE_SECOND>) {
		chomp($_);
		# Split genpos line, label(0), start(1), end(2)
		@temp_genpos = split('\t',$_);
		
		#print OUT_FASTA_SEQUENCES "IN THE SECOND LOOP\n";
		#print OUT_FASTA_SEQUENCES "$temp_genpos[0]\t";
		#print OUT_FASTA_SEQUENCES "$temp_genpos[1]\t";
		#print OUT_FASTA_SEQUENCES "$temp_genpos[2]\n";
		
		# Move values into arrays
		push (@genpos_name, $temp_genpos[0]);
		push (@genpos_start, $temp_genpos[1]);
		push (@genpos_end, $temp_genpos[2]);
		# Reset @genpos_temp array
		@temp_genpos = ();
}
close(FILEHANDLE_SECOND);
# Determine number of lines\fragments in label_genpos file
$nmbr_genpos_name = ($#genpos_name + 1);
$nmbr_genpos_start = ($#genpos_start + 1);
$nmbr_genpos_end = ($#genpos_start + 1);

#print OUT_FASTA_SEQUENCES "Number of names is $nmbr_genpos_name\n";
#print OUT_FASTA_SEQUENCES "Number of starts is $nmbr_genpos_start\n";
#print OUT_FASTA_SEQUENCES "Number of ends is $nmbr_genpos_end\n";
}

# Read in hapmap genotypes
# Compare with RA data, output results
#--------------------------------------------------------------------------------------------
foreach my $process_hapmap (@hapmap_files) {
	print "Processing hapmap.txt file: $process_hapmap\n\n";
	open(FILEHANDLE_THIRD, $process_hapmap)
		or die "Cannot open FILEHANDLE_THIRD - for hapmap.txt file";
	print OUT_FASTA_SEQUENCES "Fasta Label\tFasta Start\tFasta End\tSNP Location\tHapmap Call\tRA Call\n";

	while(<FILEHANDLE_THIRD>) {
		chomp($_);
		# Split hapmap line for testing, position(0), genotype(1)
		@temp_hapmap = split('\t',$_);
		
		#print OUT_FASTA_SEQUENCES "$temp_hapmap[0]\t$temp_hapmap[1]\n";
		
		# Determine if SNP is in RA region
		for($i = 0; $i < $nmbr_genpos_name; $i++) {
		
			# SNP overlaps RA sequence
			if ( ($temp_hapmap[0] >= $genpos_start[$i]) && ($temp_hapmap[0] <= $genpos_end[$i])) {
				
				#print "$genpos_name[$i]\n";
				#print "$fasta_info{$genpos_name[$i]}\n";
				#print "$fasta_info{'>GSX_23_HD.txt.chrX_138655546_138655682_106'}\n";
				# Get the sequence and split it
				@temp_ra_seq = split( '',$fasta_info{$genpos_name[$i]});
				$temp_location = (($temp_hapmap[0] - $genpos_start[$i]));
				print OUT_FASTA_SEQUENCES "$genpos_name[$i]\t$genpos_start[$i]\t$genpos_end[$i]\t$temp_hapmap[0]\t$temp_hapmap[1]\t$temp_ra_seq[$temp_location]\n";
			}
			else {
				next;
			}
		# Reinitialize array
			#@temp_hapmap = ();
		}
	}
}
close(FILEHANDLE_THIRD);



print "Completed RA_compare_hapmap.pl version $version script\n";














































































