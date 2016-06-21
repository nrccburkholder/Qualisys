USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectSurveySubTypes]    Script Date: 8/18/2014 8:33:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[QCL_SelectSurveySubTypes]      
    @SurveyId INT,
	@SubtypeCategory_id INT     
AS      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
SET NOCOUNT ON        
      

SELECT sst.SurveySubtype_id, sst.Subtype_id, sst.Survey_id, st.Subtype_nm, st.SubtypeCategory_id, st.bitRuleOverride
FROM SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
WHERE sst.Survey_id = @SurveyId
and st.SubtypeCategory_id = @SubtypeCategory_id 

          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
SET NOCOUNT OFF

GO


