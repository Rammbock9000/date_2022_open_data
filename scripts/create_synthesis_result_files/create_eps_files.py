# This is a sample Python script.

# Press Shift+F10 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.


def split_line(line, delim):
    line_t = line
    line_t = line_t.replace('\n', '')
    line_t = line_t.replace('\r', '')
    return line_t.split(delim)


def find_integer_II_reference(csv_file_prefix, scheduler, ratII):
    int_II_file = csv_file_prefix.replace(scheduler, 'ED97') + '.csv'
    II = None
    RU = None
    f_max = None
    total_power = None
    with open(int_II_file, 'r') as f:
        for line in f.readlines()[1:]:
            elements = split_line(line, ';')
            II_new = float(elements[11])
            if II_new < ratII:
                continue
            if II != None:
                if II < II_new:
                    continue
            II = II_new
            RU = float(elements[15])
            power_total = float(elements[8])
            f_max = float(elements[7])
    return II, RU, power_total, f_max


def calc_energy_per_sample(src_file, scheduler, dst_file):
    lines = None
    with open(src_file+'.csv', 'r') as f:
        lines = f.readlines()
    with open(dst_file+'.csv', 'w') as f:
        line_t = lines[0].replace('\n', '')
        line_t = line_t.replace('\r', '')
        line_t = line_t.replace(';vhd_file_index', '')
        line_t = line_t.replace('throughput_mega_samples_per_sec', 'throughputMegaSamplesPerSec')
        f.write(line_t + ';energyPerSample;powerResourceProduct;EPSResourceProduct;EPSSavings\n')
        for line in lines[1:]:
            elements = split_line(line, ';')
            f_max = float(elements[7])
            f_max = min(f_max, 250.0)  # target frequency 250 MHz
            power_total = float(elements[8])
            II = float(elements[11])
            if scheduler == 'ED97':
                RU = float(elements[13])
            else:
                RU = float(elements[15])
            energy_per_sample = 1000 * power_total * II / f_max  # [nJ / sample]
            power_resource_product = power_total * RU
            EPS_resource_product = energy_per_sample * RU
            if scheduler == 'ED97':
                II_int, RU_int, power_total_int, f_max_int = II, RU, power_total, f_max
            else:
                II_int, RU_int, power_total_int, f_max_int = find_integer_II_reference(src_file, scheduler, II)
            EPS_int_II = 1000 * power_total_int * II_int / min(f_max_int, 250.0)  # [nJ / sample]
            EPS_savings = (EPS_int_II - energy_per_sample) / EPS_int_II
            if RU == -1 or II == -1 or power_total == -1:
                energy_per_sample = -1
                power_resource_product = -1
                EPS_resource_product = -1
                EPS_savings = -1
            for i in range(len(elements)):
                f.write(elements[i])
                f.write(';')
            f.write(str(energy_per_sample) + ';')
            f.write(str(power_resource_product) + ';')
            f.write(str(EPS_resource_product) + ';')
            f.write(str(EPS_savings) + '\n')


def filter_non_optimal(src_file, scheduler, dst_file):
    lines = None
    with open(src_file+'.csv', 'r') as f:
        lines = f.readlines()
    with open(dst_file+'.csv', 'w') as f:
        f.write(lines[0])
        for i in range(len(lines[1:])):
            line = lines[i+1]
            try:
                elements = split_line(line, ';')
                II = float(elements[11])
                RU = float(elements[15])
                # check if this implementation is pareto optimal
                paretoOpt = True
                # skip header line
                for j in range(len(lines[1:])):
                    line2 = lines[j + 1]
                    elements2 = split_line(line2, ';')
                    II2 = float(elements2[11])
                    RU2 = float(elements2[15])
                    # check pareto optimality
                    if (RU > RU2 and II >= II2) or (RU == RU2 and II >= II2 and i>j):
                        paretoOpt = False
                        break
                # skip non-pareto-opt implementations
                if not paretoOpt:
                    continue
                # write line for minimal RU
                f.write(line)
            except:
                continue

def filter_non_optimal_ru(src_file, scheduler, dst_file):
    lines = None
    with open(src_file+'.csv', 'r') as f:
        lines = f.readlines()
    with open(dst_file+'.csv', 'w') as f:
        f.write(lines[0])
        for i in range(len(lines[1:])):
            line = lines[i+1]
            try:
                elements = split_line(line, ';')
                II = float(elements[11])
                if scheduler == 'ED97':
                    RU = float(elements[13])
                else:
                    RU = float(elements[15])
                # check if this implementation is pareto optimal
                paretoOpt = True
                # skip header line
                for j in range(len(lines[1:])):
                    line2 = lines[j + 1]
                    # do not compare with itself
                    if i == j:
                        continue
                    elements2 = split_line(line2, ';')
                    II2 = float(elements2[11])
                    if scheduler == 'ED97':
                        RU2 = float(elements2[13])
                    else:
                        RU2 = float(elements2[15])
                    # check pareto optimality
                    if (RU > RU2 and II == II2) or (RU == RU2 and II == II2 and i>j):
                        paretoOpt = False
                        break
                # skip non-pareto-opt implementations
                if not paretoOpt:
                    continue
                # write line for minimal RU
                f.write(line)
            except:
                print('oh no exception')
                continue

def do_it(models, schedulers, src_path, dst_path, ru):
    for model in models:
        for scheduler in schedulers:
            csv_file = f'{model}_{scheduler}'
            calc_energy_per_sample(src_path+csv_file, scheduler, dst_path+csv_file+'_EPS')
            if ru:
                filter_non_optimal_ru(dst_path+csv_file+'_EPS', scheduler, dst_path+csv_file+'_EPS_OPT_RU')
            else:
                filter_non_optimal(dst_path+csv_file+'_EPS', scheduler, dst_path+csv_file+'_EPS_OPT')

if __name__ == '__main__':
    schedulers = ['ED97', 'NonUniformILP', 'UniformILPNew']
    models = ['fir_hilb', 'fir_gen', 'fir_GM', 'fir_srg', 'ycbcr_tr', 'rgb_tr', 'splin_pf', 'fir_SHI', 'fir_SAM', 'iir_sos16', 'mat_inv', 'r2_FFT']
    src_path = '../../synth_results/synth_raw/split/'
    dst_path = '../../synth_results/energy_plot/'
    #do_it(['fir_gen'], ['NonUniformILP'], src_path, dst_path, False)
    do_it(models, schedulers, src_path, dst_path, False)
    do_it(['fir_gen'], schedulers, src_path, dst_path, True)
