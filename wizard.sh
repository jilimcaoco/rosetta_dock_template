#!/bin/bash


#this is a wizard to help guide rosetta ligand docking campaigns
#contact: 
#Jose Miguel Limcaoco
#limcaoco@umich.edu

DATE=$(date +'%m%d%Y')
WIZARD_NAME='Rosetta Dock Wizard'
#source setup_rosetta_dock_env.sh

create_ligand_params () {

    PS3="${WIZARD_NAME}: What docking protocol do you want to create params for?"
    select params_mode in GA_ligand_dock RosettaLigand; do 
        break
    done

    echo "${WIZARD_NAME}: you have chosen... ${params_mode}"
	PS3='${WIZARD_NAME}: Select a Ligand Library'
	ligand_library_ids=($(find input_files/ligand_libraries\
				   -mindepth 1\
				   -maxdepth 1\
				   -type d\
				   -printf "%P\n" | sort -t '\0'))
	
	select ligand_library_id in "${ligand_library_ids[@]}"; do 
	    break
	done
	LIGAND_LIBRARY="input_files/ligand_libraries/${ligand_library_id}"
	echo "${WIZARD_NAME}: Selected ligand library is: $LIGAND_LIBRARY"
   
	PS3='${WIZARD_NAME}: Select a prepared receptor'
	receptor_ids=($(find intermediate_files/prepared_receptors\
			     -mindepth 1\
			     -maxdepth 1\
			     -type d\
			     -printf "%P\n" | sort -t '\0' ))
	
	select prepared_receptor_id in "${receptor_ids[@]}"; do 
	    break
	done
	RECEPTOR_NAME=${prepared_receptor_id}
	echo $RECEPTOR_NAME
	echo "${WIZARD_NAME}Please enter a one letter Prefix for the ligand library... "
	read LIGAND_ID
	echo "${WIZARD_NAME}Ligand ID selected is ${LIGAND_ID} "

    
    if [ "${params_mode}" = "GA_ligand_dock" ]; then
    
	mkdir ./intermediate_files/prepared_ligand_libraries/GA_${ligand_library_id}
	mkdir ./intermediate_files/prepared_ligand_libraries/GA_${ligand_library_id}/params
	mkdir ./intermediate_files/prepared_ligand_libraries/GA_${ligand_library_id}/pdbs
	mkdir ./intermediate_files/prepared_ligand_libraries/GA_${ligand_library_id}/receptor_ligand_structs

	bash  ${ROSETTA_DOCK}/scripts/prepare_structures_GA.sh\
	      ${LIGAND_LIBRARY}\
	      ${LIGAND_ID}\
	      ${RECEPTOR_NAME}\
	      ${ligand_library_id}	
    fi
    
    #OG ligand docking here 
    if [ "${params_mode}" = "RosettaLigand" ]; then
    
	mkdir ./intermediate_files/prepared_ligand_libraries/${ligand_library_id}
	mkdir ./intermediate_files/prepared_ligand_libraries/${ligand_library_id}/params
	mkdir ./intermediate_files/prepared_ligand_libraries/${ligand_library_id}/pdbs
	mkdir ./intermediate_files/prepared_ligand_libraries/${ligand_library_id}/receptor_ligand_structs

	bash  ${ROSETTA_DOCK}/scripts/prepare_structures.sh\
	      ${LIGAND_LIBRARY}\
	      ${LIGAND_ID}\
	      ${RECEPTOR_NAME}\
	      ${ligand_library_id}
    fi
}

receptor_fast_relax () {
    

    PS3='${WIZARD_NAME}: Select a unrelaxed receptor'
    ur_receptor_ids=($(find ${PROJ_DIR}/input_files/unrelaxed_receptors\
			    -mindepth 1\
			    -maxdepth 1\
			    -type d\
			    -printf "%P\n" | sort -t '\0'))
    
    select selected_ur_receptor_id in "${ur_receptor_ids[@]}"; do 
	break
    done
    
    UNRELAXED_RECEPTOR=${selected_ur_receptor_id}
    RFR_JOB_NAME=${UNRELAXED_RECEPTOR}_relax_${DATE}

    
    
    mkdir ${PROJ_DIR}/rosetta_runs/receptor_relax_runs/${RFR_JOB_NAME} 
    mkdir ${PROJ_DIR}/rosetta_runs/receptor_relax_runs/${RFR_JOB_NAME}/sbatch_scripts
    mkdir ${PROJ_DIR}/intermediate_files/prepared_receptors/${UNCRELAXED_RECEPTOR}

    bash ${ROSETTA_DOCK}/scripts/receptor_fastrelax.sh $UNRELAXED_RECEPTOR $RFR_JOB_NAME

    echo "${WIZARD_NAME}: finished setting up receptor minimization job"
    echo "to run go into ./rosetta_runs/receptor_relax_runs/${REF_JOB_NAME} and run numbered scripts sequentialy"
}

ga_ligand_docking() {
    echo "GA Ligand Docking Selected"
    PS3="${WIZARD_NAME}: select ligand database to dock "
    prep_ligand_databases=($(find intermediate_files/prepared_ligand_libraries/\
				  -mindepth 1\
				  -maxdepth 1\
				  -type d\
				  -printf "%P\n" | sort -t '\0'))
    
    select selected_prep_ligand_database in "${prep_ligand_databases[@]}"; do 
	break
    done
    LIGAND_DATABASE=${selected_prep_ligand_database}

    PS3="${WIZARD_NAME}: select receptor to dock to "
    r_receptor_ids=($(find intermediate_files/))
    
    receptor_ids=($(find intermediate_files/prepared_receptors\
			 -mindepth 1\
			 -maxdepth 1\
			 -type d\
			 -printf "%P\n" | sort -t '\0' ))
    
    select prepared_receptor_id in "${receptor_ids[@]}"; do 
	break
    done

    RECEPTOR_NAME=${prepared_receptor_id}

    LIGAND_DOCK_JOB_NAME="${LIGAND_DATABASE}_docking_${RECEPTOR_NAME}"
   
    mkdir ${PROJ_DIR}/rosetta_runs/ligand_docking_runs/${LIGAND_DOCK_JOB_NAME}_${DATE}
    mkdir ${PROJ_DIR}/rosetta_runs/ligand_docking_runs/${LIGAND_DOCK_JOB_NAME}_${DATE}/input_files
    mkdir ${PROJ_DIR}/rosetta_runs/ligand_docking_runs/${LIGAND_DOCK_JOB_NAME}_${DATE}/input_files/sbatch_files
    mkdir ${PROJ_DIR}/output_files/${LIGAND_DOCK_JOB_NAME}_${DATE}
    IN_DIR="${PROJ_DIR}/rosetta_runs/ligand_docking_runs/${LIGAND_DOCK_JOB_NAME}_${DATE}/input_files"
    OUT_DIR="${PROJ_DIR}/output_files/${LIGAND_DOCK_JOB_NAME}_${DATE}"
     
    
    echo "${WIZARD_NAME}: what are the starting coordinates for the ligand?"
    read -p "X coord: " X_COORD
    read -p "Y coord: " Y_COORD
    read -p "Z coord: " Z_COORD

    #row creating SBATCH SCRIPTS
    bash ${ROSETTA_DOCK}/scripts/GA_ligand_dock.sh\
         ${RECEPTOR_NAME}\
         ${LIGAND_DATABASE}\
         ${X_COORD} ${Y_COORD} ${Z_COORD}\
         ${OUT_DIR}\
	 ${IN_DIR}\
         ${LIGAND_DOCK_JOB_NAME}\
         ${DATE}
        
    echo "${WIZARD_NAME}: finished setting up ligand_docking job"
    echo "to run go into ./rosetta_runs/ligand_docking_runs/${REF_JOB_NAME} and run numbered scripts sequentialy"
}


ligand_docking () {
    echo "Ligand Docking Selected"
    
    PS3="${WIZARD_NAME}: select ligand database to dock "
    prep_ligand_databases=($(find intermediate_files/prepared_ligand_libraries/\
				  -mindepth 1\
				  -maxdepth 1\
				  -type d\
				  -printf "%P\n" | sort -t '\0'))
    
    select selected_prep_ligand_database in "${prep_ligand_databases[@]}"; do 
	break
    done
    LIGAND_DATABASE=${selected_prep_ligand_database}

    PS3="${WIZARD_NAME}: select receptor to dock to "
    r_receptor_ids=($(find intermediate_files/))
    
    receptor_ids=($(find intermediate_files/prepared_receptors\
			 -mindepth 1\
			 -maxdepth 1\
			 -type d\
			 -printf "%P\n" | sort -t '\0' ))
    
    select prepared_receptor_id in "${receptor_ids[@]}"; do 
	break
    done

    RECEPTOR_NAME=${prepared_receptor_id}

    LIGAND_DOCK_JOB_NAME="${LIGAND_DATABASE}_docking_${RECEPTOR_NAME}"
   
    mkdir ${PROJ_DIR}/rosetta_runs/ligand_docking_runs/${LIGAND_DOCK_JOB_NAME}_${DATE}
    mkdir ${PROJ_DIR}/rosetta_runs/ligand_docking_runs/${LIGAND_DOCK_JOB_NAME}_${DATE}/input_files
    mkdir ${PROJ_DIR}/rosetta_runs/ligand_docking_runs/${LIGAND_DOCK_JOB_NAME}_${DATE}/input_files/\
	  sbatch_files
    mkdir ${PROJ_DIR}/output_files/${LIGAND_DOCK_JOB_NAME}_${DATE}
    IN_DIR="${PROJ_DIR}/rosetta_runs/ligand_docking_runs/${LIGAND_DOCK_JOB_NAME}_${DATE}/input_files"
    OUT_DIR="${PROJ_DIR}/output_files/${LIGAND_DOCK_JOB_NAME}_${DATE}"
   

    PS3="${WIZARD_NAME}: Do you want to set new inital coordinates for the ligand?"
    select coord_mode in YES NO; do 
        break
    done
    
    if [ "${coord_mode}" = "YES" ]; then 
    
	echo "${WIZARD_NAME}: what are the starting coordinates for the ligand?"
	read -p "X coord: " X_COORD
	read -p "Y coord: " Y_COORD
	read -p "Z coord: " Z_COORD
	bash ${ROSETTA_DOCK}/scripts/ligand_dock.sh\
	     ${RECEPTOR_NAME}\
	     ${LIGAND_DATABASE}\
	     ${X_COORD} ${Y_COORD} ${Z_COORD}\
	     ${OUT_DIR}\
	     ${IN_DIR}\
	     ${LIGAND_DOCK_JOB_NAME}\
	     ${DATE}
    else
	bash ${ROSETTA_DOCK}/scripts/ligand_dock_pre_pos.sh\
	     ${RECEPTOR_NAME}\
	     ${LIGAND_DATABASE}\
	     ${OUT_DIR}\
	     ${IN_DIR}\
	     ${LIGAND_DOCK_JOB_NAME}\
	     ${DATE}
    fi
        
    echo "${WIZARD_NAME}: finished setting up ligand_docking job"
    echo "to run go into ./rosetta_runs/ligand_docking_runs/${REF_JOB_NAME} and run numbered scripts sequentialy"

}


rmsd_calc () {
    echo "${WIZARD_NAME}: RMSD Calcualation Selected"
    echo "${WIZARD_NAME}: Make sure your chosen models to calculate RMSD is in a file named 'RMSD_standard' "
    
    PS3='${WIZARD_NAME}: select job to run RMSD calculation on'
    finished_jobs=($(find ${PROJ_DIR}/rosetta_runs/ligand_docking_runs -mindepth 1 -maxdepth 1 -type d -printf "%P\n" | sort -t '\0'))
    select selected_job in "${finished_jobs[@]}"; do 
        break
    done 
    
    read -p "${WIZARD_NAME}: please enter special tag if wanted: " TAG
    
    
    RMSD_JOB_NAME=${selected_job}_${TAG}_rmsd
    SILENT_FILE_DIR=${PROJ_DIR}/output_files/${selected_job}
    
    echo "THIS IS THE FOLLOWING VARIABLE:  $SILENT_FILE_DIR"
    
    RMSD_OUT_DIR=${PROJ_DIR}/output_files/${RMSD_JOB_NAME} 
    mkdir ${RMSD_OUT_DIR}
    mkdir ${RMSD_OUT_DIR}/rmsd_scores/
    mkdir ${RMSD_OUT_DIR}/ligand_out_lists
    mkdir ${RMSD_OUT_DIR}/log_files
    
    for LIGAND_DIR in ${PROJ_DIR}/output_files/${selected_job}/*; do
   
	LIGAND=$(echo $(basename "${LIGAND_DIR}"))
	#echo ${LIGAND}
	bash ${ROSETTA_DOCK}/scripts/ligand_rmsd_calc_v2.sh ${LIGAND} ${SILENT_FILE_DIR} ${RMSD_OUT_DIR} ${selected_job}
    done
    
    echo "${WIZARD_NAME}: after jobs are finished run 3_analysis.sh scripts in the rosetta_run dir"
    mkdir ${PROJ_DIR}/rosetta_runs/ligand_docking_runs/${selected_job}/docking_plots
    bash ${ROSETTA_DOCK}/scripts/analysis.sh ${RMSD_JOB_NAME} ${selected_job} 
}

ligand_relax () {
    echo "Ligand Minimization Selected ##not yet finished##"
    PS3='${WIZARD_NAME}: select ligand database to dock'
    prep_ligand_databases=($(find intermediate_files/prepared_ligand_libraries/ -mindepth 1 -maxdepth 1 -type d -printf "P\n" | sort -t '\0'))
    
    select selected_prep_ligand_database in "${prep_ligand_databases[@]}"; do 
	break
    done
    LIGAND_DATABASE=${prep_ligand_databases}

    PS3='${WIZARD_NAME}: select receptor to dock to'
    r_receptor_ids=($(find intermediate_files/))
    
    receptor_ids=($(find intermediate_files/prepared_receptors -mindepth 1 -maxdepth 1 -type d -printf "P\n" | sort -t '\0' ))
    select prepared_receptor_id in "${receptor_ids[@]}"; do 
	break
    done
    RECEPTOR_NAME=${prepared_receptor_id}

    LIGAND_DOCK_JOB_NAME = '${LIGAND_DATABASE}_docking_${RECEPTOR_NAME}'
    mkdir ${PROJ_DIR}/rosetta_runs/ligand_minimization_runs/${LIGAND_DOCK_JOB_NAME}

    bash ${ROSETTA_DOCK}/scripts/ligand_relax.sh
    
    echo "${WIZARD_NAME}: finished setting up ligand_minimization job"
    echo "to run go into ./rosetta_runs/ligand_minimization_runs/${REF_JOB_NAME} and run numbered scripts sequentialy"

}

#first prompt

echo "For any bugs please contact: Jose Miguel Limcaoco at limcaoco@umich.edu"


PS3='${WIZARD_NAME}: What would you like to setup?'
options=("Ligand Params" "Receptor Minimization" "Ligand Docking" "Bound Ligand Minimization" "GA Ligand Docking" "Calculate RMSD"  "Quit")
select opt in "${options[@]}"; do 
case $opt in
    "Ligand Params")
    echo "${WIZARD_NAME}: creating ligand params file..."
    create_ligand_params
    break
    ;;
    "Receptor Minimization")
    echo "${WIZARD_NAME}: setting up a Fast_Relax job..."
    receptor_fast_relax
    break
    ;;
    "Ligand Docking")
    echo "${WIZARD_NAME}: setting up ligand_docking job..."
    ligand_docking
    break
    ;;
    "GA Ligand Docking")
    echo "${WIZARD_NAME}: setting up GA_ligand_docking job..."
    ga_ligand_docking
    break
    ;;
    "Bound Ligand Minimization")
    echo "${WIZARD_NAME}: setting up ligand_relax job..."
    ligand_relax
    break
    ;;
    "Calculate RMSD")
    rmsd_calc
    echo "${WIZARD_NAME}: setting up RMSD calculation..."
    break
    ;;
    "Quit")
    break
    ;;
    *) echo "invalid option $REPLY";;
esac
done
