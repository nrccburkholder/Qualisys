USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectAllSurveyTypes]    Script Date: 7/25/2014 9:02:28 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[QCL_SelectAllSurveyTypes]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT SurveyType_ID, SurveyType_dsc, CAHPSType_id, SeedMailings, SeedSurveyPercent, SeedUnitField, CAHPSType_id as OptionType_id
FROM [dbo].SurveyType

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


GO


