SELECT
    @@SERVERNAME AS ServerName,
    @@VERSION AS SqlServerVersion,
    DB_NAME() AS CurrentDatabase;
GO