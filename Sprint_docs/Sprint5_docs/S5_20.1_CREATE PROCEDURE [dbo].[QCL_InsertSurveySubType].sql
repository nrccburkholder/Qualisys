USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_InsertSurveySubType]    Script Date: 8/18/2014 8:31:44 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[QCL_InsertSurveySubType]        
    @Survey_id                  INT,        
    @Subtype_id                 INT
AS

INSERT INTO SurveySubtype (Survey_id, [Subtype_id]) 
VALUES (@Survey_id, @Subtype_id)


GO


