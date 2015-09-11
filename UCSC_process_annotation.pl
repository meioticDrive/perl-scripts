#!/usr/bin/perl
##############################################################################
### Version 1.6
### Michael E. Zwick
### Date: 3/4/2008
### #!/usr/bin/perl - alternate perl location
### #!/usr/bin/env perl
### #!/opt/local/bin/perl5.10
##############################################################################
### Program designed to:
### 1. Process gene information downloaded from the UCSC browser. Files 
### contained in a single directory. Run program from within the directory.
### 2. Make the message and coding file format for the Popgencode
##############################################################################
### Directions for Use:
### 1. Identify gene(s) of interest, search in UCSC Browser for region
### 2. Zoom out to ensure that entire gene is contained within coordinates
### 3. Push "Tables" Button
### 4. Gene information is in "Genes and Gene Prediction Tracks", 
###    table: knownGene
### 5. Choose to output selected fields (in output format:)
### 6. Choose output file name (should be gene_name.ucsc.gene.txt
### 7. Fields downloaded from UCSC include:
###    name	strand	txStart	txEnd	cdsStart	cdsEnd	exonCount	exonStarts	
###    exonEnds
### 8. Put text file in a folder, run this perl script from within the folder
### 9. Note: There may be bugs or other complications from alternatively 
### spliced gene - since they are listed more than once. May require some hand 
### annotation to help fix this (or make a pseudo gene with one long coding ### sequence).
### Version 1.1
### 1. Fixed bug caused by UCSC cdsStart, exonStart starting at 0 vice 1
### Version 1.2
### 1. Updated code to output 0 (fwd strand), 1 (reverse strand) for genes.
### Version 1.3
### 1. Added code to fix bug in situation with 2 exons, but only 1 coding 
### fragment
### Version 1.4
### 1. Added code to fix bug with processing - strand genes. Labels in ucsc 
### browser are opposite for these genes.
### Version 1.5
#### 1. Went back to simpler code - misunderstanding of labels in version 1.4.
##############################################################################
##############################################################################
use warnings;
use strict;
use Cwd;
##############################################################################
# Local variable definitions
##############################################################################
# Define local variables
my(@ucsc_file, $ucsc_file_number, @ucsc_labels, @ucsc_gene_info, 
@ucsc_exonStarts, @ucsc_exonEnds, $exon_number, $temp_start, $temp_end, 
$coding_start, $coding_end, $loop_count, $coding_exon_counter, $strand);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);


##############################################################################
# Program Overview:
# Start in a folder containing a single uscs gene table file
# Read in the data from the file
# Determine the number of exons, read in the exon start and finish
##############################################################################

# Remove old files
system ("rm *.annot.coding.txt");
system ("rm *.annot.message.txt");
system ("rm log*");

# Open for output of log files
open(OUT_LOG, ">", "log.ucsc_process_annotation.out")
	or die "Cannot open OUT_FASTA for data output";
	
# Obtain name of ucsc gene_annotation.txt files
@ucsc_file = glob("*.ucsc.gene.txt");
$ucsc_file_number = ($#ucsc_file + 1);
if ($ucsc_file_number == 0) {
	die "$ucsc_file_number ucsc gene annotation files detected.
	 Check directory. Exiting program";
}
print OUT_LOG "Detected $ucsc_file_number ucsc.gene.txt file(s)\n";

# Loop over each of the data directories
foreach my $files (@ucsc_file) {
	
	print "\nFile name is: $files\n\n";
	# Open $files to be read
	open (IN_ANNOT, "<", "$files")
		or die "Cannot open IN_ANNOT filehandle to read file";
		
	# Open output file - will append info to file
	open (OUT_MESSAGE, ">>", "$files.annot.message.txt")
		or die "Cannot open OUT_MESSAGE filehandle to output message info";
	
		# Open output file - will append info to file
	open (OUT_CODING, ">>", "$files.annot.coding.txt")
		or die "Cannot open OUT_CODING filehandle to output coding info";
		
	# Output $files name to log file
	print OUT_LOG "$files\n";

	# Read in text information from $files
	# First line is labels
	# Subsequent lines are gene information - one gene per line
	while (<IN_ANNOT>) {
		chomp($_);
		
		# Read in labels on first line into @ucsc_labels
		# Split by tabs, read in labels
		if ($_ =~ /^#name/) {
			#print "Entered into the first line loop\n";
			@ucsc_labels = split( '\t',$_);
			print OUT_LOG "Labels read into memory\n";
			next;
		} else {
				# Process a gene
				# Read in all the fields for a given gene
				# $ucsc_gene_info[0] contains the gene ID
				# $ucsc_gene_info[1] contains strand information
				# $ucsc_gene_info[4] contains coding sequence start
				# $ucsc_gene_info[5] contains coding sequence end
				# $ucsc_gene_info[6] contains the number of exons
				# $ucsc_gene_info[7] contains exonStarts
				# $ucsc_gene_info[8] contains exonEnds
				@ucsc_gene_info = split( '\t',$_);
				# print "This gene has $ucsc_gene_info[6] exons\n";
				# print "These are the exonStarts: $ucsc_gene_info[7]\n";
				# print "These are the exonEnds: $ucsc_gene_info[8]\n";
				
				# Place exonStarts and exonEnds into separate arrays
				# Output data in Message formant
				@ucsc_exonStarts = split( ',', $ucsc_gene_info[7]);
				@ucsc_exonEnds = split( ',', $ucsc_gene_info[8]);
			}

    ######################################################################
    # Format message file for output
    # Works correctly for genes with any number of exons, any strand
    ######################################################################
    Format_Message_File();

    # Format coding file for single exon coding sequenes
    if ($ucsc_gene_info[6] == 1) {
        sub Format_Single_Exon_Coding();
        next;
    }
    elsif (($ucsc_gene_info[6] <= 2) && ($ucsc_gene_info[4] > $ucsc_exonEnds[0])) {
        sub Format_Two_Exon_Coding();
        next;
    }
    # Skip Bad Annotation (Genes with > 2 exons, only 1 coding exon)
    # These seem to consist of incorrect genbank entries (often are paired 
    # with a correctly annotation genome sequence
    elsif (($ucsc_gene_info[6] > 2) && ($ucsc_gene_info[5] < $ucsc_exonEnds[0])) {
        next;
    }

    # Reset Variables
    $temp_start = 1;
    $temp_end = 0;
    $coding_start = ($ucsc_gene_info[4] + 1);
    $coding_end = $ucsc_gene_info[5];
    $loop_count = 0;
    $coding_exon_counter = 0;

	# Coding Section for genes more than 2 exons
	if ($ucsc_gene_info[6] >= 2) {
		# print "Entering the coding section, more than 2 exons\n";
		# Process Genes with more than 2 coding exons
		for (my $i = 0; $i < $exon_number; $i++) {
			# Debug Code
			#print "Counter equals $i\n";
			#print "Coding_start equals $coding_start\n";
			#print "ExonEnds is equal to $ucsc_exonEnds[$i]\n";
			# Output beginning of coding sequence (find the beginning)
			# Use for genes with more than 1 coding exon
			if (($coding_start < $ucsc_exonEnds[$i]) && ($loop_count == 0)) {
				#print "Made it into the first loop (coding sequence)\n";
				#print "$coding_start\t$i\t$ucsc_exonEnds[$i]\n";
				print OUT_CODING "$coding_start\t$ucsc_exonEnds[$i]\t";
				print OUT_CODING ("$temp_start\t");
				$temp_end = $ucsc_exonEnds[$i] - $coding_start + $temp_start;
				print OUT_CODING ("$temp_end\t");
				#print OUT_CODING "$ucsc_gene_info[1]\t";
				# Output a 0 for fragments on the + strand
				if ("$ucsc_gene_info[1]" eq "+") {
					print OUT_CODING "0\t";
				}
				# Output a 1 for fragments on the - strand
				if ("$ucsc_gene_info[1]" eq "-") {
					print OUT_CODING"1\t";
				}
				# Exon counting code
				if ($i == 0) {
					print OUT_CODING "$i\n";
					$coding_exon_counter = $i;
				} else {
					print OUT_CODING "$coding_exon_counter\n";
					$coding_exon_counter++;
					}
				$loop_count = 1;
				next;
			}
			
			# Output coding sequence lines - except for the last one
			if (($loop_count == 1) && ($coding_end > $ucsc_exonEnds[$i])) {
				#print "Made it into the second loop (coding sequence)\n";
				print OUT_CODING ($ucsc_exonStarts[$i] + 1) . "\t";
				print OUT_CODING  $ucsc_exonEnds[$i] . "\t";
				$temp_start = $temp_end + 1;
				$temp_end = $ucsc_exonEnds[$i] - ($ucsc_exonStarts[$i] + 1) + $temp_start;
				print OUT_CODING "$temp_start\t$temp_end\t";
				#print OUT_CODING "$ucsc_gene_info[1]\t";
				# Output a 0 for fragments on the + strand
				if ($ucsc_gene_info[1] eq "+") {
					print OUT_CODING "0\t";
				}
				# Output a 1 for fragments on the - strand
				if ($ucsc_gene_info[1] eq "-") {
					print OUT_CODING "1\t";
				}
				# Exon counting code
				if ($coding_exon_counter == 0) {
					print OUT_CODING "$i\n";
				} else {
					print OUT_CODING "$coding_exon_counter\n";
					$coding_exon_counter++;
					}
			}
				
			# Output last coding sequence line
			if (($loop_count == 1) && ($coding_end <= $ucsc_exonEnds[$i])) {
				#print "Made it into the third loop (coding sequence)\n";
				print OUT_CODING ($ucsc_exonStarts[$i] + 1) . "\t";
				print OUT_CODING "$coding_end\t";
				$temp_start = $temp_end + 1;
				$temp_end = $coding_end - ($ucsc_exonStarts[$i] + 1) + $temp_start;
				print OUT_CODING "$temp_start\t$temp_end\t";
				#print OUT_CODING "$ucsc_gene_info[1]\t";
				# Output a 0 for fragments on the + strand
				if ($ucsc_gene_info[1] eq "+") {
					print OUT_CODING "0\t";
				}
				# Output a 1 for fragments on the - strand
				if ($ucsc_gene_info[1] eq "-") {
					print OUT_CODING "1\t";
				}
				# Exon counting code
				if ($coding_exon_counter == 0) {
					print OUT_CODING "$i\n";
				} else {
					print OUT_CODING "$coding_exon_counter\n";
					$coding_exon_counter++;
					}
				#print "Modulus operator returns " . "$temp_end" % 3 . "\n";
				# Perform Check for Coding fragment size
				
				# print "Variable temp_end is: $temp_end\n\n";
				if (($temp_end % 3) != 0) {
					#print OUT_CODING "Modulus operator returns " . "$temp_end" % 3 . "\n";
					#print OUT_CODING "Check the coding sequence above - it appears to be the wrong size!!\n";
					#print OUT_CODING "Observed coding fragment size discrepancy working with file $files!!\n";
					print OUT_LOG "Error in annotation for gene: $ucsc_gene_info[0]\n";
					print OUT_LOG "Modulus operator returns " . "$temp_end" % 3 . "\n";
					print OUT_LOG "Check the coding sequence above - it appears to be the wrong size!!\n";
					print OUT_LOG "Observed coding fragment size discrepancy working with file $files!!\n";
					#print "Observed coding fragment size discrepancy working with file $files!!\n";
				}
				last;
			}
		}
		#print "Exiting the coding section, more than 2 exons\n\n";
	}
		#print "Finished reading a line\n\n";
	}
	#print "Finished processing annotation file.\n\n";
}
close (OUT_MESSAGE);
close (OUT_CODING);
close (IN_ANNOT);
print OUT_LOG "Completed UCSC_process_annotation.pl program.\n";
close(OUT_LOG);
print "Completed UCSC_process_annotation.pl program.\n";
exit;

##############################################################################
### Subroutines
##############################################################################

# Purpose
#   Make message files
#
# Required Parameters
#
# Optional Parameters
#   none
#
# Side Effects
#   none
#
# Assumptions
#
sub Format_Message_File {

######################################################################
# Output annot.message.txt file all genes - works for any number of exons
######################################################################

    # Set variable for a given gene to be processed
    $strand = $ucsc_gene_info[1];
    #print "The strand is equal to $strand\n";
    $exon_number = $ucsc_gene_info[6];
    $temp_start = 1;
    $temp_end = 0;

    for (my $i = 0; $i < $exon_number; $i++) {
        #print "Entering the message subroutine\n";
        # Add 1 to UCSC starts to correct coordinate system
        print OUT_MESSAGE ($ucsc_exonStarts[$i]+1) . "\t";
        print OUT_MESSAGE  $ucsc_exonEnds[$i] . "\t";

        if ($i == 0) {
            print OUT_MESSAGE ("$temp_start\t");
            $temp_end = $ucsc_exonEnds[$i] - ($ucsc_exonStarts[$i] + 1) + $temp_start;
            print OUT_MESSAGE ("$temp_end\t");
        }

        if ($i > 0) {
            $temp_start = $temp_end + 1;
            $temp_end = $ucsc_exonEnds[$i] - ($ucsc_exonStarts[$i] + 1) + $temp_start;
            print OUT_MESSAGE "$temp_start\t$temp_end\t";
        }
        #print OUT_MESSAGE "$ucsc_gene_info[1]\t";
        # Output a 0 for fragments on the + strand
        if ($ucsc_gene_info[1] eq "+") {
            print OUT_MESSAGE "0\t";
        }
        #Output a 1 for fragments on the - strand
        if ($ucsc_gene_info[1] eq "-") {
            print OUT_MESSAGE "1\t";
        }
        #Output fragment number
        print OUT_MESSAGE "$i\n";
    }
}

# Purpose
#   Make message files
#
# Required Parameters
#  none
# Optional Parameters
#  none
#
# Side Effects
#   none
#
# Assumptions
#
sub Format_Single_Exon_Coding() {

$temp_start = 1;
$temp_end = 0;
$coding_start = ($ucsc_gene_info[4] + 1);
$coding_end = $ucsc_gene_info[5];
$loop_count = 0;
$coding_exon_counter = 0;

print "Entered single exon coding";
######################################################################
# Process genes with exonCount = 1, 1 coding fragment,
# Added condition cdsStart > exonEnds[0]
######################################################################
	if ($ucsc_gene_info[6] == 1) {
		print "Entering the 1 exon, 1 coding fragment\n";
			# Print out ucsc coordinates
			print OUT_CODING "$coding_start\t$coding_end\t";
			# Print out relative coordinates
			print OUT_CODING ("$temp_start\t");
			$temp_end = $coding_end - $coding_start + $temp_start;
			print OUT_CODING ("$temp_end\t");
			# Output a 0 for fragments on the + strand
			if ($ucsc_gene_info[1] eq "+") {
				print OUT_CODING "0\t";
			}
			# Output a 1 for fragments on the - strand
			if ($ucsc_gene_info[1] eq "-") {
				print OUT_CODING "1\t";
			}
			# Exon counting code - 1 exon by definition
			print OUT_CODING "0\n";
			if (($temp_end % 3) != 0) {
				#print "Found error in the 1 exon, coding sequence subroutine\n";
				#print OUT_CODING "Modulus operator returns " . "$temp_end" % 3 . " in special 2 message exon code\n";
				#print OUT_CODING "Check the coding sequence above - it appears to be the wrong size!!\n";
				#print OUT_CODING "Observed coding fragment size discrepancy working with file $files!!\n";
				print OUT_LOG "Error in annotation for gene: $ucsc_gene_info[0]\n";
				print OUT_LOG "Modulus operator returns " . "$temp_end" % 3 . "\n";
				print OUT_LOG "Check the coding sequence above - it appears to be the wrong size!!\n";
				#print OUT_LOG "Observed coding fragment size discrepancy working with file $files!!\n";
				#print "Observed coding fragment size discrepancy working with file $files!!\n";
			}
		print "Exiting the 1 exon, 1 coding fragment subroutine\n\n";
		#next;
	}
}

# Purpose
#   Make message files
#
# Required Parameters
#
# Optional Parameters
#   none
#
# Side Effects
#   none
#
# Assumptions
#
sub Format_Two_Exon_Coding() {

######################################################################
# Output coding.txt file
# Code for two exons
######################################################################
$temp_start = 1;
$temp_end = 0;
$coding_start = ($ucsc_gene_info[4] + 1);
$coding_end = $ucsc_gene_info[5];
$loop_count = 0;
$coding_exon_counter = 0;

# Process genes with exonCount = 2, 1 coding fragment, + strand
# Added condition cdsStart > exonEnds[0]
if (($ucsc_gene_info[6] <= 2) && ($ucsc_gene_info[4] > $ucsc_exonEnds[0])) {
	print "Entering the 2 exon, 1 coding fragment\n";
	if (($ucsc_gene_info[6] == 2) && ($coding_start > $ucsc_exonEnds[0])) {
	#print "Made it into special exonCount = 2 exon loop, + strand\n";
	# Print out ucsc coordinates
	print OUT_CODING "$coding_start\t$coding_end\t";
	# Print out relative coordinates
	print OUT_CODING ("$temp_start\t");
	$temp_end = $coding_end - $coding_start + $temp_start;
	print OUT_CODING ("$temp_end\t");
	# Output a 0 for fragments on the + strand
	if ($ucsc_gene_info[1] eq "+") {
		print OUT_CODING "0\t";
	}
	# Output a 1 for fragments on the - strand
	if ($ucsc_gene_info[1] eq "-") {
		print OUT_CODING "1\t";
	}
	# Exon counting code - 1 exon by definition
	print OUT_CODING "0\n";
	if (($temp_end % 3) != 0) {
		#print "Observed error in 2 exon, 1 coding fragment code\n";
		#print OUT_CODING "Modulus operator returns " . "$temp_end" % 3 . " in special 2 message exon code\n";
		#print OUT_CODING "Check the coding sequence above - it appears to be the wrong size!!\n";
		#print OUT_CODING "Observed coding fragment size discrepancy working with file $files!!\n";
		print OUT_LOG "Error in annotation for gene: $ucsc_gene_info[0]\n";
		print OUT_LOG "Modulus operator returns " . "$temp_end" % 3 . "\n";
		print OUT_LOG "Check the coding sequence above - it appears to be the wrong size!!\n";
		#print OUT_LOG "Observed coding fragment size discrepancy working with file $files!!\n";
		#print "Observed coding fragment size discrepancy working with file $files!!\n";
			}
		# Move to next gene
		#print "\n";
		#next was here - bug??
	}
    print "Exiting the 2 exon, 1 coding fragment, + strand\n\n";
    #next;
    }
}












