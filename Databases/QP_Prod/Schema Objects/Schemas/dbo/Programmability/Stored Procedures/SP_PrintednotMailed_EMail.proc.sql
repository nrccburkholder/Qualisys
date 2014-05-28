CREATE PROCEDURE SP_PrintednotMailed_EMail    
AS    
    
SET NOCOUNT ON    
    
CREATE TABLE ##BD_Queue (    
 Employee   VARCHAR(100),     
 ClientName   VARCHAR(42),     
 StudyName   VARCHAR(42),     
 SurveyName   VARCHAR(42),     
 Survey_id   INT,     
 datPrinted   DATETIME,     
 datBundled   DATETIME,     
 MailingStep   VARCHAR(20),     
 numPrinted   INT,     
 SampleSet   INT,     
 SampleDate   DATETIME    
)     
    
INSERT INTO ##BD_Queue (ClientName, StudyName, SurveyName, Survey_id, datPrinted, datBundled, MailingStep, numPrinted, SampleSet)     
SELECT c.strClient_nm, s.strStudy_nm, sd.strSurvey_nm, sd.Survey_id, CONVERT(VARCHAR(10),datPrinted,120), datBundled,     
 strMailingStep_nm, COUNT(*), SampleSet_id     
FROM SentMailing sm(NOLOCK), Survey_def sd(NOLOCK), Samplepop sp(NOLOCK), scheduledMailing schm(NOLOCK), MailingStep ms(NOLOCK),     
 Study s(NOLOCK), Client c(NOLOCK)    
WHERE sm.datMailed IS NULL     
AND sm.datPrinted BETWEEN '1/1/99' AND DATEADD(DAY,-4,GETDATE())     
AND sm.SentMail_id=schm.SentMail_id     
AND schm.Samplepop_id=sp.Samplepop_id     
AND ms.MailingStep_id=schm.MailingStep_id     
AND ms.Survey_id=sd.Survey_id     
AND sd.Study_id=s.Study_id     
AND s.Client_id=c.Client_id     
GROUP BY c.strClient_nm, s.strStudy_nm, sd.strSurvey_nm, sd.Survey_id, CONVERT(VARCHAR(10),datPrinted,120), datBundled, strMailingStep_nm, SampleSet_id     
ORDER BY c.strClient_nm, s.strStudy_nm, sd.strSurvey_nm, sd.Survey_id, CONVERT(VARCHAR(10),datPrinted,120), datBundled, strMailingStep_nm, SampleSet_id     
    
UPDATE q     
SET Employee=strEmail     
FROM ##BD_Queue q, Survey_def sd, Study s, Employee e     
WHERE q.Survey_id=sd.Survey_id     
AND sd.Study_id=s.Study_id     
AND s.adEmployee_id=e.Employee_id     
AND e.bitactive = 1    -- Exclude inactive employees (AD) from the email list (1/3/05 SS)  
  
select * from ##bd_queue  
  
    
UPDATE q     
SET SampleDate=datSamplecreate_dt     
FROM ##BD_Queue q, SampleSet ss     
WHERE q.SampleSet=ss.SampleSet_id     
  
/****/    
declare @country nvarchar(255)
declare @environment nvarchar(255)
exec qp_prod.dbo.sp_getcountryenvironment @ocountry=@country output, @oenvironment=@environment output

DECLARE @strEmployee VARCHAR(300)    
--SET @strEmployee='QualisysDBAEmailAlerts@NationalResearch.com;'
SET @strEmployee='itsoftwareengineeringlincoln@nationalresearch.com;'

IF @environment = 'PRODUCTION'
BEGIN
	IF @country = 'CA'
		--SET @strEmployee=@strEmployee+'PHolung;' --pholung@nationalresearch.ca
		SET @strEmployee=@strEmployee+'PrintedNotMailedCA@nationalresearch.com;'	--TODO add new email group
	ELSE
		--SET @strEmployee=@strEmployee+'LBreckner;KAnstine;JVonfeldt;'  
		SET @strEmployee=@strEmployee+'PrintedNotMailedUS@nationalresearch.com;'	--TODO add new email group
	  
	SELECT @strEmployee = @strEmployee +  Employee + ';' FROM (SELECT DISTINCT Employee FROM ##BD_Queue WHERE Employee IS NOT NULL AND Employee <> '') ade  
END

SET @strEmployee=LEFT(@strEmployee,((LEN(@strEmployee))-1))     
/****/  
    -- Code Revised 1/3/05 SS  
     -- DECLARE @Employee VARCHAR(42), @strEmployee VARCHAR(300)    
     -- SET @strEmployee='Business Analysts;JSamuelson;LBreckner;KAnstine;BVaske;Project Managers;HResnik;'     
     -- DECLARE emp CURSOR FOR    
     -- SELECT DISTINCT Employee    
     -- FROM ##BD_Queue    
     --     
     -- OPEN emp     
     --     
     -- FETCH NEXT FROM emp INTO @Employee     
     -- WHILE @@FETCH_STATUS=0     
     --     
     -- BEGIN     
     --     
     -- SET @strEmployee=@strEmployee + @Employee + ';'     
     --     
     -- FETCH NEXT FROM emp INTO @Employee     
     -- END     
     --     
     -- CLOSE emp     
     -- DEALLOCATE emp     
     -- SET @strEmployee=LEFT(@strEmployee,((LEN(@strEmployee))-1))     
     -- print @stremployee    
  
declare @Sub varchar(300)
exec qp_prod.dbo.sp_getemailsubject 'Printed Not Mailed',@country, @environment, 'Qualisys', @osubject=@Sub output

--EXEC Master.dbo.XP_SendMail @Recipients=@strEmployee , @Subject='Printed Not Mailed' , @Message='Please take action to resolve any of your items on this list.' , @Query='SELECT * FROM ##BD_Queue'  ,     
--@Attach_Results='True' , @width=500 , @dbuse='QP_Prod'     
EXEC msdb.dbo.sp_send_dbmail @profile_name='QualisysEmail',  
@recipients=@strEmployee,  
@subject=@Sub,  
@body='Please take action to resolve any of your items on this list.',  
@body_format='HTML',  
@importance='High',  
@execute_query_database = 'qp_prod',  
@attach_query_result_as_file = 1,  
@Query='SELECT * FROM ##BD_Queue'  
  
  
     
DROP TABLE ##BD_Queue     
    
SET NOCOUNT OFF


