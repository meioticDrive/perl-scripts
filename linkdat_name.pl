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
use vars qw(@all_dirs @filess $dirname $file $file_name $date_exp $count);


#-------------------------------------------------------------------------------
my $dirname = ".";          # Set to current working directory
my @all_dirs = glob "*";    # Get all directories

open OUT_TEXT, ">linkdat_files.txt";  #Open new output data file handle

#-------------------------------------------------------------------------------
foreach $date_exp (@all_dirs) { #Loop over all dirs containing files
    
    #print OUT_TEXT "\nDirectory (Experiment Date): $date_exp\n"; #Print dir name 
    
    $dirname = "$dirname/$date_exp";                        #Patch up the path
    chdir "$dirname" || die "Cannot chdir $dirname/$file. Exiting loop";
    my @filess = glob "*.DAT";                              #Get all .DAT files
    #--------------------------------------------------------------------------
        foreach $file_name (@filess) {      #Loop over all files within dir
        
        system "ln -s /Users/michaelzwick/Documents/05-Software_Projects/reseq_2/dat_files/$date_exp/$file_name ../../anthrax";
        $count +=1;                         #count .DAT files
        #print OUT_TEXT "$file_name\n";               #Output filename to .txt file
     }
     #--------------------------------------------------------------------------
     
     
     $dirname = ".";
     chdir "../";
}
print OUT_TEXT "\n";
print OUT_TEXT "Total of $count .DAT files linked for ABACUS\n";
print OUT_TEXT "Successfully completed linkdat_name.pl program.\n";
print OUT_TEXT "\n";

close OUT_TEXT;

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Improvements
# 1. incorporate date into file name: year_mon_day_dat_files (maybe chip design)
# 2. check to see if file of the same name exists (do I want to overwrite)
# 3. Here is the link command: ln -s target files directory location

