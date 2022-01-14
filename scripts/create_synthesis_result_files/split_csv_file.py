def main():
	delim = ';'

	base_path = '../../synth_results/synth_raw/'

	file_name = 'synth_detailed.csv'

	schedulers = ['UniformILPNew', 'ED97', 'NonUniformILP']
	models = ['fir_gen', 'fir_GM', 'fir_hilb', 'fir_srg', 'rgb_tr', 'spline_pf', 'ycbcbr_tr', 'fir_SHI', 'iir_sos16', 'mat_inv', 'fir_SAM', 'r2_FFT']

	base_path = base_path
	file_name = file_name
	file_path = base_path + file_name
	with open(file_path) as fr:
		lines = fr.readlines()
		header = lines[0]
		last_scheduler = ''
		last_model = ''
		# write-file object
		fw = None
		# iterate through lines of read-file
		for line in lines[1:]:
			elements = line.split(delim)
			# skip empty lines
			if len(elements) < 2:
				continue
			# get model and scheduler
			model = elements[0]
			scheduler = elements[1]
			# open new file if needed
			if scheduler != last_scheduler or model != last_model:
				write_path = base_path + 'split/{}_{}.csv'.format(model,scheduler)
				if fw != None:
					fw.close()
				fw = open(write_path,'w')
				fw.write(header)
			# write content to file
			fw.write(line)
			last_model = model
			last_scheduler = scheduler

if __name__=='__main__':
	main()
