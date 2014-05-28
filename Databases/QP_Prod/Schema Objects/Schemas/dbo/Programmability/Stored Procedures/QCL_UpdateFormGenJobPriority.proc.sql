CREATE PROCEDURE QCL_UpdateFormGenJobPriority
@SurveyID INT,
@Priority INT
AS

UPDATE Survey_def SET Priority_flg=@Priority WHERE Survey_id=@SurveyID

IF @@ERROR<>0
	RAISERROR ('Error Updating the priority.', 18, 1)


