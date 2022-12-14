#!/bin/bash
#setting vars
LIGAND=${1}
SILENT_FILE_DIR=${2}
RMSD_OUT_DIR=${3}
SELECTED_JOB=${4}
#making list of out files

cd ${SILENT_FILE_DIR}/${LIGAND}

ls out_files/ > ${RMSD_OUT_DIR}/ligand_out_lists/${LIGAND}_out.list

#finding top file
#cd pdbs
#echo "ligand_rmsd_calc_v2.sh: finding top pose..."
#bash ../../get_pdbs_adv.sh -top ${LIGAND}


mkdir ${RMSD_OUT_DIR}/rmsd_scores/${LIGAND}


#running rmsd_calc
echo "ligand_rmsd_calc_v2.sh: submitting slurm jobs..."
cd ${RMSD_OUT_DIR}/log_files
sbatch ${ROSETTA_DOCK}/scripts/ligand_rmsd_calc.sh ${LIGAND} ${SILENT_FILE_DIR} ${RMSD_OUT_DIR} ${SELECTED_JOB}

echo 'ligand_rmsd_calc_v2.sh: PAU!'
