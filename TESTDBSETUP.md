# Capture existing Production database configuration details
    - Crunchy Postgres Operator - version 5.4.3 (provided)
    - Postgres - version 15 (provided)
    - database configuration (resources, storage, and scaling policies, high availability) needs to be noted.
    - capture applictaions connection strings where this production database is being accessed.
    - Permissions, users and roles.
    - database architecture (provided)
# To acknowledge or think about some more things to gather, I would discuss with team to get more info and discuss my stragery with the team and the leads.
# Data Masking 
    - If sensitive data or PII is involved, we would want to apply data masking techniques to protect it in the test environment.

# Security Best Practices
    - Ensure that the test environment adheres to the same security best practices as the production environment, including access controls, encryption, and vulnerability scanning. We may need to discuss with security team to ensure this is enabled.    

# Conifgure test environment on the given namespace
    - use same crunchy Postgres Operator(v5.4.3) to deploy Postgre SQL 15 database in the openshift namespace allocated for the test environment.
    - Make sure all the resources, storage, scaling policies, high availability, permissions matches the existing production setup.

# Back up and Dumps
    - Run backup on production database on top of reqular backup schedule.
    - Export the schema from production database including all tables, indexes, constraints, triggers, functions, Stored Procedures.
    - Use pg_dump to export schema from production database. we can either do that table by table or for the entire database.
        pg_dump -h <hostname> -U <username> -d <database_name> --schema-only | gzip > <output_file.sql.gz>  # this is for big schemas

        pg_dump -h <hostname> -U <username> -d <database_name> --schema-only -n <schema_name> -f <output_file.sql>
        ex: pg_dump -h <hostname> -U <username> -d <database_name> --schema-only -n housing -n housing_type -n ownership -n owners -f <output_file.sql>

        (always advised to use service accounts instead of user accounts)

# Import schema on to test database
    - Create the new tables housing_type, housing, ownership, owners.
        createdb -T template0 dbname
    - All the users who own objects in the dumped database or were granted permissions on the objects need to be created, If they do not exist, the restore will fail to recreate the objects with the original ownership and/or permissions.   
    - Apply the schema to test databases one after another using the below command
    psql -h <test-db-host> -U <user> -d <database>  -f output_file.sql

# Migrate data from Production to Test database
    - pg_dump --data-only --no-owner --no-acl -h <production-host> -U <user> -d <database> -t housing_type | psql -h <test-db-host> -U <user> -d <database>  (for smaller databases)
    - for larger dataset this can be achived using compressed pgdumps with --data-only option.  
    pg_dump -h <hostname> -U <username> -d <database_name> -F c -Z 9 -f <path_to_output.dump>
    restore: pg_restore -h <hostname> -U <username> -d <database_name> -v <path_to_dump.dump>

# Post activity checks  
    - Verify the row counts and key relationships are intact.
        SELECT COUNT(*) FROM housing;
        SELECT COUNT(*) FROM housing_type;
        SELECT COUNT(*) FROM ownership;
        SELECT COUNT(*) FROM owners;
    - Ensure foreign key constraints and indexes are functioning as expected.
    - Perform similar production queries and test database and ensure they return same data and performance.
    - Ensure Test database is matching Prod postgresql settings (e.g., shared_buffers, work_mem) as closely as possible.

# Load Testing
    - Conduct load testing to evaluate the performance of the API under various load conditions. This will help identify potential bottlenecks and ensure that the API can handle expected traffic.  

# Update scripts and  monitoring
    - Update deployment(CICD) scripts with this new test database and tables details for continous integration and deployment. 
    _  consider adding this test db to existing .github/workflows to automatically deploy to this environment.
    - Update application connection strings on test environment and make sure applictaions can access the test db.
    - Check the permissions.
    - Update monitoring tools like grafana dashboard and add to splunk for more logging to check performance and high availability.
 
# Validation
    - Access apis and runs tests against test environment to ensure everything is working fine.