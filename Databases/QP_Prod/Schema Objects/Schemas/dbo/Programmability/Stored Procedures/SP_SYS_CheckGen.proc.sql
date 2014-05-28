CREATE PROCEDURE SP_SYS_CheckGen 
AS
/* Check PCLGen Machines to see IF they are still Running */
IF (SELECT numParam_Value FROM QualPro_Params WHERE strParam_nm = 'PCLGenPause') = 0
BEGIN  --IF not paused
DECLARE @date DATETIME
IF (SELECT COUNT(*) FROM PCLNeeded WHERE bitDone = 0) > 0
BEGIN  --IF work to do

   DECLARE @error BIT, @Machine_nm VARCHAR(16), @MachineList VARCHAR(100)
   DECLARE pcl_Machines CURSOR FOR
	   SELECT DISTINCT(Computer_nm) 
	   FROM PCLGenRun
	   WHERE DATEDIFF(HOUR,Start_dt,GETDATE()) < 2
	   AND Computer_nm LIKE 'NRCPCLGen%'
	   ORDER BY Computer_nm

   SET @error = 0

   OPEN pcl_Machines

   FETCH NEXT FROM pcl_Machines INTO @Machine_nm

   WHILE @@FETCH_STATUS = 0
   BEGIN
      IF DATEDIFF(MINUTE,(SELECT MAX(Start_dt) FROM PCLGenRun WHERE Computer_nm = @Machine_nm), GETDATE()) > 50
	BEGIN
         SET @error = 1
	 SET @MachineList = CASE WHEN @Machinelist IS NULL THEN RIGHT(@Machine_nm,2) ELSE @MachineList+', '+RIGHT(@Machine_nm,2) END
	END
      FETCH NEXT FROM pcl_Machines INTO @Machine_nm
   END

   CLOSE pcl_Machines
   DEALLOCATE pcl_Machines

declare @country nvarchar(255)
declare @environment nvarchar(255)
exec qp_prod.dbo.sp_getcountryenvironment @ocountry=@country output, @oenvironment=@environment output
declare @vsubject nvarchar(255)
exec qp_prod.dbo.sp_getemailsubject 'PCLGen stopped responding',@country, @environment, 'Qualisys', @osubject=@vsubject output

   IF (SELECT COUNT(*) FROM PCLGenRun WHERE DATEDIFF(HOUR,Start_dt,GETDATE()) < 2 AND Computer_nm LIKE 'NRCPCLGen%') = 0
      SET @error = 1
      
   IF @error = 1
   --   EXEC master.dbo.xp_sendmail 
   --      @recipients = '4024731136@atsbeep.com',
   --      @subject = 'PCLGen stopped responding',
		 --@message = @MachineList         
	EXEC msdb.dbo.sp_send_dbmail @profile_name='QualisysEmail',
	@recipients='dba@nationalresearch.com',
	@subject=@vsubject,
	@body=@MachineList,
	@body_format='text',
	@importance='High'         
         

END --IF work to do
END --IF not paused
/* SET PCLGen to reRun any Batches that errored out due to General SQL Error */
SELECT   l2.PCLGenRun_id, CONVERT(INT,SUBSTRING(L2.LogEntry,12,6)) Batch_id, 
         SUBSTRING(L2.LogEntry,20,3) cnt,
         COUNT(*) RunRowCnt
INTO     #Redo
FROM     PCLGenLog L1, PCLGenLog L2, PCLGenLog L3
WHERE    DATEDIFF(HOUR,L1.datLogged,GETDATE())<7
         AND L1.PCLGenRun_id=L2.PCLGenRun_id
         AND L2.PCLGenRun_id=L3.PCLGenRun_id
         AND L2.LogEntry LIKE 'Load Batch % mail items'
         AND L1.LogEntry LIKE 'Error! General SQL error.%'
GROUP BY l2.PCLGenRun_id,CONVERT(INT,SUBSTRING(L2.LogEntry,12,6)), SUBSTRING(L2.LogEntry,20,3) 
HAVING   COUNT(*) <= 10 
ORDER BY CONVERT(INT,SUBSTRING(L2.LogEntry,12,6))

UPDATE PCLNeeded 
SET    bitDone=0 
WHERE  bitDone=1
   AND Batch_id IN (SELECT   pn.Batch_id
                    FROM     PCLNeeded pn, (SELECT Batch_id, MIN(CONVERT(INT,cnt)) cnt, MAX(RunRowCnt) RunRowCnt FROM #Redo GROUP BY Batch_id) rd
                    WHERE    pn.Batch_id=rd.Batch_id
                    GROUP BY pn.Batch_id,rd.cnt
                    HAVING   rd.cnt=COUNT(*))

DROP TABLE #Redo


