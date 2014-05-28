CREATE PROCEDURE [dbo].[SP_SYS_RemoveIdentity]
	@Study_id		INT,
	@strTable_nm	VARCHAR(100),
	@strField_nm	VARCHAR(100)
AS

DECLARE @sql VARCHAR(8000)

--First clear the table
SELECT @sql='TRUNCATE TABLE S'+LTRIM(STR(@Study_id))+'.'+@strTable_nm
EXEC (@sql)

--Drop the constraint
SELECT @sql='ALTER TABLE S'+LTRIM(STR(@Study_id))+'.'+@strTable_nm+' DROP CONSTRAINT PK_S'+LTRIM(STR(@Study_id))+@strTable_nm
EXEC (@sql)

--Test for then drop rogue index if it exists
SELECT @sql='IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[S'+LTRIM(STR(@Study_id))+'].['+@strTable_nm+']'') AND name = N''POPULATIONpop_idI'') DROP INDEX [POPULATIONpop_idI] ON [S'+LTRIM(STR(@Study_id))+'].['+@strTable_nm+'] WITH ( ONLINE = OFF )'
EXEC (@sql)

--Drop the identity column(Pop_id, Enc_id, etc)
SELECT @sql='ALTER TABLE S'+LTRIM(STR(@Study_id))+'.'+@strTable_nm+' DROP COLUMN '+@strField_nm
EXEC (@sql)

--Add the column back 
SELECT @sql='ALTER TABLE S'+LTRIM(STR(@Study_id))+'.'+@strTable_nm+' ADD '+@strField_nm+' INT'
EXEC (@sql)

--Alter the column to be not null
SELECT @sql='ALTER TABLE S'+LTRIM(STR(@Study_id))+'.'+@strTable_nm+' ALTER COLUMN '+@strField_nm+' INT NOT NULL'
EXEC (@sql)

--Add the primary key
SELECT @sql='ALTER TABLE S'+LTRIM(STR(@Study_id))+'.'+@strTable_nm+' ADD CONSTRAINT PK_S'+LTRIM(STR(@Study_id))+@strTable_nm+' PRIMARY KEY CLUSTERED ('+@strField_nm+')'
EXEC (@sql)


