#!/usr/bin/perl

##!/home/tswingo3/perl5/perlbrew/perls/perl-5.15.8/bin/perl

# Name: seqant2ped_map.pl
# Description: take seqant output and make a pedigree / map file
# Date created: Mon Apr 16 10:46:40 2012
# Date last modified: Mon Apr 16 10:46:40 2012
# By: TS Wingo

use strict;
use warnings;

my $seqant_dir = $ARGV[0];
my $id_file = $ARGV[1];
my $output_ext = $ARGV[2];
my (%chet, %demo, %geno, %het, %hom, %markers, %markers_info) = ( );

if (@ARGV != 3) {
	print "Usage: $0 <seqant_dir with annotation files> <ids of individuals sequenced> <output extension>\n";
	exit 1;
}

open(in_IDS, "<", "$id_file") || die "Cannot open '$id_file', $!.\n";
while (<in_IDS>) {
	next if ($_ =~ m/^#/);
	chomp $_;
	my @line = split(/\s+/, $_);
	if (@line == 3) {
		my ($id, $sex, $aff) = split(/\s+/, $_);
		$demo{$id} = "0 $id 0 0 $sex $aff";
	} elsif (@line == 1) {
		my $id = $line[0];
		$demo{$id} = "0 $id 0 0 0 0";
	} else {
		print "ERROR *** " x 4 . "\n";
		print "\tThe ID file, '$id_file,' must have either 1 column with just ids or 3 columns\n";
		print "\twith id, sex, affectation status that are separated by a tab or space.\n";
		exit 1;
	}
}

foreach my $file (glob("$seqant_dir/*.SNP.Annotation*txt")) {
	print "processing $file...\n";
	open (my $fh, "<", $file) || die "Cannot open '$file', $!.\n";
	while (<$fh>) {
		next if (($. == 1));
		chomp $_;
		my @fields = split(/\t/, $_);
		next if (@fields != 31);
		my $chr = $fields[0];
		my $pos = $fields[1];
		my $gene_symb = $fields[2];
		my $ref_base = $fields[5];
		my $allele = $fields[6];
		my ($org_aa, $new_aa, $rep);
		if ($fields[8] =~ m/---/) {
			$org_aa = "NA";
			$new_aa = "NA";
			$rep = 0;
		} elsif ($fields[8] =~ m/(^[A-Z]{1})/) {
			$org_aa = $1;
			#print "Original Amino acid is $org_aa\t\t";
			$new_aa = $fields[10];
			#print "New Amino acid is $new_aa\n";
			if ($org_aa eq $new_aa) {
				$rep = 0;
			} else {
				$rep = 1;
			}
		} else {
			die "Something went wrong with the Amnio Acid Substitution thing.\n";
		}
		#print "'$org_aa' '$new_aa'\n";
		my @variant_name = ( );
		if ($fields[13] =~ m/---/) {
			$variant_name[0] = "$chr\_$pos";
		} else {
			@variant_name = split(/,/, $fields[13]);
		}
		my @maf = ( ); 
		if ($fields[14] =~ m/---/) {
			$maf[0] = "NA";
		} else {
			@maf = split(/,/, $fields[14]);
		}
		my $phastcons = ($fields[16] + $fields[17] + $fields[18]) / 3;
		my $num_obs = $fields[19] + $fields[21] + $fields[23] + $fields[25] + $fields[27] + $fields[29];
		my @hom_snp = split(/,/, $fields[20]) unless $fields[19] == 0;
		my @het_snp = split(/,/, $fields[22]) unless $fields[21] == 0;
		my @hom_del = split(/,/, $fields[24]) unless $fields[23] == 0;
		my @het_del = split(/,/, $fields[26]) unless $fields[25] == 0;
		my @hom_ins = split(/,/, $fields[28]) unless $fields[27] == 0;
		my @het_ins = split(/,/, $fields[30]) unless $fields[29] == 0;

		my %temp_geno = ( );

		# make genotypes for homozygous snps
		foreach my $id (@hom_snp) {
			$temp_geno{$id} = "$allele $allele";
			$hom{$variant_name[0]}{$id}++;
		}
		foreach my $id (@hom_del) {
			$temp_geno{$id} = "$allele $allele";
			$hom{$variant_name[0]}{$id}++;
		}
		foreach my $id (@hom_ins) {
			$temp_geno{$id} = "$allele $allele";
			$hom{$variant_name[0]}{$id}++;
		}

		# make genotypes for het snps
		foreach my $id (@het_snp) {
			$temp_geno{$id} = "$allele $ref_base";
			$het{$variant_name[0]}{$id}++;
		}

		foreach my $id (@het_del) {
			$temp_geno{$id} = "$allele $ref_base";
			$het{$variant_name[0]}{$id}++;
		}
		
		foreach my $id (@het_ins) {
			$temp_geno{$id} = "$allele $ref_base";
			$het{$variant_name[0]}{$id}++;
		}
		# make final genotypes for everyone
		foreach my $id (keys %demo) {
			if (exists($temp_geno{$id})) {
				$geno{$id}{$variant_name[0]} = $temp_geno{$id};
			} else {
				$geno{$id}{$variant_name[0]} = "$ref_base $ref_base";
			}
		}
		$markers{$variant_name[0]} = "$chr $variant_name[0] 0 $pos";
		$markers_info{$variant_name[0]} = "$gene_symb $num_obs $maf[0] $rep $phastcons";
	}
	close($fh);
}

# write pedigree file
open(outPED, ">", "$output_ext.ped") || die "Cannot open '$output_ext.ped', $!.\n";
foreach my $id (sort keys %geno) {
	print outPED "$demo{$id}";
	foreach my $marker (sort keys %{ $geno{$id} }) {
		print outPED " $geno{$id}{$marker}";
	}
	print outPED "\n";
}
close(outPED);

# write marker file
open(outMAP, ">", "$output_ext.map") || die "Cannot open '$output_ext.map', $!.\n";
foreach my $marker (sort keys %markers) {
	print outMAP "$markers{$marker}\n";
}
close(outMAP);

# write marker data file
# columns: name, gene symbol, # obs, MAF, replacement/non-replacement, avg phastcons score
open(outMARKERINFO, ">", "$output_ext.markerinfo.txt") || die "Cannot open '$output_ext.markerinfo.txt', $!.\n";
foreach my $marker (sort keys %markers_info) {
	print outMARKERINFO "$marker $markers_info{$marker}\n";
}
close(outMARKERINFO);

exit;
