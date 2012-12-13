#!/usr/bin/perl
use warnings;
use strict;
use Bio::DB::SeqFeature::Store;
#use Bio::DB::Sam;
use Data::Dumper;

my $sqlite = shift;
die "Please provide a SQLite datafile of a seqfeature db" if !defined $sqlite;


#############################################################################
## make a Bio::DB::SeqFeature::Store object (contains info about  organism in
## SQLite database and all the methods needed to interact with the database
#############################################################################

# Open the sequence database
my $db_obj = Bio::DB::SeqFeature::Store->new(
  -adaptor => 'DBI::SQLite',
  -dsn     => $sqlite
);


my @features_type_gene = $db_obj->get_features_by_type('gene');
foreach my $feature (@features_type_gene) {
  my $gene_name  = $feature->name;
  my $gene_start = $feature->start;
  my $gene_end   = $feature->end;
  my $ref        = $feature->ref;
  my $strand = $feature->strand;
  my %attr = $feature->attributes;
  my $note = @{$attr{Note}}[0];
  my $gene_info = "$gene_name($ref:$gene_start..$gene_end)";

  if ($note =~ /histone deacetylase/i){

    my $gene_seq =$db_obj->fetch_sequence(-seq_id=>$ref,-start=>$gene_start,-end=>$gene_end);
    print ">$gene_name|complete_gene|$ref:$gene_start..$gene_end $note strand:$strand\n$gene_seq\n";

    ## use the gene coordinates to get the seq 1kb upstream of gene
   
    my ($promoter_start , $promoter_end);
    if ($strand > 0 ){
      $promoter_start = $gene_start - 1000 ;
      $promoter_end = $gene_start - 1;
    } else {
      $promoter_start = $gene_end + 1000 ;
      $promoter_end = $gene_end + 1;
      ## sort small to big
      if ($promoter_end < $promoter_start){
        ($promoter_start, $promoter_end) = ($promoter_end, $promoter_start);
      }
    }

    my $promoter_seq =$db_obj->fetch_sequence(-seq_id=>$ref,-start=>$promoter_start,-end=>$promoter_end);

    print ">$gene_name|promoter|$ref:$promoter_start..$promoter_end\n$promoter_seq\n";
    

 }
 
}
