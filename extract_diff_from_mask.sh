#!/bin/bash
##script to extract ROI diffusivity from the xx, yy and zz diffusivity maps using manually drawn masks
##Eva van Heese
##May 2023, version 1.3

##input requirements
#DTI tensor.nii.gz: use optional flag while running DTI fit using the FSL diffusion Toolbox --save_tensor
#4 ROI masks per subject, for projection and association fibres, left and right hemisphere (see documentation), script by default assumes [mask_basename]-[proj/assoc]-[L/R].nii(.gz)
#subj_list.txt should contain one column with subject folder names along the rows

##running instructions
#required adjustments to this script: change workdir to toplevel directory of subject directories, adjust vars based on preferred output (could also use FA map), adjust basenames (i.e. non-changing aspect of subject name) for subject, masks, fibres, hemispheres
#run with ./script_diff_mask_extraction.sh subj_list.txt

##expected output for each subject
#output_${sub}.csv containing 4 columns, 12 rows, excluding headers (subject_outcome min max mean)
#diff_maps directory with whole-brain diffusivity maps of Dxx, Dyy, Dzz
#temp directory with ROI-only diffusivity maps (in-between step for value extraction, for reference)

##define paths and variables
#workdir="/home/anw/evanheese/my-scratch/dtifit_corrected/1-PA-smashed-frontal"
workdir="/home/anw/evanheese/my-scratch/dtifit_corrected/2-AP-pointy-frontal"
vars=("Dxx" "Dyy" "Dzz")
mask_basename="mask_DTI-ALPS-ROI"
fibre=("proj" "assoc")
hemi=("L" "R")

cd ${workdir}
mkdir output_raw	

##read subjects from subj_list.txt and extract values using fsl tools
while read -r sub; do
		
	#to subject directory
	echo "**working on subject ${sub}**"
	cd ${workdir}/${sub}

	#split DTI tensor into diffusivity maps of interest and store in diff_maps directory in subject folder
	fslsplit ${sub}_tensor.nii.gz -t
	mkdir ${workdir}/${sub}/diff_maps
	cp vol0000.nii.gz ${workdir}/${sub}/diff_maps/${sub}_Dxx.nii.gz 
	cp vol0003.nii.gz ${workdir}/${sub}/diff_maps/${sub}_Dyy.nii.gz
	cp vol0005.nii.gz ${workdir}/${sub}/diff_maps/${sub}_Dzz.nii.gz
	rm -r vol000*
	echo "----tensor succesfully split into diffusivity maps"

	#make output files a and b (raw data per subject)
	echo "subject_outcome" >> ${workdir}/${sub}/outputa_${sub}.csv
	echo "min max mean SD perc_2.5 median perc_97.5 ROI_voxels_n ROI_voxels_volume" >> ${workdir}/${sub}/outputb_${sub}.csv

	#make subfolder for temporary files in subject folder
	mkdir ${workdir}/${sub}/temp/

	#extract values for each variable, each fibre, each hemisphere and store in output files
	for v in ${vars[@]}; do
  		echo "------extracting ${v}"
		for f in ${fibre[@]}; do
			#echo "$f"
			for h in ${hemi[@]}; do
				#echo "$h"
				echo "${sub}_${v}_${f}_${h}" >> ${workdir}/${sub}/outputa_${sub}.csv
				fslmaths ${workdir}/${sub}/diff_maps/${sub}_${v}.nii.gz -mas ${workdir}/${sub}/${mask_basename}-${f}-${h}-00*_smri_dti_1.nii.gz ${workdir}/${sub}/temp/${sub}_${v}_${f}_${h}.nii.gz
				fslstats ${workdir}/${sub}/temp/${sub}_${v}_${f}_${h}.nii.gz -R -M -S -P 2.5 -P 50 -P 97.5 -V >> ${workdir}/${sub}/outputb_${sub}.csv
			done
		done
	done
	echo "--------done with  subject ${sub}"

	#merge output files and clean up subject folder
	paste -d ' ' outputa_${sub}.csv outputb_${sub}.csv > output_raw_${sub}.csv
	rm -r outputa_${sub}.csv outputb_${sub}.csv
	cp output_raw_${sub}.csv ${workdir}/output_raw
done < ${workdir}/subj_list_2.txt

#re-organise output into one file
cd ${workdir}/output_raw
head -n 1 output_raw_${sub}.csv > all_output_raw.csv #take header
tail -n +2 -q output_raw_0*.csv >> all_output_raw.csv #concatenate all files and remove headers