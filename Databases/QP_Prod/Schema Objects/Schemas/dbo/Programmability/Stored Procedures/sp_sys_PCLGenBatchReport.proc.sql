Create proc sp_sys_PCLGenBatchReport as


DECLARE @starttime DATETIME      
DECLARE @endtime DATETIME      
DECLARE @formgened INT, @PCLGened INT      
select @starttime = (CONVERT(VARCHAR(10),GETDATE()-1,120)) + ' 6:00'      
select @endtime = (CONVERT(VARCHAR(10),GETDATE(),120)) + ' 6:00'     

SELECT Computer_nm, COUNT(*) AS Total_Batches      
 FROM PCLGenRun(NOLOCK)      
 WHERE Start_dt BETWEEN @starttime AND @endtime      
 GROUP BY Computer_nm    
 ORDER BY Computer_nm


