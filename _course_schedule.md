# Course schedule (draft)

Planning document for the 2-day CLI + HPC workshop. Drafted 2026-10-06.
Timings are first estimates, not yet tested in class.

Optional content goes in a collapsed tip box titled "Tip: ... (optional)", so participants
who want more can open it. The box has no heading of its own (changed 2026-10-09).

## Before the workshop (self-study, about 30-60 min)

Page: reworked `source/installation.qmd`, based on the MicEco2025 terminal page (done 2026-10-06).
Sent as a self-contained attachment (`source/installation_preworkshop.html`) with the
announcement email (`_preworkshop_instructions.md`).

1. Crunchomics access. Workshop participants: batch request from the sign-up form information (UvAnetID, PI; existing accounts also noted there), we email them when the accounts are ready (decided 2026-10-12, first batch run, timing not known yet). Self-learners: email to Wim de Leeuw, PI in cc; takes 1-3 days, so first. On the page as a tabset (`::: {.panel-tabset}`, tab colours in `styles.scss`).
2. Install a terminal (the page defines terminal and shell here, the prompt in Check 1; the separate "Some terms" step was moved to the start of bash_intro on 2026-10-12): MobaXterm (recommended) or WSL2 on Windows. Mac and Linux users open the built-in terminal.
3. Check 1: `echo $SHELL` prints a shell name.
4. Check 2: log in to Crunchomics with `ssh`, then `exit`. Tests account, password and eduroam/VPN.
5. Choose a text editor for the notebook (RStudio recommended, Notepad/Notepad++, TextEdit, VS Code) and save a test `.md` file.
6. Report problems to Nina Dombrowski as soon as possible, at the latest a few days before the workshop (was one week; shortened 2026-10-12 because batch accounts may arrive late).

## Day 1: command line basics on your own laptop (about 3h45)

| Time | Block | Content |
|---|---|---|
| 15 min | Start | How the two days work. Introduce the notebook idea (the file itself is made after `mkdir`, see next row). |
| 50 min | Finding your way | Terminal, shell and prompt (CLI vs GUI; opening section of bash_intro, moved from installation.qmd on 2026-10-12), `pwd`, `ls`, command structure (options, arguments), `man` / `--help`, file system, absolute and relative paths, `cd`, `mkdir`. `touch data_analysis/notes.md` right after `mkdir`, with the three Markdown elements (heading, code block, text). Notebook checkpoint 1 at the end. Survival skills in the main text: Tab, arrow up, `Ctrl+C`, reading a first error message. |
| 45 min | Getting the data | `wget` / `curl`, `cp`, `mv`, `tar`, `rm` (with warning), wildcards. Notebook checkpoint 2 at the end (only the commands that rebuild the data folder, no detours). |
| 15 min | Break | |
| 55 min | Looking at the data | `>`, `head` / `tail` / `less`, `wc -l`, pipes, `cut` (makes `fastq_files.txt`), fastq format, `gzip` / `zcat`, `grep`. Notebook checkpoint 3 at the end: commands + checks in one code block, one sentence on lines per read (shortened 2026-11-04; the "can your notebook explain every file?" check moved to checkpoint 5). |
| 35 min | Repeating things | Variables. Simple loop over a wildcard (`echo` first, then `zcat \| wc -l` for each file). `>>` to collect the counts in one file. Save the loop in a `.sh` file and run it with `bash` (prepares for `sbatch`).. Notebook checkpoint 4 at the end (no model notes from here on; the script itself is documentation). |
| 10 min | Wrap-up | Notebook checkpoint 5 "Tidy your notebook": short description at the top, reread, every-file check, `## Questions for day 2`. |

**Optional:** `nano`, advanced counting tips, sample mapping tip, quotes tip (after the variables section: word splitting with `echo $var | cut`, double vs single quotes, wildcards in quotes; added 2026-11-04, output from a WSL test run). (`sort` / `uniq` and `cat` stay core: commands participants meet regularly in real work, decided 2026-10-08.)

## Day 2: working on Crunchomics (about 4h00)

| Time | Block | Content |
|---|---|---|
| 10 min | Recap | Day 1 in 5 commands, from the participants' own notebooks. No separate checkpoint box at the start of the page (merged into checkpoints 1 and 5, decided 2026-10-08). |
| 35 min | What an HPC is | Login node vs compute nodes, SLURM, etiquette, storage (25 GB home vs 500 GB personal directory). `ssh`. The prompt shows where you are (laptop or HPC). Run `omics_install_script` and explain what it does: adds the shared software folder to the PATH, sets up python, creates the `~/personal` link to the 500 GB directory. Make the project folder. |
| 20 min | Moving data | `scp` from the laptop terminal, check with `ls`. FileZilla as a tip. Notebook checkpoint 1 at the end (with model notes): introduces `# On my computer` / `# On Crunchomics` at the top of each code block. |
| 35 min | First jobs | `sinfo` (not on the page since the rewrite; decide: add to the page or drop here), `squeue`, `srun echo`, `seqkit stats` with `srun` (wildcard, simple). Read the table on Crunchomics with `cat`, compare `num_seqs` with the day 1 line counts, select columns with `cut`. |
| 30 min | sbatch | Parts of a job script, `logs/` folder, using `seqkit stats` (same command as with `srun`, so the two can be compared). Submit, `squeue`, read the log, `scancel`. Then choosing resources (short rules of thumb). Notebook checkpoint 2 after `scancel`, before the resources section: seqkit version (`seqkit version`), sbatch command, job ID, read count vs day 1 in one line ("which run made the current table" dropped 2026-11-04). |
| 15 min | Break | |
| 25 min | Installing software with conda | What conda/mamba is and why environments exist. Motivation: `fastp --version` on Crunchomics shows 1.0.1, the current version is 1.4.0 (released 2026-10-07). Instructor demo install first. Then participants install Miniforge on the login node **into `/zfs/omics/personal/$USER/miniforge3` (= `~/personal`), not the 25 GB home**, and create a pinned environment `fastp_1.4.0`. Notebook checkpoint 3: `## Software` section near the top of the notebook (tools + versions, Miniforge folder, `mamba create`, why an own fastp). |
| 55 min | fastp | Run fastp on **one** sample with `srun` and look at what it produces. Make `samples.txt` (4 sample names) with `ls \| cut \| cut`. Build the loop `for sample in $(cat samples.txt)` step by step with `echo` (dry run first), following the IBED for-loops page. R1/R2 found with a wildcard written directly in the fastp command (not stored in a variable), used as the moment to talk about checking what a wildcard matches. Put the loop in an `sbatch` script with conda activation (`source ~/.bashrc` + `conda activate`), submit, read the log. Check outputs: 4 samples in, so 8 trimmed files + 4 HTML + 4 JSON reports = 16 files. Compare read counts with the day 1 `line_counts.txt`. Step 7 (added 2026-11-04, about 10 min): participants write their own job script, by copying `seqkit.sh` to `seqkit_trimmed.sh` and changing input, output, job name and log names; `stats_trimmed.txt` is checked against the Step 6 read count. Same script as `example_doc/scripts/seqkit_trimmed.sh`. Can move to homework if time runs out. Notebook checkpoint 4 after the Step 7 exercise: one code block (samples.txt, sbatch, 16-file check, scp of reports), job ID + one line expected vs seen, reads before/after filtering from the report (shortened 2026-11-04). Test run on one sample = one sentence only. |
| 15 min | Wrap-up | New section "Wrapping up day 2": copy the job scripts to the local `scripts/` with `scp`, then notebook checkpoint 5 (update description, every-file check incl. `logs/`, answer "Questions for day 2"; comparing with the example notebook is now a sentence after the box, for after the workshop, 2026-11-04). Walk through `example_doc.qmd` ("this is what your notes can become"). Where to get help. Pointer to the LLM page (later). |

**Optional:** `srun --pty bash` (interactive session), `sacct` (with "compare used vs requested" and "adjust step by step", decided 2026-10-09), "Finding R2 without a list file" box (`${R1/_R1/_R2}`, `basename`, `while read`), `screen`, fastp as a job array over `samples.txt`, one job per sample, output in `results/fastp_array/` (changed from seqkit over `fastq_files.txt` on 2026-10-13; link to the IBED SLURM page), `awk` on the raw and trimmed seqkit tables (before vs after; the trimmed table itself is core since 2026-11-04, Step 7), FastQC tip (visual reports), `scp` with wildcards, better log file names.

## Risks

Timing review 2026-11-04 (Claude read both pages in full; estimates, not timed in class):

- Day 1 is the tight day: about 3h55-4h30 against 3h45 planned. "Looking at the data"
  (estimate 65-75 min, plan 55) and "Repeating things" (estimate 40-50 min, plan 35) run over.
  In "Repeating things", the script section is the first core use of `nano`, and MobaXterm
  users run `apt install nano` in class. Skip first if behind: the two "(advanced)" grep
  questions, the `cat` combine exercise, the gzip size exercise, the TAAGA loop exercise
  (keep the `>>` exercise).
- Day 2 adds up to 4h00 with Step 7. Estimated slack: 5-10 min in "What an HPC is" and
  "First jobs". Conda and fastp fit the planned times (Nina's experience). If behind, Step 7
  moves to homework (nothing later depends on it). Fallback if an install fails: use the
  Crunchomics fastp (1.0.1, older but works) for the loop.
- Baseline: the pre-rewrite version (commit 0a38131) ran in one 4 h module, with the terminal
  installation in class, and was tight for some participants. The core path now has about 2x
  the commands (~150 -> ~295 lines) in 2x the time, with installation as homework. The 10
  notebook checkpoints are the only addition without an old counterpart (shortened 2026-11-04).
- Optional boxes are not class time: participants read them after the workshop.

## Decisions

| Topic | Decision |
|---|---|
| Marking optional sections | Collapsed tip box titled "Tip: ... (optional)", no own heading. A neutral heading only where the box would otherwise fall under an unrelated section (e.g. "## Going further" for job arrays after the wrap-up). Changed 2026-10-09: "(optional)" in heading + box title was redundant. |
| Miniforge install | In class on day 2, after a short explanation and an instructor demo. Install into the personal folder (500 GB), not home (25 GB). Non-interactive (`-b -p /zfs/omics/personal/$USER/miniforge3`, then `conda init`), because typing the install folder at the prompt tripped up students before; the page links the Miniforge license, since `-b` accepts it without showing it. On the login node (fine on Crunchomics). (Decided 2026-10-07.) |
| fastp version | 1.4.0 (released 2026-10-07), environment `fastp_1.4.0`. Earlier versions had reports of stalling with higher thread numbers; to be watched in the test run. (Decided 2026-10-07.) |
| conda in job scripts | `source ~/.bashrc` followed by `conda activate` is enough on Crunchomics (confirmed by Nina, 2026-10-07). |
| `omics_install_script` | Run in class on day 2, with a short explanation of what it does. Must run before the conda install, because it creates the `~/personal` link. |
| Day 2 order | Follows the page (decided 2026-10-07): first jobs with `seqkit stats` (`srun`, then `sbatch` + `sacct`), break, conda, then fastp with its own loop and job script. |
| seqkit stats instead of FastQC | Decided 2026-10-07. seqkit v2.7.0 is pre-installed on Crunchomics (no `module load`). Its text table can be read on Crunchomics directly (no `scp` back), `num_seqs` can be checked against the day 1 counts, and the table gives material for an optional `awk` box. Copying files back with `scp` is now taught with the fastp HTML reports. FastQC stays as a tip only. Options: `-b -a -T -o`, `--threads 1` (`-b` in every seqkit command, added 2026-10-07). |
| `cut` | Core on day 1, not optional (decided 2026-10-07): very useful in bioinformatics, and day 2 uses it to make `samples.txt`. |
| Day 1 loop | Loop over a wildcard only, with a readable variable name (`file`, not `i`). Variables get their own short section first. The `1 2 3` warm-up, `loops.png` and the backtick `cat` loop are dropped. Counts collected with `>>` (appending was mentioned but never shown). (Decided 2026-10-07.) |
| fastp loop: finding R1/R2 | List file `samples.txt` with the 4 sample names, loop with `for sample in $(cat samples.txt)`. No new syntax like `${R1/_R1/_R2}` in the core path; that goes in a collapsed "Finding R2 without a list file" box. The wildcard path is written directly in the fastp command, not stored in a variable: bash does not expand a wildcard in a quoted variable (`"$R1"` stays `data/seq_project/*/...`, tested in Git Bash 5.2 on 2026-10-07). (Decided 2026-10-07.) |
| List file names | `samples.txt` = 4 sample names (fastp loop, and the optional array tip on day 2). `fastq_files.txt` = 8 file names (day 1 `cut` section). |
| Windows terminal | MobaXterm first (lighter install), WSL2 second. Git Bash dropped. |
| Pre-workshop ssh check | Plain `ssh`, without `-X`. |
| installation.qmd audience | Works for both workshop participants and self-study; contact Nina also outside the workshop. |
| Notebook (documentation thread) | Participants keep `~/data_analysis/notes.md` in Markdown (RStudio recommended), one file on the laptop for both days (day 2 commands are copied from the ssh window into it). Made with `touch` after `mkdir data_analysis`, opened by double-click. Blue "Notebook checkpoint" box at the end of each schedule block, styles `.callout-notebook` + nested `.callout-notebook-answer` ("Compare with my notes") in `styles.scss`. Model notes only for the first checkpoints, later only the prompt. Time cost accepted: writing the notes is thinking time. (Decided 2026-10-08. The earlier remark "the block timings are generous" was dropped on 2026-11-04: the timing review found day 1 tight; see Risks and "Checkpoint length".) |
| Hourly check-ins | About once an hour, ask for questions. If there are none, do a live-coding demo from `_demos.md` (predict first, then run). The demos are a buffer, not extra content. (2026-11-04.) |
| Step 7 "Write your own job script" (day 2) | Core, at the end of the fastp section (decided 2026-11-04): copy `seqkit.sh` to `seqkit_trimmed.sh` and change it. Gives day 2 one exercise where participants write a job script themselves (the rest of day 2 is mostly follow-along). The optional awk box now uses its `stats_trimmed.txt` instead of its own `srun`. |
| Checkpoint length | In class: commands with a comment + one line on what you saw (sentence in the bash_intro notebook section). The every-file check only at the two wrap-ups. Reflection and the comparison with the example notebook after the workshop. Optional boxes are read after class. (Decided 2026-11-04.) |
| code_documentation.qmd | Removed (decided 2026-10-08). Documentation is a thread through both days (notebook checkpoints); `example_doc.qmd` is the wrap-up and got a "Going further" section (Quarto, BES guide). Markdown Basics link in the day 1 notebook section. |
| `sort` / `uniq`, `cat` | Core, not optional (decided 2026-10-08): participants meet them regularly in real work. |
| hpc_intro.qmd | Style pass only, no trimming (decided 2026-10-08): the facts are current and change rarely, and the snapshot rules trip people up often. |
| `--ntasks=1` | In every `srun` and every `#SBATCH` header (decided 2026-10-14). Crunchomics nodes have 2 threads per core (`ThreadsPerCore=2`), so `--cpus-per-task=1` gets a full core (2 CPUs). Without `--ntasks`, SLURM fills that with 2 tasks, so `srun` ran the command twice (tested 2026-10-14: `SLURM_NTASKS=2`, `procid` 0 and 1). For sbatch it changes nothing (the script runs once), added only so `srun` and `sbatch` use the same options. Not added to the LLM-written script quoted in `llm_usage.qmd`. |
| Links to the AWK tutorial | Short links only, no new sections (decided 2026-11-04): end of the awk tip box (day 2), index/readme, llm_usage "Further reading" (check_llm_code page), the `sed` line in the day 1 sample mapping tip. Windows line endings in list files (e.g. `samples.txt` from Excel or a sequencing center): 4 sentences in the day 2 "Important" paragraph (`file` should print only `ASCII text`, `ls` check shows `$'\r'`), fix linked to the AWK sed page; one sentence in the day 1 line endings box. Tested in WSL Ubuntu 24.04 (file 5.45, GNU sed 4.9): `sed 's/\r$//'` fixes CRLF but not a UTF-8 BOM; `file` detects both. |
| Showing command output | Plain text output block + lead-in sentence, copied from a real run. Screenshots only where the look on screen matters. No code run at render time. Not every chunk gets an output. |
