import os


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

def do_it(M_S_max):
    directory = '../../synth_results/energy_plot/'
    new_file = f'eps_savings.csv'
    models = {}
    max_eps_savings_total = float('-inf')
    with open(directory+new_file, 'w') as f:
        f.write('model;uniformMinus;uniformAvg;uniformPlus;nonuniformMinus;nonuniformAvg;nonuniformPlus\n')
    for filename in os.listdir(directory):
        # skip files that are not of interest
        if not filename.endswith('EPS_OPT.csv') or filename.startswith('._'):
            continue
        # skip integer-II files
        if 'ED97' in filename:
            continue
        # now we got a rat-II file
        print(f'file: {filename}')
        with open(directory+filename, 'r') as f:
            lines = f.readlines()[1:]
            numModels = float(len(lines))
            epsSavingsAvg = 0.0
            modelCounter = 0
            epsSavingsMin = float('inf')
            epsSavingsMax = float('-inf')
            for line in lines:
                elements = split_line(line)
                model = elements[0]
                scheduler = elements[1]
                S = float(elements[12])
                M = float(elements[13])
                f = float(elements[7])
                if S > M_S_max or M > M_S_max:
                    continue
                epsSavings = 100.0 * float(elements[-1])
                if epsSavings == -100.0:
                    # invalid data
                    epsSavingsMin = 0.0
                    epsSavingsMax = 0.0
                    epsSavingsAvg += 0.0
                else:
                    # valid data
                    epsSavingsMin = min(epsSavingsMin, epsSavings)
                    epsSavingsMax = max(epsSavingsMax, epsSavings)
                    epsSavingsAvg += epsSavings
                    modelCounter += 1.0
                    if scheduler == 'UniformILPNew' or scheduler == 'NonUniformILP':
                        max_eps_savings_total = max(max_eps_savings_total, epsSavings)
            if modelCounter > 0:
                epsSavingsAvg /= modelCounter
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
            with open(directory + new_file, 'r') as f2:
                lines = f2.readlines()
                if scheduler == 'UniformILPNew':
                    lines[line_number] = lines[line_number].replace('A;', f'{epsErrMinus};')
                    lines[line_number] = lines[line_number].replace(';B;', f';{epsSavingsAvg};')
                    lines[line_number] = lines[line_number].replace(';C;', f';{epsErrPlus};')
                elif scheduler == 'NonUniformILP':
                    lines[line_number] = lines[line_number].replace(';D;', f';{epsErrMinus};')
                    lines[line_number] = lines[line_number].replace(';E;', f';{epsSavingsAvg};')
                    lines[line_number] = lines[line_number].replace(';F', f';{epsErrPlus}')
                else:
                    raise Exception(f'invalid scheduler: {scheduler}')
            with open(directory + new_file, 'w') as f2:
                for line in lines:
                    f2.write(line.replace('_',''))
    print(f'maximum eps savings: {max_eps_savings_total}%')

def sort_table(M_S_max):
    directory = '../../synth_results/energy_plot/'
    new_file = f'eps_savings.csv'
    order = ['firhilb', 'firgen', 'firGM', 'firsrg', 'ycbcrtr', 'rgbtr', 'splinpf', 'firSHI', 'firSAM', 'iirsos16', 'matinv', 'r2FFT']
    with open(directory+new_file, 'r') as f:
        lines = f.readlines()
    with open(directory+new_file, 'w') as f:
        f.write(lines[0])
        for model in order:
            for line in lines[1:]:
                elements = split_line(line)
                if not elements:
                    continue
                if elements[0] == model:
                    f.write(line)


if __name__ == '__main__':
    M_S_max = float('inf')
    do_it(M_S_max)
    #sort_table(M_S_max)
