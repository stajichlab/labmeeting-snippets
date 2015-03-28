echo blastall -i Hordeum_vulgare.030312v2.16.cdna.all.test.fa -d Oryza_brachyantha.Oryza_brachyantha.v1.4b.16.cdna.all.fa -p blastn -e 1e-5 -o blast.blast | qsub -d ./ -V

