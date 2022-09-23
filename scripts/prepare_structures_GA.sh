#!/bin/bash


SCRIPT_NAME="prepare_structure_GA.sh"
#wizard inputs here
LIGAND_LIBRARY=${1}
LIGAND_ID_PRE=${2}
RECEPTOR_NAME=${3}
ligand_library_id=${4}


#now doing stuff
cd ${PROJ_DIR}/${LIGAND_LIBRARY}

echo "${SCRIPT_NAME}: generating GA params file now"
LIGAND_NUM=0
for LIGAND_FILE in ./*.mol2
do

    echo "${SCRIPT_NAME}: processing... ${LIGAND_FILE}"
    LIGAND_NUM=$((${LIGAND_NUM}+ 1))

    if [ $LIGAND_NUM -lt 10 ]
    then
	NEW_LIGAND_NUM=0$LIGAND_NUM
    else
	NEW_LIGAND_NUM=$LIGAND_NUM
    fi

    LIGAND_ID="${LIGAND_ID_PRE}${NEW_LIGAND_NUM}"
    LIGAND_INPUT="${LIGAND_ID_PRE}${NEW_LIGAND_NUM}.mol2"
    cp ${LIGAND_FILE} ${LIGAND_INPUT} 
    echo "${SCRIPT_NAME}: DEBUG: mol2genparams input is... ${LIGAND_INPUT}"
    ${PATH_TO_ROSETTA}/main/source/scripts/python/public/generic_potential/mol2genparams.py \
		      -s ${LIGAND_INPUT} \
		      --resname ${LIGAND_ID}

    echo "${SCRIPT_NAME}: done generating params file for ${LIGAND_FILE}"
    echo "${SCRIPT_NAME}: adding ligand stuct to receptor pdb..."
    #should be just like the OG script
    #just need to add options file and call GA ligand dock and it should be good to go

    
    cat ${PROJ_DIR}/intermediate_files/prepared_receptors/${RECEPTOR_NAME}/${RECEPTOR_NAME}.pdb ${LIGAND_ID}_0001.pdb > ${PROJ_DIR}/intermediate_files/prepared_ligand_libraries/GA_${ligand_library_id}/receptor_ligand_structs/${RECEPTOR_NAME}_docking_${LIGAND_ID}.pdb

    echo "END" >> ${PROJ_DIR}/intermediate_files/prepared_ligand_libraries/GA_${ligand_library_id}/receptor_ligand_structs/${RECEPTOR_NAME}_docking_${LIGAND_ID}.pdb

    echo "prepare_structures.sh: done preparing structures for ${CONF_FILE}..."

    echo ${LIGAND_ID} >> ${PROJ_DIR}/intermediate_files/prepared_ligand_libraries/GA_${ligand_library_id}/ligand_list.txt

    echo "${LIGAND_FILE} is now ${LIGAND_ID}" >> ${PROJ_DIR}/intermediate_files/prepared_ligand_libraries/GA_${ligand_library_id}/ligand_ids.txt

    pwd
    #moving to intermediate file directory
    cp ${LIGAND_ID}.params ${PROJ_DIR}/intermediate_files/prepared_ligand_libraries/GA_${ligand_library_id}/params
    cp ${LIGAND_ID}_0001.pdb ${PROJ_DIR}/intermediate_files/prepared_ligand_libraries/GA_${ligand_library_id}/pdbs

    rm Z*
    
done

