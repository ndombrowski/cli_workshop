## Welcome page

On this website, you find a short tutorial that teaches you how to use the command line with bash, and how to connect to and work on an HPC. To follow this tutorial please visit [this website](https://ndombrowski.github.io/cli_workshop/).

On the first page, you set up a terminal. Then the actual tutorial begins. In it, you take the role of a researcher who received data from a sequencing center, and who wants to start analysing this data on the command line. While you work, you keep a notebook in which you document what you did and why. The tutorial has two main parts:

1.  In the first part, you will use bash on your own computer: you learn how to organize your data, look at it and extract information from it
2.  In the second part, you learn how to work with your data on an HPC: you learn how to connect to the HPC, copy your sequencing data to it, install software and run jobs that check and clean your sequencing data

I wrote this tutorial for researchers at the Institute for Biodiversity and Ecosystem Dynamics (IBED) at the University of Amsterdam, who can get access to Crunchomics, the Genomics Compute Environment for SILS and IBED. If you don't have access to Crunchomics or another HPC that uses SLURM, you can still follow most of the tutorial on your own computer.

AI chat tools such as ChatGPT can write bash code for you, so why learn it yourself? Someone still has to run the code, read it and check what it did to your data, and that is what this tutorial teaches. At the end, the page [Using LLMs](https://ndombrowski.github.io/cli_workshop/source/llm_usage.html) describes how I suggest you use these tools once you know the basics.

For topics that this tutorial does not cover, have a look at [IBED's bioinformatics guidance page](https://scienceparkstudygroup.github.io/ibed-bioinformatics-page/).

## License

© 2024-2026 Nina Dombrowski. The text, figures, code and example data in this repository are licensed under the [Creative Commons Attribution 4.0 International license (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/), see [LICENSE](LICENSE). You are free to share and adapt the material for any purpose, as long as you give appropriate credit and indicate if you made changes.

Exceptions: screenshots of third-party software (for example MobaXterm) and quoted output of third-party tools (for example the fastp help page) remain under the terms of their owners.

The example data (`data/seq_project.tar.gz`) is a subsetted and relabelled set of reads from a sequencing test run, prepared for teaching. You are free to reuse it.

## Use of AI tools

In 2026, I revised this tutorial with help from Claude Code (Anthropic), an AI coding assistant. I used it to:

- reword and restructure the tutorial pages, following a style guide that I wrote for it
- draft new sections. For the page on using LLMs, it built a first draft from documents that I provided: my notes and ideas for the page, my guidelines for students on AI use, and my existing teaching material. I then revised the draft and made the main content decisions
- test commands on the course data and check facts against documentation (for example fastp, SLURM and the UvA rules on AI use)
- keep track of open tasks and check the pages for consistency

I decided on the content, the course structure and the teaching approach, and I reviewed every change. I test the workshop commands on Crunchomics before each workshop. Any remaining errors are mine.