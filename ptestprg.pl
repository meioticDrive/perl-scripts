#!/usr/bin/perl -w
# Test Program
#-------------------------------------------------------------------------------
use vars qw(@home $potato $lift $tennis $pipe);

@home = ("couch", "chair", "table", "stove");
($potato, $lift, $tennis, $pipe) = @home;

printf "$potato\t $lift\t $tennis\t $pipe\n";