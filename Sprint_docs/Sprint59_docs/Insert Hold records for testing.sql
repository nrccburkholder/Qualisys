USE [odsdb]
GO

/*
ClientID	StudyID		SurveyID
2521		4770		15910
2539		4882		16129
*/

DECLARE @holdid int

DECLARE @encounterdate datetime = '2016-10-10'

DECLARE @clientid int
DECLARE @clientname varchar(20)
DECLARE @studyid int
DECLARE @studyname varchar(20)   
DECLARE @surveyid int
DECLARE @surveyname varchar(20)

SET @clientid =2521
SET @clientname = '_JWilley2'
SET @studyid =4770
SET @studyname  = 'HCAHPS'   
SET @surveyid  = 15910
SET @surveyname  = 'HCAHPS'


SET @clientid  =2521
SET @clientname  = '_JWilley2'
SET @studyid  =4829
SET @studyname  = 'HHCAHPS16'   
SET @surveyid  = 16039
SET @surveyname  = 'HHCAHPS16'

SET @clientid  =2503
SET @clientname  = 'Vruenprom_Test'
SET @studyid  =4703
SET @studyname  = 'HHCAHPS'   
SET @surveyid  = 15822
SET @surveyname  = 'HHCAHPS2'

SET @clientid  =2503
SET @clientname  = 'Vruenprom_Test'
SET @studyid  =4703
SET @studyname  = 'HHCAHPS'   
SET @surveyid  = 15873
SET @surveyname  = 'HHCAHPS3'


if not exists ( 
	SELECT hss.HoldID, ClientID, StudyID, SurveyID,EncounterHoldDate,HoldReason,hst.HoldDescription HoldStatus,TicketNumber,SurveyManagerID,AccountManagerID,DataManagerID,RequesterID,CompletionDate,DateCreated,DateModified 
	FROM odsdb.dbo.HoldSurveys hss 
	INNER JOIN odsdb.dbo.Holds hs on hss.HoldID = hs.HoldID 
	INNER JOIN odsdb.dbo.HoldStatus hst on hst.HoldStatusID = hs.HoldStatusID
	WHERE hss.clientid = @clientid and hss.studyid = @studyid and hss.surveyid = @surveyid
)
begin

	INSERT INTO [dbo].[Holds]
			   ([EncounterHoldDate]
			   ,[HoldReason]
			   ,[HoldStatusId]
			   ,[TicketNumber]
			   ,[SurveyManagerId]
			   ,[SurveyManager]
			   ,[AccountManagerId]
			   ,[AccountManager]
			   ,[DataManagerId]
			   ,[DataManager]
			   ,[RequesterId]
			   ,[Requester]
			   ,[CompletionDate]
			   ,[DateCreated]
			   ,[DateModified])
		 VALUES
			   ('2016-10-10'
			   ,'Just testing'
			   ,1
			   ,1
			   ,1
			   ,'tbutler'
			   ,1
			   ,'tbutler'
			   ,1
			   ,'tbutler'
			   ,1
			   ,'tbutler'
			   ,NULL
			   ,GETDATE()
			   ,GETDATE())


		SET @holdid = Scope_identity()

	INSERT INTO [dbo].[HoldSurveys]
			   ([HoldId]
			   ,[ClientId]
			   ,[Client]
			   ,[StudyId]
			   ,[Study]
			   ,[SurveyId]
			   ,[Survey])
		 VALUES
			   (@holdid
			   ,@clientid
			   ,@clientname
			   ,@studyid
			   ,@studyname
			   ,@surveyid
			   ,@surveyname)



	SELECT hss.HoldID, ClientID, StudyID, SurveyID,EncounterHoldDate,HoldReason,hst.HoldDescription HoldStatus,TicketNumber,SurveyManagerID,AccountManagerID,DataManagerID,RequesterID,CompletionDate,DateCreated,DateModified 
	FROM odsdb.dbo.HoldSurveys hss 
	INNER JOIN odsdb.dbo.Holds hs on hss.HoldID = hs.HoldID 
	INNER JOIN odsdb.dbo.HoldStatus hst on hst.HoldStatusID = hs.HoldStatusID

end

SELECT * from dbo.Holds
