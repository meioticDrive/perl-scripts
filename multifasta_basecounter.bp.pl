#!/usr/bin/perl 
#-------------------------------------------------------------------------------
#
# MultiFasta Base Counter
#	Andrew Stewart
#	Navy Medical Research Center
#	Biological Defense Research Directorate
# 	astew@umd.edu
#

=head1 NAME

MultiFasta Base Counter

=head1 SYNOPSIS

% mfasta_basecount.pl filename

=head1 DESCRIPTION

Inputs a mfasta file and outputs the number of bases for each type (A,T,G,C,N)

=head1 AUTHOR

Andrew Stewart, astew@wam.umd.edu

=cut

use strict;
use Bio::Perl;
use Bio::Tools::SeqStats;

#-------------------------------------------------------------------------------
# Initialization
my ($MFASTA);

#-------------------------------------------------------------------------------
# Parameters
$MFASTA = shift @ARGV;

#-------------------------------------------------------------------------------
# Main

# Input multi fasta file
my $seqo = Bio::SeqIO->new(
	-file	=> $MFASTA,
	-format	=> 'Fasta');
	
# Iterate through sequences, performing base counts for each and printing to
# standard output.
print "id\tA\tT\tC\tG\tN\n";
while ( my $seq = $seqo->next_seq() ) {
	print ">" . $seq->id() . "\t";
	my $hash_ref = Bio::Tools::SeqStats->count_monomers($seq);
	print %$hash_ref->{'A'} . "\t";
	print %$hash_ref->{'T'} . "\t";
	print %$hash_ref->{'C'} . "\t";
	print %$hash_ref->{'G'} . "\t";
	print %$hash_ref->{'N'} . "\n";
}