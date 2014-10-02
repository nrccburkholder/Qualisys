USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_DeleteSurveyQuestionnaireSubType]    Script Date: 8/18/2014 8:32:25 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[QCL_DeleteSurveyQuestionnaireSubType]        
    @Survey_id                 INT,    
	@SubtypeCategory_id		   INT
AS

DELETE SurveySubtype
FROM SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
WHERE sst.Survey_id = @Survey_Id
and st.SubtypeCategory_id = @SubtypeCategory_id 


GO


