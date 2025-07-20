#!/bin/bash -l
#SBATCH --job-name=rnaseq_qc
#SBATCH --account=project_2009955
#SBATCH --partition=small
#SBATCH --time=12:00:00
#SBATCH --ntasks=8
#SBATCH --mem-per-cpu=20000
#SBATCH --array=1-15
#SBATCH --gres=nvme:128

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

module load openjdk

# set up some paths for running
mkdir -p fastp_preprocess
mkdir -p processedreads
mkdir -p fastp_postprocess

# location for illumina adapters
CONTAMS="/projappl/project_2005777/source/bbmap/bbmap/resources/adapters.fa"

# set the input file to process
MYLIB=$(sed -n ${SLURM_ARRAY_TASK_ID}p library_ids.txt)

#bannerSimple "${MYLIB} fastp raw reads" "+"
#
#fastp \
#--in1 rawreads/${MYLIB}_R1.fq.gz \
#--in2 rawreads/${MYLIB}_R2.fq.gz \
#-j fastp_preprocess/${MYLIB}.json \
#-h fastp_preprocess/${MYLIB}.html \
#-R ${MYLIB} \
#--dont_overwrite \
#-w 1 \
#-p \
#-P 20 \
#--disable_adapter_trimming \
#--disable_trim_poly_g \
#--disable_quality_filtering \
#--disable_length_filtering

bannerSimple "${MYLIB} bbduk remove contams/adapters" "="

bbduk.sh ow=t int=f \
	ftm=5 ktrim=r k=23 \
    mink=11 hdist=1 hdist2=1 tbo tpe \
    ref=${CONTAMS} \
    in=rawreads/${MYLIB}_R1.fq.gz \
    in2=rawreads/${MYLIB}_R2.fq.gz \
    out=${LOCAL_SCRATCH}/${MYLIB}.ftm.fastq

bannerSimple "${MYLIB} bbduk remove phiX" "+"

bbduk.sh ow=t int=t \
    ref=phix k=31 hdist=1 \
    in=${LOCAL_SCRATCH}/${MYLIB}.ftm.fastq \
    out=${LOCAL_SCRATCH}/${MYLIB}.phx.fastq

rm ${LOCAL_SCRATCH}/${MYLIB}.ftm.fastq

bannerSimple "${MYLIB} bbduk quality trim q=10 right" "="

bbduk.sh ow=t int=t \
    qtrim=r trimq=10 \
    in=${LOCAL_SCRATCH}/${MYLIB}.phx.fastq \
    out=${LOCAL_SCRATCH}/${MYLIB}.trm.fastq

rm ${LOCAL_SCRATCH}/${MYLIB}.phx.fastq

bannerSimple "${MYLIB} bbmap map to rRNA database" "+"

bbmap.sh ow=t int=t nodisk=t \
	ambiguous=best semiperfectmode=t \
	ref=rrna/nanjingSynCom122_rrnas.nodup.fasta \
	in=${LOCAL_SCRATCH}/${MYLIB}.trm.fastq \
	outm=rrna/${MYLIB}.rRNA.fastq.gz \
	outu=${LOCAL_SCRATCH}/${MYLIB}_R1.fastq.gz \
	outu2=${LOCAL_SCRATCH}/${MYLIB}_R2.fastq.gz

bannerSimple "${MYLIB} fastp processed reads" "="

fastp \
--in1 ${LOCAL_SCRATCH}/${MYLIB}_R1.fastq.gz \
--in2 ${LOCAL_SCRATCH}/${MYLIB}_R2.fastq.gz \
-j fastp_postprocess/${MYLIB}.json \
-h fastp_postprocess/${MYLIB}.html \
-R ${MYLIB} \
--dont_overwrite \
-w 1 \
-p \
-P 20 \
--disable_adapter_trimming \
--disable_trim_poly_g \
--disable_quality_filtering \
--disable_length_filtering

mv ${LOCAL_SCRATCH}/${MYLIB}_R1.fastq.gz processedreads
mv ${LOCAL_SCRATCH}/${MYLIB}_R2.fastq.gz processedreads

# cleanup
rm -f ${LOCAL_SCRATCH}/${MYLIB}*

seff ${SLURM_JOBID}
