time_close=60

uptime_now=`uptime | awk -F' ' '{print $3}'`

time_up=$((time_close-uptime_now))

echo "Remaining time: " $time_up
