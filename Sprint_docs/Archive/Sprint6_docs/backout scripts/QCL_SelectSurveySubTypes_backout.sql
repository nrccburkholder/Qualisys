USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectSurveySubTypes]    Script Date: 9/17/2014 4:24:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[QCL_SelectSurveySubTypes] 
@surveytypeid int 
AS
SELECT SurveySubType_id, SurveyType_ID, SubType_NM , QuestionnaireType_ID
FROM SurveySubTypes
WHERE SurveyType_ID = @surveytypeid

