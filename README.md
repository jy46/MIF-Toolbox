# MIF-Toolbox
Repository for MATLAB code used for information theoretic analysis of neural signals. In particular, this software computes Mutual Information in the Frequency domain (MIF) (Malladi et al., 2018) between time series data. The code uses a new low-variance approach that is improved for correlating MIF between neural signals with relevent experimental measurements, such as the accuracy of a monkey during a task. 

## Usage
The key function that you can use for MIF estimation is <strong>helper_functions/miCompute.m</strong>, which takes in 6 arguments:
<ol>
<li><strong>x</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- input data for first signal in shape (time)X(trials/windows)</li>
<li><strong>y</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- input data for second signal in shape (time)X(trials/windows)</li>
<li><strong>Fs</strong>&nbsp;&nbsp;&nbsp;- sampling frequency in Hz</li>
<li><strong>Fm</strong>&nbsp; - maximum frequency to compute MIF for in Hz (e.g. Fm = 100 Hz means MIF will not be computed above 100 Hz)</li>
<li><strong>K</strong> &nbsp;&nbsp;&nbsp; - number of neighbors for k-nearest neighbors (k-nn) mutual information estimate (Kraskov et al., 2004), which should be half the number of samples for decreasing variance (Kraskov et al., 2004)</li>
<li><strong>Np</strong> &nbsp;- number of permutations for significance testing</li>
</ol>

Using an approach based on a prior work (Pantazis et al., 2005), significance testing relies on using a threshold for MIF values equal to the 95th percentile of a maximum distribution composed of maximum MIF samples across frequency for each permutation. In particular, trials/windows of <strong>x</strong> are permuted and then MIF is computed, from which the maximum MIF value across frequencies is contributed to the maximum distribution.

The output of the function is two variables:
<ol>
<li><strong>MI</strong> - vector of MIF values</li>
<li><strong>f</strong>&nbsp;&nbsp;&nbsp; - vector of frequencies corresponding to MIF values</li>
</ol>

Therefore, a full call would be: <strong>[ MI, f ] = miCompute( x, y, Fs, Fm, K, Np )</strong>

## Example
We provide an example file <strong>miExampleScript.m</strong> at the root of the repository that calls this function to compute the MIF between two simulated random processes which are composed of random sinusoids to reflect neural oscillations. This is inspired by prior work (Malladi et al., 2018). For this model, MIF is analytically known and the estimates of our implementation can be compared with those true MIF values. The script displays a scatter plot comparing these estimated and true MIF values, along with the correlation.

The three sinusoids we consider are as follows:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; X(t) &nbsp;= Acos(2&pi; &fnof;0t+&Theta;)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; W(t) = Bcos(2&pi; &fnof;0t+&Phi;)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Y(t) &nbsp;= X(t) + W(t)  

where A ~ Rayleigh(&#963;_A = 1), B ~ Rayleigh(&#963;_B), &Theta; ~ uniform(0, 2&pi;), and &Phi; ~ uniform(0, 2&pi;).

Accordingly, the MIF MI_XY(&fnof;0,&fnof;0) is computed between X and Y for &fnof;0, and is known to be (Malladi et al., 2018):

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; MI_XY(&fnof;0,&fnof;0) = log(1 + (S_X(&fnof;0)/S_W(&fnof;0))) = log(1 + (1/&#963;_B))

when &#963;_A = 1.

Therefore, the true MI values used in the example script are randomly selected over a range by varying &#963;_B. The resulting scatter plot shows the relationship between these true MI_XY(&fnof;0,&fnof;0) values and estimated values produced by our technique.

## Compatibility
This software has been successfully tested in MATLAB R2020a on Windows 10, macOS Catalina, and Ubuntu 20.04. Pre-compiled mex files are included (compiled using modified code from TSTOOL (DPI Göttingen, 2009)), and the <strong>helper_functions/load_mex_directory.m</strong> script automatically adds the OS-relavant folder containing these mex files.

For future compatibility, if the pre-compiled mex files no longer work in a newer release of MATLAB, we have included a function tsool_files/makemex.m (modified from TSTOOL (DPI Göttingen, 2009)) that automatically will recompile the mex files from source and overwrite the existing mex files in the OS-appropriate folder. To utilize this function, change your directory to tstool_files/ and then in MATLAB call "makemex" with no input arguments.

## Method
The key idea of this augmentation to the prior MIF approach (Malladi et al., 2018) is that we capitalize on the mutlitaper method (Thomson 1982) to reduce estimation variance and sharpen the capability of MIF estimation in correlation analyses. In particular, we implement what we call the "post" approach, where MI_XY(&fnof;0,&fnof;0) is computed separately for each taper and then the average MIF value taken across tapers is treated as the estimated MI_XY(&fnof;0,&fnof;0). Each MI estimate is performed via k-nn MI estimation (Kraskov et al., 2004).

## Acknowledgement
We thank DPI Göttingen for TSTOOL (DPI Göttingen, 2009), which is a software package that we have included some of the code from in order to perform k-nn estimation of MI (Kraskov et al., 2004). We have modified the code to produce up-to-date mex files, and both the modified code and mex files are included in the tstool_files/ directory. Since their code was licensed as GPLv2, we have also adopted the GPLv2 license for this toolbox.

## References
<ol>
  <li>Malladi et al. Mutual information in frequency and its application to measure cross-frequency coupling in epilepsy. IEEE Transactions on Signal Processing, 66, 2018.</li>
  <li>Kraskov et al. Estimating mutual information. Physical Review E, 69, 2004.</li>
  <li>Pantazis et al. A comparison of random field theory and permutation methods for the statistical analysis of MEG data. NeuroImage, 25, 2005.
  <li>Thomson. Spectrum estimation and harmonic analysis. Proceedings of the IEEE, 70, 1982.</li>
  <li>DPI Göttingen. TSTOOL. University of Göttingen, Göttingen, Germany, 2009. http://www.dpi.physik.uni-goettingen.de/tstool/.</li>
</ol>
