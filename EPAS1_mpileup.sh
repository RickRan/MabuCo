inputdata=/public/adna/qiaomei_fu/Mabucuo/bam/mnt/data3/summary/220414.Mabucuo.Jingkun/bam/V2477.nc.human.mapping.sorted.uniq.L30MQ0.masked_2termCT.bam; 
outname=XXX;
samtools=/public/software/adna/samtools-1.5/samtools; 
$samtools mpileup -r 2:46567916-46600661  $inputdata  > ${outname}.mp
for k in for k in 46567916 46568680 46569017 46569770 46570342 46571017 46571435 46577251 46579689 46583581 46584859 46588019 46588331 46589032 46594122 46597756 46598025 46600030 46600358 46600661; do grep $k ${outname}.mp >> ${outname}.epas ; done