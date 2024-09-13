# DTI-ALPS
DTI-ALPS: Diffusion Tensor Imaging Along the Perivascular Space

## The theory
Taoka and colleagues ([Taoka et al., 2017](https://pubmed.ncbi.nlm.nih.gov/28197821/)) proposed a post-processing technique to be applied to diffusion tensor images: diffusion tensor image analysis along the perivascular space (DTI-ALPS). The DTI-ALPS index aims to reflect diffusion along the perivascular space as a measure of brain clearance and has been widely applied in a diverse range of clinical populations (>140 publications in the last 5 years). The index is calculated based on diffusivity in a small area of the brain with a unique, perpendicular position of two fibre tracts and blood vessels, next to the lateral ventricles. Neurodegenerative disorders in which protein accumulations play a central role, such as Alzheimer’s and Parkinson’s disease, showed lower DTI-ALPS indices compared to healthy controls ([Cai et al., 2023](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9804035/); [Chang et al., 2023](https://pubmed.ncbi.nlm.nih.gov/37097074/); [Chen et al., 2021](https://pubmed.ncbi.nlm.nih.gov/33680283/); [Ma et al., 2021](https://www.frontiersin.org/journals/aging-neuroscience/articles/10.3389/fnagi.2021.773951/full); [Taoka et al., 2017](https://pubmed.ncbi.nlm.nih.gov/28197821/)). Of note, the index and what it claims to reflect has been disputed as DTI-ALPS is not CSF- nor ISF-selective and is only measured at a single location in the brain. Changes in DTI-ALPS index could therefore also originate from changes in tissue pulsatility, changes in white matter structure or presence of more fluid in the brain (i.e. enlarged PVS, free water due to demyelination, white matter hyperintensities; [Ringstad, 2024](https://link.springer.com/article/10.1007/s00234-023-03270-2); [Taoka et al., 2024](https://pubmed.ncbi.nlm.nih.gov/38569866/)). 

## Overview of the general workflow
1) Standard DTI processing
2) Drawing Regions of Interest (ROIs)
3) Calculating the DTI-ALPS index

## Required software and dependencies
The DTI processing can be performed with any type of preferred software. For ROI drawing, you require software to open FA maps and draw a region to extract diffusivity values from. This could for example be done using FSLeyes and FSLmaths/stats. 

## Criticism: cautious interpretation

## Sources
Cai, X., Chen, Z., He, C., Zhang, P., Nie, K., Qiu, Y., Wang, L., Wang, L., Jing, P., & Zhang, Y. (2023). Diffusion along perivascular spaces provides evidence interlinking compromised glymphatic function with aging in Parkinson’s disease. CNS Neuroscience & Therapeutics, 29(1), 111–121.

Chang, H.-I., Huang, C.-W., Hsu, S.-W., Huang, S.-H., Lin, K.-J., Ho, T.-Y., Ma, M.-C., Hsiao, W.-C., & Chang, C.-C. (2023). Gray matter reserve determines glymphatic system function in young-onset Alzheimer’s disease: Evidenced by DTI-ALPS and compared with age-matched controls. Psychiatry and Clinical Neurosciences, 77(7), 401–409.

Chen, H.-L., Chen, P.-C., Lu, C.-H., Tsai, N.-W., Yu, C.-C., Chou, K.-H., Lai, Y.-R., Taoka, T., & Lin, W.-C. (2021). Associations among Cognitive Functions, Plasma DNA, and Diffusion Tensor Image along the Perivascular Space (DTI-ALPS) in Patients with Parkinson’s Disease. Oxidative Medicine and Cellular Longevity, 2021, 4034509.

Ma, X., Li, S., Li, C., Wang, R., Chen, M., Chen, H., & Su, W. (2021). Diffusion Tensor Imaging Along the Perivascular Space Index in Different Stages of Parkinson’s Disease. Frontiers in Aging Neuroscience, 13, 773951.

Ringstad, G. (2024). Glymphatic imaging: a critical look at the DTI-ALPS index. Neuroradiology, 66(2), 157–160.

Taoka, T., Ito, R., Nakamichi, R., Nakane, T., Kawai, H., & Naganawa, S. (2024). Diffusion Tensor Image Analysis ALong the Perivascular Space (DTI-ALPS): Revisiting the Meaning and Significance of the Method. Magnetic Resonance in Medical Sciences: MRMS: An Official Journal of Japan Society of Magnetic Resonance in Medicine, 23(3), 268–290.

Taoka, T., Masutani, Y., Kawai, H., Nakane, T., Matsuoka, K., Yasuno, F., Kishimoto, T., & Naganawa, S. (2017). Evaluation of glymphatic system activity with the diffusion MR technique: diffusion tensor image analysis along the perivascular space (DTI-ALPS) in Alzheimer’s disease cases. Japanese Journal of Radiology, 35(4), 172–178.


