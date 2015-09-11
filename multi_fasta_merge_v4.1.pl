#!/usr/bin/perl -w
# Michael W. Craige
# Zwick lab - Emory University
# May 08, 2006
#***********************************************************************************************************
# This script locates and process multi-fasta files for Multiple Sequence Alignment and phylogeny prediction
#***********************************************************************************************************
# 1. Counts the number of folders in the working directory (Glob) containing multi-fasta files
# 2. Check each folder for "*.fasta" files, if found then count the number of files.
# 3. Rename all *.fasta found to match HASH values
# 4. Open each multi-fasta sequence file and change headers to match file name (HASH values) 
# 5. Remove the first 7 sequences from each file then merge remaining sequences to create a combined fasta sequence 
# 6. A combined multi-fasta sequence file get written in each folders (phylogeny_multi_fasta.out)
#************************************************************************************************************************
# Define variables and environment
#*********************************
use strict;
use warnings;
use Cwd;
my ($count);
my ($dir);
my $file = shift;
my($key, $value, @fasta_file, $fasta_file_loop, @data_directories, $data_dir_number, $dirname);
#************************************************************
# Print working directory containing folders with fasta files
#************************************************************
print ("\n");
system ("pwd");
print ("\n");
#*****************************************************
# Count number of folders containing multi fasta files 
#*****************************************************
@data_directories = glob("[0-9]*");
$data_dir_number = ($#data_directories + 1);
if ($data_dir_number == 0)
{
die "$data_dir_number data directories not detected.\n
Please check directory. Exiting program";
}
print "Detected $data_dir_number data folders\n\n";
#****************************************************
# Check for files in folders above with suffix .fasta
#****************************************************
print ("Starting to process $data_dir_number folders\n\n");

# Loop over iand move into all working directories
foreach my $dirs (@data_directories) {
chdir ("$dirs");
system ("pwd");
opendir (DIR, ".") || die "Could not open dirrectory";
my @files = grep (/\.fasta$/, readdir(DIR));
$count = @files;
closedir(DIR);
if ($count == 0) {
print " \n$count ", "", "fasta file(s) found in working directory\n";
print "Was not able to find '*.fasta' file(s) in data folder\n\n";

	exit; 
	}
		else
	{

print " \n$count ", "", " fasta files found in working directory\n";
	}
#*******************************************************************
# Create HASH table to change Fasta file names to identifiable names
#*******************************************************************
my (%nameTable) = (	# initialized hash table
# Defining keys and value for renaming files
	"2004_1201_B.anthracisASC245_WGA_S1_R1.DAT.fasta" => "BAN_ASC_245.fasta",
	"2004_1118_Sterne34F2_WGA_S1_R1.DAT.fasta" => "BAN_34F2.fasta",
	"2004_1201_B.thuringiensisNRRL_HD571_WGA_S1_R1.DAT.fasta" => "BTU_HD571.fasta",
	"2004_1015_ATCC10792_WGA_S1_R1.DAT.fasta" => "BTU_ATCC_10792.fasta",
	"2004_1015_ATCC39152_WGA_S1_R1.DAT.fasta" => "BTU_ATCC_39152.fasta",
	"2004_1130_NCTC4041_WGA_S1_R1.DAT.fasta" => "BTU_NCTC_4041.fasta",
	"2004_1007_BTU0003_WGA_S1_R1.DAT.fasta" => "BCE_BGSC_4A1.fasta",
	"2004_1007_BCE0004_WGA_S1_R1.DAT.fasta" => "BCE_BGSC_6A1.fasta",
	"2004_1007_BCE0005_WGA_S1_R1.DAT.fasta" => "BCE_S74.fasta",
	"2004_1007_BCE0008_WGA_S1_R1.DAT.fasta" => "BCE_F3080B.fasta",
	"2004_1007_BCE0009_WGA_S1_R1.DAT.fasta" => "BCE_F3942_87.fasta",
	"2004_1007_BCE0010_WGA_S1_R1.DAT.fasta" => "BCE_F4801_72.fasta",
	"2004_1007_BCE0013_WGA_S1_R1.DAT.fasta" => "BCE_S710.fasta",
	"2004_1007_G9241_WGA_S1_R1.DAT.fasta" => "BCE_G9241.fasta",
	"2004_1015_B33_WGA_S1_R1.DAT.fasta" => "BCE_B33.fasta",
	"2004_1015_ET51B_WGA_S1_R1.DAT.fasta" => "BCE_ET51B.fasta",
	"2004_1015_ET76B_WGA_S1_R1.DAT.fasta" => "BCE_ET76B.fasta",
	"2004_1015_ET79B_WGA_S1_R1.DAT.fasta" => "BCE_ET79B.fasta",
	"2004_1021_B.cereus003130_WGA_S1_R1.DAT.fasta" => "BCE_00-3130.fasta",
	"2004_1114_Bcereus-S363_WGA_S1_R1.DAT.fasta" => "BCE_S363.fasta",
	"2004_1114_Bcereus00-3096_WGA_S1_R1.DAT.fasta" => "BCE_00-3096.fasta",
	"2004_1114_Bcereus97-4144_WGA_S1_R1.DAT.fasta" => "BCE_97-4144.fasta",
	"2004_1114_Bcereus99-5941_WGA_S1_R1.DAT.fasta" => "BCE_99-5941.fasta",
	"2004_1118_BcereusET-33L_WGA_S1_R1.DAT.fasta" => "BCE_ET-33L.fasta",
	"2004_1130_B.cereus00-3037_WGA_S1_R1.DAT.fasta" => "BCE_00-3037.fasta",
	"2004_1130_B.cereus00-3086_WGA_S1_R1.DAT.fasta" => "BCE_00-3086.fasta",
	"2004_1130_B.cereus72-4810_WGA_S1_R1.DAT.fasta" => "BCE_72-4810.fasta",
	"2004_1130_B.cereus95-9130_WGA_S1_R1.DAT.fasta" => "BCE_95-9130.fasta",
	"2004_1130_B.cereusM1292_WGA_S1_R1.DAT.fasta" => "BCE_M1292.fasta",
	"2004_1130_B.cereusSPS2_WGA_S1_R1.DAT.fasta" => "BCE_SPS2.fasta",
	"2004_1201_B.cereus77-2809A_WGA_S1_R1.DAT.fasta" => "BCE_77-2809A.fasta",
	"2004_1201_B.cereus95-2410_WGA_S1_R1.DAT.fasta" => "BCE_95-2410.fasta",
	"2004_1201_B.cereus95-8201_WGA_S1_R1.DAT.fasta" => "BCE_95-8201.fasta",
	"2005_1026_Bce10987_WGA_S1_R1.DAT.fasta" => "BCE_10987.fasta",
	"2005_1026_Bce14579_WGA_S1_R1.DAT.fasta" => "BCE_14579.fasta",
	"2004_1015_B548_WGA_S1_R1.DAT.fasta" => "BMY_B548.fasta",
	"2004_1015_ATCC6423_WGA_S1_R1.DAT.fasta" => "BMY_ATCC_6423.fasta",
	"2004_1130_B.mycoidesB951_WGA_S1_R1.DAT.fasta" => "BMY_B951.fasta",
	"2004_1021_B518_WGA_S1_R1.DAT.fasta" => "BMY_B518.fasta",
	"2004_1201_B.megaterium98-3792_WGA_S1_R1.DAT.fasta" => "BMG_98_3792.fasta",
	"2004_1118_BSU0001_BGSC1A1_WGA_S1_R1.DAT.fasta" => "BSU_BGSC1A1.fasta",
	"2004_1114_BGSC1A2_WGA_S1_R1.DAT.fasta" => "BSU_BGSC1A2.fasta",
);
while ( ($key, $value) = each %nameTable ) {
	rename ($key, $value);
}
#****************************************************************
# Merge and concatenate multiple fasta files with suffix (.fasta)
# to create large Fasta sequence for MSA 
#****************************************************************
# Define BioPerl Variables and Environment
use Bio::SeqIO;
use Bio::PrimarySeq;

# Create array for input file and Unique file IDs 
@ARGV = values %nameTable;

# Processing multiple fasta files with the suffix (.fasta)
print "\nStarting to process individual multi fasta files .....please wait\n";

# Read input sequence files and create output (.OUT) file
my $out_o = Bio::SeqIO->new(-file => (">" . "$dirs" . ".phylogeny_multi_fasta.out"),
                            -format => 'fasta'
                            ) || die "Program ended, unable to create OUTPUT file.\n";

# Create array to slurp and manipulate multiple FASTA sequences within all .fasta files
for my $file (@ARGV){
    my $UID = "$file";
    my $in_o = Bio::SeqIO->new (-file => "$file",
                                -format => 'fasta'
				) || die "Program ended because $file was not found\n";

# Create temp file to store unique id name for each sequence and remove identifier (header)
my $temp_seq = Bio::PrimarySeq->new (-seq =>'',
					-id => 'null',
					-alphabet => 'dna');

# Write out sequences starting with the 8th and later with unique identifier to output file
    my $i=0;
    while  (my $seq = $in_o->next_seq){
	my ($prefix) = ($seq->primary_id =~ /(^.+_)\d+$/);

	$temp_seq->id($UID);
        $temp_seq->seq($temp_seq->seq . $seq->seq) if $i >= 7;
        $i++;
    	}
	$out_o->write_seq($temp_seq);
	$UID;
}
chdir ("..");
}
print "\nAll done, check 'phylogeny_multi_fasta.out'. Thank you!\n\n";
