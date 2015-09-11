#!/usr/bin/perl -w
# Version 1.0
# Michael E. Zwick
# 7/28/2010
################################################################################
# Program designed to:
# 1. Run over multiple multifasta files all found within a single folder. The 
# individual files contain protein or DNA sequences from a single 
# individual/strain.
# 2. Output the data into strain specific files, concatenating sequences from 
# different files
# 3. Merge all individual strain/individual files into a single large multifasta # file
# Execute: From withing folder containing files of interest
################################################################################

################################################################################
# Include standard modules
################################################################################
use strict;
use Cwd;
################################################################################
# Local variable definitions
################################################################################

my(@data_files, $data_file_number, $files, @all_lines, @fasta_file, $dirname, $strain_ID, $file_count);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

$file_count = 0;

################################################################################
# Main Program Code
# Program Overview:
# Get all directory names
# Define fasta_file_number above, loop over all file numbers
# Write/Append sequence for same individual to different files
################################################################################

# Get current working directory
$dirname = getcwd();

# Make Output directory
mkdir("Output");

# Open for output of log files
open(OUT_LOG, ">", "$dirname/log.MERGE.multiplefasta.to.multifasta.singlefolder.out") or die "Cannot open OUT_FASTA for data output";

################################################################################
# Obtain names of all files in a directory
################################################################################
@data_files = glob("*.fasta");
$data_file_number = ($#data_files + 1);
if ($data_file_number == 0) {
	die "$data_file_number data directories detected.\n
	Check directory. Exiting program";
}
print OUT_LOG "Detected $data_file_number data files\n";
print OUT_LOG "File names include:\n";
#print OUT_LOG "@data_files\n";

################################################################################
# Main loop in program
# Process each fasta file, loop over all files
################################################################################
foreach my $files (@data_files) {

  # Open $files to be read
  open (FILEHANDLE_FIRST, "<", "$files") or die "Cannot open FILEHANDLE_FIRST filehandle to read file";
  print ("Processing file: $files\n");
  
  # Process First File
  # Get Fasta header names
  if ($file_count == 0) {
  
    # Read in text from first $file, output to OUT_ANNOT file
    while (<FILEHANDLE_FIRST>) {
      chomp($_);
      #Debug: print "$_\n";
  
      # Read strain-individual name from FASTA header
      if(($_ =~ />/)) {
        # Debug: print "Entering first if loop \n";
        
        # Select substring without > character
        $strain_ID = substr($_, 1);
        #Debug: print "$strain_ID\n";
      
        # Open output filehandle with $strain_ID name
        open (OUT_FASTA, ">>", "$dirname/Output/$strain_ID") or die "Cannot open OUT_FASTA filehandle to read file";
      
        # Write out FASTA header
        print OUT_FASTA ">" . "$strain_ID\n";
      } else {
          # Debug: print "Entering first file, final else loop \n";
          # Write lines to output file that contain protein-DNA sequence data
          print OUT_FASTA "$_";
        }
    }
  }
  # Process Later Files
  # Ignore Fasta header names
  if ($file_count > 0) {
  
    # Read in text from later $file, output to OUT_ANNOT file
    while (<FILEHANDLE_FIRST>) {
    chomp($_);
    #Debug: print "$_\n";
  
      # Read strain-individual name from FASTA header
      if(($_ =~ />/)) {
        # Debug: print "Entering first if loop, later files\n";
        
        # Select substring without > character
        $strain_ID = substr($_, 1);
        #Debug: print "$strain_ID\n";
      
        # Open output filehandle with $strain_ID name
        open (OUT_FASTA, ">>", "$dirname/Output/$strain_ID") or die "Cannot open OUT_FASTA filehandle to read file";

      } else {
          # Debug: print "Entering later file, final else loop \n";
          # Write lines to output file that contain protein-DNA sequence data
          print OUT_FASTA "$_";
        }
    }
  }
  close (FILEHANDLE_FIRST);
  # Increment $file_count
  $file_count++;
  print OUT_LOG "Successfully processed file $files.\n";
}
print OUT_LOG "Processed $file_count files\n";
print OUT_LOG "Completed MERGE.multiplefasta.to.multifasta.singlefolder\n";
close(OUT_LOG);
print "Processed $file_count files\n";
print "Completed MERGE.multiplefasta.to.multifasta.singlefolder\n";



































