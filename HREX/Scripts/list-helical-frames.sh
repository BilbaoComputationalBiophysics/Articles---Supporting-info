# This awk line lists the frames where SK2 is fully helical. 
# The input is the ss.dat file
# (generated from the ss.xpm file through the plot_sscontent_vs_time.sh
# script, and the output is the frames.ndx file, which is then 
# used with the  trjconv Gromacs tool to extract the fully helical 
# frames from the  trajectory.
# To execute this, run ./list-helical-frames.sh 
# (with ss.dat in the current directory).

awk 'BEGIN{print "[ frames ]"}
{for (frame=0; frame<NF; frame++) if ($(frame+1)==5) hel[frame]++}
END{for (i=0; i<NF; i++) if (hel[i]==15) print i}' ss.dat > frames.ndx 
