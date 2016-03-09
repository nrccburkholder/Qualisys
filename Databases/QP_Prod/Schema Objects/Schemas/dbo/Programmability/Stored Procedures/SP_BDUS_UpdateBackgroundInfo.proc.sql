CREATE PROCEDURE [dbo].[SP_BDUS_UpdateBackgroundInfo]
    @intStudyID         INT,      
    @intPopID           INT,      
    @intSamplePopID     INT,      
    @intQuestionFormID  INT,      
    @strSetClause       VARCHAR(7800),      
    @strFieldList       VARCHAR(5000),      
    @intProgram  int      
      
AS      
/*
	S42 US13 OAS: Language in which Survey Completed - added code to update SentMailing.LangID for Phone step processed through QSI TransferResults 02/08/2016 TSB
*/      
SET NOCOUNT ON      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
      
--Declare required variables      
DECLARE @strSql VARCHAR(8000)      
      
--Update the Population table for this study      
SET @strSql='UPDATE S'+CONVERT(VARCHAR,@intStudyID)+'.Population '+CHAR(10)+      
            'SET '+@strSetClause+' '+CHAR(10)+      
            'WHERE Pop_id='+CONVERT(VARCHAR,@intPopID)      
EXEC (@strSql)    

-- S42 US13
if SUBSTRING(@strSetClause,1, 6) = 'LangID'
BEGIN

	SET @strSQL = '
		if not exists (
			select 1
			from dbo.SENTMAILING sm
			inner join dbo.questionform qf on (sm.SENTMAIL_ID = qf.SENTMAIL_ID)
			inner join ScheduledMailing scm on sm.ScheduledMailing_id=scm.ScheduledMailing_id
			inner join MailingStep ms on scm.Methodology_id=ms.Methodology_id and scm.MailingStep_id=ms.MailingStep_id
			inner join MailingStepMethod msm on msm.MailingStepMethod_id= ms.MailingStepMethod_id
			where qf.SAMPLEPOP_ID = ' + CONVERT(VARCHAR,@intSamplePopID) +' '+ CHAR(10) + 
			'and msm.MailingStepMethod_nm = ''Phone''
			and sm.'+ @strSetClause + ')'+ CHAR(10) +  
			'begin ' + CHAR(10) +  
				'update sm '+ CHAR(10) +  
				'SET ' + @strSetClause + ' '+ CHAR(10) + 
				'from dbo.SENTMAILING sm
				inner join dbo.questionform qf on (sm.SENTMAIL_ID = qf.SENTMAIL_ID)
				inner join ScheduledMailing scm on sm.ScheduledMailing_id=scm.ScheduledMailing_id
				inner join MailingStep ms on scm.Methodology_id=ms.Methodology_id and scm.MailingStep_id=ms.MailingStep_id
				inner join MailingStepMethod msm on msm.MailingStepMethod_id= ms.MailingStepMethod_id
				where qf.SAMPLEPOP_ID = ' + CONVERT(VARCHAR,@intSamplePopID) +' '+ CHAR(10) + 
				'and msm.MailingStepMethod_nm = ''Phone''' + CHAR(10) +  
			'end '

	EXEC (@strSql)  
	 
END
  
      
--Add the entries into the HandEntry_Log table      
SELECT @strSql='INSERT INTO HandEntry_Log (QuestionForm_id,Field_id,datEntered,intProgram)      
SELECT '+LTRIM(STR(@intQuestionFormID))+',Field_id,GETDATE(),'+LTRIM(STR(@intProgram))+'      
FROM MetaField      
WHERE strField_nm IN ('''+REPLACE(@strFieldList,',',''',''')+''')'      
EXEC (@strSql)      
      
--Update the datamart for this study      
--We will now only queue up the changes on 10 instead of on 47.      
INSERT INTO UpdateBackGroundInfo_Log (Study_id,Pop_id,SamplePop_id,strSetClause,datScheduled)      
SELECT @intStudyID,@intPopID,@intSamplePopID,@strSetClause,GETDATE()      

INSERT INTO UpdateBackGroundInfo_History (Study_id,Pop_id,SamplePop_id,strSetClause,datScheduled)      
SELECT @intStudyID,@intPopID,@intSamplePopID,@strSetClause,GETDATE()      
      
--EXEC NRC47.QP_Comments.dbo.SP_BDUS_UpdateBackgroundInfo @intStudyID, @intPopID, @intSamplePopID, @strSetClause      
    
--insert into Catalyst extract queue so new address will be updated    
insert NRC_DataMart_ETL.dbo.ExtractQueue (EntityTypeID, PKey1, PKey2, IsMetaData,IsDeleted, source)      
select 7, @intSamplePopID, NULL, 0,0, 'SP_BDUS_UpdateBackgroundInfo'    
        
--Cleanup      
SET NOCOUNT OFF      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
