#!/bin/bash
#
##
#
#SBATCH --job-name=rmsd_calc
#SBATCH --ntasks=1
#SBATCH --account=maom0
#SBATCH --nodes=1
#SBATCH --array=1-10
#SBATCH --output=mp_rmsd_slrm.log
#SBATCH --mem-per-cpu=8g
#SBATCH --time=01-12:00:00
#SBATCH --partition=standard
#SBATCH --mail-user=limcaoco@med.umich.edu
#SBATCH --mail-type=END,FAIL
# more robust error handling
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
#load gcc vers 4.8.5
module load gcc/4.8.5
##
## Run ligand_docking
##
JOB_ID=${SLURM_JOB_ID}
TASK_ID=${SLURM_ARRAY_TASK_ID}
LIGAND=${1}
SILENT_FILE_DIR=${2}
RMSD_OUT_DIR=${3}
SELECTED_JOB=${4}


OUT_FILE=$(head -${TASK_ID} ${RMSD_OUT_DIR}/ligand_out_lists/${LIGAND}_out.list | tail -1)

${PATH_TO_ROSETTA}/main/source/bin/rosetta_scripts.default.linuxgccrelease \
    -database ${PATH_TO_ROSETTA}/main/database \
    -parser:protocol ${ROSETTA_DOCK}/scripts/rosetta_xml_scripts/ligand_rmsd.xml \
    @ ${PROJ_DIR}/rosetta_runs/ligand_docking_runs/${SELECTED_JOB}/ligand_params.options \
    -parser:script_vars native=${PROJ_DIR}/rosetta_runs/ligand_docking_runs/${SELECTED_JOB}/RMSD_standard/${LIGAND}.pdb \
    -in:file:silent ${SILENT_FILE_DIR}/${LIGAND}/out_files/${OUT_FILE} \
    -run:jran ${JOB_ID} \
    -out:level 200 \
    -out:file:score_only ${RMSD_OUT_DIR}/rmsd_scores/${LIGAND}/${LIGAND}_${TASK_ID}_rmsd.sc \
    -overwrite \
    > ${RMSD_OUT_DIR}/log_files/rmsd_${LIGAND}_${TASK_ID}.log

