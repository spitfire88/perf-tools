#!/bin/bash

# Number of seconds between each data capture
INTERVAL=10

# Number of data points to show on the graph
DATA_POINTS=1

rm -rf *.log
awk -v interval=$INTERVAL 'BEGIN{ print "Timestamp", "Paged In", "Paged Out" }' > vmstat_graph_data.log
# Continuously capture vmstat data and update the line graph
while true; do
    vmstat -s | grep "pages paged" | awk '{printf "%s ", $1 } END {printf "\n"}' > vmstat_data.log
    clear
    awk -v interval=$INTERVAL 'BEGIN{ printf "%s ", strftime("%H:%M:%S") } NR % 2 == 1 { print $0 }' vmstat_data.log | tail -n $DATA_POINTS >> vmstat_graph_data.log
    echo "set terminal dumb; set title 'Pages Paged In/Out'; set xlabel 'Timestamp'; set ylabel 'Value'; set xdata time; set timefmt '%H:%M:%S'; set format x '%H:%M:%S'; set xtics rotate; set xrange [*:*] noreverse; set autoscale xfix; plot 'vmstat_graph_data.log' using 1:2 with lines title 'Paged In', '' using 1:3 with lines title 'Paged Out'" | gnuplot
    sleep $INTERVAL
done

