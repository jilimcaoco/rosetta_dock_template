#!/bin/bash
#





cat > rosetta_runs/ligand_minimization_runs/${LIGAND_DOCK_JOB_NAME}/input_files/sbatch/files/${LIGAND}_minimization_${RECEPTOR}.sbatch <<EOF

#
#SBATCH --job-name=JLC_Production
#SBATCH --ntasks=1
#SBATCH --array=1-10
#SBATCH --account=maom99
#SBATCH --nodes=1
#SBATCH --output=mp_docking_slrm.log
#SBATCH --mem-per-cpu=5g
#SBATCH --time=02-12:00:00
#SBATCH --partition=standard
#SBATCH --mail-user=limcaoco@umich.edu
#SBATCH --mail-type=END,FAIL
# more robust error handling
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
#load gcc vers 4.8.5
module load gcc/4.8.5
##
## Run ligand_docking
##
JOB_ID=$SLURM_JOB_ID
TASK_ID=$SLURM_ARRAY_TASK_ID
LIGAND=E66
TARGET=4hjo
SCRATCH_DIR=/scratch/maom_root/maom99/limcaoco/ligand_relax_${LIGAND}_${TARGET}_9_28_2021
PATH_TO_ROSETTA=/home/limcaoco/rosetta/rosetta3.12
#mkdir ${SCRATCH_DIR} This makes 50 new scratch directories instead of making\
# one, make the scratch directory outside and change the SCRATCH_DIR variable path before running!!!
${PATH_TO_ROSETTA}/main/source/bin/rosetta_scripts.default.linuxgccrelease \
    -database ${PATH_TO_ROSETTA}/main/database \
    @/home/limcaoco/egfr_project/bin/${TARGET}_w_${LIGAND}_relax.options\
    -run:jran ${JOB_ID} \
    -out:nstruct 1000 \
    -out:level 200 \
    -out:prefix ${JOB_ID}_${TASK_ID}_ \
    -out:file:silent ${SCRATCH_DIR}/out_files/ldock_${LIGAND}_${TARGET}_${JOB_ID}_${TASK_ID}.out \
    > ${SCRATCH_DIR}/ldock_${LIGAND}_${TARGET}_${JOB_ID}_${TASK_ID}.log
##
## creating .err file from STDERR
##
command 2> ${SCRATCH_DIR}/ldock_${JOB_ID}_${TASK_ID}.err
command 1> ${SCRATCH_DIR}/ldock_${JOB_ID}_${TASK_ID}.txt

EOF

cat > rosetta_runs/ligand_minimization_runs/${LIGAND_DOCK_JOB_NAME}/1_run.sh <<EOF

#!/bin/bash
#

for LIGAND_SBATCH_FILE in ${IN_DIR}/sbatch_files/*;
do

sbatch ${LIGAND_SBATCH_FILE}
echo "Submittingjob ${SLURM_JOB_ID} to the SLURM cluster"

done

echo "Finished submitting SLURM jobs"
echo "CHeck status with squeue -u username"

EOF

