#!/bin/bash 

RMSD_JOB_NAME=${1}
LIGAND_DOCK_JOB_NAME=${2}

cat > rosetta_runs/ligand_docking_runs/${LIGAND_DOCK_JOB_NAME}/3.analysis.sh <<EOF
#!/bin/bash
#

#creating master score files and placeing them in docking_plots
for LIGAND_DIR in \${PROJ_DIR}/output_files/${RMSD_JOB_NAME}/rmsd_scores/*; do 
    LIGAND=$(echo $(basename "\${LIGAND_DIR}"))
    echo "creating master file for \${LIGAND}"
    cat ${LIGAND_DIR}/*.sc >> ./docking_plot/\${LIGAND}_rmsd_master.sc
    done 

#now creating energy landscape plots
cd ./docking_plots
for LIGAND_SC in *master.sc; do 
    python \${ROSETTA_DOCK}/scripts/RosettaLP/plotting/plot_energy_landscape.py \${LIGAND_SC}
    done
cd ..

#now calculating pnear with bootstraping 
cd ./docking_plots
for LIGAND_SC in *master.sc; do 
    python \${ROSETTA_DOCK}/scripts/RosettaLP/pnear/pnear_w_bootstrap.py \${LIGAND_SC}
    done
cd ..
EOF
