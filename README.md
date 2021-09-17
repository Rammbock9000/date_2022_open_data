# date_2022_open_data

=====================

== INFO

=====================
- we assume that you can execute bash scripts and have python installed
- in our bash scripts we assume that you can call python from command line via "python3"
- if this is not the case, please modify the scripts accordingly (e.g., by changing "python3" to "python")


=====================

== CONTENTS

=====================

data files: 
- schedules for all schedulers as csv files
- a .vhd file for each schedule (for which origami did not time out)
- vivado report files for all synthesized .vhd files (that synthesized successfully)

scripts:
- analyze report files => generate summary csv files
- create scheduling results table from csv files => generate .tex table
- .tex file to create energy figure from csv files
