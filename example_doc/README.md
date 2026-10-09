# Example project: quality control of ITS sequencing data

This folder is an example of how you can share the code of an analysis on GitHub. It belongs to the
tutorial [Introduction to the CLI](https://ndombrowski.github.io/cli_workshop/), and uses the same
data as the tutorial.

The analysis looks at sequencing data from 4 samples, with a forward (R1) and a reverse (R2) read file
for each sample. It checks the quality of the reads with SeqKit, cleans the reads with fastp, and then
checks the cleaned reads again. All steps were run on the UvA Crunchomics HPC.

## Where to start

Start with the notebook. It describes every step of the analysis, in the order in which I ran them:

- [notebook/example_notebook.qmd](notebook/example_notebook.qmd): the notebook as a Quarto file
- [HTML report](https://ndombrowski.github.io/cli_workshop/example_doc/notebook/example_notebook.html):
  the same notebook as a web page, which is easier to read

## What is in this folder

```
example_doc/
├── README.md                 # this file
├── notebook/
│   └── example_notebook.qmd  # all the code I ran, with notes on the results
└── scripts/
    ├── seqkit.sh             # job script: read statistics of the raw reads
    ├── fastp.sh              # job script: cleaning the reads
    └── seqkit_trimmed.sh     # job script: read statistics of the cleaned reads
```

The scripts in `scripts/` are job scripts for the SLURM scheduler on Crunchomics. The notebook submits
them with `sbatch`. I keep them in their own folder and publish them together with the notebook, so
that all the code I ran is available.

## What is not in this folder

When you run the workflow, it creates more files and folders in your project folder:

- `data/`: the raw sequencing data. It is downloaded in the notebook, so there is no need to store it here.
- `results/`: everything the analysis produces, such as read counts, SeqKit tables and the cleaned reads.
- `logs/`: the log files that SLURM writes for each job.
- `samples.txt` and `fastq_files.txt`: lists of sample and file names, made in the notebook.

I don't put these on GitHub. Data and results files are often too large for GitHub, and anyone can
make them again by running the code. What matters is the code, and the notes on how and why it was run.

## How to run the workflow yourself

1. Make a project folder on Crunchomics, for example `~/personal/data_analysis`.
2. Open the notebook and change the section "Settings (change these before you run the workflow)".
   This is the only part of the code you need to change.
3. Run the commands from the notebook one by one. All commands run from the project folder itself,
   not from the `notebook/` folder. The notebook makes sure of this with `cd $wdir`.
4. After the step that makes the folders `data`, `scripts`, `logs` and `results`, copy the job
   scripts from this `scripts/` folder into the `scripts` folder of your project. The notebook
   needs them from the section "Read statistics with seqkit" onwards.

The notebook lives in its own folder to keep the project tidy. In the tutorial, you kept your
`notes.md` directly in `data_analysis/`, which works just as well for a small project.
