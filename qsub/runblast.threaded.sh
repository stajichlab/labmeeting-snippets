#PBS -l nodes=1:ppn=4 -j oe -N runblastthread -o blast.thread.log
module load ncbi-blast

time blastp  -num_threads $PBS_NP -query test_proteins.pep -db uniprot_sprot.fasta -out test_thread.blastp.out  -evalue 1e-40
