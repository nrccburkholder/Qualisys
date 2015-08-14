/*
	S27.US27	QSI
		As a Client Support Manager working with phone vendor data, I want QSI to import results when a breakoff disposition is not the final disposition 
		from the phone vendor, so that I do not have to manually manipulate the vendor files and reimport data prior to CMS submissions.

	T27.3	Scenario 2: Breakoff disposition with all missing responses
		•	An interviewer begins the survey, but the respondent answers “I don’t know” or something similar to all of the questions. These are marked with 
			the appropriate value for “missing”. After several questions, the interviewer gives up and ends the call with a breakoff disposition.
		•	The data from the vendor is brought into the DL_ tables. Since the responses are all “M”, they are recoded to -9 and brought into Qualisys 
			QuestionResult. The breakoff disposition is logged in disposition log.

		For the desired future functionality, I believe we discussed changing this to a “no response” disposition. 
		
		I noticed there is a “blank phone survey” disposition available (disposition_id = 27), but most CAHPS don’t have a disposition mapping to this.
		
		We could assign that dispo and add records in SurveyTypeDispositions to map that disposition_id to the appropriate CAHPS disposition for “no response”.

Dave Gilsdorf

NRC_DataMart_ETL:
ALTER PROCEDURE [dbo].[csp_CAHPSProcesses] 

QP_Prod:
CREATE PROCEDURE [dbo].[sp_FG_CAHPSPreProcessing]
CREATE PROCEDURE [dbo].[CheckForBlankBreakoffs]
insert into Disposition (Disposition_id,action_id,strReportLabel,MustHaveResults)
update/insert into SurveyTypeDispositions 

***************************************************************
**************** ALSO UPDATE THE FORMGEN JOB!!! ***************
***************************************************************
Manually change the CheckForCAHPSIncompletes step:
1. change the name from CheckForCAHPSIncompletes to CAHPS Pre-processing
2. change the command from [exec dbo.CheckForCAHPSIncompletes] to [exec dbo.sp_FG_CAHPSPreProcessing]

*/
go
use NRC_DataMart_ETL
go
ALTER PROCEDURE [dbo].[csp_CAHPSProcesses] 
AS
-- this code was previously in NRC_Datamart_ETL.dbo.csp_CAHPSProcesses. We're putting it in its own proc so that 
-- it can be called at the beginning of the ETL, instead of in the middle.

	DECLARE @country VARCHAR(10)
	SELECT @country = [STRPARAM_VALUE] FROM [QP_Prod].[dbo].[qualpro_params] WHERE STRPARAM_NM = 'Country'
	select @country
	IF @country = 'US'
	BEGIN
		EXEC [QP_Prod].[dbo].[CheckForBlankBreakoffs]
		EXEC [QP_Prod].[dbo].[CheckForCAHPSIncompletes] 
		EXEC [QP_Prod].[dbo].[CheckForACOCAHPSUsablePartials]
		EXEC [QP_Prod].[dbo].[CheckForMostCompleteUsablePartials] -- HHCAHPS and ICHCAHPS
		EXEC [QP_Prod].[dbo].[CheckHospiceCAHPSDispositions]
	END
	ELSE
	IF @country = 'CA'
	BEGIN
		EXEC [QP_Prod].[dbo].[CIHICompleteness]
	END
go
use QP_Prod
go
if EXISTS (select * from sys.procedures where schema_id=1 and name = 'sp_FG_CAHPSPreProcessing')
	DROP PROCEDURE [dbo].[sp_FG_CAHPSPreProcessing]
go
CREATE PROCEDURE [dbo].[sp_FG_CAHPSPreProcessing]
AS
	exec [dbo].[CheckForBlankBreakoffs]
	exec [dbo].[CheckForCAHPSIncompletes]
go
if EXISTS (select * from sys.procedures where schema_id=1 and name = 'CheckForBlankBreakoffs')
	DROP PROCEDURE [dbo].[CheckForBlankBreakoffs]
go
CREATE PROCEDURE [dbo].[CheckForBlankBreakoffs]
AS
-- if we're processing a Breakoff disposition (disposition_id=11) and there are no answered questions, log a Blank Phone Survey disposition too (disposition_id=49)
DECLARE @MinDate DATE;
SET @MinDate = DATEADD(DAY, -4, GETDATE());

declare @Breakoffs table (Samplepop_id int, Disposition_id int, questionform_id int, sentmail_id int, numAnswers int)

insert into @breakoffs
SELECT DISTINCT PKey1 as Samplepop_id, Pkey2 as Disposition_id, qf.questionform_id, qf.sentmail_id, 0 as numAnswers
FROM NRC_DataMart_ETL.dbo.ExtractQueue eq
inner join Questionform qf on eq.pkey1=qf.samplepop_id
WHERE eq.ExtractFileID IS NULL 
AND eq.EntityTypeID = 14 
AND eq.Pkey2=11 
and eq.Created > @MinDate
and qf.datReturned is not null

update bo set numAnswers=sub.numAnswers
from @breakoffs bo
inner join (select qr.questionform_id, count(*) as numAnswers
			from @breakoffs bo
			inner join questionresult qr on bo.questionform_id=qr.questionform_id
			where qr.intresponseval>=0
			group by qr.questionform_id) sub
		on bo.questionform_id=sub.questionform_id

insert into DispositionLog (SentMail_id,SamplePop_id,Disposition_id,ReceiptType_id,datLogged,LoggedBy,DaysFromCurrent,DaysFromFirst,bitExtracted)
select bo.sentmail_id, bo.samplepop_id, 49 as disposition_id, 12 as receipttype_id, getdate() as datlogged, 'CheckForBlankBreakoffs' as Loggedby, 0,0,0
from @breakoffs bo
where bo.numAnswers=0

go
set identity_insert Disposition on
insert into Disposition (Disposition_id,strDispositionLabel,action_id,strReportLabel,MustHaveResults)
values (49, 'Breakoff is actually blank', 0, 'Breakoff is actually blank', 0)
set identity_insert Disposition off
go
select * 
into #breakoff
from SurveyTypeDispositions
where disposition_id in (22,11)

update std set hierarchy=std.hierarchy+1
--select std.* 
from #breakoff bo
inner join SurveyTypeDispositions std on bo.SurveyType_ID=std.SurveyType_ID and std.Hierarchy>=bo.hierarchy

/* NOTE: the new disposition will get inserted into the Hulk/Gator/Medusa Disposition table and SurveyTypeDispositions table via the thrice-daily.
         the only thing we need to do in qp_comments is increment the hierarchy values.
*/
update std set hierarchy=std.hierarchy+1
--select std.* 
from #breakoff bo
inner join datamart.qp_comments.dbo.SurveyTypeDispositions std on bo.SurveyType_ID=std.SurveyType_ID and std.Hierarchy>=bo.hierarchy

insert into SurveyTypeDispositions (Disposition_ID,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
select distinct 49, std.Value, bo.Hierarchy, 'Breakoff is actually blank', 0, null, bo.SurveyType_ID 
from #breakoff bo
inner join SurveyTypeDispositions  std on bo.surveytype_id=std.SurveyType_ID
where std.[desc] like '%max%' 
order by Surveytype_id
go

