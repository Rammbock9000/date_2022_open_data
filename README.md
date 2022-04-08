# fccm_2022_open_data 

=====================

== INFO

=====================

- we assume that you can execute bash scripts and have python installed
- in our bash scripts we assume that you can call python from command line via "python3"
- if this is not the case, please modify the scripts accordingly (e.g., by changing "python3" to "python")


=====================

== CONTENTS

=====================

data files: 
- schedules for all schedulers as csv files
- a .vhd file for each synthesis
- vivado report files for all successfully synthesized .vhd files

scripts:
- analyze report files => generate summary csv files
- create scheduling results table from csv files => generate .tex table
- .tex file to create energy figure from csv files

results:
- a PDF with extended experimental results and short descriptions

=====================

== INSTRUCTIONS

=====================

0) Optional: Ignore all following steps and just examine the result file "tex/results.pdf" if you are only interested in the extended experimental results.
	-> Follow steps 1-6 if you wish to re-generate all results yourself.
1) Optional: You can re-generate synthesis results using the provided .vhd files.
2) Make bash scripts executable if necessary.
3) Navigate into "scripts/generate_directories" and execute "generate_directories.sh". This sets up the folder structure for the following scripts.
4) Navigate into "scripts/create_synthesis_result_files".
5) Execute (in order): "analyze_synthesis_results.sh", "create_throughput_csv.py", "split_csv_file.py" and "gen_delta_E_all.py".
6) Navigate into "tex" and build "results.tex" to generate a PDF file with all relevant tables and figures.
