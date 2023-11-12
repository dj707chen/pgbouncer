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
    export PgBouncer="pgbouncer-instance-682021980d"

### Public IP
    psql -h 34.29.247.64 -p 5432 --username=admin    testdb # public ip, password: admin@123 , not working
    psql -h 34.29.247.64 -p 5432 --username=postgres testdb # public ip, password: admin@123 , not working
        psql: error: connection to server at "34.29.247.64", port 5432 failed: FATAL:  password authentication failed for user "admin"
        psql: error: connection to server at "34.29.247.64", port 5432 failed: FATAL:  password authentication failed for user "postgres"

    psql -h 34.29.247.64 -p 5432 --username=testuser testdb # public ip, password: aPass , not working

### PgBouncer
    ping 35.226.233.52
    psql -h 35.226.233.52 -p 6432 --username=admin    testdb # password: admin@123 pgbouncer, error
    psql -h 35.226.233.52 -p 6432 --username=postgres testdb # password: admin@123 pgbouncer, error
        psql: error❌: connection to server at "35.226.233.52", port 6432 failed: FATAL:  password authentication failed for user "admin"
        psql: error❌: connection to server at "35.226.233.52", port 6432 failed: FATAL:  password authentication failed for user "postgres"

    psql -h 35.226.233.52 -p 6432 --username=testuser testdb # password: aPass     pgbouncer, error
        Password for user testuser:
        psql: error❌: connection to server at "35.226.233.52", port 6432 failed: FATAL:  SASL authentication failed

## Trouble shooting pgbouncer SASL authentication failure
SSH into pgbouncer-instance-682021980d

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
