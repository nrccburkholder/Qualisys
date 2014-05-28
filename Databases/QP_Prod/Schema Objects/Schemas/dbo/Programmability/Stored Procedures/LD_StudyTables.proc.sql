--Created 7/14/2010  
--by Michael Beltz  
--pass thru proc created for old config manager data structure code so it didn't have  
--to make a connection to Load database  
CREATE proc LD_StudyTables @Study_ID int, @indebug int = 0
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


