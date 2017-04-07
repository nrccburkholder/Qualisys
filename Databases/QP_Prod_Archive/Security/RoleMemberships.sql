EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'NRC\ElevatedDatabaseAccess';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'#Splunk';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatawriter', @membername = N'NRC\ElevatedDatabaseAccess';

