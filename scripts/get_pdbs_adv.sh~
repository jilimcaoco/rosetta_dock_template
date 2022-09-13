#!/bin/bash
#
##
##get_pdbs.sh script retrives all the pdbs from the silent files in a specified directory
##
# variables 1 = mode 2=score type 3=extra ligand params file
set -euo pipefail 

SCORE_TYPE=${2}
MODE=${1}
EXTRA_PARAMS=${3}
PATH_TO_ROSETTA=/home/limcaoco/rosetta/rosetta_dev
#PATH_TO_SCRATCH=/scratch/ave_root/ave0/limcaoco




echo "get_pdbs_adv.sh: selected mode is: " ${MODE}
echo "get_pdbs_adv.sh: selected score file is: " ${SCORE_TYPE}

SCORE_NUM=1

#score type options
#if [ ${SCORE_TYPE} == '-total_score']; then
#    SCORE_NUM=1
#elif [ ${SCORE_TYPE} == '-ligand_interface']; then 
#    SCORE_NUM=55
#else
#    echo "get_pdbs_adv.sh: ERR: not a valid score type..."
#    echo "get_pdbs_adv.sh: valid score types are: -total_score, -ligand_interface "
#fi



#mode options
if [ ${MODE} == '-help' ]; then
    echo "get_pdbs_adv.sh: This Script Supports the following modes: "
    echo "get_pdbs_adv.sh: -help (prints command usage) "
    echo "get_pdbs_adv.sh: -list (extracts pdbs from given list named pdb_list in the working directory) "
    echo "get_pdbs_adv.sh: -top (extracts top scoring pdb according to overall score) "
    echo "get_pdbs_adv.sh: (example usage in pdb directory) 'bash get_pdbs_adv.sh -top' "        

elif [ ${MODE} == '-score' ]; then
    for SILENT_FILE in ../out_files/*; \
	do
	echo "get_pdbs_adv.sh: getting scores for: " ${SILENT_FILE}
	grep '^SCORE:' ${SILENT_FILE} >> scores.sc 
    done
    
    sort -k${SCORE_NUM} -n scores.sc > sorted_scores.sc
    awk '{print ${${SCORE_NUM}}' sorted_scores.sc > temp_name_tags
    sed '/description/d' temp_name_tags > name_tags 
    sed -n 1p name_tags > top_model


elif [ ${MODE} == '-list' ]; then
    for SILENT_FILE in ../out_files/*; \
	do ${PATH_TO_ROSETTA}/main/source/bin/extract_pdbs.default.linuxgccrelease \
	-in:file:silent ${SILENT_FILE} \
	-out:pdb_gz \
	-in:file:tagfile pdb_list >> extract_pdbs_adv.log
    done
    echo "get_pdbs_adv.sh: PAU!"


elif [ ${MODE} ==  '-top' ]; then
    
    for SILENT_FILE in ../out_files/*; \
	do 
	echo "get_pdbs_adv.sh: getting scores for: " ${SILENT_FILE}
	grep '^SCORE:' ${SILENT_FILE} >> scores.sc 
    done
    sort -k49 -n scores.sc > sorted_scores.sc
    awk '{print $53}' sorted_scores.sc > temp_name_tags
    sed '/description/d' temp_name_tags > name_tags 
    sed -n 1p name_tags > top_model
    echo "get_pdbs_adv.sh: the top scoring model is: "
    head top_model
    #rm temp_name_tags
	
    echo "get_pdbs_adv.sh: extracting top model now..."
    for SILENT_FILE in ../out_files/*; \
        do ${PATH_TO_ROSETTA}/main/source/bin/extract_pdbs.default.linuxgccrelease \
        -in:file:silent ${SILENT_FILE} \
        -out:pdb_gz \
        @ ${EXTRA_PARAMS} \
	-in:file:tagfile top_model >> extract_pdbs_adv.log
    done
    rm extract_pdbs_adv.log
    echo "get_pdbs_adv.sh: PAU!"

elif [ ${MODE} ==  '-top10' ]; then
 
    head -n 10 name_tags > top10_models
    echo "get_pdbs_adv.sh: the top 10 scoring models is: "
    head top10_models
	
    echo "get_pdbs_adv.sh: extracting top 10 models now..."
    for SILENT_FILE in ../out_files/*; \
        do ${PATH_TO_ROSETTA}/main/source/bin/extract_pdbs.default.linuxgccrelease \
        -in:file:silent ${SILENT_FILE} \
        -out:pdb_gz \
	@ ${EXTRA_PARAMS} \
        -in:file:tagfile top10_models >> extract_pdbs_adv.log
    done
    rm extract_pdbs_adv.log
    echo "get_pdbs_adv.sh: PAU!"

elif [ ${MODE} ==  '-top20' ]; then
 
    head -n 20 name_tags > top20_models
    echo "get_pdbs_adv.sh: the top 10 scoring models is: "
    head top20_models
	
    echo "get_pdbs_adv.sh: extracting top 10 models now..."
    for SILENT_FILE in ../out_files/*; \
        do ${PATH_TO_ROSETTA}/main/source/bin/extract_pdbs.default.linuxgccrelease \
        -in:file:silent ${SILENT_FILE} \
        -out:pdb_gz \
	@ ${EXTRA_PARAMS} \
        -in:file:tagfile top20_models >> extract_pdbs_adv.log
    done
    rm extract_pdbs_adv.log
    echo "get_pdbs_adv.sh: PAU!"

elif [ ${MODE} ==  '-top50' ]; then

    head -n 50 name_tags > top10_models
    echo "get_pdbs_adv.sh: the top 10 scoring models is: "
    head top10_models

    echo "get_pdbs_adv.sh: extracting top 10 models now..."
    for SILENT_FILE in ../out_files/*; \
        do ${PATH_TO_ROSETTA}/main/source/bin/extract_pdbs.default.linuxgccrelease \
        -in:file:silent ${SILENT_FILE} \
        -out:pdb_gz \
        -in:file:tagfile top10_models >> extract_pdbs_adv.log
    done
    rm extract_pdbs_adv.log
    echo "get_pdbs_adv.sh: PAU!"

elif [ ${MODE} ==  '-top200' ]; then

    head -n 200 name_tags > top10_models
    echo "get_pdbs_adv.sh: the top 10 scoring models is: "
    head top10_models

    echo "get_pdbs_adv.sh: extracting top 10 models now..."
    for SILENT_FILE in ../out_files/*; \
        do ${PATH_TO_ROSETTA}/main/source/bin/extract_pdbs.default.linuxgccrelease \
        -in:file:silent ${SILENT_FILE} \
        -out:pdb_gz \
        -in:file:tagfile top10_models >> extract_pdbs_adv.log
    done
    rm extract_pdbs_adv.log
    echo "get_pdbs_adv.sh: PAU!"


elif [ ${MODE} ==  '-top1000' ]; then

    head -n 1000 name_tags > top10_models
    echo "get_pdbs_adv.sh: the top 10 scoring models is: "
    head top10_models

    echo "get_pdbs_adv.sh: extracting top 10 models now..."
    for SILENT_FILE in ../out_files/*; \
        do ${PATH_TO_ROSETTA}/main/source/bin/extract_pdbs.default.linuxgccrelease \
        -in:file:silent ${SILENT_FILE} \
        -out:pdb_gz \
        -in:file:tagfile top10_models >> extract_pdbs_adv.log
    done
    rm extract_pdbs_adv.log
    echo "get_pdbs_adv.sh: PAU!"

elif [ ${MODE} ==  '-all' ]; then
 
 	
    echo "get_pdbs_adv.sh: extracting all models now..."
    for SILENT_FILE in ../out_files/*; \
        do ${PATH_TO_ROSETTA}/main/source/bin/extract_pdbs.default.linuxgccrelease \
        -in:file:silent ${SILENT_FILE} \
	@ ${EXTRA_PARAMS} \
	-in:path:database ${PATH_TO_ROSETTA}/main/database \
	-gen_potential \
	-crystal_refine \
	-out:pdb_gz >> extract_pdbs_adv.log
    done
    echo "get_pdbs_adv.sh: PAU!"

else
    echo "get_pdbs_adv.sh: " ${MODE} "not a valid option, see -help"
fi
