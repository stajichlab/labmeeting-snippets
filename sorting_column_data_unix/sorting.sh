#ln -s /shared/gen220/data_files/expression/*.tab .
sort -n -r -k6 Nc3H.expr.tab | head -n 100 > top100_3H.tab
sort -n -r -k6 Nc20H.expr.tab | head -n 100 > top100_20H.tab

awk '{print $1}' top100_20H.tab top100_3H.tab | sort | uniq -c | sort -n | grep "2 " | awk '{print $2}' > both_expressed.dat

for gene in `cat both_expressed.dat`; do grep $gene Nc20H.expr.tab | awk '{print $1, $3, $4, $5}'; done | sort -k2,2 -k4n,4