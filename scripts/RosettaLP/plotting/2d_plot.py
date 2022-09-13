#!/bin/python
#
##
## This python script is by Miguel Limcaoco production enjoy!
## email: limcaoco@umich.edu
##
#

import sys
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
 

DESCRIPTION="""
Simple 2D plot. Input is a TSV or space-sv file with any amount of rows but
only 2 columns.

Usage: $python 2D_plot.py ${FILE_NAME} ${X_AXIS_NAME} ${Y_AXIS_NAME}

"""
def makeDataFrame(file_name: str) -> pd.DataFrame:
    
    data_to_plot = np.genfromtxt(file_name)
    df = pd.DataFrame(data_to_plot)
    
    #cleaning empty rows and columns
    df = df.dropna(axis=1, how='all')
    df = df.dropna(axis=0, how='all')

    return df

def show_df(df: pd.DataFrame) -> None:
    print(str(sys.argv[0]), ": ", "Data Preview...")
    print(df)

def main():
    
    if len(sys.argv) <= 3:                                                                  
        print(str(sys.argv[0]), ": ", "ERROR, missing arguments. see documentation...")
        print(DESCRIPTION)
        sys.exit(1)    
    else:
        df = makeDataFrame(sys.argv[1])
        
        show_df(df)
        
        print(str(sys.argv[0]), ": ", "ploting...", str(sys.argv[1]))
        columns = list(df.columns.values)

        print(str(sys.argv[0]), ": ", "constructing plot...")
        plt.plot(df[columns[0]], df[columns[1]])
        plt.xlabel(str(sys.argv[2]))
        plt.ylabel(str(sys.argv[3]))

        print(str(sys.argv[0]), ": ", "saving plot as ", str(sys.argv[1]) , ".png...")
        fig_name = str(sys.argv[1]) + ".png"
        plt.savefig(fig_name)

        print(str(sys.argv[1]), ": ", "Script Complete...")
        sys.exit(0)
   
if __name__=="__main__":
    main()
