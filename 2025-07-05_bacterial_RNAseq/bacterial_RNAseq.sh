## Bacterial RNAseq analysis
## Yasmin Hilliam, PhD

#!/bin/bash

##------------------------------------------------------------------------------

# Many RNAseq analysis packages are designed for use with human or model
# organism data and so these packages often come with human databases
# pre-installed. However, if you need to perform analysis on data from your 
# chosen bacterial species you may need to build your own database to align
# your reads to.

##------------------------------------------------------------------------------

# We're going to look at how to use NCBI datasets to download reference files,
# HISTAT 2 to build a reference index and align reads, and then HTSeq to count
# those reads.

##------------------------------------------------------------------------------

ssh ws<YOUR ID>@fairbioinformatics.dartmouth.edu

##------------------------------------------------------------------------------

conda create -n bact_rna

##------------------------------------------------------------------------------

# check that your environment has been created

conda info --envs

# activate environment

conda activate bact_rna

# install required packages

conda install bioconda::pysam

conda install conda-forge::numpy

conda install bioconda::hisat2

pip install HTSeq

conda install conda-forge::ncbi-datasets-cli

# check that all our packages are installed correctly

conda list -n bact_rna

# create directory and symlinks for trimmed reads

mkdir trimmed_reads

cd trimmed_reads

ln -s /data/workshop-00/bact_raw/1-CL1_TAACTTGG-GTCGTGAA_L004_R1_001.fastq.gz S1_R1.fastq.gz

ln -s /data/workshop-00/bact_raw/1-CL1_TAACTTGG-GTCGTGAA_L004_R1_001.fastq.gz S1_R2.fastq.gz

ls -l

# download required reference files

datasets download genome accession GCF_000006765.1 --include gff3,genome

ls

unzip ncbi_dataset.zip

ls /data/ws08/ncbi_dataset/data/GCF_000006765.1

# there should be two files in here: GCF_000006765.1_ASM676v1_genomic.fna and genomic.gff

##------------------------------------------------------------------------------

# If you visit and NCBI genome page there is a tab labeled "datasets" that you
# can click that will allow you to copy and paste the code to download the
# dataset from the command line. Here, we've only included the GFF and genome
# (.fna) files because those are all we need for this analysis.

##------------------------------------------------------------------------------

# Now we will build and index from our reference genome. It is important to make
# sure your genome file and annotation file are downloaded from the same source
# or the results will not play nicely together later on.

##------------------------------------------------------------------------------

mkdir build

mkdir build/PAO1

hisat2-build -p 16 /data/ws08/ncbi_dataset/data/GCF_000006765.1/GCF_000006765.1_ASM676v1_genomic.fna /data/ws08/build/PAO1

ls build/PAO1

##------------------------------------------------------------------------------

# Our index is now created so we can align our reads to our reference genome

mkdir aligned_reads

hisat2 -p 16 -q --phred33 --summary-file /data/ws08/aliged_reads/S1_alignment_summary.txt -x /data/ws08/build/PAO1 -1 /data/ws08/trimmed_reads/S1_R1.fastq.gz -2 /data/ws08/trimmed_reads/S1_R1.fastq.gz -S /data/ws08/aliged_reads/S1_aligned.reads.sam

cd aligned_reads

cat S1_alignment_summary.txt

# Now we have a .sam file containing our alignments that we can feed into HTSeq
# to count aligned reads per gene.

##------------------------------------------------------------------------------

mkdir htseq

htseq-count -f sam -t gene -i locus_tag /data/ws08/aligned_reads/S1_aligned.reads.sam /data/ws08/ncbi_dataset/data/GCF_000006765.1/genomic.gff > /data/ws08/htseq/S1_counts.txt

##------------------------------------------------------------------------------

# On Mac (sorry I don't know how to do this on Windows terminal) hit Command+T 
# to open a new terminal tab. This tab will open on your local machine and will 
# not be signed into the server. You can now use this tab to use scp to 
# download your counts file on to your local machine for import into R

##------------------------------------------------------------------------------

scp ws<YOUR ID>@fairbioinformatics.dartmouth.edu:/data/ws08/htseq/S1_counts.txt /path/to/downloads


