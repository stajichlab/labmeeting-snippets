#!/bin/bash
#PBS -l mem=1gb
#PBS -l walltime=100:00:00
#PBS -t 1-3
#PBS -V

cd $PBS_O_WORKDIR

NUM=3

blastall -p blastn -i /rhome/cjinfeng/testqsub/Hordeum_vulgare.030312v2.16.cdna.all.test.fa.cut/Hordeum_vulgare.030312v2.16.cdna.all.test.fa.$PBS_ARRAYID -d /rhome/cjinfeng/testqsub/Oryza_brachyantha.Oryza_brachyantha.v1.4b.16.cdna.all.fa -o /rhome/cjinfeng/testqsub/Hordeum_vulgare.030312v2.16.cdna.all.test.fa.cut/Hordeum_vulgare.030312v2.16.cdna.all.test.fa.$PBS_ARRAYID.blastout -e 1e-6 -m 8

echo "Done"
