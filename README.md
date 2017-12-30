## MultiColorSPR

Accessory software to perform multi-color single particle reconstruction from SMLM datasets

### General Information

For pseudocode and processing instructions, see `Documentation`.

The code was developed and tested in MATLAB2016b for Windows 10 and macOS 10.12.6 and requires no non-standard hardware.

To install, copy the repository `MultiColorSPR`, open and run each script following the instructions therein and in `Documentation`. No install time.

### Demo

Test Datasets are available at https://doi.org/10.5281/zenodo.1127010

Instructions can be found in `Documentation`. After downloading, unpack and open `test_data_for_MultiColorSPR`. Either copy the folder into the `MultiColorSPR` folder or update the path information in the beginning of each script accodingly.

### Dependencies 

1)	To detect the beads within `Calculate_AffineT_from_Beads.m`, we use parts of a the [Matlab Particle Tracking Code repository](http://site.physics.georgetown.edu/matlab/).

2)	For DBSCAN, within `particle_filter.m`, we use an implementation from [Michal Daszykowski](http://www.chemometria.us.edu.pl/download/DBSCAN.M)

3)	Within `particle_filter.m`, during the calculation of the shape descriptors, we use the code [fit_ellipse.m](https://ch.mathworks.com/matlabcentral/fileexchange/3215-fit-ellipse)

4)	We further make use of the code for [efficient subpixel image registration by cross-correlation](https://ch.mathworks.com/matlabcentral/fileexchange/18401-efficient-subpixel-image-registration-by-cross-correlation)

