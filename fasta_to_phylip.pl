#!/usr/bin/perl
#
# Name: fasta_to_phylip
# Version: 1.0
# Date: 02/01/2007
# Author: Michael E. Zwick
#--------------------------------------------------------------------------------------------
# 1. The purpose of this script is to change a multi-fasta file into Phylip format.
# 2. Uses Bioperl
#--------------------------------------------------------------------------------------------

use strict;
use warnings;
use Cwd;
use Bio::SeqIO;

my ($in, $out);






$in  = Bio::SeqIO->new(-file => "test.out",
                       -format => 'Fasta');
$out = Bio::SeqIO->new(-file => ">test.phylip",
                       -format => 'phylip');
while ( my $seq = $in->next_seq() ) {$out->write_seq($seq); }