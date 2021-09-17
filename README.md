# date_2022_open_data

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
- vivado report files for all synthesized .vhd files (that synthesized successfully)

scripts:
- analyze report files => generate summary csv files
- create scheduling results table from csv files => generate .tex table
- .tex file to create energy figure from csv files


=====================

== INSTRUCTIONS

=====================

1) optional: you can re-generate synthesis results using the provided .vhd files
2) make bash scripts executable
3) navigate into "scripts/generate_directories" and execute "generate_directories.sh". This sets up the folder structure for the following scripts
4) navigate into "scripts/create_scheduling_summary_table" and execute "create_scheduling_summary_table.py" to generate Table II from the paper
5) navigate into "scripts/synthesis_result_files"
6) execute (in order): "analyze_synthesis_results.sh", "create_throughput_csv.py", "create_eps_files.py" and "gen_EPS_savings.py" to generate data for Figures 3-6 from the paper
7) navigate into "tex" and build "main.tex" to generate a PDF file with all relevant tables and figures
8) we created Table III without any scripts but you can extract all data from the synthesis results stored in the .csv files in directory "synth_results/energy_plot" (i.e., fir_SHI_XXX_EPS_OPT.csv)
