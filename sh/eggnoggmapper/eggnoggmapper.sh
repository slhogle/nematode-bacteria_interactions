#!/usr/bin/env bash
#SBATCH --account=project_2009955
#SBATCH --partition=small
#SBATCH --time=40:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=100GB
#SBATCH --gres=nvme:200

export PATH="/projappl/project_2005777/tykky/eggnog-mapper-2.1.10/bin:$PATH"
export EGGNOG_DATA_DIR=$LOCAL_SCRATCH

echo "downloading eggnogmapper data to ${LOCAL_SCRATCH}"

download_eggnog_data.py -y --data_dir ${LOCAL_SCRATCH}

emapper.py \
--data_dir $LOCAL_SCRATCH \
--temp_dir $LOCAL_SCRATCH \
--cpu 20 \
-m diamond \
-i nanjingSynCom122_combined.faa \
--output nanjingSynCom122_combined
