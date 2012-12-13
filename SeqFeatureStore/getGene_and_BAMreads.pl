#!/usr/bin/perl
use warnings;
use strict;
use Bio::DB::SeqFeature::Store;
use Bio::DB::Sam;
use Data::Dumper;

my $sqlite = shift;
die "Please provide a SQLite datafile of a seqfeature db" if !defined $sqlite;

my $bam = shift;
die "Please provide a BAM datafile" if !defined $sqlite;

my $fasta = shift;
die "Please provide a FASTA file associated with the BAM file"
  if !defined $sqlite;

#############################################################################
## make a Bio::DB::SeqFeature::Store object (contains info about  organism in
## SQLite database and all the methods needed to interact with the database
#############################################################################

# Open the sequence database
my $db_obj = Bio::DB::SeqFeature::Store->new(
  -adaptor => 'DBI::SQLite',
  -dsn     => $sqlite
);

#############################################################################
## make a sam object (contains all data in bam file and all methods needed
## to interact with bam file
#############################################################################
my $sam = Bio::DB::Sam->new(
  -bam   => $bam,
  -fasta => $fasta,
);

my @features_type_gene = $db_obj->get_features_by_type('gene');
foreach my $feature (@features_type_gene) {
  my $gene_name  = $feature->name;
  my $gene_start = $feature->start;
  my $gene_end   = $feature->end;
  my $ref        = $feature->ref;
  my $strand     = $feature->strand;
  my %attr       = $feature->attributes;
  my $note       = @{ $attr{Note} }[0];
  my $gene_info  = "$gene_name($ref:$gene_start..$gene_end)";

  if ( $note =~ /histone deacetylase/i ) {
   
    my @read_info = getOverlappingReads( $ref, $gene_start, $gene_end );
    foreach my $read_info (@read_info) {
      print ">$gene_info $read_info";
    }

  }
}

sub getOverlappingReads {
  my ( $ref, $start, $end ) = @_;
  my @read_info;
  my @alignments = $sam->get_features_by_location(
    -seq_id => $ref,
    -start  => $start,
    -end    => $end
  );
  foreach my $alignment (@alignments) {
    my $length  = $alignment->length;
    my $f_start = $alignment->start;
    my $f_end   = $alignment->end;
    my $f_seq   = $alignment->query->dna;

    push @read_info, "read:$f_start..$f_end len=$length\n$f_seq\n";
  }
  return @read_info;
}

