#!/bin/bash
##script to run DTIfit from FSL FDT toolbox
##Eva van Heese
##April 2023, version 1.1 (last used May 2023)

##DTIFIT documentation
#https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FDT/UserGuide
#DTIFIT fits a diffusion tensor model at each voxel. 
#You would typically run dtifit on data that has been pre-processed and eddy current corrected."

##input requirements
#--data: diffusion weighted data, a 4D series of data volumes
#--out: output basename
#--mask: BET binary brain mask, a single binarised volume in diffusion space containing ones inside the brain and zeroes outside the brain (created in this script using bet)
#--bvecs: gradient directions, an ASCII text file containing a list of gradient directions applied during diffusion weighted volumes
#--bvals: b values, an ASCII text file containing a list of b values applied during each volume acquisition

##advanced options
#--save_tensor: save elements of the tensor (6 volumes: Dxx, Dyy, Dzz, etc) -> required for DTI-ALPS postprocessing!

##running instructions
#required adjustments to this script: change workdir to toplevel directory of subject directories
#run with ./perform_DTIfit.sh subj_list.txt

##expected output for each subject
#all eigenvectors, eigenvalues, basic DTI metrics (MD, FA, MO, S0), DTI-tensor

##define paths and variables
#workdir="/home/anw/evanheese/my-scratch/dtifit_corrected/1-PA-smashed-frontal"
workdir="/home/anw/evanheese/my-scratch/dtifit_corrected/2-AP-pointy-frontal"

cd ${workdir}

##run bet and DTIfit
while read sub; do
	echo "processing ${sub}..."	
	
	mkdir ${workdir}/${sub}
	cd ${workdir}/${sub}
	cp ${sub}_eddy_corrected_data.nii ${sub}_eddy_corrected_data_to_split.nii
	fslsplit ${sub}_eddy_corrected_data_to_split.nii
	cp vol0046.nii.gz ${sub}_b0_for_brain_mask.nii.gz
	rm -r vol0*.nii.gz
	bet ${sub}_b0_for_brain_mask.nii.gz ${sub}_brain.nii.gz -m -f 0.3 #generate binary mask - default thresholding (0.5) was lowered here to 0.3 to include a larger brain
	dtifit --data=${sub}_eddy_corrected_data.nii --out=${sub} --mask=${sub}_brain_mask.nii.gz --bvecs=${sub}_eddy_corrected_rotated_bvecs.bvec --bvals=${sub}.bval --save_tensor
	cd ..
done < /home/anw/evanheese/my-scratch/dtifit_corrected/subj_list_2.txt