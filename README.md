# DTI-ALPS
DTI-ALPS: Diffusion Tensor Imaging Along the Perivascular Space

## The theory
Taoka and colleagues ([Taoka et al., 2017](https://pubmed.ncbi.nlm.nih.gov/28197821/)) proposed a post-processing technique to be applied to diffusion tensor images: diffusion tensor image analysis along the perivascular space (DTI-ALPS). The DTI-ALPS index aims to reflect diffusion along the perivascular space as a measure of brain clearance and has been widely applied in a diverse range of clinical populations (>140 publications in the last 5 years). The index is calculated based on diffusivity in a small area of the brain with a unique, perpendicular position of two fibre tracts and blood vessels, next to the lateral ventricles. Neurodegenerative disorders in which protein accumulations play a central role, such as Alzheimer’s and Parkinson’s disease, showed lower DTI-ALPS indices compared to healthy controls ([Cai et al., 2023](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9804035/); [Chang et al., 2023](https://pubmed.ncbi.nlm.nih.gov/37097074/); [Chen et al., 2021](https://pubmed.ncbi.nlm.nih.gov/33680283/); [Ma et al., 2021](https://www.frontiersin.org/journals/aging-neuroscience/articles/10.3389/fnagi.2021.773951/full); [Taoka et al., 2017](https://pubmed.ncbi.nlm.nih.gov/28197821/)). Of note, the index and what it claims to reflect has been disputed as DTI-ALPS is not CSF- nor ISF-selective and is only measured at a single location in the brain. Changes in DTI-ALPS index could therefore also originate from changes in tissue pulsatility, changes in white matter structure or presence of more fluid in the brain (i.e. enlarged PVS, free water due to demyelination, white matter hyperintensities; [Ringstad, 2024](https://link.springer.com/article/10.1007/s00234-023-03270-2); [Taoka et al., 2024](https://pubmed.ncbi.nlm.nih.gov/38569866/)). 

## Overview of the general workflow
1) Standard DTI processing
2) Drawing Regions of Interest (ROIs)
3) Calculating the DTI-ALPS index

## Required software and dependencies
The DTI processing can be performed with any preferred software. For ROI drawing, you require software to open FA maps and draw a region to extract diffusivity values from. This could for example be done using FSLeyes and FSLmaths/stats. 

## 1) Standard DTI processing
Process as usual. Note that you need to output the tensor as this is usually not part of the default output (also see [perform_DTIfit.sh](https://github.com/evavanheese/DTI-ALPS/blob/main/perform_DTIfit.sh)). In dtifit from FSL this can be done with the `--save-tensor` flag:
```
dtifit --data=${sub}_eddy_corrected_data.nii --out=${sub} --mask=${sub}_brain_mask.nii.gz --bvecs=${sub}_eddy_corrected_rotated_bvecs.bvec --bvals=${sub}.bval --save_tensor
```

Split tensor into diffusivity maps:
```
fslsplit ${sub}_tensor.nii.gz -t
```
Output:

`vol0000.nii.gz` equals Dxx

`vol0003.nii.gz` equals Dyy

`vol0005.nii.gz` equals Dzz

## 2) Drawing Regions of Interest (ROIs)
The ROI analysis consists of two steps: (1) drawing ROIs and (2) extracting values from the ROIs. Before drawing the regions of interest (ROIs), some decisions need to be made. Previous studies vary in ROI size, shape, location, hemisphere(s), type of map used to draw ROIs, and the number of raters. A subset of the literature using the DTI-ALPS index in sleep and neurodegenerative disorders (n=18 studies), is summarised below:

|ROI characteristic|possibilities described in reviewed studies| | | |studies without/with poor description|
|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|
|**ROI size and shape**|5 mm diameter sphere (8/18)|4 mm diameter sphere (1/18)|3x3 pixel square (2/18)|varied size and shape per subject with matched centre position (1/18)|6/18|
|**ROI location**|at the level of the lateral ventricular body (15/18)||||3/18|
|**ROI placement**|left only (all participants were right-handed; 6/18)|bilateral (6/18)|||6/18|
|**ROI drawn on..**|colour-coded FA map (11/18)|colour-coded FA map with the assistance of SWI scan (4/18)|ADC maps (1/18)||2/18|
|**ROI raters**|1 rater (2/18)|2 raters (5/18)|||11/18|

Similar to previous studies, we decided to draw bilateral, rectangular 2D ROIs of 3x3 pixels, at the most superior part of the lateral ventricular body on the colour-coded FA maps. We used the ellipsoid map instead of the standard FA map. 

**Drawing ROIs in FSLeyes**
1) Open the colour-coded FA map (possibly overlay on a brain image, i.e. B0, for better identification)
2) Correctly position the green location cursor at the most superior part of the lateral ventricular body (use both sagittal and horizontal view), preferably even more superior than the most superior tip of the ventricle because that is where most veins run perpendicular to the ventricle
3) Select the horizontal view and zoom in on the area next to the lateral ventricular body
4) Click tools -> edit mode
5) Click the icon in the left sidebar to create an empty 3D mask (note: create a separate mask for the projection and association ROI and ensure the correct mask is selected when drawing the ROI)
6) Use the select icon in the top bar to select an ROI, click the pencil tool
7) Ensure that the 2D button is selected in the top bar
8) ROI default size is 3x3 pixels, this can be altered in the top bar ("selection size")
9) Select the ROIs for the projection/association fibres
10) Possibly redo/adjust the ROIs using the undo and redo arrows in the sidebar and eraser in the top bar
11) If you are content with the ROI, binarise it using the fill icon in the sidebar. Before clicking, ensure that the fill value in the top bar is set to 1. The ROI will turn white.
12) Save the ROI mask by clicking the save icon in the overlay list. 

![image](https://github.com/user-attachments/assets/835330ae-fcf8-477c-8899-4fb289c74dc6)
**Figure 1.** FSLeyes screenshot showing the sagittal and horizontal view of the brain. The green location cursor is placed along the midline of the brain (horizontal view), a bit above the most superior part of the lateral ventricular body in the midline (sagittal view). 

![image](https://github.com/user-attachments/assets/8dcbfabf-ce8d-4f8d-94a1-de79dc520949)
**Figure 2.** Enlargement of the area of interest (horizontal view, right hemisphere) showing a predominantly blue (projection fibres) and green (association fibres) area.

![image](https://github.com/user-attachments/assets/3e1cffcd-695d-4baa-a7d7-6ec5c4daea34)
**Figure 3.** 3x3 pixel 2D ROI is drawn below the lateral ventricular body on the horizontal view. Ensure that the ROIs for the projection fibres (blue, left) and association fibres (green, right) are aligned on the A-P axis.

**Extracting values from ROIs**
1) Load FSL in the command line
2) Personalise and run the following command to extract only the voxels from a certain map that are included in the mask and put them in a new output file. To calculate the DTI-ALPS index, we need the three diffusivity directions from the fitted tensor. 

Template:
```
fslmaths '[map-of-interest].nii(.gz)' -mas '[mask_proj].nii(.gz)' '[name_output_file].nii(.gz)'
```

Example:
```
fslmaths 'sub-01_Dxx.nii.gz' -mas 'mask_DTI-ALPS-ROI_proj_sub-01.nii.gz' 'sub-01_DTI-ALPS_proj_Dxx.nii.gz'
```

3) Personalise and run the following command to extract min and max intensity (-R), mean (-M). You can add flags to output more information, for example to give coordinates of the maximum intensity voxel (-x):

Template:
```
fslstats name_output_file -R -M'
```

Example:
```
fslstats sub-01_DTI-ALPS_proj_Dxx.nii.gz -R -M'
```

FAQ's:
- If you find some 0’s in your output values, check whether separate ROIs were saved in separate masks.
- If you find only 0’s in your output values, check whether you binarised your masks.

Useful sources:

- [FSLeyes](https://open.win.ox.ac.uk/pages/fsl/fsleyes/fsleyes/userdoc/index.html)

Available code:

- Please see [extract_diff_from_mask.sh](https://github.com/evavanheese/DTI-ALPS/blob/main/extract_diff_from_mask.sh) to extract the diffusivities from the mask.

- Please see [calculate_DTI_ALPS_index_v2.ipynb](https://github.com/evavanheese/DTI-ALPS/blob/main/calculate_DTI_ALPS_index_v2.ipynb) to calculate the DTI-ALPS index.

## 3) Calculating the DTI-ALPS index
We calculate the DTI-ALPS index according to the following formula:
![image](https://github.com/user-attachments/assets/5d2cbccb-c2b9-46c5-bce9-75ef131eaed6)

## Criticism: cautious interpretation
While the DTI-ALPS index has been widely investigated, it is important to recognize several limitations that may affect the robustness and interpretation of the findings. In particular, certain confounding factors should be carefully considered, as they could significantly influence the outcomes. Moreover, we are still uncertain about what this method reflects exactly, which further complicates its interpretation and necessitates cautious evaluation.

Confounding factors to consider:
|Confounding factor|Publication|
|------------------|-----------------|
|Echo time: significantly greater ALPS index for shorter TEs|[Taoka 2022b]()|
|Head rotation: reorientation of maps improves ALPS index reproducibility|[Tatekawa 2022](https://link.springer.com/article/10.1007/s11604-022-01370-2)| 
|ROI placement: higher reproducibility for bilateral ROI placement|[Taoka 2022b](https://link.springer.com/article/10.1007/s11604-021-01187-5)|
|Age: significantly lower ALPS index for older participants|[Toaka 2022a](https://link.springer.com/article/10.1007/s11604-022-01275-0)| 

## Sources
Cai, X., Chen, Z., He, C., Zhang, P., Nie, K., Qiu, Y., Wang, L., Wang, L., Jing, P., & Zhang, Y. (2023). Diffusion along perivascular spaces provides evidence interlinking compromised glymphatic function with aging in Parkinson’s disease. CNS Neuroscience & Therapeutics, 29(1), 111–121.

Chang, H.-I., Huang, C.-W., Hsu, S.-W., Huang, S.-H., Lin, K.-J., Ho, T.-Y., Ma, M.-C., Hsiao, W.-C., & Chang, C.-C. (2023). Gray matter reserve determines glymphatic system function in young-onset Alzheimer’s disease: Evidenced by DTI-ALPS and compared with age-matched controls. Psychiatry and Clinical Neurosciences, 77(7), 401–409.

Chen, H.-L., Chen, P.-C., Lu, C.-H., Tsai, N.-W., Yu, C.-C., Chou, K.-H., Lai, Y.-R., Taoka, T., & Lin, W.-C. (2021). Associations among Cognitive Functions, Plasma DNA, and Diffusion Tensor Image along the Perivascular Space (DTI-ALPS) in Patients with Parkinson’s Disease. Oxidative Medicine and Cellular Longevity, 2021, 4034509.

Ma, X., Li, S., Li, C., Wang, R., Chen, M., Chen, H., & Su, W. (2021). Diffusion Tensor Imaging Along the Perivascular Space Index in Different Stages of Parkinson’s Disease. Frontiers in Aging Neuroscience, 13, 773951.

Ringstad, G. (2024). Glymphatic imaging: a critical look at the DTI-ALPS index. Neuroradiology, 66(2), 157–160.

Taoka, T., Masutani, Y., Kawai, H., Nakane, T., Matsuoka, K., Yasuno, F., Kishimoto, T., & Naganawa, S. (2017). Evaluation of glymphatic system activity with the diffusion MR technique: diffusion tensor image analysis along the perivascular space (DTI-ALPS) in Alzheimer’s disease cases. Japanese Journal of Radiology, 35(4), 172–178.

Taoka, T., Ito, R., Nakamichi, R., Nakane, T., Sakai, M., Ichikawa, K., ... & Naganawa, S. (2022a). Diffusion-weighted image analysis along the perivascular space (DWI–ALPS) for evaluating interstitial fluid status: age dependence in normal subjects. Japanese Journal of Radiology, 40(9), 894-902.

Taoka, T., Ito, R., Nakamichi, R., Kamagata, K., Sakai, M., Kawai, H., ... & Naganawa, S. (2022b). Reproducibility of diffusion tensor image analysis along the perivascular space (DTI-ALPS) for evaluating interstitial fluid diffusivity and glymphatic function: CHanges in Alps index on Multiple conditiON acquIsition eXperiment (CHAMONIX) study. Japanese journal of radiology, 40(2), 147-158.

Taoka, T., Ito, R., Nakamichi, R., Nakane, T., Kawai, H., & Naganawa, S. (2024). Diffusion Tensor Image Analysis ALong the Perivascular Space (DTI-ALPS): Revisiting the Meaning and Significance of the Method. Magnetic Resonance in Medical Sciences: MRMS: An Official Journal of Japan Society of Magnetic Resonance in Medicine, 23(3), 268–290.

Tatekawa, H., Matsushita, S., Ueda, D., Takita, H., Horiuchi, D., Atsukawa, N., ... & Miki, Y. (2023). Improved reproducibility of diffusion tensor image analysis along the perivascular space (DTI-ALPS) index: an analysis of reorientation technique of the OASIS-3 dataset. Japanese Journal of Radiology, 41(4), 393-400.
