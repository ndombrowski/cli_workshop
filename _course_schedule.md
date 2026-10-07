# Course schedule (draft)

Planning document for the 2-day CLI + HPC workshop. Drafted 2026-10-06.
Timings are first estimates, not yet tested in class.

Sections marked **optional** are written as "(optional)" in the heading and placed
in a collapsed box, so participants who want more can open them.

## Before the workshop (self-study, about 30-60 min)

Page: reworked `source/installation.qmd`, based on the MicEco2025 terminal page (done 2026-10-06).
Sent as a self-contained attachment (`source/installation_preworkshop.html`) with the
announcement email (`_preworkshop_instructions.md`).

1. Request Crunchomics access (email to Wim de Leeuw, PI in cc; takes 1-3 days, so first).
2. Learn the terms: terminal, shell, prompt.
3. Install a terminal: MobaXterm (recommended) or WSL2 on Windows. Mac and Linux users open the built-in terminal.
4. Check 1: `echo $SHELL` prints a shell name.
5. Check 2: log in to Crunchomics with `ssh`, then `exit`. Tests account, password and eduroam/VPN.
6. Choose a text editor for the notes file (RStudio, Notepad/Notepad++, TextEdit, VS Code).
7. Report problems to Nina Dombrowski at the latest one week before the workshop.

## Day 1: command line basics on your own laptop (about 3h45)

| Time | Block | Content |
|---|---|---|
| 15 min | Start | How the two days work. Create the notes file (start of the documentation thread). |
| 50 min | Finding your way | Prompt, `pwd`, `ls`, command structure (options, arguments), `man` / `--help`, file system, absolute and relative paths, `cd`, `mkdir`. Survival skills in the main text: Tab, arrow up, `Ctrl+C`, reading a first error message. |
| 45 min | Getting the data | `wget` / `curl`, `cp`, `mv`, `tar`, `rm` (with warning), wildcards |
| 15 min | Break | |
| 55 min | Looking at the data | `>`, `head` / `tail` / `less`, `wc -l`, pipes, `cut` (makes `fastq_files.txt`), fastq format, `gzip` / `zcat`, `grep` |
| 35 min | Repeating things | Variables. Simple loop over a wildcard (`echo` first, then `zcat \| wc -l` for each file). `>>` to collect the counts in one file. Save the loop in a `.sh` file and run it with `bash` (prepares for `sbatch`). |
| 10 min | Wrap-up | Tidy the notes file |

**Optional:** `sort` / `uniq`, `cat` for combining files, `nano`, advanced counting tips, sample mapping tip.

## Day 2: working on Crunchomics (about 3h50)

| Time | Block | Content |
|---|---|---|
| 10 min | Recap | Day 1 in 5 commands |
| 35 min | What an HPC is | Login node vs compute nodes, SLURM, etiquette, storage (25 GB home vs 500 GB personal directory). `ssh`. The prompt shows where you are (laptop or HPC). Run `omics_install_script` and explain what it does: adds the shared software folder to the PATH, sets up python, creates the `~/personal` link to the 500 GB directory. Make the project folder. |
| 20 min | Moving data | `scp` from the laptop terminal, check with `ls`. FileZilla as a tip. |
| 35 min | First jobs | `sinfo`, `squeue`, `srun echo`, `seqkit stats` with `srun` (wildcard, simple). Read the table on Crunchomics with `cat`, compare `num_seqs` with the day 1 line counts, select columns with `cut`. Interactive session with `srun --pty bash`. |
| 30 min | sbatch | Parts of a job script, `logs/` folder, using `seqkit stats` (same command as with `srun`, so the two can be compared). Submit, `squeue`, read the log, `scancel`. Then `sacct` and choosing resources. |
| 15 min | Break | |
| 25 min | Installing software with conda | What conda/mamba is and why environments exist. Motivation: `fastp --version` on Crunchomics shows 1.0.1, the current version is 1.4.0 (released 2026-10-07). Instructor demo install first. Then participants install Miniforge on the login node **into `/zfs/omics/personal/$USER/miniforge3` (= `~/personal`), not the 25 GB home**, and create a pinned environment `fastp_1.4.0`. |
| 45 min | fastp | Run fastp on **one** sample with `srun` and look at what it produces. Make `samples.txt` (4 sample names) with `ls \| cut \| cut`. Build the loop `for sample in $(cat samples.txt)` step by step with `echo` (dry run first), following the IBED for-loops page. R1/R2 found with a wildcard written directly in the fastp command (not stored in a variable), used as the moment to talk about checking what a wildcard matches. Put the loop in an `sbatch` script with conda activation (`source ~/.bashrc` + `conda activate`), submit, read the log. Check outputs: 4 samples in, so 8 trimmed files + 4 HTML + 4 JSON reports = 16 files. Compare read counts with the day 1 `line_counts.txt`. |
| 15 min | Wrap-up | Walk through `example_doc.qmd` ("this is what your notes can become"). Where to get help. Pointer to the LLM page (later). |

**Optional:** "Extra bash syntax" box (`${R1/_R1/_R2}`, `basename`, `while read`), `screen`, arrays over `fastq_files.txt` (link to the IBED SLURM page), `seqkit stats` on the trimmed reads with `awk` (before vs after), FastQC tip (visual reports), `scp` with wildcards, better log file names.

## Risks

- Day 2 is tight (3h50 of 4h). If the conda install takes longer, the optional
  parts move to self-study. Fallback if an install fails: use the
  Crunchomics fastp (1.0.1, older but works) for the loop.

## Decisions

| Topic | Decision |
|---|---|
| Marking optional sections | "(optional)" in the heading + collapsed box |
| Miniforge install | In class on day 2, after a short explanation and an instructor demo. Install into the personal folder (500 GB), not home (25 GB). Non-interactive (`-b -p /zfs/omics/personal/$USER/miniforge3`, then `conda init`), because typing the install folder at the prompt tripped up students before; the page links the Miniforge license, since `-b` accepts it without showing it. On the login node (fine on Crunchomics). (Decided 2026-10-07.) |
| fastp version | 1.4.0 (released 2026-10-07), environment `fastp_1.4.0`. Earlier versions had reports of stalling with higher thread numbers; to be watched in the test run. (Decided 2026-10-07.) |
| conda in job scripts | `source ~/.bashrc` followed by `conda activate` is enough on Crunchomics (confirmed by Nina, 2026-10-07). |
| `omics_install_script` | Run in class on day 2, with a short explanation of what it does. Must run before the conda install, because it creates the `~/personal` link. |
| Day 2 order | Follows the page (decided 2026-10-07): first jobs with `seqkit stats` (`srun`, then `sbatch` + `sacct`), break, conda, then fastp with its own loop and job script. |
| seqkit stats instead of FastQC | Decided 2026-10-07. seqkit v2.7.0 is pre-installed on Crunchomics (no `module load`). Its text table can be read on Crunchomics directly (no `scp` back), `num_seqs` can be checked against the day 1 counts, and the table gives material for an optional `awk` box. Copying files back with `scp` is now taught with the fastp HTML reports. FastQC stays as a tip only. Options: `-a -T -o`, `--threads 1`. |
| `cut` | Core on day 1, not optional (decided 2026-10-07): very useful in bioinformatics, and day 2 uses it to make `samples.txt`. |
| Day 1 loop | Loop over a wildcard only, with a readable variable name (`file`, not `i`). Variables get their own short section first. The `1 2 3` warm-up, `loops.png` and the backtick `cat` loop are dropped. Counts collected with `>>` (appending was mentioned but never shown). (Decided 2026-10-07.) |
| fastp loop: finding R1/R2 | List file `samples.txt` with the 4 sample names, loop with `for sample in $(cat samples.txt)`. No new syntax like `${R1/_R1/_R2}` in the core path; that goes in a collapsed "Extra bash syntax" box. The wildcard path is written directly in the fastp command, not stored in a variable: bash does not expand a wildcard in a quoted variable (`"$R1"` stays `data/seq_project/*/...`, tested in Git Bash 5.2 on 2026-10-07). (Decided 2026-10-07.) |
| List file names | `samples.txt` = 4 sample names (fastp loop). `fastq_files.txt` = 8 file names (day 1 `cut` section, and the optional array tip on day 2). |
| Windows terminal | MobaXterm first (lighter install), WSL2 second. Git Bash dropped. |
| Pre-workshop ssh check | Plain `ssh`, without `-X`. |
| installation.qmd audience | Works for both workshop participants and self-study; contact Nina also outside the workshop. |
| Showing command output | Plain text output block + lead-in sentence, copied from a real run. Screenshots only where the look on screen matters. No code run at render time. Not every chunk gets an output. |
