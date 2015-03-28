#/usr/bin/perl 
use strict;
use warnings;

my $file1;
my $file2;

# @ARGV

print "the command line arguments are @ARGV\n";
print "the command line arguments are ", join(',',@ARGV),"\n";
 $file1 = $ARGV[0];
 $file2 = $ARGV[1];

`bl2seq -i $file1 -j $file2 -p blastp -o 7less.from_perl.blastp`;

