#!/bin/python
#
##
## This python script is a Miguel Limcaoco production enjoy!
## email: limcaoco@umich.edu
##
#
#  Import statements
import sys
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from quality_measures import calculate_pnear
from parse_sc_file import extract_ligand_energy_landscape as interface_rmsd

def main():
    #file_name = input(str(sys.argv[0]) + ": Enter name of scorefile...")
    file_name = str(sys.argv[1])
    print(str(sys.argv[0]) + ": creating energy landscape plot for " + file_name)

    landscape_df = interface_rmsd(file_name)
    #print(landscape_df)    
    print(str(sys.argv[0]), ": ", "plotting...", file_name[:-3])

    print(str(sys.argv[0]), ": ", "constructing plot...")
    plt.plot(landscape_df["ligand_rms_no_super_X"], landscape_df["interface_delta_X"], '.k', alpha=0.3)
    plt.xlabel("RMSD")
    plt.ylabel("interface energy (REU)")

    print(str(sys.argv[0]), ": ", "saving plot as ", file_name[:-3] , ".png...")
    fig_name = file_name[:-3] + ".pdf"
    plt.savefig(fig_name, format='pdf')

    #print(str(sys.argv[0]), ": ", "calculating pnear now...")
    #pnear = calculate_pnear(landscape_df["interface_delta_X"], landscape_df["ligand_rms_no_super_X"] )
    #print(str(sys.argv[0]), ": ", "pnear is: ", pnear)

    print(str(sys.argv[0]), ": ", "Pau!")
    sys.exit(0)
    

if __name__ == "__main__":
    main()
