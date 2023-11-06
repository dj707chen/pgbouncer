# How to test

## Run hammerdb
We will run the test in the pgbouncer-instance-96dba99e9b, which is cos.

When I tried to run /run/user/configure_hammerdb.sh, I got apt-get command not found.
Googled "gcp cos vm install apt-get", got https://stackoverflow.com/questions/59753885/apt-get-command-not-found-in-coreos-cos
need to run /usr/bin/toolbox

/usr/bin/toolbox run docker, mounting /run:/media/root/run

    grep bind /usr/bin/toolbox
        TOOLBOX_BIND="--bind=/:/media/root --bind=/usr:/media/root/usr --bind=/run:/media/root/run"

    toolbox
    cd /media/root/run/user
    ls
        clean_up.sh            configure-hammerdb.tcl  run_workload.sh   start_all_services.sh  terminate_active_connections.py
        configure-hammerdb.sh  pgbouncer.ini           run_workload.tcl  stop_all_services.sh   userlist.txt

## Connect from local
    gcloud compute start-iap-tunnel pgbouncer-instance-96dba99e9b 22 \
        --zone=us-central1-a \
        --local-host-port=localhost:4226
    psql -h 34.72.24.75 -p 6432 --username=testuser testdb
        Password for user testuser:
        psql: error: connection to server at "34.72.24.75", port 6432 failed: FATAL:  SASL authentication failed
