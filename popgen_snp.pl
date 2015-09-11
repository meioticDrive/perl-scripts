#!/usr/bin/perl -w
# Program designed to read names of all .DAT files (pass through multiple
# directories), place into a text file
# The directory structure assumed as follows:
# Chip_Design_Scanned_Chips[FOLDER]
#    Date[FOLDER]
#       .DAT[FILES]
#        EXP_Files[FOLDER]
# Program should:
# 1. Read the names of all Date[FOLDER]
# 2. For each Date[FOLDER], read the names of all .DAT[FILES]
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use strict;

#-------------------------------------------------------------------------------
# Variable Definitions
#-------------------------------------------------------------------------------
my(@files, @fasta_first, $file_number, $fasta_files, $count, $i, $j, @snp_first, @snp_second, @fasta_names, @snp_pos, $snp_nmbr);

#-------------------------------------------------------------------------------
# SNP Information from anthrax.popgen.xls file, from composite fasta files
# Number of SNPs, SNP positions relative to genbank file, clear old output file
#-------------------------------------------------------------------------------
$snp_nmbr = 37;
@snp_pos = qw(129567 132396 132398 132400 132436 132632 133691 133763 135261 230830 231160 232881 233325 233845 234679 235203 235375 235765 236255 4377582 4377773 4378229 4379182 4383141 382345 385885 386053 386104 386674 386909 387228  388076 789100 789687 790977 793036 793636);
system("rm snp_out.txt");

#-------------------------------------------------------------------------------
# Obtain the names of all the *.fasta files in a directory
# Determine the number of files
#-------------------------------------------------------------------------------
@files = glob("*.popgen.txt");
$file_number = ($#files + 1);

#-------------------------------------------------------------------------------
# print "The number of fasta files is $file_number\n";
# Check for file error conditions - no file present, more than 1 file present
#-------------------------------------------------------------------------------
if ($file_number == 0) {
    die "Error! No popgen file present. Check directory. Exiting program";
}
if ($file_number > 1) {
    die "Error! Too many popgen files present. Check directory. Exiting program";
}
	#---------------------------------------------------------------------------
	# FileHandle For Reading from Popgen file
	#---------------------------------------------------------------------------
	open(FILEHANDLE_FIRST, "<", $files[0]) 
        || die "Cannot open FILEHANDLE_FIRST";

	#---------------------------------------------------------------------------
	# Open Data Output Filehandles
	#---------------------------------------------------------------------------
	open(FILEHANDLE_OUT_1, ">", "snp_out.txt")
		|| die "Cannot open FILEHANDLE_OUT_1";

while (defined(my $first_fh = <FILEHANDLE_FIRST>)) {

	#---------------------------------------------------------------------------
	# Get line containing number of fasta files
	# Split line, assign to @snp_first, verify elements
	# Should read only 1 line
	#---------------------------------------------------------------------------
	if($first_fh =~ m/Number of Fasta Files to Process/) {
		@snp_first = split(/,/, $first_fh);
		# Verify first line read is correct
		if (($i = (@snp_first)) != 2) { 
			die "Error. Too many variables in array snp_first. Exiting";
		}
		$fasta_files = $snp_first[1];
		#print "The number of fasta files is $fasta_files";
		#print "The number of elements in snp_first is $i\n";
		#print FILEHANDLE_OUT_1 $first;
	}
	#---------------------------------------------------------------------------
	# Get lines containing fasta file names from popgen file
	# Get number of elements in array, assign to $j
	# Even number elements of array contain fasta file names
	# Move fasta file names into @fasta_names
	#---------------------------------------------------------------------------
	if($first_fh =~ m/Please Enter Name/) {
		push @snp_second,   (split(/,/, $first_fh));
		$j = (@snp_second);
		for (my $k = 0; $k < $j; $j = $j + 2) {
			$fasta_names[$k] = $snp_second[$j];
		}
		#$j = $#snp_second; #nmbr elements - 1
		#print "The number of elements in array snp_second is $j\n";
		#print FILEHANDLE_OUT_1 $first;
	}
	
	# Get total sites line popgen file
	# Figure way to print out next lines
	if($first_fh =~ m/Total Segregating Sites/) {
		print FILEHANDLE_OUT_1 $first_fh;
	}
	
	# Get SNP lines from popgen file
	# Figure out general solution
	if($first_fh =~ m/nmrc_   /) {
		print FILEHANDLE_OUT_1 $first_fh;
	}
	

	
}


close(FILEHANDLE_FIRST);

close(FILEHANDLE_OUT_1);


	# Verify correct number of elements
	#	if (($j = (@snp_second)) != ($fasta_files*2)) {
	#		die "Error. Wrong number off elements in array snp_second. Exiting";
	#	}
	

print "hello world.\n";





