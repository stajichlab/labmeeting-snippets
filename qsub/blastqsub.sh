#!/bin/bash
#PBS -l mem=2gb
#PBS -l walltime=100:00:00
#PBS -V

cd $PBS_O_WORKDIR

if [ ! -f Oryza_brachyantha.Oryza_brachyantha.v1.4b.16.cdna.all.fa.nhr ]; 
then
 formatdb -i Oryza_brachyantha.Oryza_brachyantha.v1.4b.16.cdna.all.fa -p F
fi

blastall -i Hordeum_vulgare.030312v2.16.cdna.all.test.fa -d Oryza_brachyantha.Oryza_brachyantha.v1.4b.16.cdna.all.fa -p blastn -e 1e-5 -o blastqsub.blast

echo "Done" 
