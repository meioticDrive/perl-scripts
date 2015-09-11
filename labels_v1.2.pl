#!/usr/bin/perl -w
# Michael W. Craige
# Renaming Multi-fasta files
use strict;
use warnings;
my($key, $value);
# Create Hash Table
my (%nameTable) = (	# initialized hash table
# Defining keys and value for renaming files
'>BAN_ASC_245.fasta'	=>	'BAN_001',
'>BAN_34F2.fasta'	=>	'BAN_002',
'>BCE_ET51B.fasta'	=>	'BAN_004',
'>BCE_BGSC_6A1.fasta'	=>	'BCE_001',
'>BCE_S74.fasta'	=>	'BCE_002',
'>BCE_F3080B.fasta'	=>	'BCE_003',
'>BCE_F3942_87.fasta'	=>	'BCE_004',
'>BCE_F4801_72.fasta'	=>	'BCE_005',
'>BCE_S710.fasta'	=>	'BCE_006',
'>BCE_G9241.fasta'	=>	'BCE_007',
'>BCE_B33.fasta'	=>	'BCE_008',
'>BCE_00-3130.fasta'	=>	'BCE_012',
'>BCE_S363.fasta'	=>	'BCE_013',
'>BCE_00-3096.fasta'	=>	'BCE_014',
'>BCE_97-4144.fasta'	=>	'BCE_015',
'>BCE_99-5941.fasta'	=>	'BCE_016',
'>BCE_ET-33L.fasta'	=>	'BCE_017',
'>BCE_00-3037.fasta'	=>	'BCE_018',
'>BCE_00-3086.fasta'	=>	'BCE_019',
'>BCE_72-4810.fasta'	=>	'BCE_020',
'>BCE_95-9130.fasta'	=>	'BCE_021',
'>BCE_M1292.fasta'	=>	'BCE_022',
'>BCE_SPS2.fasta'	=>	'BCE_023',
'>BCE_77-2809A.fasta'	=>	'BCE_024',
'>BCE_95-2410.fasta'	=>	'BCE_025',
'>BCE_95-8201.fasta'	=>	'BCE_026',
'>BCE_10987.fasta'	=>	'BCE_027',
'>BCE_14579.fasta'	=>	'BCE_028',
'>BCE_ET76B.fasta'	=>	'BCE_029',
'>BCE_ET79B.fasta'	=>	'BCE_030',
'>BMG_98_3792.fasta'	=>	'BMG_001',
'>BMY_B548.fasta'	=>	'BMY_001',
'>BMY_ATCC_6423.fasta'	=>	'BMY_002',
'>BMY_B951.fasta'	=>	'BMY_003',
'>BMY_B518.fasta'	=>	'BMY_004',
'>BSU_BGSC1A1.fasta'	=>	'BSU_001',
'>BSU_BGSC1A2.fasta'	=>	'BSU_002',
'>BTU_HD571.fasta'	=>	'BTU_001',
'>BTU_ATCC_10792.fasta'	=>	'BTU_002',
'>BTU_ATCC_39152.fasta'	=>	'BTU_003',
'>BTU_NCTC_4041.fasta'	=>	'BTU_004',
'>BCE_BGSC_4A1.fasta'	=>	'BTU_005',

);
while ( ($key, $value) = each %nameTable ) {
	rename ($key, $value);
 }

# End of Script
