#!/bin/python3
import sys
import rdkit
from rdkit import Chem
from rdkit.Chem import AllChem
import typing
from typing import List
from random import randint

def random_library(sdf_file_name:str, lib_length:int):

    mol_supplier = Chem.SDMolSupplier(sdf_file_name)

    mol_list = []
    for x in range(0, lib_length):

        random_num = randint(0, len(mol_supplier))
        #print(random_num)

        selected_mol = mol_supplier[random_num]
        
        print("DEBUG: mol atoms" + str(len(selected_mol.GetAtoms())))
        while len(selected_mol.GetAtoms()) == 0:
            random_num = randint(0, len(mol_supplier))
            #print(random_num)

            selected_mol = mol_supplier[random_num]
            #print(Chem.MolToSmiles(selected_mol))
        print("First_pass: " + Chem.MolToSmiles(selected_mol))
        mol_list.append(selected_mol)

    return mol_list

def gen_3d_coords(mol_list):
    new_list = []
    for mol in mol_list:
        print("DEBUG: " + Chem.MolToSmiles(mol))
        mol_w_h = Chem.AddHs(mol)
        AllChem.EmbedMolecule(mol_w_h)
        new_list.append(mol_w_h)

    return new_list

def main():
    
    sdf_file_name: str = str(sys.argv[1])
    project_name: str = str(sys.argv[2])
    lib_length: int = int(sys.argv[3])
    mol_list = random_library(sdf_file_name, lib_length)
    #len(mol_list)
    #print(mol_list)
    
    newlist = gen_3d_coords(mol_list)
    sdf_out_name = project_name + ".sdf"
    
    with Chem.SDWriter(sdf_out_name) as w:
        for m in newlist:
            w.write(m)
    w.close()
    sys.exit(0)

if __name__ == "__main__":
    main()
