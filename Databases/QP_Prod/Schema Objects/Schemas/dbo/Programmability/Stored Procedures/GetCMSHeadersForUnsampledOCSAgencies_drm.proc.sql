CREATE PROCEDURE [dbo].[GetCMSHeadersForUnsampledOCSAgencies_drm] @sampleMonth as INT, @sampleYear as INT  
AS  
BEGIN  
  
 SET NOCOUNT ON  
  
 IF @sampleMonth < 1 OR @sampleMonth > 12   
 BEGIN  
  RAISERROR('invalid sampleMonth provided',18,255)  
  RETURN  
 END  
 IF @sampleYear < 2010 OR @sampleYear > 2050   
 BEGIN   
  RAISERROR('invalid sampleYear provided',18,255)  
  RETURN  
 END  
  
 DEClARE @sampleDate as DateTime  
 SET @sampleDate = CAST( CAST(@sampleYear as varchar(4)) + '-' + CAST(@sampleMonth as varchar(2)) + '-1' AS DATETIME)  
  
 -- Get the mail methodologies and number of methodologies.  If number is > 1 then the methodology has changed at some point  
 SELECT a.*, b.cnt   
 into #mailmeth   
 FROM   
  MAILINGMETHODOLOGY AS a WITH(NOLOCK)  
 INNER JOIN (SELECT Survey_Id,count(*) cnt FROM MAILINGMETHODOLOGY WITH(NOLOCK) GROUP BY Survey_Id) AS b on a.survey_id=b.survey_id  
 where a.BITACTIVEMETHODOLOGY=1  
  
 -- get list of clients that did not sample,   
 -- store in temp table and then we will back fill the patients-hha  
 SELECT   
  sd.STUDY_ID,  
  sd.SURVEY_ID,  
  1 as [header-type],  
  strFacility_nm as [provider-name],  
  suf.MedicareNumber as [provider-id],  
  DATEPART(mm,sst.datDateRange_FromDate) as [sample-month],  
  DATEPART(yyyy,sst.datDateRange_FromDate) as [sample-yr],  
  mailmeth.StandardMethodologyID as [survey-mode],  
  mailmeth.cnt as [MailMethCount],  
  2 as [sample-type],  
  -1 as  [patients-hha],  
  ISNULL(pif.NumPatInFile,0) as [number-vendor-submitted],  
  0 as [number-eligible-patients],  
  0 as [number-sampled]  
 INTO #aatemp1   
 FROM   
  QP_Prod.dbo.SURVEY_DEF sd WITH(NOLOCK) inner join QP_Prod.dbo.SAMPLEPLAN spl WITH(NOLOCK)
   on sd.SURVEY_ID = spl.SURVEY_ID 
  inner join QP_Prod.dbo.SAMPLEUNIT su WITH(NOLOCK)
   on spl.SAMPLEPLAN_ID = su.SAMPLEPLAN_ID 
  inner join QP_Prod.dbo.SAMPLESET sst WITH(NOLOCK)
   on sd.SURVEY_ID = sst.SURVEY_ID 
  inner join QP_Prod.dbo.SUFacility suf WITH(NOLOCK)
   on su.SUFacility_id = suf.SUFacility_id  
  inner join #mailmeth mailmeth WITH(NOLOCK)
   on sd.SURVEY_ID=mailmeth.SURVEY_ID
  left join QP_PROD.dbo.CAHPS_PatInfileCount pif WITH(NOLOCK)
   on pif.Sampleset_id=sst.sampleset_id 
   and pif.sampleunit_id=su.sampleunit_id 
   and pif.MedicareNumber=suf.MedicareNumber
 WHERE su.bitHHCAHPS = 1
  and sst.datDateRange_FromDate = @sampleDate  
  and sd.Active = 1  
  and sst.datScheduled is null  
  
 -- back fill the patients-hha value by looking in the ENCOUNTER table for the study  
 DECLARE MY_CURSOR Cursor FOR Select STUDY_ID From #aatemp1  
 OPEN MY_CURSOR   
  
 DECLARE @sql varchar(2048)  
 DECLARE @STUDY_ID INT  

 Fetch NEXT FROM MY_Cursor INTO @STUDY_ID  
 While (@@FETCH_STATUS <> -1)  
 BEGIN  
  
  SET @sql = 'UPDATE a   
    SET a.[patients-hha]=ISNULL(b.[patients-hha],0)--,   
     --a.[number-vendor-submitted]=b.[number-vendor-submitted]  
   FROM #aatemp1 as a    
   ,( SELECT  
     MAX(HHPatServed) as [patients-hha],  
     Count(*) as [number-vendor-submitted]   
    FROM   
     S' + cast(@STUDY_ID as varchar(32)) + '.ENCOUNTER WITH(NOLOCK)   
    where   
     HHSampleMonth='+CAST(@sampleMonth AS VARCHAR(2))+' and HHSampleYear='+CAST(@sampleYear as varchar(4)) +') as b  
   WHERE a.Study_id=' + cast(@STUDY_ID as varchar(32))  
  
  --print @sql   
  EXEC(@sql)  
  
 FETCH NEXT FROM MY_CURSOR INTO @STUDY_ID  
 END  
 CLOSE MY_CURSOR  
 DEALLOCATE MY_CURSOR  
  
 -- RECODE,  I'm assuming an NRC 13 -> CMS 1, NRC 14 -> CMS 2 and NRC 15 -> CMS 3  
 UPDATE a set a.[survey-mode]=1 FROM #aatemp1 as a WHERE a.[survey-mode]=13  
 UPDATE a set a.[survey-mode]=2 FROM #aatemp1 as a WHERE a.[survey-mode]=14  
 UPDATE a set a.[survey-mode]=3 FROM #aatemp1 as a WHERE a.[survey-mode]=15  
  
 -- if you want the data in table form  
 SELECT   
  [header-type],  
  [provider-name],  
  [provider-id],  
  [sample-month],  
  [sample-yr],  
  CASE [MailMethCount] WHEN 1 THEN [survey-mode] ELSE -999 END as [survey-mode],  
  [sample-type],  
  [patients-hha],  
  [number-vendor-submitted],  
  [number-eligible-patients],   
  [number-sampled]   
 FROM #aatemp1  
  
 -- return the data in XML form  
SELECT  Tag, Parent,      
  [Providers!1!],      
  [header!2!header-type!Element],      
  [header!2!provider-name!Element],      
  [header!2!provider-id!Element],      
  [header!2!sample-month!Element],      
  [header!2!sample-yr!Element],      
  [header!2!survey-mode!Element],     
  [header!2!sample-type!Element],     
  [header!2!patients-hha!Element],     
  [header!2!number-vendor-submitted!Element],         
  [header!2!number-eligible-patients!Element],          
  [header!2!number-sampled!Element]   
from (   
 SELECT      
  1 AS Tag,      
  NULL AS Parent,      
  NULL AS 'Providers!1!',      
  NULL AS 'header!2!header-type!Element',      
  NULL AS 'header!2!provider-name!Element',      
  NULL AS 'header!2!provider-id!Element',      
  NULL AS 'header!2!sample-month!Element',      
  NULL AS 'header!2!sample-yr!Element',      
  NULL AS 'header!2!survey-mode!Element',     
  NULL AS 'header!2!sample-type!Element',     
  NULL AS 'header!2!patients-hha!Element',     
  NULL AS 'header!2!number-vendor-submitted!Element',         
  NULL AS 'header!2!number-eligible-patients!Element',          
  NULL AS 'header!2!number-sampled!Element'   
 UNION ALL  
 SELECT      
  2 AS Tag,      
  1 AS Parent,    
  NULL AS header,      
  [header-type],  
  [provider-name],  
  [provider-id],  
  [sample-month],  
  [sample-yr],  
  CASE [MailMethCount] WHEN 1 THEN [survey-mode] ELSE -999 END,  
  [sample-type],  
  [patients-hha],  
  [number-vendor-submitted],  
  [number-eligible-patients],   
  [number-sampled]   
 FROM #aatemp1  
 ) A  
 FOR XML EXPLICIT  
  
 DROP TABLE #mailmeth  
 DROP TABLE #aatemp1   
  
 SET NOCOUNT OFF  
END
