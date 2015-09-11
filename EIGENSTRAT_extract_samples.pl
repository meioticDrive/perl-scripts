#!/usr/bin/perl -w
# Version 1.0
# Copyright Michael E. Zwick, 2015_08-31
################################################################################
# Program designed to:
# 1. Parse an Eigenstrat output file: data.evec.txt
# 2. Output samples to drop into data.drop.txt file. This samples that exceed
# value for PC1 or PC2
# 3. Out samples to keep into data.keep.txt file. These samples do not exceed
# values for PC1 or PC2
# Usage: Launch directory above target, include target directory name
################################################################################
use warnings;
use strict;
use Cwd;

################################################################################
# Local variable definitions
################################################################################
# Define local variables
my(@evec_file, $evec_file_number, @line, $i, $in);
my($PC1_upper_value, $PC1_lower_value, $PC2_upper_value, $PC2_lower_value);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables
$i = 0;
$in = 0;
@evec_file = ();
$evec_file_number = 0;

# Set thresholds here
$PC1_upper_value = 0.05;
$PC1_lower_value = -0.05;
$PC2_upper_value = 0.05;
$PC2_lower_value = -0.05;

################################################################################
# Program Overview
################################################################################

# Change to user provided directory
chdir "$ARGV[0]"
	or die "Cannot change to directory $ARGV[0]\n";

# Remove old files
unlink("log.EIGENSTRAT_extract_samples.out");

# Open for output of log files
open(OUT_LOG, ">>", "log.EIGENSTRAT_extract_samples.out")
	or die "Cannot open OUT_LOG for data output";

# Obtain name of EIGENSTRAT EVEC files
@evec_file = glob("*evec*");
$evec_file_number = ($#evec_file + 1);
if ($evec_file_number == 0) {
	die "$evec_file_number evec files detected.\n
		Check directory. Exiting program";
}

# Output information to log file
print "Detected $evec_file_number EIGENSTRAT evec files\n";
print OUT_LOG "Detected $evec_file_number EIGENSTRAT evec files\n";

# Output files detected for processing
for ($i = 0; $i < $evec_file_number; $i++) {
	print OUT_LOG "$evec_file[$i]\n";
	@line = split (/.evec./, $evec_file[$i]);
	
	
	print OUT_LOG "Processing evec file\n";
	print "Processing evec file\n";
}

# Open output file for BRIDGE comments
open (OUT_DROP, ">>", "$line[0].drop.txt")
	or die "Cannot open OUT_ANNOT filehandle to parsed output file info";

# Open output file for BRIDGE comments
open (OUT_SAMPLEIDS, ">>", "sampleIDs.drop.txt")
	or die "Cannot open OUT_ANNOT filehandle to parsed output file info";

# Open output file for BRIDGE comments
open (OUT_KEEP, ">>", "$line[0].keep.txt")
	or die "Cannot open OUT_ANNOT filehandle to parsed output file info";

# Select samples to keep or drop from .evec file
# Assume only one *.evec.* file
parsetext ($evec_file[0], $PC1_upper_value, $PC1_lower_value, $PC2_upper_value, $PC2_lower_value);

close (OUT_DROP);
close (OUT_KEEP);
print OUT_LOG "Completed EIGENSTRAT_extract_samples.pl program.\n";
close (OUT_LOG);
print "Completed EIGENSTRAT_extract_samples.pl program.\n";

################################################################################
# Subroutines
################################################################################

sub parsetext {
	# Define variables
	# Variables include:
	# 	Name of text file - $temp_file
	# 	Text to match to start parsing on next line - $start
	# 	Text to match to end parsing of lines on prior line - $stop
	my ($temp_file, $pc1_upper_threshold, $pc1_lower_threshold, $pc2_upper_threshold, $pc2_lower_threshold) = @_;
	my (@matchingLines, $temp_line, @text_file);
	
	#Initialize variables
	$temp_line = "";
	@matchingLines = ();
	@text_file = ("$temp_file");
	
	# Select and output text between $start and $stop
	# Assume sending a single file for processing
	foreach my $files (@text_file) {
		# Open $files to be read
		open (IN_ANNOT, "<", "$files")
			or die "Cannot open IN_ANNOT filehandle to read file";

		# Process *.evec.* file
		while (<IN_ANNOT>) {
			chomp $_;
			
			# Drop first line
			if (/^\s+#eigvals:/) {
				next;
			}
			
			# Read lines for keep or drop #
			@matchingLines = split (/\s+/, $_);
			
			if (($matchingLines[2] > $pc1_upper_threshold) or ($matchingLines[2] < $pc1_lower_threshold)
			or ($matchingLines[3] > $pc2_upper_threshold) or ($matchingLines[3] < $pc2_lower_threshold)) {
				print OUT_SAMPLEIDS "$matchingLines[1]\n";
				print OUT_DROP "$_\n";
				print "$_\n";
			}
			else {
				print OUT_KEEP "$_\n";
			}
		}
	close (IN_ANNOT);
	}
}