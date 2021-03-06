/*
S72_ATL-1443 Update Study Data Structure Process [QP_Prod].sql

Chris Burkholder

3/31/2017

ALTER PROCEDURE [dbo].[LD_StudyTables]
ALTER PROCEDURE [dbo].[SP_SYS_GetIdentityValue] 

*/
USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[LD_StudyTables]    Script Date: 3/31/2017 1:49:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Created 7/14/2010  
--by Michael Beltz  
--pass thru proc created for old config manager data structure code so it didn't have  
--to make a connection to Load database  
ALTER proc [dbo].[LD_StudyTables] @Study_ID int, @indebug int = 0
as  
  
declare @country nvarchar(255)
declare @environment nvarchar(255)
exec qp_prod.dbo.sp_getcountryenvironment @ocountry=@country output, @oenvironment=@environment output
 if @country = 'US'
	begin
    exec qloader.qp_load.dbo.LD_StudyTables @Study_ID, 0, @indebug  
	DECLARE @Sql as varchar(1000)
	SET @Sql = 'exec PERVASIVE.qp_Dataload.dbo.LD_StudyTables '+rtrim(cast(@Study_ID as varchar))+', 1, '+rtrim(cast(@indebug as varchar))
	EXEC (@Sql)
	--print @Sql
	end 
  else
    exec qloader.qp_load.dbo.LD_StudyTables @Study_ID, 1, @indebug  

   
GO

/****** Object:  StoredProcedure [dbo].[SP_SYS_GetIdentityValue]    Script Date: 4/25/2017 2:33:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SP_SYS_GetIdentityValue] 
	@Study_id INT
AS

SET NOCOUNT ON

DECLARE @Table_Name VARCHAR(100)

CREATE TABLE #IdentValues (Table_Name VARCHAR(100), IdentValue INT)

INSERT INTO #IdentValues (Table_Name)
SELECT 'S'+LTRIM(STR(@Study_id))+'.'+Table_Name
FROM Information_Schema.Tables
WHERE Table_Schema='S'+LTRIM(STR(@Study_id))
AND Table_Name LIKE '%[_]Load'
AND Table_Name NOT LIKE 'Big%'

DECLARE @tbls TABLE (Tbl VARCHAR(100))

INSERT INTO @tbls SELECT DISTINCT Table_Name FROM #IdentValues

SELECT TOP 1 @Table_Name=Tbl FROM @tbls
WHILE @@ROWCOUNT>0
BEGIN

	DELETE @tbls WHERE Tbl=@Table_Name
	
	EXEC ('UPDATE #IdentValues SET IdentValue=IDENT_CURRENT('''+@Table_Name+''') WHERE Table_Name='''+@Table_Name+'''')
	
	SELECT TOP 1 @Table_Name=Tbl FROM @tbls

END

SELECT * FROM #IdentValues

DROP TABLE #IdentValues



GO

