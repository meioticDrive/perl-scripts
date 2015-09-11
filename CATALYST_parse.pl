#!/usr/bin/perl -w
# Version 1.0
# Copyright Michael E. Zwick, 2015_08-20
################################################################################
# Program designed to:
# 1. Parse grant text from Bridge application reviews.
# 2. Bridge reviews needs to be saved as plain text files.
# 3. Need to add auto conversion of combined.temp.txt to Unix end of lines
# Usage: Launch directory above target, include target directory name
################################################################################
use warnings;
use strict;
use Cwd;

################################################################################
# Local variable definitions
################################################################################
# Define local variables
my(@text_file, $text_file_number, @line, $i, $in);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables
$i = 0;
$in = 0;
@text_file = ();
$text_file_number = 0;

################################################################################
# Program Overview
################################################################################

# Change to Alignment directory, in user provided directory
chdir "$ARGV[0]"
	or die "Cannot change to directory $ARGV[0]\n";

# Remove old files
unlink("log.BRIDGE_parse.out");
unlink glob("*.parsed.txt");

# Open for output of log files
open(OUT_LOG, ">>", "log.BRIDGE_parse.out")
	or die "Cannot open OUT_LOG for data output";

# Obtain name of BRIDGE review files
@text_file = glob("*.txt");
$text_file_number = ($#text_file + 1);
if ($text_file_number == 0) {
	die "$text_file_number BRIDGE files detected.\n
		Check directory. Exiting program";
}

# Output information to log file
print "Detected $text_file_number BRIDGE files\n";
print OUT_LOG "Detected $text_file_number BRIDGE files\n";

# Output files detected for processing
for ($i = 0; $i < $text_file_number; $i++) {
	print OUT_LOG "$text_file[$i]\n";
	print OUT_LOG "Processing BRIDGE text file\n";
	print "Processing BRIDGE text ped files\n";
}

# Add code to get directory name here
# Update name of parsed file with directory name

	# Open output file for BRIDGE comments
	open (OUT_ANNOT, ">>", "$ARGV[0].parsed.txt")
		or die "Cannot open OUT_ANNOT filehandle to parsed output file info";

# Get Faculty Name
facultyname ("combined.temp.txt");

# Get comments from sections of CATALYST reviews
print OUT_ANNOT "Significance and Impact of Study\n\n";
parsetext ("combined.temp.txt", "Comment:", "Innovation:");

print OUT_ANNOT "Innovation\n\n";
parsetext ("combined.temp.txt", "Innovation:", "Approach:");

print OUT_ANNOT "Approach\n\n";
parsetext ("combined.temp.txt", "Approach:", "Investigator:");

print OUT_ANNOT "Investigator\n\n";
parsetext ("combined.temp.txt", "Investigator:", "Overall Comments");

print OUT_ANNOT "Overall Comments\n\n";
parsetext ("combined.temp.txt", "Overall Comments", "Recommendation for Support:");

close (OUT_ANNOT);
print OUT_LOG "Completed BRIDGE_parse.pl program.\n";
close (OUT_LOG);
print "Completed BRIDGE_parse.pl program.\n";

################################################################################
# Subroutines
################################################################################
sub facultyname {
	#Define variables
	my ($temp_file) = @_;
	my (@line, $count);
	
	#Initialize variables
	@text_file = ("$temp_file");
	@line = ();
	$count = 0;

	foreach my $files (@text_file) {
	
		# Open $files to be read
		open (IN_ANNOT, "<", "$files")
			or die "Cannot open IN_ANNOT filehandle to read file";
		
		# Get faculty member name
		while (<IN_ANNOT>) {
			if (($_ =~ /^Faculty/) && ($count ==0)) {
				@line = split (/:/, $_);
				$line[1] =~ s/^\s+|\s+$//g;
				print OUT_ANNOT "Faculty Name: $line[1]\n\n";
				$count = 1;
				}
		}
	}
	close (IN_ANNOT);
}

sub parsetext {
	# Define variables
	# Variables include:
	# 	Name of text file - $temp_file
	# 	Text to match to start parsing on next line - $start
	# 	Text to match to end parsing of lines on prior line - $stop
	my ($temp_file, $start, $stop,) = @_;
	my (@matchingLines, $spool);
	
	#Initialize variables
	$spool = 0;
	@matchingLines = ();
	@text_file = ("$temp_file");
	
	# Select and output text between $start and $stop
	# Assume sending a single file for processing
	foreach my $files (@text_file) {
		# Open $files to be read
		open (IN_ANNOT, "<", "$files")
			or die "Cannot open IN_ANNOT filehandle to read file";
		# Process Significance and Impact of Study Comments
		while (<IN_ANNOT>) {
			$_ =~ s/^\s+|\s+$//g;
			
			# Significance and Impact of Study Comments
			if (/^$start/i) {
				$spool = 1;
				next;
			}
			elsif (/^$stop/i) {
				$spool = 0;
				print OUT_ANNOT map { "$_ \n" } @matchingLines;
				print OUT_ANNOT "\n";
				@matchingLines = ();
			}
			
			if ($spool == 1) {
				if ($_ =~ /\S/) {
					push (@matchingLines, $_);
				}
			}
		}
	close (IN_ANNOT);
	}
}