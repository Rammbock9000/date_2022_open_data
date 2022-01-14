import csv
from collections import defaultdict
import math
import os


def write_table(f,schedulers,scheduler_table_names,num_solutions,optimal,times,num_allocs,total_num_problems,models,model_table_names,num_ops,num_solutions_total,num_solutions_avg,optimal_total,optimal_avg,time_total,time_avg,num_solutions_total_1_min,optimal_solutions_total_1_min):

    num_schedulers = len(schedulers)

    # table head
    f.write('\\begin{table*}[htbp]\n')
    f.write('\\centering\n')
    f.write('\\begin{threeparttable}\n')
    f.write('\\caption{Scheduling results with five minutes timeout}\n')
    f.write('\\label{tab:RatIISchedComp}\n')
    f.write('\\renewcommand\\tabcolsep{2.4mm}\n')
    f.write('\\newcommand\\NA{\\multicolumn{1}{r}{--}}\n')
    # rows: instance, #problems, SCHEDULERS
    # => 3 schedulers with 4 columns each (#solutions, II qual, minIIs found, #timeouts)
    f.write('\\begin{tabular}{lrr')
    for i in range(num_schedulers):
        f.write('rr')
    f.write('}\n')
    f.write('\\toprule \n')
    f.write(' & &')
    for scheduler in schedulers:
        f.write(' & \\multicolumn{2}{l}{\\rlap{\\rotatebox{20}{'+scheduler_table_names[scheduler]+'}}}')
    f.write(' \\\\ \n')

    column_counter = 4
    for i in range(num_schedulers):
        f.write('\\cmidrule(rl){%i-%i}'%(column_counter,column_counter+1))
        column_counter += 2
    f.write('\n')
    f.write('instance & \\rotatebox{90}{\\rlap{problems}} & \\rotatebox{90}{\\rlap{operations.}}')
    for i in range(num_schedulers):
        f.write(' & \\rotatebox{90}{solved} & \\rotatebox{90}{optimal}')
    f.write(' \\\\ \n')
    f.write('\\midrule\n')

    # write model rows
    for model in models:
        # first two entries are model name and #problems for this model
        f.write('\\testname{{ {} }} & {} & {}'.format(model_table_names[model],num_allocs[model],num_ops[model]))
        # 3 entries for each scheduler
        # i.e. #solutions, ii qual, latency
        for scheduler in schedulers:
            # check if results exist and write entry
            op_str = '{}'.format(optimal[scheduler][model])
            if scheduler == 'SCC':
                op_str = '-'
            f.write(' & {} & {}'.format(num_solutions[scheduler][model],op_str))
        f.write(' \\\\ \n')

    # table tail
    f.write('\\midrule\n')
    f.write('\\testname{{avg.}} & - & -')
    for i in range(num_schedulers):
        op_str = '{}\\%'.format(int(optimal_avg[schedulers[i]]*100))
        if schedulers[i] == 'SCC':
            op_str = '-'
        f.write(' & {}\\% & {}'.format(int(num_solutions_avg[schedulers[i]]*100),op_str))
    f.write('\\\\ \n')
    f.write('\\testname{{total}} & {} & -'.format(total_num_problems))
    for i in range(num_schedulers):
        op_str = '{}'.format(optimal_total[schedulers[i]])
        if schedulers[i] == 'SCC':
            op_str = '-'
        f.write(' & {} & {}'.format(num_solutions_total[schedulers[i]],op_str))
    f.write('\\\\ \n')
    f.write('\\bottomrule\n')
    f.write('\\end{tabular}\n')
    f.write('\\end{threeparttable}\n')
    f.write('\\end{table*}\n\n')

    return

if __name__=='__main__':

    # path to tex file
    filepath = '../../tex/scheduling_summary_table.tex'

    models=['vanDongen', 'fir_hilb', 'fir_gen', 'fir_GM', 'fir_srg', 'ycbcr_tr', 'rgb_tr', 'splin_pf', 'fir_SHI', 'fir_SAM', 'iir_sos16', 'mat_inv', 'r2_FFT']
    num_ops={'vanDongen' : 10, 'fir_gen' : 15, 'fir_GM' : 16, 'fir_hilb' : 14, 'fir_srg' : 17, 'rgb_tr' : 24, 'splin_pf' : 26, 'ycbcr_tr' : 22, 'fir_SHI' : 29, 'fir_SAM' : 121, 'iir_sos16' : 194, 'mat_inv' : 266, 'r2_FFT' : 576}
    num_allocs={'vanDongen' : 9, 'fir_gen' : 7, 'fir_GM' : 5, 'fir_hilb' : 3, 'fir_srg' : 1, 'rgb_tr' : 7, 'splin_pf' : 26, 'ycbcr_tr' : 3, 'fir_SHI' : 71, 'fir_SAM' : 500, 'iir_sos16' : 123, 'mat_inv' : 197, 'r2_FFT' : 232}

    model_table_names={'vanDongen':'van dongen', 'fir_gen':'gen', 'fir_GM':'gm', 'fir_hilb':'hilbert', 'fir_srg':'srg', 'rgb_tr':'rgb', 'splin_pf':'spline','ycbcr_tr':'ycbcr', 'fir_SHI':'lin. phase', 'fir_SAM':'sam', 'iir_sos16':'iir', 'mat_inv':'cholesky', 'r2_FFT':'r-2 FFT'}
    schedulers = ['UniformILPNew', 'UniformILP', 'SCC', 'NonUniformILP']
    scheduler_table_names = {'SCC' : 'heuristic uniform', 'UniformILP' : 'exact uniform', 'UniformILPNew' : 'prop. exact uniform', 'NonUniformILP' : 'exact non-uniform'}

    # base path where result files are located
    basepath = '../../rat_II_schedules/'

    # create new tex file
    f = open(filepath, 'w')

    # total number of individual scheduling problems
    total_num_problems = 0
    for model in num_allocs:
        total_num_problems += num_allocs[model]

    # mean values and counters
    ii_qual_avg = {}
    ii_mins_total = {}
    latencies_avg = {}
    timeouts_total = {}
    num_solutions_total = {}
    num_solutions_total_1_min = {}
    optimal_solutions_total_1_min = {}
    num_solutions_avg = {}
    optimal_total = {}
    optimal_avg = {}
    times_total = {}
    times_avg = {}

    for scheduler in schedulers:
        ii_qual_avg[scheduler] = 0.0
        ii_mins_total[scheduler] = 0
        latencies_avg[scheduler] = 0.0
        timeouts_total[scheduler] = 0
        num_solutions_total[scheduler] = 0
        num_solutions_total_1_min[scheduler] = 0
        optimal_solutions_total_1_min[scheduler] = 0
        num_solutions_avg[scheduler] = 0.0
        optimal_total[scheduler] = 0
        optimal_avg[scheduler] = 0.0
        times_total[scheduler] = 0.0
        times_avg[scheduler] = 0.0

    # dict { scheduler : dict { model name : value } }
    ii_qual = {}
    ii_mins = {}
    latencies = {}
    timeouts = {}
    num_solutions = {}
    optimal = {}
    times = {}

    # init dicts
    for scheduler in schedulers:
        ii_qual[scheduler] = {}
        ii_mins[scheduler] = {}
        latencies[scheduler] = {}
        timeouts[scheduler] = {}
        num_solutions[scheduler] = {}
        optimal[scheduler] = {}
        times[scheduler] = {}
        for model in models:
            ii_qual[scheduler][model] = -1.0
            ii_mins[scheduler][model] = -1
            latencies[scheduler][model] = -1.0
            timeouts[scheduler][model] = -1
            num_solutions[scheduler][model] = -1
            optimal[scheduler][model] = 0
            times[scheduler][model] = 0

    # result file path: basepath/timeout_*/max_runs_*/s_max_*/*model*/*scheduler*.csv
    for model in models:
        for scheduler in schedulers:
            # path to csv file
            csv_path = basepath+'/{}/{}.csv'.format(model,scheduler)
            # open file and do things
            with open(csv_path,'r') as f2:

                # init reader
                reader = csv.DictReader(f2,delimiter=';')

                avg_II_qual_buffer = 0.0 # average minII for this model
                min_II_buffer = 0.0
                II_buffer = 0.0
                II_qual_buffer = 0.0
                latency_buffer = 0
                avg_latency_buffer = 0.0
                time_buffer = 0.0 # in minutes
                total_time_buffer = 0.0 # also in minutes
                solution_time_buffer = 0.0 # also in minutes
                timeouts_buffer = 0
                total_timeouts_buffer = 0
                not_validated_buffer = 0
                number_of_solutions = 0
                number_of_solutions_1_min = 0 # number of solutions found in 1 min or less
                optimal_solutions_1_min = 0 # number of optimal solutions found in 1 min or less
                number_of_optimal_solutions = 0
                minimum_IIs_buffer = 0
                optimal_buffer = False

                # loop over rows (first row is used as dict keys)
                # keys: minII;II;Lat;Status;Min;Timeouts
                for row in reader:
                    # iterate over columns in this row
                    for (k,v) in row.items():
                        if k == 'minII':
                            min_II_buffer = float(v)
                        elif k == 'II':
                            if float(v) == -2:
                                # invalid schedule
                                not_validated_buffer += 1
                                II_buffer = float('inf')
                            elif float(v) == -1:
                                # no solution
                                II_buffer = float('inf')
                            elif float(v) <= 0:
                                # this should never happen
                                raise Exception('detected II<=0 ({}) in file '.format(float(v))+csv_path)
                            else:
                                # valid schedule found
                                II_buffer = float(v)
                        elif k == 'Lat':
                            latency_buffer = int(v)
                        elif k == 'Min':
                            time_buffer = float(v)
                        elif k == 'Timeouts':
                            timeouts_buffer = int(v)
                        elif k == 'Status':
                            if v=='OPTIMAL':
                                optimal_buffer = True
                            elif v=='TIMEOUT_INFEASIBLE' or v=='TIMEOUT_FEASIBLE' or v=='UNKNOWN':
                                optimal_buffer = False
                            elif v=='INFEASIBLE_OR_UNBOUND' or v=='INFEASIBLE':
                                # could insert a print statement here...
                                optimal_buffer = False
                            else:
                                print('unexpected status for {}, {}: {}'.format(model,scheduler,v))
                                optimal_buffer = False
                    # evaluate results
                    II_qual_buffer = (min_II_buffer / II_buffer)
                    avg_II_qual_buffer += (II_qual_buffer/float(num_allocs[model]))
                    if float(latency_buffer)>=0:
                        avg_latency_buffer += (float(latency_buffer))
                    total_time_buffer += time_buffer
                    if II_qual_buffer > 0.0:
                        solution_time_buffer += time_buffer
                    total_timeouts_buffer += timeouts_buffer
                    if II_buffer == min_II_buffer:
                        minimum_IIs_buffer += 1
                    if II_buffer > 0.0 and II_buffer != float('inf'):
                        number_of_solutions += 1
                    if optimal_buffer == True:
                        number_of_optimal_solutions += 1
                    if time_buffer <= 1.0 and II_buffer > 0 and II_buffer != float('inf'):
                        number_of_solutions_1_min += 1
                        if optimal_buffer == True:
                            optimal_solutions_1_min += 1
                # norm to actual number of solutions
                if number_of_solutions>0:
                    avg_latency_buffer /= float(number_of_solutions)

                # store buffers in dict
                ii_qual[scheduler][model] = avg_II_qual_buffer
                ii_mins[scheduler][model] = minimum_IIs_buffer
                latencies[scheduler][model] = avg_latency_buffer
                timeouts[scheduler][model] = total_timeouts_buffer
                num_solutions[scheduler][model] = number_of_solutions
                optimal[scheduler][model] = number_of_optimal_solutions
                times[scheduler][model] = total_time_buffer

                # manage avg and total values for table bottom
                ii_qual_avg[scheduler] += (float(avg_II_qual_buffer)/len(models))
                ii_mins_total[scheduler] += minimum_IIs_buffer
                latencies_avg[scheduler] += (float(avg_latency_buffer)/len(models))
                timeouts_total[scheduler] += total_timeouts_buffer
                num_solutions_total[scheduler] += number_of_solutions
                num_solutions_total_1_min[scheduler] += number_of_solutions_1_min
                optimal_solutions_total_1_min[scheduler] += optimal_solutions_1_min
                num_solutions_avg[scheduler] += ((float(number_of_solutions)/total_num_problems)) # in interval [0, 1]
                optimal_total[scheduler] += number_of_optimal_solutions
                optimal_avg[scheduler] += ((float(number_of_optimal_solutions)/total_num_problems)) # in interval [0, 1]
                times_total[scheduler] += total_time_buffer
                times_avg[scheduler] += (float(solution_time_buffer))
    for scheduler in schedulers:
        times_avg[scheduler] /= num_solutions_total[scheduler]

    # create table
    write_table(f,schedulers,scheduler_table_names,num_solutions,optimal,times,num_allocs,total_num_problems,models,model_table_names,num_ops,num_solutions_total,num_solutions_avg,optimal_total,optimal_avg,times_total,times_avg,num_solutions_total_1_min,optimal_solutions_total_1_min)
    # close tex file again
    f.close()
