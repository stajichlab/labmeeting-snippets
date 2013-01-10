#!/usr/bin/perl  
use strict;
use warnings;

my $counter = 1;
my $format = "freq";
my $format2 = "frq";
my @buffer =();
my @fileList = ();
print "#################################\n";
print "\n";
print "This program will clean up all your freq file in current folder.\n";
print "Any sequence less than 50bp long will be ignored. \n";
print "A new fasta format file for each input freq file. \n";
print "\n";
print "#################################\n";
print "Created by Greg Gu from Jason Stajich's lab in UC Riverside.\n";
print "Email Greg using daigu\@ucr.edu for any more help.\n";
print "#################################\n";

my $dir = "."; 
opendir(DIR,$dir);
@fileList = sort(grep {/\.$format$/} readdir(DIR));
closedir(DIR);
opendir(DIR,$dir);
my @temp = sort(grep {/\.$format2$/} readdir(DIR));
push (@fileList,@temp);
closedir(DIR);
my $fileNumbers = @fileList;
if ($fileNumbers >0){
	foreach my $fileName (@fileList){
		#$fileName =~ s/[\n\r\t\f]//g;
			#while ($fileName ne "stop")
			open inFile, $fileName or die $!; #only good for same directory}
			$fileName =~ s/\.[^.]+$//;
			while (<inFile>){
				my @s=split();
				if (length($s[1])>50){
					my $newLine = ">Query"."$counter"."\n";
					push(@buffer, $newLine);
					push(@buffer, ($s[1],"\n"));
					$counter++;
				}
				else {$counter++;}
			}
			close inFile;
			open outFile, ">$fileName.fasta" or die $!;
			print outFile @buffer;
			close outFile;
			print "Done with "."$fileName.fasta"."!\n";
			@buffer = ();
			$counter = 1;
			#$fileName = <STDIN>;
			#$fileName =~ s/[\n\r\f\t]//g;
	}
	print "ALL DONE. \n";
}
else{
	print "There are no freq files in current directory.\n";
	print "Did nothing, quit without error.\n";
}
