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
    vi ...

## Connect from local
    PgBouncer = "pgbouncer-instance-4498eda780
"
    db_connection_name = "lunar-outlet-403221:us-central1:db-pgbouncer-1eecca28"
    read_replica_connection_name = [
      "lunar-outlet-403221:us-east1:db-pgbouncer-1eecca28-replica-ha-0",
    ]

        # Not needed for now
        gcloud compute start-iap-tunnel pgbouncer-instance-4498eda780
 22 \
            --zone=us-central1-a \
            --local-host-port=localhost:4226

    psql -h 34.31.167.92 -p 5432 --username=testuser testdb # public ip, working

    ping 35.226.117.112
    psql -h 35.226.117.112 -p 6432 --username=admin testdb # pgbouncer, error
    psql -h 35.226.117.112 -p 6432 --username=postgres testdb # pgbouncer, error
    psql -h 35.226.117.112 -p 6432 --username=testuser testdb # pgbouncer, error
        Password for user testuser:
        psql: error: connection to server at "35.226.117.112", port 6432 failed: FATAL:  SASL authentication failed

## Trouble shooting pgbouncer SASL authentication failure
SSH into pgbouncer-instance-4498eda780

    cd /run/user
    ./stop_all_services.sh
    ./start_all_services.sh

    sudo journalctl
    sudo journalctl -u sshd

    docker ps
    # Open shell in pgbouncer container
    docker exec -it pgbouncer /bin/sh
        cd /var/log/pgbouncer
        ls
        exit

## SCRAM authentication
Googled "pgbouncer auth_type = scram-sha-256", got
cannot do SCRAM authentication: password is SCRAM secret but client authentication did not provide SCRAM keys
[>](https://github.com/pgbouncer/pgbouncer/issues/774)
