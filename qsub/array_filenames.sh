#PBS -l nodes=1:ppn=1

N=$PBS_ARRAYID
if [ ! $N ]; then
 N=$1
fi

FILELIST=list
LINE=`head -n $N $FILELIST | tail -n 1`

echo "LINE $N is $LINE"
# now $LINE has the filename you want to use in it, so you can write a script like
# blastp -query $FILE -db database ... etc