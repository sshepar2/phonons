# phonons

Includes scripts which were helpful when using VASP in conjunction with phonopy/phono3py as well as Quantum Espresso and D3Q.

### fc2_diff.sh

Useful if doing phonon calculations with Quantum Espresso. Used to test 2nd order force constant convergence.
Takes in two force constant files Fourier transformed (using d3_q2r.x executable D3Q package) from dynamical matrices calculated from ph.x.
Finds common force constants and takes the difference since it is assumed a different amount of q-points were sampled on the same system.

It should also work if the usual q2r.x executable is used to Fourier transform. The only difference is the d3_q2r.x executable centers
the force constants so they are symmetric about zero. As long as the same executable is used on both files you'll get what you need. See the bash script
for further information. Not efficient at all. If file is large will take very long. Recommend optimizing.


### jjj
