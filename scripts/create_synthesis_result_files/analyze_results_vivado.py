import re
import sys
import os.path


# getColValue returns the value of column "col" of a table in line "line" which is delimited by "delim"
def getColValue(line,col,delim="|"):
	pos_start=0
	for i in range(0,col):
		pos_end = line.find(delim,pos_start)
		res = line[pos_start:pos_end].strip()
#		print res
		pos_start = pos_end + 1;
	return res

def parseVivadoResultFiles(workdir,project_name, entity, verbose,synthesis_only):

#old file definition:

	utilization_report_file = workdir + "/"  + entity + "_utilization_"
	timing_report_file = workdir + "/" + entity + "_timing_"
	power_report_file = workdir + "/" + entity + "_power_"

#	utilization_report_file = workdir + "/"  + project_name + "_utilization_"
#	timing_report_file = workdir + "/" + project_name + "_timing_"
#	power_report_file = workdir + "/" + project_name + "_power_"
	
	if synthesis_only:
		utilization_report_file +="synth.rpt"
		timing_report_file +="synth.rpt"
		power_report_file +="synth.rpt"
	else:
		utilization_report_file +="placed.rpt"
		timing_report_file +="synth.rpt"
		power_report_file +="synth.rpt"
	
	utilization_report=None
	timing_report=None
	power_report=None
	
	if os.path.isfile(utilization_report_file):
		utilization_report = open(utilization_report_file, "r")
	else:
		print ("file " + utilization_report_file + " does not exist, ignoring resource usage", file=sys.stderr)

	if os.path.isfile(timing_report_file):
		timing_report = open(timing_report_file, "r")
	else:
		print ("file " + timing_report_file + " does not exist, ignoring timing results", file=sys.stderr)

	if os.path.isfile(power_report_file):
		power_report = open(power_report_file, "r")
	else:
		print ("file " + power_report_file + " does not exist, ignoring power results", file=sys.stderr)

	CLBs="-1";
	LUTs="-1";
	FFs="-1";
	DSPs="-1";
	fmax="-1";
	powerTotal = "-1"
	powerStatic = "-1"
	powerDynamic = "-1"

	if utilization_report != None:
		for line in utilization_report:
			if "| CLB  " in line:
				CLBs = getColValue(line,3)
				
			if "| CLB LUTs  " in line:
				LUTs = getColValue(line,3)
				
			if "| CLB Registers  " in line:
				FFs = getColValue(line,3)
				
			if "| DSPs  " in line:
				DSPs = getColValue(line,3)

	if timing_report != None:
		for line in timing_report:
			if "Data Path Delay:" in line:
				delay = getColValue(line,2,':')
				delay = getColValue(delay,1,'ns')
#				delay = delay[:delay.find("ns")]
				fmax = 1000/float(delay);
				fmax = "{:.2f}".format(fmax);

	if power_report != None:
		for line in power_report:
			if "Total On-Chip Power (W)" in line:
				powerTotal = getColValue(line,3)

			if "Device Static (W)" in line:
				powerStatic = getColValue(line,3)

			if "Dynamic (W)" in line:
				powerDynamic = getColValue(line,3)


	if verbose:
		print (" === " + project_name + " === ")
		print ("CLBs:" + CLBs)
		print ("LUTs:" + LUTs)
		print ("FFs:" + FFs)
		print ("DSPs:" + DSPs)
		print ("fmax:" + fmax)
		print ("total power:" + powerTotal)
		print ("static power:" + powerStatic)
		print ("dynamic power:" + powerDynamic)
	else:
		print (workdir + ";" + CLBs + ";" + LUTs + ";" + FFs + ";" + DSPs + ";" + fmax + ";" + powerTotal + ";" + powerStatic + ";" + powerDynamic)


if __name__=='__main__':
	workdir = sys.argv[1]
	project_name = sys.argv[2]
	entity = sys.argv[3]
	
	if len(sys.argv) > 4:
		verbose = int(sys.argv[4])
	else:
		verbose = 1
	
	if len(sys.argv) > 5:
		synthesis_only = int(sys.argv[5])
	else:
		synthesis_only = 0
	parseVivadoResultFiles(workdir,project_name,entity,verbose,synthesis_only)
