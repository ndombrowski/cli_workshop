# Live coding demos

Short demos for the get-togethers during the workshop. 

Plan for how to do these:

1. Type the command live, but don't press Enter yet.
2. Ask the students what they expect to happen. Collect a few answers.
3. Press Enter and compare the result with the answers.
4. If there is an error, let the students read it first. Then read it out loud together and find the useful part.
5. Fix the command and run it again.
6. Copy the working command into your own `notes.md`.

Overview:

| # | Demo | Day | Fits after |
|---|---|---|---|
| 1 | Wrong working directory | 1 and 2 | `cd` (day 1), `sbatch` (day 2) |
| 2 | Path error | 1 | Absolute and relative paths |
| 3 | Wildcard matches nothing | 1 | Wildcards |
| 4 | Loop that does not do what you think | 1 and 2 | Day 1 loop, day 2 fastp loop |
| 5 | Environment variables and PATH | 2 | `omics_install_script`, conda |
| 6 | awk on the seqkit table | 2 | `seqkit stats` |


## 1. Wrong working directory

The most common beginner mistake: the command is correct, but you run it from the wrong folder.

**Setup:** `~/data_analysis` with `data/seq_project` in it.

**Day 1 version:**

```bash
cd ~/data_analysis/results

# Looks fine, but fails
ls data/seq_project
```

**What happens:** `ls` says it cannot access `data/seq_project`. The folder exists, but not here.

**Fix:**

```bash
# Where am I?
pwd

# Go back to the project folder and try again
cd ~/data_analysis
ls data/seq_project
```

**Point out:**
- The prompt shows the current folder. Look at it before you run a command.
- `pwd` is the first thing to type when a path "suddenly" doesn't work.
- Relative paths start from the current folder. The same command works in one folder and
  fails in another.

**Day 2 version:** run `sbatch` from inside `scripts/` instead of `data_analysis/`.

```bash
cd ~/personal/data_analysis/scripts
sbatch seqkit.sh
```

The job runs from the folder where you typed `sbatch`, so all relative paths in the script
now start from `scripts/`. seqkit can't find `data/seq_project/*/*gz`. The log paths
(`logs/seqkit_%j.out`) are relative too, so SLURM looks for `scripts/logs/`. Test before the
session where the error message ends up, or whether you get a log at all. Fix: `cd ..`, then
`sbatch scripts/seqkit.sh`.


## 2. Path error

The folder exists, but the path to it is wrong.

**Setup:** in `~/data_analysis`.

```bash
# Typo in the folder name
ls data/seq_projet

# A / at the start makes it an absolute path: it now starts at the root of the computer
ls /data/seq_project
```

**What happens:** both commands say "No such file or directory".

**Fix:**

```bash
# Type the first letters, then press Tab to complete
ls data/seq_p<Tab>
```

**Point out:**
- Read the error: the name in quotes is the path the shell tried. Compare it letter by letter.
- A leading `/` changes the meaning of the whole path.
- Tab completion avoids typos. If Tab completes nothing, the path is wrong at that point.


## 3. Wildcard matches nothing

If a wildcard matches no file, bash passes the pattern on unchanged, including the `*`.

**Setup:** in `~/data_analysis`.

```bash
# Forgot the */ for the sample folders
ls data/seq_project/*.fastq.gz

# echo shows what bash makes of a wildcard, without doing anything
echo data/seq_project/*.fastq.gz
echo data/seq_project/*/*.fastq.gz
```

**What happens:** `ls` complains about a file with a `*` in its name. The first `echo` prints
the pattern itself. The second `echo` prints the 8 file paths.

**Point out:**
- An error message with a `*` in the file name means the wildcard matched nothing.
- `echo` is a safe way to check a wildcard before you use it in `rm`, `cp` or a loop.
- Leads into demo 4: in a loop, this mistake gives no error at first.


## 4. Loop that does not do what you think

**Setup:** in `~/data_analysis` (day 1) or `~/personal/data_analysis` with `samples.txt` (day 2).

**Version A: forgotten `$` (day 1)**

```bash
for fastq_file in data/seq_project/*/*.fastq.gz; do
    echo fastq_file
done
```

**What happens:** prints the word `fastq_file` 8 times. The loop runs 8 times, but `echo`
prints the text, not the variable. Fix: `echo $fastq_file`.

**Version B: wildcard matches nothing (day 1, links to demo 3)**

```bash
for fastq_file in data/seq_project/*.fastq.gz; do
    echo $fastq_file
done
```

**What happens:** the loop runs once, with the pattern itself as the "file name". Without the
`echo` dry run, `zcat` would fail on a file called `data/seq_project/*.fastq.gz`.

**Version C: looping over the file name instead of its content (day 2)**

```bash
for sample in samples.txt; do
    echo $sample
done
```

**What happens:** prints `samples.txt` once. The loop goes over the words you give it, so
`samples.txt` is just one word. Fix: `for sample in $(cat samples.txt); do`.

**Point out:**
- This is why we always start a loop with `echo`: the dry run shows what each iteration gets.
- Count the lines the dry run prints. Do they match the number of files or samples you expect?


## 5. Environment variables and PATH

Shows why `command not found` happens, and what `omics_install_script` and `conda activate`
change.

**Setup:** on Crunchomics, after `omics_install_script` and the fastp install.

```bash
# Variables that bash sets for you
echo $USER
echo $HOME

# PATH is one long line. tr replaces each : with a new line, so we get one folder per line
echo $PATH | tr ':' '\n'

# Which fastp does bash find, and which version?
which fastp
fastp --version

# Activate the environment and look again
conda activate fastp_1.4.0
echo $PATH | tr ':' '\n'
which fastp
fastp --version

conda deactivate
```

**What happens:** after `conda activate`, a `miniforge3` folder appears at the top of the
PATH list, and `which fastp` points there. After `conda deactivate`, bash finds the
Crunchomics fastp again.

**Optional extra:** `$USER` in a path, e.g. `ls /zfs/omics/personal/$USER`. Same command
works for every participant.

**Point out:**
- bash searches the PATH folders from top to bottom and uses the first match.
- `command not found` means: none of the PATH folders has this program.
- This is why the version goes in the notebook: the same command name can run different
  programs.


## 6. awk on the seqkit table

Build a short awk command step by step, with a check after each step.

**Setup:** `results/seqkit/stats_raw.txt` on Crunchomics (from the `srun` or `sbatch` run).

```bash
# Look at the header first: which column has what?
head -n 1 results/seqkit/stats_raw.txt

# Step 1: print column 1 (file name)
awk -F'\t' '{print $1}' results/seqkit/stats_raw.txt

# Step 2: add column 4 (num_seqs). The header is still there
awk -F'\t' '{print $1, $4}' results/seqkit/stats_raw.txt

# Step 3: skip the header line
awk -F'\t' 'NR > 1 {print $1, $4}' results/seqkit/stats_raw.txt

# Step 4: total number of reads over all files
awk -F'\t' 'NR > 1 {sum = sum + $4} END {print sum}' results/seqkit/stats_raw.txt
```

**Possible mistake to show:** leave out `-F'\t'` in step 2. Check what happens to the
columns before the session.

**Check the result:** compare the total with the day 1 counts (sum of the line counts in
`line_counts_bash.txt`, divided by 4). Two methods, one answer.

**Point out:**
- `head -n 1` first: never guess column numbers.
- Build the command in small steps and run it after each step.
- `NR` vs `FNR`: the optional box in `hpc_howto.qmd` uses `FNR`, because it reads two files.
  With one file, both give the same result.
- Column numbers (`$1` file, `$4` num_seqs) are taken from the awk box in `hpc_howto.qmd`.
  Check them against the header.
