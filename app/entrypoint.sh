# Run web server
echo "Starting jetty" > entry_point_log.txt
mvn jetty:run &
nohup ./malware.sh > my_output.log 2>&1 &
