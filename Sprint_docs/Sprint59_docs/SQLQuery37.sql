USE [odsdb]
GO

DECLARE @holdid int
DECLARE @startdate datetime = '2016-10-10'
DECLARE @encounterdate datetime = '2016-10-10'
DECLARE @clientid int
DECLARE @clientname varchar(20)
DECLARE @studyid int 
DECLARE @studyname varchar(20)
DECLARE @surveyid int
DECLARE @surveyname varchar(20)


if not exists ( 
	SELECT hss.HoldID, ClientID, StudyID, SurveyID,StartDate,EncounterDate,HoldReason,hst.HoldDescription HoldStatus,TicketNumber,SurveyManagerID,AccountManagerID,DataManagerID,RequesterID,CompletionDate,DateCreated,DateModified 
	FROM odsdb.dbo.HoldSurveys hss 
	INNER JOIN odsdb.dbo.Holds hs on hss.HoldID = hs.HoldID 
	INNER JOIN odsdb.dbo.HoldStatus hst on hst.HoldStatusID = hs.HoldStatusID
	WHERE hss.clientid = @clientid and hss.studyid = @studyid and hss.surveyid = @surveyid
)
begin

	INSERT INTO [dbo].[Holds]
			   ([StartDate]
			   ,[EncounterDate]
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
			   ,'2016-10-10'
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



	GO

	SELECT hss.HoldID, ClientID, StudyID, SurveyID,StartDate,EncounterDate,HoldReason,hst.HoldDescription HoldStatus,TicketNumber,SurveyManagerID,AccountManagerID,DataManagerID,RequesterID,CompletionDate,DateCreated,DateModified 
	FROM odsdb.dbo.HoldSurveys hss 
	INNER JOIN odsdb.dbo.Holds hs on hss.HoldID = hs.HoldID 
	INNER JOIN odsdb.dbo.HoldStatus hst on hst.HoldStatusID = hs.HoldStatusID

end