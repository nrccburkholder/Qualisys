CREATE PROCEDURE sp_dba_ETLVolumeCounts
AS
SELECT CONVERT(VARCHAR,DATEADD(dd,1,SM.DATMAILED),101) AS ETLDATE, /*DATMAILED */  COUNT(*) CNT 
INTO #EHS
FROM (SELECT SAMPLESET_ID FROM SAMPLESET SS (NOLOCK) WHERE DATSCHEDULED BETWEEN  GETDATE()-45 AND GETDATE() AND WEB_EXTRACT_FLG = 1) SS, 
SAMPLEPOP SP (NOLOCK), SCHEDULEDMAILING SC (NOLOCK), SENTMAILING SM  (NOLOCK)
WHERE SS.SAMPLESET_iD = SP.SAMPLESET_iD AND SP.SAMPLEPOP_ID = SC.SAMPLEPOP_ID AND SC.SCHEDULEDMAILING_ID= SM.SCHEDULEDMAILING_ID
AND DATMAILED IS NOT NULL AND DATMAILED BETWEEN  GETDATE() - 45 AND GETDATE()-1
GROUP BY CONVERT(VARCHAR,DATEADD(dd,1,SM.DATMAILED),101) 

SELECT CASE WHEN DATEPART(hh,datExtracted_DT)  IN (22,23) THEN CONVERT(VARCHAR,DATEADD(hh,2,datExtracted_DT),101) ELSE CONVERT(VARCHAR,datExtracted_dt,101) END AS  ETLDATE, COUNT(*) AS Cnt  
into #ehc
FROM comments_extract_history 
WHERE datextracted_dt > getdate()-45
GROUP BY CASE WHEN DATEPART(hh,datExtracted_DT)  IN (22,23) THEN CONVERT(VARCHAR,DATEADD(hh,2,datExtracted_DT),101) ELSE CONVERT(VARCHAR,datExtracted_dt,101) END 

SELECT CASE WHEN DATEPART(hh,datExtracted_DT)  IN (22,23) THEN CONVERT(VARCHAR,DATEADD(hh,2,datExtracted_DT),101) ELSE CONVERT(VARCHAR,datExtracted_dt,101) END AS  ETLDATE, COUNT(*) AS Cnt  
into #ehr
FROM questionform_extract_history 
WHERE datextracted_dt > getdate()-45
GROUP BY CASE WHEN DATEPART(hh,datExtracted_DT)  IN (22,23) THEN CONVERT(VARCHAR,DATEADD(hh,2,datExtracted_DT),101) ELSE CONVERT(VARCHAR,datExtracted_dt,101) END 

-- SELECT * FROM SCHEDULEDMAILING SC, FROM SAMPLEPOP WHERE SAMPLESET_ID IN (SELECT SAMPLESET_ID FROM SAMPLESET SS (NOLOCK) WHERE DATSCHEDULED BETWEEN  GETDATE()-45 AND GETDATE() AND WEB_EXTRACT_FLG = 1)
-- drop table #data
select distinct etldate, 0 scnt, 0 ccnt , 0 rcnt, 0 tcnt  into #data from #ehs s
union 
select distinct etldate, 0 scnt, 0 ccnt , 0 rcnt, 0 tcnt  from #ehc c
union 
select distinct etldate, 0 scnt, 0 ccnt , 0 rcnt, 0 tcnt  from #ehr r

-- select * from #data order by 1 desc
-- select top 100 * from #ehs order by 1 DESC
-- select top 100 * from #ehc order by 1 DESC
-- select top 100 * from #ehr ORDER BY 1 DESC

update d set scnt = cnt from #data d, #ehs s where d.etldate = s.etldate
update d set ccnt = cnt from #data d, #ehc c where d.etldate = c.etldate
update d set rcnt = cnt from #data d, #ehr r where d.etldate = r.etldate
update #data set tcnt = scnt+ccnt+rcnt

select * from #data

drop table #ehs
drop table #ehc
drop table #ehr
drop table #data


