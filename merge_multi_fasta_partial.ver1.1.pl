#!/usr/bin/perl -w
# Michael W. Craige
# March 28, 2006
#*************************************************************
# 1. Check for multi sequence (*.fasta) files in a working directory (exist if no files)
#
# 3. Remove fasta sequences 001 through 007 from within each multi fasta sequence files 
#
# 4. Merge and concatenate all remaining multi fasta sequences (008 through 012) into an output file
#
# 5. Individual merge sequences are then separated by unique identifier_id ( >30kb_NN_nmrc_008_1)
#*************************************************************
#
use Bio::SeqIO;
use Bio::PrimarySeq;
use strict;
use warnings;
use Cwd;
my ($count);
my ($dir);
#
#*************************************************************
#
print ("\n");
system ("pwd");
print ("\n");
#
#***************************************************************
# Search and count files in working directory with suffix .fasta
#***************************************************************
opendir (DIR, ".") || die "Could not open directory";
my @files = grep (/\.fasta$/, readdir(DIR));
$count = @files;
closedir(DIR);
if ($count == 0) {
	print ("\n");
	system("pwd");
	print " \n$count ", "", "fasta file(s) found in working directory\n";
	print "Was not able to find '*.fasta' file(s) in your working directory\n\n";
	exit; 
}
else {
	print " \n$count ", "", " fasta files found in working directory\n";
	#
	#*******************************************************************
	# Merge and concatenate multiple fasta files with the suffix (.fasta)
	#*******************************************************************
	print "\nStarting to process individual multi fasta files .....please wait\n";
}

# Read input sequence files and create output (.OUT) file
my $out_o = Bio::SeqIO->new(-file => ">phylogeny_multi_fasta.out",
                            -format => 'fasta'
                            ) || die "Program ended, unable to create OUTPUT file.\n";

my $UID = 1;

# Create array to slurp and manipulate multiple FASTA sequences within all .fasta files
for my $file (@ARGV){
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

	$temp_seq->id($prefix.$UID);
        $temp_seq->seq($temp_seq->seq . $seq->seq) if $i >= 7;
        $i++;
    	}
	$out_o->write_seq($temp_seq);
	$UID++;
}

print "\nAll done, check 'phylogeny_multi_fasta.out'. Thank you!\n\n";
