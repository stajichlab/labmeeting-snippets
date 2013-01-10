#!/usr/bin/perl
use strict;
use warnings;

#use File::Basename;
#use Bio::Seq;

sub writeBuffer{
# @buffer2, $subCounter, $fileName
	my @arr = @{ $_[0] };
	foreach my $l (@arr){
	my $outName = "$_[2]"."_"."$_[1]";
	open outFile, ">$outName.fasta" or die $!;
	print outFile @arr;
	close outFile;
}
}
my $format = "fasta";
my @fileList = ();
my $counter = 0;
my $subCounter = 1;
#my @buffer1 = ();
my @buffer2 = ();
print "#################################\n";
print "\n";
print "This program will clean up your ITS file in this folder for any sequence less than 25bp long. \n";
print "The Program will alse creat new files for each input fasta file. \n";
print "Each new file will NOT longer than 500 records.\n";
print "\n";
print "#################################\n";
print "Created by Greg Gu from Jason Stajich's lab in UC Riverside.\n";
print "Email Greg using daigu\@ucr.edu for any more help.\n";
print "#################################\n";
#my $fileName = <STDIN>;
my $dir = ".";
opendir(DIR,$dir);
@fileList = sort(grep {/\.$format$/} readdir(DIR));
closedir(DIR);
my $fileNumbers = @fileList;
my %Hbuffer1 = ();
my $key = "";
if ($fileNumbers > 0){
		foreach my $fileName (@fileList){
		open inFile, $fileName or die $!; #only good for same directory}
		$fileName =~ s/\.[^.]+$//; #get only name without extention
		foreach my $l (<inFile>){
			if ($counter % 2 == 1 and length($l) >24) {$Hbuffer1 {$key} = $l;} #fillup the hash buffer
			else {if ($counter % 2 == 0) {$key = substr $l, 6;
				  $key = int ($key);}}	#creat a new key 
			#else {push (@buffer2,$l);}
			$counter++;
		}
		close inFile;
		#foreach my $seq (@buffer1){
		#foreach $key (keys %Hbuffer1){
		foreach (sort {$a <=> $b} keys(%Hbuffer1)) {
				#if (length($seq)>24){
				#push into buffer2;
				#my $newLine = $key;
				my $newLine = ">Query".$_."\n";
				push(@buffer2, $newLine);
				push(@buffer2, $Hbuffer1{$_});
				#$counter++;
				#all required data ready
			#if buffer2 is full then write buffer;
			if (scalar(@buffer2)>999){ 
				#write buffer into a file
				writeBuffer(\@buffer2,$subCounter,$fileName);
				#reset all related counters;
				$subCounter += 1;
				@buffer2 =();
				#$counter = 1; #if the new file should be always start at query1
				}
		}
		writeBuffer(\@buffer2,$subCounter,$fileName); #save whatever left into the last file
		$subCounter = 1;
		@buffer2= () ;
		print "Done with "."$fileName.fasta"."!\n";
	}
	print "ALL DONE. \n";
}
else{
    print "There are no freq files in current directory.\n";
    print "Did nothing, quit without error.\n";
}

