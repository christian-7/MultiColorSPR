## MultiColorSPR

Accessory software to perform multi-color single particle reconstruction from single molecule localization microscopy (SMLM) datasets.

### Workflow

The provided software generates large dual-color particle libraries from high-throughput SMLM datasets, by performing the following steps: 

- channel registration using 1) an affine and  2) a rigid linear translation
- particle segmentation 
- particle filtering and image generation

To generte a 3D reconstruction from the input 2D particle library, follow the instructions provided in `SPR from SMLM in Scipion`.

Dual-color particle datasets are co-oriented (for proteins with a shared symmetry axis) and reconstructed in Scipion as described in `SPR from SMLM in Scipion`. Axial translation can be calculated using `CC_Image_Alignment.m` and tested using the smulated dataset in `test_data_9_fold`.

### General Information

For pseudocode and processing instructions, see `Documentation`.

The code was developed and tested in MATLAB2016b for Windows 10 and macOS 10.12.6 and requires no non-standard hardware.

To install, copy the repository `MultiColorSPR`, open and run each script following the instructions therein and in `Documentation`. No install time.

### Demo

Test Datasets are available at https://doi.org/10.5281/zenodo.1127010

Detailed instructions on how to process the test datasets can be found in `Documentation`. After downloading, unpack the file `test_data_for_MultiColorSPR.zip`. Either copy the folder into the `MultiColorSPR` folder or update the path information in the beginning of each script accordingly. Currently, each path is formatted for macOS.

### Dependencies 

1)	To detect the beads within `Calculate_AffineT_from_Beads.m`, we use parts of a the [Matlab Particle Tracking Code repository](http://site.physics.georgetown.edu/matlab/).

2)	For DBSCAN, within `particle_filter.m`, we use an implementation from [Michal Daszykowski](http://www.chemometria.us.edu.pl/download/DBSCAN.M)

3)	Within `particle_filter.m`, during the calculation of the shape descriptors, we use the code [fit_ellipse.m](https://ch.mathworks.com/matlabcentral/fileexchange/3215-fit-ellipse)

4)	We further make use of the code for [efficient subpixel image registration by cross-correlation](https://ch.mathworks.com/matlabcentral/fileexchange/18401-efficient-subpixel-image-registration-by-cross-correlation)



