USE [QP_Prod]
GO

/****** Object:  View [dbo].[SurveyValidationProcs_view]    Script Date: 8/15/2014 10:14:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[SurveyValidationProcs_view]      
AS      
	SELECT svp.SurveyValidationProcs_id, svp.ProcedureName, svp.intOrder, svpst.CAHPSType_ID, svpst.SubType_ID
	FROM SurveyValidationProcs svp
	LEFT JOIN SurveyValidationProcsBySurveyType svpst on (svpst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id)
	WHERE svpst.CAHPSType_Id is null
	UNION
	select svp.SurveyValidationProcs_id, svp.ProcedureName, svp.intOrder, svpst.CAHPSType_ID, svpst.SubType_ID
	from SurveyValidationProcsBySurveyType svpst
	INNER JOIN SurveyValidationProcs svp ON (svp.SurveyValidationProcs_id = svpst.SurveyValidationProcs_id)



GO


