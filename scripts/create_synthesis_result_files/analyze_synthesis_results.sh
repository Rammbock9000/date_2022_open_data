#!/bin/bash

# file where results are saved
result_file='../../synth_results/synth_raw/synthesis_results_raw.csv'
touch ${result_file}
echo 'instance;CLBs;LUTs;FFs;DSPs;fmax;powerTotal;powerStatic;powerDynamic' > ${result_file}

# paths where folders with synth results are located
base_path_rat_II='../../rat_II_synth'
base_path_int_II='../../int_II_synth'

# models that should be analyzed
models=('fir_gen' 'fir_GM' 'fir_hilb' 'fir_srg' 'rgb_tr' 'splin_pf' 'ycbcr_tr' 'fir_SHI' 'iir_sos16' 'mat_inv' 'fir_SAM' 'r2_FFT')

# rat-II schedulers that should be analyzed
rat_II_schedulers=('UniformILPNew' 'NonUniformILP')

# analyze script
analyze_script='analyze_results_vivado.py'

# entity name of all entities
entity='implementedSystem'

# analyze rat-II schedulers
for scheduler in ${rat_II_schedulers[@]}
do
	for model in ${models[@]}
	do
		for folder_name in ${base_path_rat_II}/${model}/${scheduler}/*
		do
			python3 ${analyze_script} ${folder_name}/ ${entity} ${entity} 0 0 >> ${result_file}
		done
	done
done

# analyze int-II scheduler
for model in ${models[@]}
do
	for folder_name in ${base_path_int_II}/${model}/*
	do
		python3 ${analyze_script} ${folder_name}/ ${entity} ${entity} 0 0 >> ${result_file}
	done
done
