from math import ceil


def split_line(line, delim):
    line_t = line
    line_t = line_t.replace('\n', '')
    line_t = line_t.replace('\r', '')
    return line_t.split(delim)


def find_integer_II_reference(csv_file_prefix, scheduler, ratII):
    int_II_file = f'../../synth_results/synth_raw/split/{csv_file_prefix.replace(scheduler, "ED97")}.csv'
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
            RU = float(elements[13])
            power_total = float(elements[8])
            f_max = float(elements[7])
    return II, RU, power_total, f_max


def calc_energy_per_sample(csv_file_prefix, scheduler):
    lines = None
    try:
      with open(f'../../synth_results/synth_raw/split/{csv_file_prefix}.csv', 'r') as f:
          lines = f.readlines()
    except:
      # maybe the file does not exist...
      # just skip it
      print(f'file "../../synth_results/synth_raw/split/{csv_file_prefix}.csv" does not exist')
      return
    with open(f'../../synth_results/energy_plot/{csv_file_prefix}_EPS.csv', 'w') as f:
        for line in lines:
            try:
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
                    II_int, RU_int, power_total_int, f_max_int = find_integer_II_reference(csv_file_prefix, scheduler, II)
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
            except:
                if line != lines[0]:
                    print(f'continue for line "{line}"')
                    continue
                line_t = line.replace('\n', '')
                line_t = line_t.replace('\r', '')
                line_t = line_t.replace(';vhd_file_index', '')
                line_t = line_t.replace('throughput_mega_samples_per_sec', 'throughputMegaSamplesPerSec')
                f.write(line_t + ';energyPerSample;powerResourceProduct;EPSResourceProduct;EPSSavings\n')


def filter_non_optimal(csv_file_prefix, scheduler, all_IIs):
    lines = None
    try:
      with open(f'../../synth_results/energy_plot/{csv_file_prefix}_EPS.csv', 'r') as f:
          lines = f.readlines()
    except:
      # maybe the file does not exist...
      # just skip it
      print(f"filter_non_optimal: skip {csv_file_prefix}, {scheduler}")
      return
    with open(f'../../synth_results/energy_plot/{csv_file_prefix}_EPS_OPT.csv', 'w') as f:
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
                    # do not compare with itself
                    if i == j:
                        continue
                    elements2 = split_line(line2, ';')
                    II2 = float(elements2[11])
                    RU2 = float(elements2[15])
                    # check pareto optimality
                    if all_IIs and RU > RU2 and II == II2:
                        paretoOpt = False
                        break
                    if (not all_IIs) and RU > RU2 and II >= II2:
                        paretoOpt = False
                        break
                # skip non-pareto-opt implementations
                if not paretoOpt:
                    continue
                # write line for minimal RU
                f.write(line)
            except:
                print("exception EPS->EPS_OPT")
                continue

def filter_non_optimal_ru(csv_file_prefix, scheduler, max_M, max_S, max_quot, all_IIs):
    lines = None
    n_tot = 0
    n_con = 0
    try:
      with open(f'../../synth_results/energy_plot/{csv_file_prefix}_EPS_OPT.csv', 'r') as f:
          lines = f.readlines()
    except:
      # maybe the file does not exist...
      # just skip it
      return n_tot,n_con
    with open(f'../../synth_results/energy_plot/{csv_file_prefix}_EPS_OPT_RU.csv', 'w') as f:
        f.write(lines[0])
        for i in range(len(lines[1:])):
            line = lines[i+1]
            try:
                n_tot += 1
                elements = split_line(line, ';')
                II = float(elements[11])
                RU = float(elements[15])
                # check if we need to skip because of M/S bounds
                if scheduler != 'ED97':
                    S = float(elements[12])
                    M = float(elements[13])
                    intII = ceil(M/S)
                    speedup = intII / (M/S)
                    if S > max_S:
                        #print(f"skip because S={S} > {max_S}=max_S")
                        continue
                    if M > max_M:
                        #print(f"skip because M={M} > {max_M}=max_M")
                        continue
                    if M / speedup > max_quot:
                        continue
                n_con += 1
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
                    RU2 = float(elements[15])
                    # check if we need to skip because of M/S bounds
                    if scheduler != 'ED97':
                        S = float(elements[12])
                        M = float(elements[13])
                        intII = ceil(M/S)
                        if S > max_S:
                            continue
                        if M > max_M:
                            continue
                        if M*M / (S*intII) > max_quot:
                            continue
                    # check pareto optimality
                    if (all_IIs) and ((RU > RU2 and II == II2) or (RU == RU2 and II == II2 and i>j)):
                        paretoOpt = False
                        break
                    if (not all_IIs) and ((RU > RU2 and II >= II2) or (RU == RU2 and II == II2 and i>j)):
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
    return n_tot,n_con

def gen_plots():
    max_M = float('inf')
    max_S = float('inf')
    max_quot = float('inf')
    schedulers = ['ED97', 'NonUniformILP', 'UniformILPNew']
    model = 'fir_gen'
    all_IIs = True
    for scheduler in schedulers:
        csv_file = f'{model}_{scheduler}'
        calc_energy_per_sample(csv_file, scheduler)
        filter_non_optimal(csv_file, scheduler,all_IIs)
        filter_non_optimal_ru(csv_file, scheduler, max_M, max_S, max_quot,all_IIs)

def do_it(max_M, max_S, max_quot):
    schedulers = ['ED97', 'NonUniformILP', 'UniformILPNew']
    models = ['fir_gen', 'fir_GM', 'fir_hilb', 'fir_SAM', 'fir_SHI', 'fir_srg', 'iir_sos16', 'mat_inv', 'r2_FFT', 'rgb_tr', 'splin_pf', 'ycbcr_tr']
    all_IIs = False
    for model in models:
        print(f"model: {model}")
        for scheduler in schedulers:
            csv_file = f'{model}_{scheduler}'
            calc_energy_per_sample(csv_file, scheduler)
            filter_non_optimal(csv_file, scheduler,all_IIs)
            filter_non_optimal_ru(csv_file, scheduler, max_M, max_S, max_quot,all_IIs)

def main():
    max_M = float('inf')
    max_S = float('inf')
    max_quot = 5.0
    do_it(max_M, max_S, max_quot)
  

if __name__ == '__main__':
  main()
