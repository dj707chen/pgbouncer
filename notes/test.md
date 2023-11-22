# How to test

## Run hammerdb in db-pgbouncer-a0b55212
We will run the test in the db-pgbouncer-a0b55212, which is cos.

After SSH into db-pgbouncer-a0b55212, when I tried to run /run/user/configure_hammerdb.sh, I got apt-get command not found.
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
    export PgBouncer=db-pgbouncer-a0b55212

## SSH then toolbox
    apt-get update
    apt-get install postgresql-client

### DB Public IP
Associated networking: projects/lunar-outlet-403221/global/networks/db-vpc
private IP: 10.94.0.2
public IP: 34.41.80.212

    gcloud sql connect --user=testuser -d testdb db-pgbouncer-a0b55212
            Allowlisting your IP for incoming connection for 5 minutes...⠹
            Connecting to database with SQL user [testuser].Password:
            psql: error: connection to server at "34.41.80.212", port 5432 failed: Connection refused

    psql -h 34.41.80.212 -p 5432 --username=admin    testdb # public ip, password: admin@123 , not working
    psql -h 34.41.80.212 -p 5432 --username=postgres testdb # public ip, password: admin@123 , not working
            psql: error: connection to server at "34.41.80.212", port 5432 failed: FATAL:  password authentication failed for user "admin"
            psql: error: connection to server at "34.41.80.212", port 5432 failed: FATAL:  password authentication failed for user "postgres"

    psql -h 34.41.80.212 -p 5432 --username=testuser testdb # public ip, password: aPass , not working

### PgBouncer
Associated networking: projects/lunar-outlet-403221/global/networks/db-vpc
internal IP: 10.128.0.2
public IP: 34.132.212.141

Could not SSH into instance-2

    gcloud compute ssh instance-2 --troubleshoot

    ping 34.132.212.141
    psql -h 34.132.212.141 -p 6432 --username=admin    testdb # password: admin@123 pgbouncer, error
    psql -h 34.132.212.141 -p 6432 --username=postgres testdb # password: admin@123 pgbouncer, error
        (if SSH into PgBouncer VM, execute the above commond from there, it works)
        psql: error: connection to server at "34.132.212.141", port 6432 failed: Connection refused
        psql: error❌: connection to server at "34.132.212.141", port 6432 failed: FATAL:  password authentication failed for user "admin"
        psql: error❌: connection to server at "34.132.212.141", port 6432 failed: FATAL:  password authentication failed for user "postgres"

    psql -h 34.132.212.141 -p 6432 --username=testuser testdb # password: aPass     pgbouncer, error
    psql -h 127.0.0.1 -p 6432 --username=testuser testdb # password: aPass     pgbouncer, error
        Password for user testuser:
        psql: error: connection to server at "34.132.212.141", port 6432 failed: Connection refused
        psql: error❌: connection to server at "34.132.212.141", port 6432 failed: FATAL:  SASL authentication failed

## Trouble shooting pgbouncer SASL authentication failure
SSH into db-pgbouncer-a0b55212	

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
