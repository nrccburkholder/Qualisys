/*
Business Purpose: 

This procedure schedules a sample set for survey generation.

Created:  1/31/2006 By Brian Dohmen

Modified:
07/10/2015 Tim Butler S29 US29.2  modify scheduling stored procedures to identify records with missing names, remove those from set of data to go into scheduled mailing and insert dispositions into dispo log

*/   
CREATE PROCEDURE [dbo].[QCL_Samp_ScheduleSampleSetGeneration]  
@SampleSetId INT,  
@GenerationDate DATETIME  
AS  
   
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
   
IF EXISTS (SELECT *   
           FROM SamplePop sp, ScheduledMailing schm   
           WHERE sp.SampleSet_id=@SampleSetID   
           AND sp.SamplePop_id=schm.SamplePop_id)  
BEGIN  
   
   RAISERROR ('This sample set has already been scheduled.', 18, 1)  
   RETURN  
   
END  
   
BEGIN TRANSACTION  

DECLARE @Study_id int
DECLARE @SurveyType_id int

SELECT @Study_id = sp.Study_id, @SurveyType_id = ss.SurveyType_Id
FROM SampleSet ss
inner join SamplePop sp on sp.SAMPLESET_ID = ss.SAMPLESET_ID
where ss.SAMPLESET_ID = @SampleSetId
group by sp.STUDY_ID, ss.SurveyType_Id


CREATE TABLE #IncompleteCaregiversDecedents(
	pop_id int,
	Disposition_id int
)

DECLARE @sql varchar(7000)

if @SurveyType_id in (Select surveytype_id from SurveyType s where s.SurveyType_dsc = 'Hospice CAHPS')
BEGIN

	DECLARE @incompleteCargiverDisposition_id int
	DECLARE @incompleteDecedentDisposition_id int
	DECLARE @missingCaregiverDisposition_id int

	select @incompleteCargiverDisposition_id = Disposition_id from Disposition where strDispositionLabel = 'Incomplete Caregiver'
	select @incompleteDecedentDisposition_id = Disposition_id from Disposition where strDispositionLabel = 'Incomplete Decedent'
	select @missingCaregiverDisposition_id = Disposition_id from Disposition where strDispositionLabel = 'Missing Caregiver'

	SET @Sql = 
	'INSERT INTO #IncompleteCaregiversDecedents ' + + CHAR(13) + 
	'select p.pop_id, ' + CAST(@missingCaregiverDisposition_id as varchar)  + CHAR(13) + 
	' from S' + CAST(@Study_Id as varchar) + '.POPULATION p
	WHERE p.FName is null AND p.LName is Null
	INSERT INTO #IncompleteCaregiversDecedents ' + + CHAR(13) + 
	'select p.pop_id, ' + CAST(@incompleteCargiverDisposition_id as varchar)  + CHAR(13) + 
	' from S' + CAST(@Study_Id as varchar) + '.POPULATION p
	WHERE (p.FName is null AND p.LName is NOT Null) OR (p.FName is not null AND p.LName is Null)
	INSERT INTO #IncompleteCaregiversDecedents ' + + CHAR(13) + 
	'select p.pop_id, ' + CAST(@incompleteDecedentDisposition_id as varchar)  + CHAR(13) + 
	'from S' + CAST(@Study_Id as varchar) + '.POPULATION p 
	WHERE p.HSP_DecdFName is null OR p.HSP_DecdLName is Null'

	EXEC (@sql)
END

-- These are the records that we will not send.  A dispositionlog record will be added for each
SELECT sp.SamplePop_id, icd.Disposition_id
INTO #SetDispositions
FROM SampleSet ss
inner join SamplePop sp on sp.SAMPLESET_ID = ss.SAMPLESET_ID
inner join  MailingMethodology mm  on mm.SURVEY_ID = ss.SURVEY_ID
inner join MailingStep ms on ms.METHODOLOGY_ID = mm.METHODOLOGY_ID
left join #IncompleteCaregiversDecedents icd on icd.pop_id = sp.POP_ID
where ss.SAMPLESET_ID = @SampleSetId
and mm.BITACTIVEMETHODOLOGY = 1
and ms.INTSEQUENCE = 1
and icd.pop_id is not null
order by sp.POP_ID

declare @samplepop_id int
declare @disposition_id int
select top 1 @samplepop_id = SAMPLEPOP_ID, @disposition_id = Disposition_id from #SetDispositions
while @@rowcount>0
begin

	insert into [dbo].[dispositionlog] (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy)
			select NULL, @samplepop_id, @disposition_id, 0, getdate(), 'QCL_Samp_ScheduleSampleSetGeneration'

	update [dbo].[dispositionlog]
		SET DaysFromCurrent = 0, DaysFromFirst = 0
	where SamplePop_id = @samplepop_id
	and LoggedBy = 'QCL_Samp_ScheduleSampleSetGeneration'

	delete from #SetDispositions where samplepop_id=@samplepop_id
	select top 1 @samplepop_id = SAMPLEPOP_ID, @disposition_id = Disposition_id from #SetDispositions
end
   
INSERT INTO ScheduledMailing (MailingStep_id,SamplePop_id,OverRideItem_id,SentMail_id,Methodology_id,datGenerate)  
SELECT ms.MailingStep_id,sp.SamplePop_id,NULL,NULL,ms.Methodology_id,@GenerationDate  
FROM SampleSet ss
inner join SamplePop sp on sp.SAMPLESET_ID = ss.SAMPLESET_ID
inner join  MailingMethodology mm  on mm.SURVEY_ID = ss.SURVEY_ID
inner join MailingStep ms on ms.METHODOLOGY_ID = mm.METHODOLOGY_ID
left join #IncompleteCaregiversDecedents icd on icd.pop_id = sp.POP_ID
where ss.SAMPLESET_ID =@SampleSetId
and mm.BITACTIVEMETHODOLOGY = 1
and ms.INTSEQUENCE = 1
and icd.pop_id is null
order by sp.POP_ID

DROP TABLE #IncompleteCaregiversDecedents
DROP TABLE #SetDispositions
   
IF @@ERROR<>0  
BEGIN  
   ROLLBACK TRANSACTION  
   RAISERROR ('A database error occurred while scheduling the sample set.  The sample set has not been scheduled.', 18, 1)  
   RETURN  
END  
   
UPDATE SampleSet   
SET datScheduled=@GenerationDate  
WHERE SampleSet_id=@SampleSetID  
   
IF @@ERROR<>0  
BEGIN  
   ROLLBACK TRANSACTION  
   RAISERROR ('A database error occurred while scheduling the sample set.  The sample set has not been scheduled.', 18, 1)  
   RETURN  
END  
   
COMMIT TRANSACTION  
   
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF
