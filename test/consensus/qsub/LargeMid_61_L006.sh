#!/bin/bash
#$ -S /bin/bash
#$ -cwd

module load python3/3.4.3
module load 
module load samtools/1.2
module load picard/2.4.1
module load java/8

cd /mnt/work1/users/pughlab/src/ConsensusCruncher/tester/consensus/LargeMid_61_L006

python3 /mnt/work1/users/pughlab/src/ConsensusCruncher/consensus_scripts/SSCS_maker.py  --cutoff 0.7 --infile /mnt/work1/users/pughlab/src/ConsensusCruncher/tester/bamfiles/LargeMid_61_L006.bam --outfile /mnt/work1/users/pughlab/src/ConsensusCruncher/tester/consensus/LargeMid_61_L006/LargeMid_61_L006.sscs.bam --bedfile /mnt/work1/users/pughlab/src/ConsensusCruncher/consensus_scripts/cytoBand.txt

samtools view -bu LargeMid_61_L006.sscs.bam | samtools sort - LargeMid_61_L006.sscs.sorted

samtools index LargeMid_61_L006.sscs.sorted.bam

rm LargeMid_61_L006.sscs.bam

samtools view -bu LargeMid_61_L006.singleton.bam | samtools sort - LargeMid_61_L006.singleton.sorted

samtools index LargeMid_61_L006.singleton.sorted.bam

rm LargeMid_61_L006.singleton.bam

python3 /mnt/work1/users/pughlab/src/ConsensusCruncher/consensus_scripts/DCS_maker.py --infile LargeMid_61_L006.sscs.sorted.bam --outfile LargeMid_61_L006.dcs.bam --bedfile /mnt/work1/users/pughlab/src/ConsensusCruncher/consensus_scripts/cytoBand.txt

samtools view -bu LargeMid_61_L006.dcs.bam | samtools sort - LargeMid_61_L006.dcs.sorted

samtools index LargeMid_61_L006.dcs.sorted.bam

rm LargeMid_61_L006.dcs.bam

samtools view -bu LargeMid_61_L006.sscs.singleton.bam | samtools sort - LargeMid_61_L006.sscs.singleton.sorted

samtools index LargeMid_61_L006.sscs.singleton.sorted.bam

rm LargeMid_61_L006.sscs.singleton.bam

python3 /mnt/work1/users/pughlab/src/ConsensusCruncher/consensus_scripts/singleton_correction.py --singleton LargeMid_61_L006.singleton.sorted.bam --bedfile /mnt/work1/users/pughlab/src/ConsensusCruncher/consensus_scripts/cytoBand.txt

samtools view -bu LargeMid_61_L006.sscs.rescue.bam | samtools sort - LargeMid_61_L006.sscs.rescue.sorted

samtools index LargeMid_61_L006.sscs.rescue.sorted.bam

rm LargeMid_61_L006.sscs.rescue.bam

samtools view -bu LargeMid_61_L006.singleton.rescue.bam | samtools sort - LargeMid_61_L006.singleton.rescue.sorted

samtools index LargeMid_61_L006.singleton.rescue.sorted.bam

rm LargeMid_61_L006.singleton.rescue.bam

samtools view -bu LargeMid_61_L006.rescue.remaining.bam | samtools sort - LargeMid_61_L006.rescue.remaining.sorted

samtools index LargeMid_61_L006.rescue.remaining.sorted.bam

rm LargeMid_61_L006.rescue.remaining.bam

java -jar /mnt/work1/software/picard/2.4.1/picard.jar MergeSamFiles I=LargeMid_61_L006.sscs.sorted.bam I=LargeMid_61_L006.sscs.rescue.sorted.bam I=LargeMid_61_L006.singleton.rescue.sorted.bam O=LargeMid_61_L006.sscs.sc.bam

samtools view -bu LargeMid_61_L006.sscs.sc.bam | samtools sort - LargeMid_61_L006.sscs.sc.sorted

samtools index LargeMid_61_L006.sscs.sc.sorted.bam

rm LargeMid_61_L006.sscs.sc.bam

python3 /mnt/work1/users/pughlab/src/ConsensusCruncher/consensus_scripts/DCS_maker.py --infile LargeMid_61_L006.sscs.sc.sorted.bam --outfile LargeMid_61_L006.dcs.sc.bam --bedfile /mnt/work1/users/pughlab/src/ConsensusCruncher/consensus_scripts/cytoBand.txt

samtools view -bu LargeMid_61_L006.dcs.sc.bam | samtools sort - LargeMid_61_L006.dcs.sc.sorted

samtools index LargeMid_61_L006.dcs.sc.sorted.bam

rm LargeMid_61_L006.dcs.sc.bam

samtools view -bu LargeMid_61_L006.sscs.sc.singleton.bam | samtools sort - LargeMid_61_L006.sscs.sc.singleton.sorted

samtools index LargeMid_61_L006.sscs.sc.singleton.sorted.bam

rm LargeMid_61_L006.sscs.sc.singleton.bam

java -jar /mnt/work1/software/picard/2.4.1/picard.jar MergeSamFiles I=LargeMid_61_L006.sscs.sorted.bam I=LargeMid_61_L006.sscs.rescue.sorted.bam I=LargeMid_61_L006.singleton.rescue.sorted.bam I=LargeMid_61_L006.rescue.remaining.sorted.bam O=LargeMid_61_L006.all.unique.sscs.bam

samtools view -bu LargeMid_61_L006.all.unique.sscs.bam | samtools sort - LargeMid_61_L006.all.unique.sscs.sorted

samtools index LargeMid_61_L006.all.unique.sscs.sorted.bam

rm LargeMid_61_L006.all.unique.sscs.bam

java -jar /mnt/work1/software/picard/2.4.1/picard.jar MergeSamFiles I=LargeMid_61_L006.dcs.sc.sorted.bam I=LargeMid_61_L006.sscs.sc.singleton.sorted.bam I=LargeMid_61_L006.rescue.remaining.sorted.bam O=LargeMid_61_L006.all.unique.dcs.bam

samtools view -bu LargeMid_61_L006.all.unique.dcs.bam | samtools sort - LargeMid_61_L006.all.unique.dcs.sorted

samtools index LargeMid_61_L006.all.unique.dcs.sorted.bam

rm LargeMid_61_L006.all.unique.dcs.bam

mkdir sscs_SC

mkdir dcs_SC

mv LargeMid_61_L006.all.unique.dcs.sorted* dcs_SC

mv LargeMid_61_L006.dcs.sc* dcs_SC

mv LargeMid_61_L006.sscs.sc.singleton* dcs_SC

mv LargeMid_61_L006.all.unique.sscs* sscs_SC

mv LargeMid_61_L006.sscs.sc* sscs_SC

mv LargeMid_61_L006.*rescue* sscs_SC

mkdir sscs

mkdir dcs

mv LargeMid_61_L006.dcs.sorted.* dcs

mv LargeMid_61_L006.sscs.singleton.sorted.* dcs

mv LargeMid_61_L006* sscs

mv ./sscs/*stats.txt .

mv ./sscs/*time_tracker.txt .

mv ./sscs/*read_families.txt .

mv ./sscs/*png .
