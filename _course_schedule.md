# Course schedule (draft)

Planning document for the 2-day CLI + HPC workshop. Drafted 2026-10-06.
Timings are first estimates, not yet tested in class.

Sections marked **optional** are written as "(optional)" in the heading and placed
in a collapsed box, so participants who want more can open them.

## Before the workshop (self-study, about 30-60 min)

Page: reworked `source/installation.qmd`, based on the MicEco2025 terminal page.

1. Learn the terms: terminal, shell, prompt.
2. Install a terminal: MobaXterm or WSL2 on Windows. Mac and Linux users open the built-in terminal.
3. Check 1: `echo $SHELL` prints a shell name.
4. Check 2: log in to Crunchomics with `ssh`, then `exit`. Tests account, password and eduroam/VPN.
5. Choose a text editor for the notes file.
6. Report problems before a fixed date (to be set), so they are solved before day 1.

## Day 1: command line basics on your own laptop (about 3h45)

| Time | Block | Content |
|---|---|---|
| 15 min | Start | How the two days work. Create the notes file (start of the documentation thread). |
| 50 min | Finding your way | Prompt, `pwd`, `ls`, command structure (options, arguments), `man` / `--help`, file system, absolute and relative paths, `cd`, `mkdir`. Survival skills in the main text: Tab, arrow up, `Ctrl+C`, reading a first error message. |
| 45 min | Getting the data | `wget` / `curl`, `cp`, `mv`, `tar`, `rm` (with warning), wildcards |
| 15 min | Break | |
| 50 min | Looking at the data | `>`, `head` / `tail` / `less`, `wc -l`, pipes, fastq format, `gzip` / `zcat`, `grep` |
| 40 min | Repeating things | Variables. Simple loops (`echo`, then `zcat \| wc -l` for each file). Save commands in a `.sh` file and run it with `bash` (prepares for `sbatch`). |
| 10 min | Wrap-up | Tidy the notes file |

**Optional:** `cut`, `sort` / `uniq`, `cat` for combining files, `nano`, advanced counting tips, sample mapping tip.

## Day 2: working on Crunchomics (about 3h50)

| Time | Block | Content |
|---|---|---|
| 10 min | Recap | Day 1 in 5 commands |
| 35 min | What an HPC is | Login node vs compute nodes, SLURM, etiquette, storage (25 GB home vs 500 GB personal directory). `ssh`. The prompt shows where you are (laptop or HPC). Run `omics_install_script` and explain what it does: adds the shared software folder to the PATH, sets up python, creates the `~/personal` link to the 500 GB directory. Make the project folder. |
| 20 min | Moving data | `scp` from the laptop terminal, check with `ls`. FileZilla as a tip. |
| 35 min | First jobs | `sinfo`, `squeue`, `srun echo`, FastQC with `srun` (wildcard, simple). Copy the HTML report back and open it. Interactive session with `srun --pty bash`. |
| 15 min | Break | |
| 25 min | Installing software with conda | What conda/mamba is and why environments exist. Motivation: `fastp --version` on Crunchomics shows 1.0.1, the current version is 1.3.7 (checked 2026-10-06). Instructor demo install first. Then participants install Miniforge **into `~/personal`, not the 25 GB home**, and create a pinned fastp environment. |
| 35 min | fastp | Run fastp on **one** sample with `srun` and look at what it produces. Build the loop step by step with `echo` (dry run first). Finding R1/R2 with a wildcard in the path, used as the moment to talk about checking what a wildcard matches. |
| 40 min | sbatch | Parts of a job script, conda activation, `logs/` folder. Put the fastp loop in `sbatch`, submit, `squeue`, read the log. Check outputs: 4 samples in, so 4 reports and 8 trimmed files out? Compare read counts with the day 1 `wc -l`. Then `sacct` and choosing resources. |
| 15 min | Wrap-up | Walk through `example_doc.qmd` ("this is what your notes can become"). Where to get help. Pointer to the LLM page (later). |

**Optional:** `screen`, arrays (link to the IBED SLURM page), FastQC again on the trimmed reads (before vs after), `scp` with wildcards, better log file names.

## Risks

- Day 2 is tight (3h50 of 4h). If the conda install takes longer, the optional
  parts and `sacct` move to self-study. Fallback if an install fails: use the
  Crunchomics fastp (1.0.1, older but works) for the loop.

## Decisions

| Topic | Decision |
|---|---|
| Marking optional sections | "(optional)" in the heading + collapsed box |
| Miniforge install | In class on day 2, after a short explanation and an instructor demo. Install into `~/personal` (500 GB), not home (25 GB). |
| `omics_install_script` | Run in class on day 2, with a short explanation of what it does. Must run before the conda install, because it creates the `~/personal` link. |
| fastp loop: finding R1/R2 | Leaning towards a wildcard in the path, used to talk about wildcard care. Not final. |
