#!/usr/bin/perl -w
# Program designed to read names of all .DAT files (pass through multiple
# directories), place into a text file
# The directory structure assumed as follows:
# Chip_Design_Scanned_Chips[FOLDER]
#    Date[FOLDER]
#       .DAT[FILES]
#        exp_files[FOLDER]
# Program should:
# 1. Read the names of all Date[FOLDER]
# 2. For each Date[FOLDER], read the names of all .DAT[FILES]
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use strict;

#-------------------------------------------------------------------------------
# Variable definitions
#-------------------------------------------------------------------------------
# Define local variables for file manipulations
my(@all_dirs, @filess, $dirname, $file, $file_name, $date_exp, $count);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------
# Set to current working directory
# Get all directories (name by date)
# Open new output data file handle
# Determine localtime - fill variables
#-------------------------------------------------------------------------------
system ("rm *.txt");
$dirname = ".";          
@all_dirs = glob "*";    

#-------------------------------------------------------------------------------
# Code to enable file names in my favorite format: YYYY_MM_DD_somename
# File names need to have same number if digits to sort correctly - for example, months
# always have to have two digits, days always have to have two digits also
# Uses localtime function and ensures month and day are correct
# First: Both month and day single digit
# Second: Month single digit, day double digits
# Third: Month double digits, day single digit
# Fourth: Both month and day double digits
#-------------------------------------------------------------------------------
($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime();
if ($mon < 10 && $mday < 10) {
	open OUT_TEXT, ">" . (1900 + $year) . "_" . "0" . ($mon+1) . "0" . $mday . "_" . "dat_files.txt";
}
elsif ($mon < 10 && $mday > 9) {
	open OUT_TEXT, ">" . (1900 + $year) . "_" . "0" . ($mon+1) . $mday . "_" . "dat_files.txt";
}
elsif ($mon > 9 && $mday < 10) {
	open OUT_TEXT, ">" . (1900 + $year) . "_" . ($mon+1) . "0" . $mday . "_" . "dat_files.txt";
}
else {
	open OUT_TEXT, ">" . (1900 + $year) . "_" . ($mon+1) . $mday . "_" . "dat_files.txt";
}

#-------------------------------------------------------------------------------
# Loop over all dirs containing files
#-------------------------------------------------------------------------------
foreach $date_exp (@all_dirs) { 

	#---------------------------------------------------------------------------
	# Print dir name
	# Patch up the path
	# Change directory
	# Get all .DAT files
	#---------------------------------------------------------------------------
	print OUT_TEXT "\nDirectory (Experiment Date): $date_exp\n";  
	$dirname = "$dirname/$date_exp";                        
	chdir "$dirname" || die "Cannot chdir $dirname/$file. Exiting loop";
    @filess = glob "*.DAT";                              
    
    #-------------------------------------------------------------------------------
	# Loop over all files within dir
	#-------------------------------------------------------------------------------
    foreach $file_name (@filess) {
    
    	#-----------------------------------------------------------------------
    	# Count .DAT files
    	# Output filename to .txt file
    	#-----------------------------------------------------------------------
    	$count +=1;                         
    	print OUT_TEXT "$file_name\n";      
     }
     #--------------------------------------------------------------------------
     # Reset directory name to initial value
     # Go up one directory
     #--------------------------------------------------------------------------
     $dirname = ".";
     chdir "../";
}

#-------------------------------------------------------------------------------
# Output to file final count of .DAT files
# Output to file: time that program was run
# Output program completion statement
# Close output file
#-------------------------------------------------------------------------------
print OUT_TEXT "\n";
print OUT_TEXT "Total of $count .DAT files\n";

if ($hour < 10 && $min < 10) {
	print OUT_TEXT "Program run at " . "0" . $hour . ":" . "0" . $min;
}	
elsif ($hour < 10 && $min > 9) {
	print OUT_TEXT "Program run at " . "0" . $hour . ":" . $min;
}
elsif ($hour > 9 && $min < 10) {
	print OUT_TEXT "Program run at " . $hour . ":" . "0" . $min;
}
else {
	print OUT_TEXT "Program run at " . $hour . ":" . $min;
}

print OUT_TEXT "\nSuccessfully completed getdat_name.pl program.\n";
print OUT_TEXT "\n";
close OUT_TEXT;

#-------------------------------------------------------------------------------
# Move text file to abacus_log directory
#-------------------------------------------------------------------------------
system ("mv -i *.txt ../abacus_log");
