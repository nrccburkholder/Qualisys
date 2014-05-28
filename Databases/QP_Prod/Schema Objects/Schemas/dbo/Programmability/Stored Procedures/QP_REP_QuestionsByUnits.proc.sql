/**************************************************************************************************
	NAME: QP_REP_QuestionsByUnits
	DESCRIPTION: This stored procedure lists all units that potentially could get one or more of 
				 the questions specified in the QuestionList parameter.  Only units that have been
				 sampled within the specified Date range are shown.

	INPUT Parameters:
		@questionslist
			A comma separated list of questions
		@minDate
			The minimum sample creation Date
		@maxDate
			The maximum sample creation Date 

	Output Parameters:
		None
		
	History
		6/2/2004 DC Created
**************************************************************************************************/
CREATE PROCEDURE QP_REP_QuestionsByUnits
	@QuestionList VARCHAR(5000)
AS
DECLARE @SQL VARCHAR(5000)
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--find all units that these questions are mapped to
SET @sql='SELECT DISTINCT s.SampleUnit_id
		FROM Sel_Qstns q, SampleUnit s, SampleUnitSection sus
		WHERE QstnCore in (' + @QuestionList + ')
		AND sus.SampleUnit_id=s.SampleUnit_id 
		AND sus.SelQstnsSection=q.Section_id 
		AND sus.SelQstnsSurvey_id=q.Survey_id
		AND q.SubType=1 
		AND q.Language=1'
EXEC (@sql)


