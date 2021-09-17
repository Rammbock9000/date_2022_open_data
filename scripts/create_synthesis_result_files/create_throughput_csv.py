import os

def get_scheduler_model_index(line,schedulers,models):
	# remove last element if it's a /
	if line[-1] == '/':
		line = line[:-1]
	elements = line.split('/')
	# last element is the experiment name
	experiment = elements[-1]
	scheduler = None
	model = None
	index = None
	# find scheduler
	for s in schedulers:
		if s in experiment:
			scheduler = s
	if scheduler == None:
		print('scheduler not found - {}'.format(experiment))
		return [None, None, None]
	# find model
	for m in models:
		if m in experiment:
			model = m
	if model == None:
		print('model not found')
		return [None, None, None]
	# find index
	experiment = experiment.replace(scheduler,'')
	experiment = experiment.replace(model,'')
	# now experiment should start with two '_'
	experiment = experiment[2:]
	words = experiment.split('_')
	# fist element should be the index now
	index = int(words[0])
	return scheduler, model, index

def get_II(scheduler, model, index, rat_II_sched_files_base, int_II_sched_files_base):
  if scheduler == None or model == None or index == None or int_II_sched_files_base == None or rat_II_sched_files_base == None:
    raise Exception('invalid arguments to get_II()')
  try:
    if scheduler == 'ED97':
      f = open('{}/{}/{}_{}.csv'.format(int_II_sched_files_base,model,scheduler,index,'r'))
    if scheduler == 'UniformILPNew' or scheduler == 'NonUniformILP':
      f = open('{}/{}/{}_{}.csv'.format(rat_II_sched_files_base,model,scheduler,index,'r'))
    lines = f.readlines()
    f.close()
    II = 0.0
    S = 0
    M = 0
    rm_index = -1
    for line in lines:
      if '# II' in line:
        words = line.split(' ')
        II = float(words[2])
      if '# samples' in line:
        words = line.split(' ')
        S = int(words[2])
      if '# modulo' in line:
        words = line.split(' ')
        M = int(words[2])
      if '# resourceModel' in line:
        # now it's getting a bit complicated
        words = line.split(' ')
        rm_file_path = words[2]
        rm_file_path = rm_file_path.replace('\n','')
        rm_file_path = rm_file_path.replace('\r','')
        elements = rm_file_path.split('/')
        last_element = elements[-1]
        # now last_element should be RMXYZ.xml
        last_element = last_element.replace('RM','')
        rm_index = int(last_element.replace('.xml',''))
    # integer-II scheduler?
    if S==0:
      S=1
    if M==0:
      M=II
    if rm_index==-1:
      raise RuntimeError('could not determine resource model index')
    return II,S,M,rm_index
  except:
    return None, None, None, None

if __name__=='__main__':
	analyze_me = '../../synth_results/synth_raw/synthesis_results_raw.csv'
	tp_file = '../../synth_results/synth_raw/synth_detailed.csv'
	rat_II_sched_files_base = '../../rat_II_schedules'
	int_II_sched_files_base = '../../int_II_schedules'
	# schedule files have address sched_files_base/model_name/scheduler_i.csv

	# list of all schedulers that we want to analyze
	schedulers = ['UniformILPNew', 'ED97', 'NonUniformILP']

	# model names to analyze
	models = ['fir_gen', 'fir_GM', 'fir_hilb', 'fir_srg', 'rgb_tr', 'splin_pf', 'ycbcr_tr', 'fir_SHI', 'iir_sos16', 'mat_inv', 'fir_SAM', 'r2_FFT']

	# LUT to DSP ratio
	N = 142

	# read csv with data extracted from synthesis
	f = open(analyze_me,'r')
	lines = f.readlines()
	f.close()

	t = open(tp_file,'w')

	# ignore first line because it's just the header
	for line in lines[:]:
		line = line.replace('\n','')
		line = line.replace('\r','')
		elements = line.split(';')
		if 'instance;CLBs;LUTs;FFs;DSPs;fmax;powerTotal;powerStatic;powerDynamic' in line:
			t.write('model;scheduler;index;CLBs;LUTs;FFs;DSPs;fmax;powerTotal;powerStatic;powerDynamic;II;S;M;throughput_mega_samples_per_sec;RU;vhd_file_index')
			continue
		# check which experiment was done
		synth_folder = elements[0]

		# find right experiment
		scheduler, model, index = get_scheduler_model_index(synth_folder, schedulers, models)
		II,S,M,rm_index = get_II(scheduler, model, index, rat_II_sched_files_base, int_II_sched_files_base)
		# write model, scheduler and index
		if II>0:
			t.write('\n{};{};{};'.format(model,scheduler,rm_index))
			for element in elements[1:]:
				t.write('{};'.format(element))
			LUTs = int(elements[2])
			DSPs = int(elements[4])
			RU = LUTs + N*DSPs
			t.write('{:.2f};{};{};{:2f};{}'.format(II,S,M,float(elements[5])/II,RU))
