/*
Nextflow pipeline for performing the preparatory analyses required for `whale`,
this excludes orthogroup inference. So it basically performs
    (1) pre-alignment filtering
    (2) multiple sequence alignment
    (3) posterior sampling of tree topologies
    (4) CCD inference using ALEobserve
*/

files = file("$params.filelist").readLines()
fasta = Channel.fromList(files).view()
tools = "$params.tools"

process Prequal{
    publishDir "${params.out}/prequal_fasta", mode: 'copy'

    input:
    path f from fasta

    output:
    file "${f}.filtered" into prequal_fasta

    script:
    """
    module load mafft
    module load python

    prequal $f
    """
}

/*
MAFFT alignment
*/
process MafftAlignment {
    publishDir "${params.out}/aln", mode: 'copy'
    cache "deep"

    input:
    file f from prequal_fasta

    output:
    file "${f}.nex" into mafft_msa

    script:
    """
    module load mafft
    module load python

    mafft --maxiterate 1000 --localpair ${f} > ${f}.mafft.msa
    OMP_NUM_THREADS=1 python3 $tools convert-aln \
        -i ${f}.mafft.msa -if "fasta" -o ${f}.nex -of "nexus"
        rm -f  ./${f}.mafft.msa
    """
}
