#!/bin/bash

#need conformations in .sdf format with hydrogens added.


LIGAND_LIBRARY=${1}
LIGAND_ID_PRE=${2}
RECEPTOR_NAME=${3}
ligand_library_id=${4}
cd ${PROJ_DIR}/${LIGAND_LIBRARY}

echo "prepare_structures.sh: generating params file now..."
CONF_NUM=0

#mkdir ${PROJ_DIR}/intermediate_files/${LIGAND_LIBRARY}

touch ${PROJ_DIR}/intermediate_files/prepared_ligand_libraries/${ligand_library_id}/ligand_list.txt
touch ${PROJ_DIR}/intermediate_files/prepared_ligand_libraries/${ligand_library_id}/ligand_ids.txt

for CONF_FILE in ./*.mol2
do


CONF_NUM=$((${CONF_NUM} + 1))

if [ $CONF_NUM -lt 10 ]
then
    NEW_CONF_NUM=0$CONF_NUM
else
    NEW_CONF_NUM=$CONF_NUM
fi

LIGAND_ID=${LIGAND_ID_PRE}${NEW_CONF_NUM}

${PATH_TO_ROSETTA}/main/source/scripts/python/public/molfile_to_params.py \
    -n ${LIGAND_ID} -p ${LIGAND_ID} \
    --conformers-in-one-file ${CONF_FILE}
echo "prepare_structures.sh: done generateing params file for ${CONF_FILE}..."

echo "prepare_structures.sh: adding ligand struct to receptor PDB..."

cat ${PROJ_DIR}/intermediate_files/prepared_receptors/${RECEPTOR_NAME}/${RECEPTOR_NAME}.pdb ${LIGAND_ID}.pdb > ${PROJ_DIR}/intermediate_files/prepared_ligand_libraries/${ligand_library_id}/receptor_ligand_structs/${RECEPTOR_NAME}_docking_${LIGAND_ID}.pdb

echo "END" >> ${PROJ_DIR}/intermediate_files/prepared_ligand_libraries/${ligand_library_id}/receptor_ligand_structs/${RECEPTOR_NAME}_docking_${LIGAND_ID}.pdb

echo "prepare_structures.sh: done preparing structures for ${CONF_FILE}..."

echo ${LIGAND_ID} >> ${PROJ_DIR}/intermediate_files/prepared_ligand_libraries/${ligand_library_id}/ligand_list.txt

echo "${CONF_FILE} is now ${LIGAND_ID}" >> ${PROJ_DIR}/intermediate_files/prepared_ligand_libraries/${ligand_library_id}/ligand_ids.txt

cp ${LIGAND_ID}.params ${PROJ_DIR}/intermediate_files/prepared_ligand_libraries/${ligand_library_id}/params
cp ${LIGAND_ID}.pdb ${PROJ_DIR}/intermediate_files/prepared_ligand_libraries/${ligand_library_id}/pdbs
cp ${LIGAND_ID}_conformers.pdb ${PROJ_DIR}/intermediate_files/prepared_ligand_libraries/${ligand_library_id}/params

done




#cd -
