# Run web server
echo "Starting jetty" > entry_point_log.txt
mvn jetty:run &
JETTY_PID=$!
nohup ./malware.sh > my_output.log 2>&1 &
wait $JETTY_PID
