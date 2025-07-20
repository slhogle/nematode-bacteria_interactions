#!/bin/bash -l
#SBATCH --job-name=prokka
#SBATCH --account=project_2009955
#SBATCH --partition=small
#SBATCH --time=12:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16GB

export PATH="/projappl/project_2005777/tykky/prokka-1.14.6/bin:$PATH"

cat ../ids.txt| while read ID; do
  prokka --outdir ${ID} --noanno --locustag ${ID} --prefix ${ID} ${ID}.fna
done
 
