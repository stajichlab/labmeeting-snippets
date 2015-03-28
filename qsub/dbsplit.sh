#demonstrate how to use bioperl script bp_dbsplit.pl to split a query file into 
# smaller pieces to submit as multiple jobs to the cluster qsub
bp_dbsplit.pl --size 500 --prefix shortname Hordeum_vulgare.030312v2.16.cdna.all.test.fa
