# Whaleprep

Arthur Zwaenepoel (2018-2019)

Nextflow pipeline and other utilities for preparing an analysis with Whale.
The pipeline does:

1. Alignment with PRANK
2. MCMC with MrBayes
3. CCD construction aith ALEobserve

The dependencies are nextflow, python3, PRANK, MrBayes and ALEobserve. The 
pipeline is configured to work with SGE cluster environments, and should be 
submitted from the head node.

To run the pipeline, do

```
nextflow whaleprep.nf --fasta <fastadir> 
```

where `fastadir` is directory with multifasta files of protein sequences for all
gene families of interest (one file per family). Optional arguments currently are:

```
--tools         path to whaleprep.py
--out           output directory name
--ngen          number of MCMC generations used in MrBayes
--samplefreq    sample frequency for the MCMC 
--burnin        the number of samples to discard as burn-in in ALEobserve
```
