USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_UpdateSurveySubType]    Script Date: 8/19/2014 4:32:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[QCL_UpdateSurveySubType]    
    @Survey_id                 INT,    
    @SubType_id                INT,
	@SubtypeCategory_id		   INT
AS

DECLARE @SurveySubtype_id INT

SELECT @SurveySubtype_id = sst.SurveySubtype_id
FROM SurveySubtype sst
INNER JOIN Subtype st on st.Subtype_id = sst.Subtype_id
WHERE sst.Survey_id = @Survey_Id
and st.SubtypeCategory_id = @SubtypeCategory_id
    
IF @SurveySubtype_id is null
BEGIN

	EXEC QCL_InsertSurveySubType @Survey_id, @Subtype_id

END
ELSE
BEGIN

	UPDATE SurveySubtype    
		SET Subtype_id = @SubType_id
	WHERE SurveySubtype_id = @SurveySubtype_id

END
GO

