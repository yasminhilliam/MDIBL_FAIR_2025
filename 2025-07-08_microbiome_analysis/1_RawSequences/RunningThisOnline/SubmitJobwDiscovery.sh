# This line specifies the script interpreter as Bash.
#!/bin/bash 

# This sets the name of the job to "DADA2" in the job scheduling system.
#SBATCH --job-name=DADA2

# This requests 2 compute nodes for the job.
#SBATCH --nodes=2

# This requests 8 tasks (cores) per node. Since there are 2 nodes, the job will use a total of 16 cores.
#SBATCH --ntasks-per-node=8

# This sets the maximum walltime (job duration) to 100 hours.
#SBATCH --time=100:00:00

# This requests email notifications at the beginning, end, and failure of the job.
#SBATCH --mail-type=BEGIN,END,FAIL

# This sets the name of the standard output file to the job name and job ID (e.g., DADA2.12345.out).
#SBATCH --output=%x.%j.out

# This sets the name of the standard error file to the job name and job ID (e.g., DADA2.12345.err).
#SBATCH --error=%x.%j.err

# Print the hostname of the node where the job is running
hostname

# Print the current date and time
date

# Load the specified module for R version 4.2.3
module load R/4.2.3

# Run the R script with the specified script file
Rscript DADA2_script.R
