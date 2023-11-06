
    Error: Error waiting for Create Instance: Failed to create subnetwork. Couldn't find free blocks in allocated IP ranges. Please allocate new ranges for this service provider.
    │ Help Token: AZ-7fWKQcNCQmc8yD2MbH86GNXRftJjxQqA-TJpB2aO3hjUXcEyGsbzIdr_jCwBdH08Pbdu4U6oszZg8Wl4bnbTMYgnKbS8cIZxfvQaaOUvbxTgr
    │
    │
    │   with module.db.google_sql_database_instance.default,
    │   on .terraform/modules/db/modules/postgresql/main.tf line 53, in resource "google_sql_database_instance" "default":
    │   53: resource "google_sql_database_instance" "default" {

Googled "Failed to create subnetwork. Couldn't find free blocks in allocated IP ranges", got

[Secure Google Cloud SQL Instances using Private IP: Gotchas & troubleshooting](https://medium.com/google-cloud/secure-google-cloud-sql-instances-using-private-ip-gotchas-troubleshooting-f7cf6dfe1bbb)