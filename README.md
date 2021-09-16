# date_2022_open_data

== CONTENTS ==
data files: 
- schedules for all schedulers as csv files
- a .vhd file for each schedule (for which origami did not time out)
- vivado report files for all synthesized .vhd files (that synthesized successfully)

scripts:
- start vivado synthesis => generate report files
- analyze report files => generate summary csv files
- create scheduling results table from csv files => generate .tex table
- .tex file to create energy figure from csv files
