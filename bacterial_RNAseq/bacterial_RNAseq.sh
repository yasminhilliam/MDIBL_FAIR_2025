## Bacterial RNAseq analysis
## Yasmin Hilliam, PhD

#!/bin/bash

##---------------------------------------------------------------------------------------

# Many RNAseq analysis packages are designed for use with human or model organism data
# and so these packages often come with human databases pre-installed. However, if you 
# need to perform analysis on data from your chosen bacterial species you may need to 
# build your own database to align to.

##---------------------------------------------------------------------------------------

# We're going to look at how to use HISAT2 and HTSeq to build a reference index from a
# genome, align our RNAseq data, and then count reads.

##---------------------------------------------------------------------------------------

ssh ws<YOUR ID>@fairbioinformatics.dartmouth.edu

##---------------------------------------------------------------------------------------

conda create -n bact_rna python=3.9 numpy pysam

##---------------------------------------------------------------------------------------

# check that your environment has been created

conda info --envs

# activate environment

conda activate bact_rna

# install required packages

conda install bioconda::hisat2

pip install HTSeq

# download required files

wget https://github.com/yasminhilliam/PaTolerance/blob/main/<PLACEHOLDER>

# unzip directory

gunzip <PLACEHOLDER>

ls

##---------------------------------------------------------------------------------------

# Now we will build an index from our reference genome. It is important to make sure your
# genome file and annotation file are downloaded from the same source, or the results
# will not play nicely together later on.

##---------------------------------------------------------------------------------------

hisat2-build \
-p 16 \
~/build/<PAO1_genome.fastq>
~/build/PAO1

ls /build/PAO1

##---------------------------------------------------------------------------------------

# Our index is now created so we can align our reads to our reference genome

mkdir aligned_reads

hisat2 -p 16 -q --phred33 \
--summary-file ~/aligned_reads/<SAMPLE>_alignment_summary.txt \
-x ~/PAO1_DB/hisat2/PAO1 \
-1 ~/trimmed_reads/<SAMPLE>_R1_001.fastq.gz \
-2 ~/trimmed_reads/<SAMPLE>_R2_001.fastq.gz \
-S ~/aligned_reads/<SAMPLE>_aligned.reads.sam

# Now we have a .sam file containing our alignments that we can feed into HTSeq to count
# aligned reads per gene. 

##---------------------------------------------------------------------------------------

htseq-count \
-f sam \
-t gene \
-i locus_tag \
~/aligned_reads/<SAMPLE>_aligned.reads.sam \
~/build/PAO1/2025-06-19_Pseudomonas_aeruginosa_PAO1_NCBI_RefSeq.gff > \
~/htseq/"$i".txt



