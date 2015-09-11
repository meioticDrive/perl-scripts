#!/usr/bin/perl -w
# Version 1.0
# Michael E. Zwick
# 1/25/06
# Program designed to:
# 1. Run over a single folder containing multiple fasta files.
# 2. Using user defined parameters, make a composite fasta file pulling 
# sequences from .fasta and .reverse.fasta files. 
# 3. Written to solve the problem associated with chips designed from unfinished genomic sequence 
# where sets of fragments are on different strands (+ or -) in final genome assembly.
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use strict;
use Cwd;
#-------------------------------------------------------------------------------
# Local variable definitions
#-------------------------------------------------------------------------------
# Define local variables

my(@fasta_file, $fasta_file_number, @reverse_fasta_file, $reverse_fasta_file_number, $file_to_process, $files, @fasta_file_data, $fasta_file_data_number, @lines, $fasta_temp, $count, @temp, $temp_DNA_seq, $true_array_size, $start_fragment, $end_fragment, $temp_start_fragment, $temp_end_fragment, $genomic_region, $file_count);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables
$count = 0;
@fasta_file_data = ();
$fasta_temp = '';
$fasta_file_data_number = 0;
$file_count = 0;

# Set to "forward" or "reverse" depending upon file type to process
#$file_to_process = "forward";
$file_to_process = "reverse";
# Fragment to start/end reading (number from 1 to N fragments)
# Reverse numbering is in opposite order (used excel file to get it right)
$start_fragment = 1;
$end_fragment = 3;
$genomic_region = "31-EDNRB";


#-------------------------------------------------------------------------------
# Program Overview:
# Start in a folder containing a set of .fasta and .reverse.fasta files
# Read in the names of all the files
#-------------------------------------------------------------------------------

# Open for output of log files
open(OUT_LOG, ">>", "log.parse_multi_fasta.out")
	or die "Cannot open OUT_FASTA for data output";
	
# Obtain name of .fasta files files (may need to edit)
@fasta_file = glob("*[0-9][0-9].fasta");
$fasta_file_number = ($#fasta_file + 1);
if ($fasta_file_number == 0) {
	die "$fasta_file_number fasta files detected.\n
		Check directory. Exiting program";
}

# Obtain name of .reverse.fasta files files (may need to edit)
@reverse_fasta_file = glob("*.reverse.fasta");
$reverse_fasta_file_number = ($#reverse_fasta_file + 1);
if ($reverse_fasta_file_number == 0) {
	die "$reverse_fasta_file_number fasta files detected.\n
		Check directory. Exiting program";
}

# Output information to log file
print "Detected $fasta_file_number fasta files, $reverse_fasta_file_number reverse fasta files\n";
print OUT_LOG "Detected $fasta_file_number fasta files, $reverse_fasta_file_number reverse fasta files\n";

if ($file_to_process eq "forward") {
	for (my $i = 0; $i < $fasta_file_number; $i++) {
		print OUT_LOG "$fasta_file[$i]\n";
	}
		print OUT_LOG "Processing fasta files\n";
		print "Processing fasta files\n";
}

if ($file_to_process eq "reverse") {
	for (my $i = 0; $i < $fasta_file_number; $i++) {
		print OUT_LOG "$fasta_file[$i]\n";
	}
		print OUT_LOG "Processing reverse fasta files\n";
		print "Processing reverse fasta files\n";
}


# Process .fasta files
if ($file_to_process eq "forward") {

	# Loop over each of the .fasta files
	foreach my $files (@fasta_file) {

	# Open $files to be read
	open (IN_ANNOT, "<", "$files")
		or die "Cannot open IN_ANNOT filehandle to read file";

	# Read in the fasta fragments from file
		while (<IN_ANNOT>) {
			
			chomp($_);
		
			if ($_ =~ /^>/) {
		
				# Get first label
				if ($count == 0) {
					@temp = $_;
					#print "The input value is $_\n";
					push (@fasta_file_data, @temp);
					$count++;
					#print "The value of count is $count\n";
					@temp = ();
					next;
				}
				
				# Push sequence onto array, get next label
				if ($count > 0) {
					#print "Count loop = $count, $fasta_temp\n";
					@temp = $fasta_temp;
					push (@fasta_file_data, @temp);
					$fasta_temp = '';
					@temp = ();
				
					# Get subsequent label
					@temp = $_;
					#print "Printing label out $_\n";
					push (@fasta_file_data, @temp);
					$count++;
					@temp = ();
				}
			}
			else {
				$fasta_temp = $fasta_temp . $_;
				#print "$fasta_temp\n";
			}
		}
		
		# Get last DNA sequence fragment
		@temp = $fasta_temp;
		push (@fasta_file_data, @temp);
		@temp = ();
		
		# Determine array size
		$fasta_file_data_number = ($#fasta_file_data);
		$true_array_size = $fasta_file_data_number + 1;
		print OUT_LOG "Working on file $files, observed $true_array_size data elements in array fasta_file_data\n";
		#print "Last array subscript is $fasta_file_data_number\n";
	# Open output file - append info to file
	# Open special output file for *.ref.fasta (broken)
		if ($files =~ /zzzzmichael.ref.fasta/) {
			open (OUT_ANNOT, ">>", "$genomic_region.chimera.ref.fasta")
			or die "Cannot open OUT_ANNOT filehandle to output file info";
		} else {
				open (OUT_ANNOT, ">>", "$genomic_region.$file_count.chimera.fasta")
					or die "Cannot open OUT_ANNOT filehandle to output file info";
			}

		# Correct count coordinates
		$temp_start_fragment = (($start_fragment - 1) * 2);
		$temp_end_fragment = ($end_fragment * 2);

		# Output the fragments to the correct output file
		for (my $j = $temp_start_fragment; $j < $temp_end_fragment; $j++) {
			print OUT_ANNOT "$fasta_file_data[$j]\n";
			#print "$j, $fasta_file_data[$j]\n";
		}

		# Clear/increment variables and arrays
		@fasta_file_data = ();
		$fasta_temp = '';
		$fasta_file_data_number = 0;
		$count = 0;
		$temp_start_fragment = 0;
		$temp_end_fragment = 0;
		$file_count++;
	}
}

# Process .reverse.fasta files
if ($file_to_process eq "reverse") {

	# Loop over each of the .fasta files
	foreach my $files (@reverse_fasta_file) {

		# Open $files to be read
		open (IN_ANNOT, "<", "$files")
			or die "Cannot open IN_ANNOT filehandle to read file";

		# Read in the fasta fragments from file
		while (<IN_ANNOT>) {
		
			chomp($_);
		
			if ($_ =~ /^>/) {
				# Get first label
				if ($count == 0) {
					@temp = $_;
					push (@fasta_file_data, @temp);
					$count++;
					@temp = ();
					next;
				}
			
				# Output sequence, get subsequent labels
				if ($count > 0) {
					#print "Count loop, $count, $fasta_temp\n";
					@temp = $fasta_temp;
					push (@fasta_file_data, @temp);
					$fasta_temp = '';
					@temp = ();
				
					# Get subsequent label
					@temp = $_;
					push (@fasta_file_data, @temp);
					$count++;
					@temp = ();
				}
			}
			else {
				$fasta_temp = $fasta_temp . $_;
				#print "$fasta_temp\n";
			}
		}
	
		# Get last DNA sequence fragment
		@temp = $fasta_temp;
		push (@fasta_file_data, @temp);
		@temp = ();
	
		# Determine array size
		$fasta_file_data_number = ($#fasta_file_data);
		#print "Array size is $fasta_file_data_number\n";
		$true_array_size = $fasta_file_data_number + 1;
		print OUT_LOG "Working on file $files, observed $true_array_size data elements in array fasta_file_data\n";

		# Open output file - append info to file
		# Open special output file for *.ref.fasta
		if ($files =~ /zzzzzzz.ref.fasta/) {
			open (OUT_ANNOT, ">>", "$genomic_region.chimera.ref.fasta")
				or die "Cannot open OUT_ANNOT filehandle to output file info";
		} else {
			open (OUT_ANNOT, ">>", "$genomic_region.$file_count.chimera.fasta")
				or die "Cannot open OUT_ANNOT filehandle to output file info";
			}

		# Output the fragments to the correct output file
		# Correct count coordinates
		$temp_start_fragment = (($start_fragment-1) * 2);
		$temp_end_fragment = (($end_fragment) * 2);

		# Output the fragments to the correct output file
		for (my $j = $temp_start_fragment; $j < $temp_end_fragment; $j++) {
			print OUT_ANNOT "$fasta_file_data[$j]\n";
		}
	
		# Clear/increment variables and arrays
		@fasta_file_data = ();
		$fasta_temp = '';
		$fasta_file_data_number = 0;
		$count = 0;
		$temp_start_fragment = 0;
		$temp_end_fragment = 0;
		$file_count++;
	}
}

close (IN_ANNOT);
close (OUT_ANNOT);

# Move files around - use while debugging
# system ("mkdir chimera");
# system ("mv *.chimera.* chimera");

print OUT_LOG "Completed parse_multi_fasta.txt_ver1.2.pl program.\n";
close (OUT_LOG);
print "Completed parse_multi_fasta.txt_ver1.2.pl program.\n";








































