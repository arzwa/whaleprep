# Whaleprep

Arthur Zwaenepoel (2018-2019)

Nextflow pipeline and other utilities for preparing an analysis with Whale.
The pipeline does:

1. Alignment with PRANK
2. MCMC with MrBayes
3. CCD construction aith ALEobserve

The dependencies are nextflow, python3, PRANK, MrBayes and ALEobserve.

To run the pipeline, do

```
nextflow <path to whaleprep>/whaleprep.nf --tools <path to whaleprep>/whaleprep.py --fasta <fastadir>
```

where `fastadir` is directory with multifasta files of protein sequences for all
gene families of interest (one file per family).
