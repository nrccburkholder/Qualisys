/*********************************************************************************************
	qp_Rep_ActionPlanPostingInfo

	This SP will return web Posting information for any action plan that contains one or more
	units within the selected client/study/survey.

	-- Modified 3/17/05 - SS - Added survey_id to parameters being passed

*********************************************************************************************/

CREATE    PROCEDURE [dbo].[qp_Rep_ActionPlanPostingInfo]
	 @associate VARCHAR(50),
	 @Client VARCHAR(50),
	 @Study VARCHAR(50),
	 @Survey VARCHAR(50)
 AS

 -- Get the survey_id from the strsurvey_nm (Needed because strsurvey_nm on datamart may be strclientfacing_nm and strsurvey_nm <> strclientfacing_nm)
 DECLARE @survey_Id INT
 SELECT @survey_id = survey_id FROM survey_def WHERE strsurvey_nm = @survey

 EXECUTE datamart.qp_comments.dbo.qp_Rep_ActionPlanPostingInfo @associate, @client, @study, @survey, @survey_id


