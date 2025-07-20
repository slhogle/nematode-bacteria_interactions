#!/bin/bash -l
#SBATCH --job-name=bwa
#SBATCH --account=project_2009955
#SBATCH --partition=small
#SBATCH --time=12:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=4GB
#SBATCH --gres=nvme:60
#SBATCH --array=1

#------------------------------------------------------------
# Global vars
#------------------------------------------------------------

function bannerSimple() {
    local msg="${2} ${1} ${2}"
    local edge
    edge=${msg//?/$2}
    echo
    echo "${edge}"
    echo "${msg}"
    echo "${edge}"
    echo
}

module load biokit
JAVAARGS="-Xms60000m"

# set the input file to process
# allows running using slurm array process
#MYLIB=$(sed -n ${SLURM_ARRAY_TASK_ID}p ../qualitycontrol/library_ids.txt)
MYLIB=$(sed -n ${SLURM_ARRAY_TASK_ID}p library_ids.txt)
#------------------------------------------------------------

bannerSimple "${MYLIB} aligning with BWA" "+"

bwa mem \
-K 100000000 \
-Y \
-t ${SLURM_CPUS_PER_TASK} \
refs/nanjingSynCom122_combined.fna \
../qualitycontrol/processedreads/${MYLIB}_R1.fastq.gz ../qualitycontrol/processedreads/${MYLIB}_R2.fastq.gz | \
samtools view -1 - > ${LOCAL_SCRATCH}/${MYLIB}.bwa.bam 

bannerSimple "${MYLIB} BAM sort" "="

# sorting with 6 threads and 4Gb per thread
samtools sort -@6 -m4G ${LOCAL_SCRATCH}/${MYLIB}.bwa.bam -o ${LOCAL_SCRATCH}/${MYLIB}.sorted.bam
rm ${LOCAL_SCRATCH}/${MYLIB}.bwa.bam

bannerSimple "${MYLIB} featureCounts" "+"

featureCounts -T ${SLURM_CPUS_PER_TASK} -F SAF -O -M -p -P -B -g ID \
-a saf/nanjingSynCom122_combined.saf \
-o counts/${MYLIB}.tsv \
${LOCAL_SCRATCH}/${MYLIB}.sorted.bam

mv ${LOCAL_SCRATCH}/${MYLIB}.sorted.bam bams

# cleanup
rm -f ${LOCAL_SCRATCH}/${MYLIB}*

seff ${SLURM_JOBID}
