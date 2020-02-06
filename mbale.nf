
/*
Posterior inference using MrBayes. Currently hardcoded to LG+G4 model, with MCMC
of 110000 generations (of which 10000 are discarded as burn-in) and a sample is
taken every 10 generations.
*/
process MrBayesMCMC {
    input:
    file aln

    output:
    file "${aln}_mb/${aln}.treesample" into mb

    script:
    """
    module load mrbayes
    module load python
    mkdir ${aln}_mb
    sed  "s/|/_/g" ${aln} > ${aln}_mb/${aln}  # get alignment (replace | by _)
    cd ${aln}_mb
    echo "set autoclose=yes nowarn=yes" > ./mbconf.txt
    echo "execute ./${aln}" >> ./mbconf.txt
    echo "prset aamodelpr=fixed(lg)" >> ./mbconf.txt  # LG model
    echo "lset rates=gamma" >> ./mbconf.txt           # G  model
    echo "mcmcp diagnfreq=100" >> ./mbconf.txt        # diagnostics every 100 gns
    echo "mcmcp samplefreq=$params.samplefreq" >> ./mbconf.txt        # sample every 10 gns
    echo "mcmc ngen=$params.ngen savebrlens=yes nchains=1" >> ./mbconf.txt
    echo "sumt" >> ./mbconf.txt
    echo "sump" >> ./mbconf.txt
    echo "quit" >> ./mbconf.txt

    mb < ./mbconf.txt > ./log.txt
    OMP_NUM_THREADS=1 python3 $tools mbtrees ${aln}.run1.t ${aln}.treesample
    """
}


/*
Run ALEobserve to get the CCD.
*/
process AleObserve {
    publishDir "${params.out}"

    input:
    file mb

    output:
    file "${mb}.ale" into ale

    script:
    """
    module load ALE_trees
    ALEobserve $mb burnin=$params.burnin
    """
}
