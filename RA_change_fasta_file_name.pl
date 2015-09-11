#!/usr/bin/perl
##############################################################################
### Name: RA_change_fasta_labels.pl
### Version 1.0
### Date: 02/15/2007
### Author: Michael E. Zwick
##############################################################################
### 1. The purpose of this script is to change the name of fasta labels from ### one name to another. The # hash %chip_strain contains the chip output 
### names and the new names.
### 2. Process multiple fasta files in the same directory
### 3. Launch script from within folder containing files
##############################################################################

use warnings;
use strict;
use Cwd;

# Define local variables
my(%chip_strain, @chip_files, $chip_file_nmbr);

# Populate the %chip_strain hash with chip names and reference file to use for comparison
%chip_strain = (
'2005_0126_ASC159_10ng_WGA300kb_20ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_003',
'2005_0127_LSU442_10ng_WGA300kb_20ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_038',
'2005_0223_A0039_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_012',
'2005_0223_A0174_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_019',
'2005_0223_A0328_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_024',
'2005_0223_A0379_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_027',
'2005_0223_A0419_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_036',
'2005_0223_A0465_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_040',
'2005_0223_ASC050_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_030',
'2005_0223_ASC054_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_031',
'2005_0223_ASC285_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_016',
'2005_0330_A0034_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_029',
'2005_0330_A0193_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_034',
'2005_0330_A0248_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_014',
'2005_0330_A0463_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_028',
'2005_0330_A0489_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_037',
'2005_0330_ASC006_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_021',
'2005_0330_ASC069_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_011',
'2005_0330_ET-76B_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_004',
'2005_0406_ASC004_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_035',
'2005_0406_ASC014_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_018',
'2005_0406_ASC015_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_013',
'2005_0406_ASC016_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_025',
'2005_0406_ASC031_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_020',
'2005_0406_ASC038_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_022',
'2005_0406_ASC061_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_023',
'2005_0406_ASC065_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_026',
'2006_1018_CRP-BACI008-001-WGA300kb_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_039',
'2006_1018_CRP-BACI008-003P-WGA300kb_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_007',
'2006_1018_CRP-BACI055-001-WGA300kb_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_033',
'2006_1018_CRP-GT3-007-WGA300kb_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_010',
'2006_1018_CRP-GT28-02A1-WGA300kb_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_008',
'2006_1018_CRP-GT41-001-WGA300kb_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_005',
'2006_1018_CRP-GT68-003-WGA300kb_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_006',
'2006_1018_CRP-VOLLUM-002-WGA300kb_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_017',
'2007_0323_CRP-AMES-004-WGA300KB_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_032',
'2007_0323_CRP-DELTA-AMES-004-WGA300KB_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_041',
'2007_0419_CRP-BACI056-001-WGA300kb_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_009',
'2007_0817_7702-2-WGA300KB_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta' => 'BAN_015',
);


##############################################################################
# Read in all .fasta files from directory
@chip_files = glob("*.fasta") 
	or print "\nNo fasta files found\n";
$chip_file_nmbr = ($#chip_files + 1);
print "Found $chip_file_nmbr .fasta files\n";


foreach my $process_file (@chip_files) {

print "Original File Name: $process_file\n";
print "Change File Name to: $chip_strain{$process_file}\n";

	rename ($process_file, $chip_strain{"$process_file"});
	
}

print "Completed RA_change_fasta_file_name.pl\n";


