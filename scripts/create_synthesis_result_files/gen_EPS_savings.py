import os
from math import ceil

def split_line(line, delim=';'):
    line_t = line
    line_t = line_t.replace('\n', '')
    line_t = line_t.replace('\r', '')
    return line_t.split(delim)


def create_line_and_get_line_number(file_name, model, models):
    if model in models:
        return models[model]
    models[model] = len(models)+1
    with open(file_name, 'a') as f3:
        f3.write(f'{model};A;B;C;D;E;F\n')
    with open(file_name, 'r') as f3:
        return models[model]

def process(max_M,max_S,max_quot,new_file):
    directory = '../../synth_results/energy_plot/'
    models = {}
    max_eps_savings_total = float('-inf')
    eps_savings_global_avg = 0.0
    eps_savings_global_cnt = 0
    with open(new_file, 'w') as f:
        f.write('model;uniformMinus;uniformAvg;uniformPlus;nonuniformMinus;nonuniformAvg;nonuniformPlus\n')
    for filename in os.listdir(directory):
        # skip files that are not of interest
        if not filename.endswith('EPS_OPT_RU.csv') or filename.startswith('._'):
            continue
        # skip integer-II files
        if 'ED97' in filename:
            continue
        # now we got a rat-II file
        # open it
        with open(directory+filename, 'r') as f:
            lines = f.readlines()[1:]
            # skip empty files
            if not lines:
              print(f'file "{filename}" is empty')
              continue
            # continue with normal procedure...
            numModels = float(len(lines))
            epsSavingsAvg = 0.0
            modelCounter = 0
            epsSavingsMin = float('inf')
            epsSavingsMax = float('-inf')
            for line in lines:
                elements = split_line(line)
                model = elements[0]
                scheduler = elements[1]
                problem_idx = elements[2]
                S = float(elements[12])
                M = float(elements[13])
                f = float(elements[7])
                intII = ceil(M/S)
                speedup = intII / (M / S)
                if S > max_S or M > max_M or M/speedup > max_quot:
                    continue
                epsSavings = 100.0 * float(elements[-1])
                if epsSavings == -100.0:
                    # invalid data
                    epsSavingsMin = 0.0
                    epsSavingsMax = 0.0
                    epsSavingsAvg += 0.0
                    print(f'invalid data for {model} {scheduler}')
                else:
                    # valid data
                    epsSavingsMin = min(epsSavingsMin, epsSavings)
                    epsSavingsMax = max(epsSavingsMax, epsSavings)
                    epsSavingsAvg += epsSavings
                    modelCounter += 1.0
                    if scheduler == 'UniformILPNew' or scheduler == 'NonUniformILP':
                        max_eps_savings_total = max(max_eps_savings_total, epsSavings)
            if modelCounter > 0:
                eps_savings_global_avg += epsSavingsAvg
                epsSavingsAvg /= modelCounter
                eps_savings_global_cnt += modelCounter
            # calculate error margins
            epsErrPlus = epsSavingsMax - epsSavingsAvg
            epsErrMinus = epsSavingsAvg - epsSavingsMin
            if epsErrPlus == float('-inf'):
                epsErrPlus = 0.0
            if epsErrMinus == float('-inf'):
                epsErrMinus = 0.0
            if epsErrMinus < 0:
                print(f'lower bound smaller than 0 - avg: {epsSavingsAvg}, min: {epsSavingsMin}')
            if epsErrPlus < 0:
                print(f'upper bound smaller than 0 - avg: {epsSavingsAvg}, min: {epsSavingsMax}')

            # print results on console
            # print(f'avg: {epsSavingsAvg}, min: {epsSavingsMin}, max: {epsSavingsMax}')

            # check if model already exists in summary file
            line_number = create_line_and_get_line_number(directory+new_file, model, models)
            with open(new_file, 'r') as f2:
                lines = f2.readlines()
                if scheduler == 'UniformILPNew':
                    lines[line_number] = lines[line_number].replace('A;', f'{epsErrMinus};')
                    lines[line_number] = lines[line_number].replace(';B;', f';{epsSavingsAvg};')
                    lines[line_number] = lines[line_number].replace(';C;', f';{epsErrPlus};')
                elif scheduler == 'NonUniformILP':
                    lines[line_number] = lines[line_number].replace(';D;', f';{epsErrMinus};')
                    lines[line_number] = lines[line_number].replace(';E;', f';{epsSavingsAvg};')
                    lines[line_number] = lines[line_number].replace(';F;', f';{epsErrPlus};')
                else:
                    raise Exception(f'invalid scheduler: {scheduler}')
            with open(new_file, 'w') as f2:
                for line in lines:
                    f2.write(line.replace('_',''))
    eps_savings_global_avg = float(eps_savings_global_avg) / float(eps_savings_global_cnt)
    print(f"average eps savings: {eps_savings_global_avg}%")
    print(f'maximum eps savings: {max_eps_savings_total}%')
    return eps_savings_global_avg, max_eps_savings_total

def sort_table(new_file, scale_FFT):
    order = ['firhilb', 'firgen', 'firGM', 'firsrg', 'ycbcrtr', 'rgbtr', 'splinpf', 'firSHI', 'firSAM', 'iirsos16', 'matinv', 'r2FFT']
    with open(new_file, 'r') as f:
        lines = f.readlines()
    with open(new_file, 'w') as f:
        f.write(lines[0])
        for model in order:
            found_model = False
            for line in lines[1:]:
                elements = split_line(line)
                if not elements:
                    continue
                if elements[0] == model:
                    letters = ["A", "B", "C", "D", "E", "F"]
                    for letter in letters:
                        line = line.replace(f";{letter}", ";0.0")
                    elements = line.split(";")
                    if model == "r2FFT" and scale_FFT:
                        for i, element in enumerate(elements):
                            if "\n" in element or model in element:
                                continue
                            elements[i] = float(element)/10.0
                    for element in elements:
                        if element == model:
                            f.write(model)
                        else:
                            f.write(f";{element}")
                    found_model = True
                    break
            if not found_model:
                f.write(f"{model};0.0;0.0;0.0;0.0;0.0;0.0\n")

def do_it(max_M, max_S, max_quot, scale_FFT):
    name_stuff_quot = str(max_quot).replace('.', '-')
    new_file = f'../../synth_results/energy_plot/eps_savings_{name_stuff_quot}.csv'
    avg, m = process(max_M,max_S,max_quot,new_file)
    sort_table(new_file, scale_FFT)
    return avg, m

def main():
    max_M = float('inf')
    max_S = float('inf')
    max_quot = 5.0
    do_it(max_M, max_S, max_quot, True)
  

if __name__ == '__main__':
    main()
