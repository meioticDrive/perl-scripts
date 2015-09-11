#!/usr/bin/perl -w
# Version 1.1
# Michael E. Zwick
# 1/6/05
# Program designed to:
# 1. Run over a single folder containing multiple fasta files.
# 2. Determine which fasta files need to be reversed.
# 3. Reverse fragment position pairs (top - bottom) - for chips designed on opposite strand
# 4. Swap fragment positions (left and right) - so that they increase in value and reflect 
# annotation from UCSC browser.
# Version 1.2
# 1. Added a bit of code to remove final \n from last line (for consistency with other data).
# 2. Added directory commands to move the reverse files into a single directory
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use strict;
use Cwd;
#-------------------------------------------------------------------------------
# Local variable definitions
#-------------------------------------------------------------------------------
# Define local variables

my(@data_directories, $data_dir_number, @sequence_file, $seq_file_number, @fasta_file, $fasta_file_number, $files, @all_lines, @fasta_file_data, $fasta_file_data_number, @lines, $fasta_temp, $count, @temp, $temp_DNA_seq, $true_array_size);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables
$count = 0;
@fasta_file_data = ();
$fasta_temp = '';
$fasta_file_data_number = 0;

#-------------------------------------------------------------------------------
# Program Overview:
# Start in a folder containing a set of genpos files
# Read in the names of the annot.message.txt files
#-------------------------------------------------------------------------------

# Open for output of log files
open(OUT_LOG, ">", "log.reverse_multi_fasta.out")
	or die "Cannot open OUT_FASTA for data output";
	
# Obtain name of annot.genpos.txt files
@fasta_file = glob("*.fasta");
$fasta_file_number = ($#fasta_file + 1);
if ($fasta_file_number == 0) {
	die "$fasta_file_number genpos files detected.\n
		Check directory. Exiting program";
}

# Output information to log file
print OUT_LOG "Detected $fasta_file_number fasta files\n";
for (my $i = 0; $i < $fasta_file_number; $i++) {
	print OUT_LOG "$fasta_file[$i]\n";
}
	print OUT_LOG "Processing fasta files\n";

# Loop over each of the genpos files
foreach my $files (@fasta_file) {

	# Open $files to be read
	open (IN_ANNOT, "<", "$files")
		or die "Cannot open IN_ANNOT filehandle to read file";
		
	# Open output file - append info to file
	# Open special output file for *.ref.fasta
	
	if ($files =~ /.ref.fasta/) {
		open (OUT_ANNOT, ">", "$files.reverse.ref.fasta")
		or die "Cannot open OUT_ANNOT filehandle to output file info";
	} else {
			open (OUT_ANNOT, ">", "$files.reverse.fasta")
				or die "Cannot open OUT_ANNOT filehandle to output file info";
		}
		
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
	# Obtain last fasta lines
	@temp = $fasta_temp;
	push (@fasta_file_data, @temp);
	@temp = ();
	
	# Determine array size
	$fasta_file_data_number = ($#fasta_file_data);
	$true_array_size = $fasta_file_data_number + 1;
	print OUT_LOG "Working on file $files, observed $true_array_size data elements in array fasta_file_data\n";
	
	# Output information to log file
	#for (my $i = 0; $i <= $fasta_file_data_number; $i++) {
	#print OUT_LOG "Element $i is $fasta_file_data[$i]\n";
	#}
	
	# Reverse fragment order in @fasta_file_data array
	# Outputs label and reversed DNA sequence (two array values)
	for (my $i = $fasta_file_data_number; $i >= 0; $i= $i - 2) {
	
	# Remove final \n - to make consistent with Cutler sequence generated data
	if ($i == 1) {
		# Print out fasta label	
		print OUT_ANNOT "$fasta_file_data[$i-1]\n";
		# Reverse DNA sequence in strings
		$temp_DNA_seq = reverse ($fasta_file_data[$i]);
		# Transliterate DNA sequences to other strand
		$temp_DNA_seq =~ tr/ACGTNacgtn/TGCANtgcan/;
		print OUT_ANNOT "$temp_DNA_seq";
	} else {
		# Print out fasta label	
		print OUT_ANNOT "$fasta_file_data[$i-1]\n";
		# Reverse DNA sequence in strings
		$temp_DNA_seq = reverse ($fasta_file_data[$i]);
		# Transliterate DNA sequences to other strand
		$temp_DNA_seq =~ tr/ACGTNacgtn/TGCANtgcan/;
		print OUT_ANNOT "$temp_DNA_seq\n";
		}
	}
	# Clear variables and arrays
	@fasta_file_data = ();
	$fasta_temp = '';
	$fasta_file_data_number = 0;
	$count = 0;
	
}

close (IN_ANNOT);
close (OUT_ANNOT);

# Move files around
system ("mkdir reverse");
system ("mv *.reverse.* reverse");

print OUT_LOG "Completed reverse_multi_fasta.txt_ver1.2.pl program.\n";
close (OUT_LOG);
print "Completed reverse_multi_fasta.txt_ver1.2.pl program.\n";








































