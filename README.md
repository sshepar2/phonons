# phonons

Includes scripts which were helpful when using VASP in conjunction with phonopy/phono3py as well as Quantum Espresso and D3Q.

## Quantum Espresso-D3Q

### fc2_diff.sh

Useful if doing phonon calculations with Quantum Espresso. Used to test 2nd order force constant convergence.
Takes in two force constant files Fourier transformed (using d3_q2r.x executable D3Q package) from dynamical matrices calculated from ph.x.
Finds common force constants and takes the difference since it is assumed a different amount of q-points were sampled on the same system.

It should also work if the usual q2r.x executable is used to Fourier transform. The only difference is the d3_q2r.x executable centers
the force constants so they are symmetric about zero. As long as the same executable is used on both files you'll get what you need. See the bash script
for further information. Not efficient at all. If file is large will take very long. Recommend optimizing.

## VASP-phonopy-phono3py

### VASP-setup.sh

Useful after using phonopy/phono3py to generate all the displaced POSCAR files, sometimes several hundred in phono3py.
The script sets up VASP jobs and submits them for each generated POSCAR file.

### check.sh

Useful to check the status of the many jobs submitted with VASP-setup.sh. Performes 4 checks for successful job completion and generates a 
file called 'check.out' summarizing the current status of your submissions. It includes how many jobs have completed successfully, along 
with other useful information such as the number of electronic steps and the time taken to complete the calculation. An example 'check.out'
file is included under /phonons/.

### phono3py-setup.sh

When calculating force constants with phonopy/phono3py needs all vasprun.xml files for all displaced POSCARS.
This just moves all vasprun.xml files into directories called disp-#####. Not entirely necessary.


