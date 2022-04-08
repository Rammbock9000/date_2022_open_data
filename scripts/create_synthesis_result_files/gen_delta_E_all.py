from create_throughput_csv import main as gen_tp_csv
from split_csv_file import main as split_csv
from create_eps_files import do_it as gen_eps_files
from create_eps_files import gen_plots
from gen_EPS_savings import do_it as gen_delta_E_csv_file

def main():
    # generate csv files from synthesis results
    gen_tp_csv()
    split_csv()
    
    # limitations on M, S and M/speedup
    max_M = float('inf')
    max_S = float('inf')
    max_quots = [x*0.5+2.0 for x in range(1, 20)] + [float('inf')]

    # number of allocations for different quotients
    # these values can be obtained by analyzing graph and resource model
    # for all scheduling problems
    # we did this using the HatScheT library
    num_allocs = {}
    num_allocs[2.5] = 9
    num_allocs[3] = 28
    num_allocs[3.5] = 29
    num_allocs[4] = 31
    num_allocs[4.5] = 39
    num_allocs[5] = 49
    num_allocs[5.5] = 59
    num_allocs[6] = 59
    num_allocs[6.5] = 87
    num_allocs[7] = 88
    num_allocs[7.5] = 102
    num_allocs[8] = 106
    num_allocs[8.5] = 112
    num_allocs[9] = 114
    num_allocs[9.5] = 123
    num_allocs[10] = 125
    num_allocs[10.5] = 126
    num_allocs[11] = 137
    num_allocs[11.5] = 150
    
    # log file
    result_file_name = "../../synth_results/C_vs_E_vs_allocs/delta_E_all.csv"
    with open(result_file_name, 'w') as f:
        f.write("maxM;maxS;maxquot;avg;max;numAllocs\n")
    
    # loop over all setups
    for max_quot in max_quots:
        gen_eps_files(max_M, max_S, max_quot)
        if max_quot == float('inf'):
            scale_FFT = True
        else:
            scale_FFT = False
        avg, m = gen_delta_E_csv_file(max_M, max_S, max_quot, scale_FFT)
        if max_quot == float('inf'):
            # do not put C = infinity into csv file for Fig. 7
            # since we can not display it properly
            # (and it is also not relevant for that figure)
            continue
        with open(result_file_name, 'a') as f:
            f.write(f"{max_M};{max_S};{max_quot};{avg};{m};{num_allocs[max_quot]}\n")
    
    # plots for "gen" benchmark (Fig. 3-5)
    # this overwrites csv files for "fir_gen" for the energy plots
    # comment out this line if you are iterested in the raw csv files 
    # of the other experiments
    gen_plots()

if __name__ == '__main__':
  main()
