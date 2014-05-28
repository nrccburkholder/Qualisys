CREATE PROCEDURE QP_Qry_SurveyPref @surveylist varchar(100), @begdate datetime, @enddate datetime
AS

DECLARE @study INT, @sql varchar(8000)
-- /************ USER PROVIDES VALUES FOR THESE VARIABLES *************************/
-- SET @surveylist = '1483,1485,1486,1492,1494,1493,1609'
-- SET @begdate = '3/1/05'
-- SET @enddate = '3/31/05'
-- /************ USER PROVIDES VALUES FOR THESE VARIABLES *************************/

CREATE TABLE #Study (Study_id INT)
SET @SQL = 'INSERT INTO #Study SELECT DISTINCT study_id FROM clientstudysurvey_view where survey_id in (' + @SurveyList + ')'
EXEC(@SQL)

WHILE (SELECT COUNT(*) FROM #STUDY) > 0
BEGIN
SELECT TOP 1 @STUDY = STUDY_ID FROM #STUDY	
	SET @sql = 'SELECT WPL.*, strdispositionlabel, sp.*, p.DOB, p.SEX, p.SSN ' + char(10)+
	'FROM WEBPREFLOG wpl, sentmailing sm, mailingmethodology mm, ' + char(10) + 
	'disposition d, scheduledmailing sc, samplepop sp, S' + convert(varchar,@study) + '.population p ' + char(10) +
	'where mm.survey_id in (' + @surveylist + ') ' + char(10) +
	'and mm.methodology_id=sm.methodology_id ' + char(10) +
	'and sm.strlithocode=wpl.strlithocode ' + char(10) +
	'and wpl.disposition_id=d.disposition_id ' + char(10) +
	'and sm.sentmail_id = sc.sentmail_id ' + char(10) +
	'and sc.samplepop_id = sp.samplepop_id and sp.study_id = ' + convert(varchar,@study) + char(10) +
	'and sp.pop_id = p.pop_id ' + char(10) + 
	'and datlogged between ''' + CONVERT(VARCHAR,@begdate) + ''' and ''' + CONVERT(VARCHAR,@enddate) + '''' 
	PRINT @sql
DELETE FROM #STUDY WHERE STUDY_ID = @STUDY
END

DROP TABLE #STUDY


