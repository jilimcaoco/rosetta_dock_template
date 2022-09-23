#!/bin/bash

#to set up new project just run this file at the project directory
#do not forget to fix the path to rosetta for your machine. 

cp -r $ROSETTA_DOCK/input_files .
cp -r $ROSETTA_DOCK/output_files .
cp -r $ROSETTA_DOCK/intermediate_files .
cp -r $ROSETTA_DOCK/output_files .
cp setup_rosetta_dock_env.sh . 
