"""
Arthur Zwaenepoel - 2019
"""
import logging
import sys
import click
import os


@click.group()
def cli():
    """
    Tools for preparing data for Whale analyses
    """
    pass


@cli.command(context_settings={'help_option_names': ['-h', '--help']})
@click.option('--infile', '-i', default=None, help="")
@click.option('--informat', '-if', default=None, help="")
@click.option('--outfile', '-o', default=None, help="")
@click.option('--outformat', '-of', default=None, help="")
@click.option('--alphabet', '-a', default="protein", help="")
def convert_aln(infile, informat, outfile, outformat, alphabet):
    """
    Convert an alignment between file formats
    """
    from Bio import AlignIO
    from Bio.Alphabet import IUPAC
    if alphabet == "protein":
        AlignIO.convert(infile, informat, outfile, outformat, IUPAC.extended_protein)
    else:
        AlignIO.convert(infile, informat, outfile, outformat, IUPAC.extended_dna)


@cli.command(context_settings={'help_option_names': ['-h', '--help']})
@click.argument('input_file')
@click.argument('output_file')
@click.option('--downsample', default=1)
@click.option('--burnin', default=0)
def mbtrees(input_file, output_file, **kwargs):
    """
    Get a list of trees from output of MrBayes
    """
    from Bio import Phylo
    with open(output_file, "w") as f:
        for i, t in enumerate(Phylo.parse(input_file, format="nexus")):
            if i % kwargs["downsample"] == 0 and i > kwargs["burnin"]:
                Phylo.write(t, f, format="newick")


# entry point
if __name__ == '__main__':
    cli()
