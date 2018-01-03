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

### SMLM simulator

We provide a simple particle simulator that generates localization maps from ground truth models. The folder `SMLM simulator` contains all required files as well as a ground truth example `GT_Cep152_Sas6.mat`. To simulate a particle dataset, open `simulate_particles_fromGT.m` and follow the steps described therein. 

Briefly, the script will perform the following actions:

- load the ground truth model (scatter of expected label positions)
- define simulation parameters (number of particles, number of frames,  labelling efficiency)
- for each simulated structure, the ground truth is randomly rotated and reduced to a number of labels based on the labelling efficiency
- populate each simulated label with localizations simulated according to measured distributions for photon count, localization precision, as well as on- and off-time
- generate image library 





