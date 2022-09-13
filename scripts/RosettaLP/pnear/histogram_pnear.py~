#!/bin/python

import sys
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from quality_measures import calculate_pnear
from parse_sc_file import extract_ligand_energy_landscape as interface_rmsd

def main():

    file_name=str(sys.argv[1])
    ligand_name=file_name[0:3]
    
    landscape_df = interface_rmsd(file_name)
    pnear = calculate_pnear(landscape_df["interface_delta_X"].astype(float), \
                            landscape_df["ligand_rms_no_super_X"].astype(float))
    bootstrap_name = ligand_name + "_bootstrap.csv"
    bootstraped_df = pd.read_csv(bootstrap_name)
    bootstraped_df = bootstraped_df.reset_index(drop=True)
    
    plt.hist(bootstraped_df["pnear_vals"], bins=40, color='k')
    plt.axvline(x=pnear, color="r")
    plt.title(file_name[0:3])
    plt.xlabel('Pnear')
    plt.xlim(0., 1.)
    plt.ylim(0, 400)
    plt.savefig(file_name[0:3] + "_bootstrap_final.pdf", format="pdf") #pdf
    sys.exit(0)

if __name__=="__main__":
    main()
