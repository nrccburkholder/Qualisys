CREATE PROCEDURE [dbo].[sp_sys_spidkiller]
AS
-- Proc that seeks out blocking backup spid on workflow database and kills it in order to prevent pager overflow.  Garrick and Ryan working on correcting problem (6/13/07) SS

DECLARE @SPID VARCHAR(20) 
select @SPID = BLOCKED from master.dbo.sysprocesses where db_name(dbid) = 'workflow' and program_name like '%SYMANTEC%' AND  BLOCKED > 0

--CREATE TABLE #sp_who2 (spid int, status varchar(100), login varchar(100), hostname varchar(100), blkby varchar(100), dbname varchar(100), command varchar(100), cputime int, diskio int, lastbatch varchar(30), programname varchar(100), spid2 int, RequestID int)
CREATE TABLE #sp_who2 (spid int, status varchar(1000), login SYSNAME NULL, hostname SYSNAME NULL, blkby SYSNAME NULL, dbname SYSNAME NULL, command varchar(1000), cputime int, diskio int, lastbatch varchar(1000), programname varchar(1000), spid2 int, RequestID int)
insert into #sp_who2 exec sp_who2   

--CREATE TABLE BLOCKKILL_LOG (spid int, status varchar(100), login varchar(100), hostname varchar(100), blkby varchar(100), dbname varchar(100), command varchar(100), cputime int, diskio int, lastbatch varchar(30), programname varchar(100), spid2 int, KillDate DATETIME)  

IF (SELECT COUNT(*) FROM BLOCK WHERE BLOCKED = @SPID) > 0
BEGIN 

INSERT INTO BLOCKKILL_LOG (spid , status , login , hostname , blkby , dbname , command , cputime , diskio , lastbatch , programname , spid2 , KillDate )
select spid , status , login , hostname , blkby , dbname , command , cputime , diskio , lastbatch , programname , spid2 , GETDATE() from #sp_who2 where spid = @spid


IF (SELECT COUNT(*) FROM master.dbo.SYSPROCESSES WHERE SPID = @SPID and blocked = 0 and exists (SELECT * FROM master.dbo.SYSPROCESSES  where blocked = @spid))>0
	SET @SPID = (SELECT 'KILL ' + @SPID)
	PRINT @SPID
 	EXEC (@SPID)
END
DROP TABLE #SP_WHO2


