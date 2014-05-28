/**************************************************************************************************
	NAME: QP_REP_QuestionsByUnits
	DESCRIPTION: This stored procedure lists all units that potentially could get one or more of 
				 the questions specified in the questionlist parameter.  Only units that have been
				 sampled within the specified date range are shown.

	INPUT Parameters:
		@questionslist
			A comma separated list of questions
		@mindate
			The minimum sample creation date
		@maxdate
			The maximum sample creation date 

	Output Parameters:
		None
		
	History
		6/2/2004 DC Created
**************************************************************************************************/
CREATE PROCEDURE QP_REP_QuestionsByUnits2 
	@questionlist VARCHAR(5000), 
	@mindate VARCHAR(25) = '01Jan1900', 
	@maxdate VARCHAR(25) = '31Dec2099'
AS
DECLARE @counter INT, @sampleunit_id INT, @SQL VARCHAR(5000)
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--find all units that these questions are mapped to
SET @sql='SELECT DISTINCT s.sampleunit_id
		FROM sel_qstns q, sampleunit s, sampleunitsection sus
		WHERE qstncore in (' + @questionlist + ')
		AND sus.sampleunit_id=s.sampleunit_id 
		AND sus.selqstnssection=q.section_id 
		AND sus.selqstnssurvey_id=q.survey_id
		AND q.subtype=1 
		AND q.language=1'
EXEC (@sql)


