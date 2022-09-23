#!/bin/python3
import sys
import rdkit
from rdkit import Chem
import typing
from typing import List

def sdf_to_smiles(sdf_file_name:str) -> List[str]:

    mol_supplier = Chem.SDMolSupplier(sdf_file_name)

    
    smiles_list: List[str] = []
    for count, mol in enumerate(mol_supplier):

        mol_smiles = Chem.MolToSmiles(mol)
        list_string = mol_smiles + " " + str(count)
        smiles_list.append(list_string)

    return smiles_list

def write_smiles_csv(smiles_list: List[str], project_name: str) -> None:

    file_name = project_name + "_smiles.csv"
    f = open(file_name, "a")
    
    for line in smiles_list:
        f.write(line+"\n")

    f.close()
    return None
    
def main():
    
    sdf_file_name: str = str(sys.argv[1])
    project_name: str = str(sys.argv[2])
    
    smiles_list = sdf_to_smiles(sdf_file_name)
    write_smiles_csv(smiles_list, project_name)

    sys.exit(0)

if __name__ == "__main__":
    main()
