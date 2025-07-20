#!/usr/bin/env bash

module load multiqc

mkdir multiqc

# run on the amplicon qc data
cd fastp_preprocess
rename 's/.html/.fastp.html/' *
rename 's/.json/.fastp.json/' *
multiqc -n fastp_preprocess --no-data-dir .
mv fastp_preprocess.html ../multiqc

cd ../fastp_postprocess
rename 's/.html/.fastp.html/' *
rename 's/.json/.fastp.json/' *
multiqc -n fastp_postprocess --no-data-dir .
mv fastp_postprocess.html ../multiqc

cd ..
tar czf fastp_preprocess.tar.gz fastp_preprocess
tar czf fastp_postprocess.tar.gz fastp_postprocess
rm -rf fastp_preprocess fastp_postprocess
