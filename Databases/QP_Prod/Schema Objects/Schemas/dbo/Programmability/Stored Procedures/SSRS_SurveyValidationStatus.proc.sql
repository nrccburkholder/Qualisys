-- =============================================
-- Author:		Dana Petersen
-- Create date: 06/22/2011
-- Description:	Proc for Survey Validation Status SSRS Report
-- =============================================
CREATE PROCEDURE SSRS_SurveyValidationStatus
	@SurveyType int,
	@ValidFlag int
AS
BEGIN
	SET NOCOUNT ON;

	--variables for dynamic SQL statement
	declare @strSQL1 varchar(100)
	declare @strSQL2 varchar(100)
	declare @strSQLAll varchar(4000)
	
	-- 999 = all survey types
	if @SurveyType = 999 select @strSQL1 = ''
	else select @strSQL1 = ' and sd.surveytype_id = ' + ltrim(STR(@SurveyType))

	-- 999 = both validated and unvalidated
	if @ValidFlag = 999 select @strSQL2 = ''
	else select @strSQL2 = ' and sd.BITVALIDATED_FLG = ' + LTRIM(str(@ValidFlag))

	-- Get info for all active clients, studies, and surveys
	-- Exclude client_ids for test clients, e.g. Faux Hospital
	select @strSQLAll = 
	'select c.STRCLIENT_NM, s.CLIENT_ID, s.STRSTUDY_NM, s.STUDY_ID, sd.STRSURVEY_NM, sd.SURVEY_ID, 	sd.BITVALIDATED_FLG
	from CLIENT c, STUDY s, SURVEY_DEF sd
	where c.CLIENT_ID = s.CLIENT_ID
	and s.STUDY_ID = sd.STUDY_ID
	and c.Active = 1
	and s.Active = 1
	and sd.Active = 1
	and c.CLIENT_ID not in (1364, 1445,1285,1233)' +
	@strSQL1 +
	@strSQL2 +
	' order by c.STRCLIENT_NM, s.STRSTUDY_NM, sd.STRSURVEY_NM'

	exec (@strSQLAll)

END


