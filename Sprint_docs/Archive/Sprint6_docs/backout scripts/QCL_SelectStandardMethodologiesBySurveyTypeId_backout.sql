USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectStandardMethodologiesBySurveyTypeId]    Script Date: 9/17/2014 4:28:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[QCL_SelectStandardMethodologiesBySurveyTypeId]
 @SurveyTypeID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT sm.StandardMethodologyId, sm.strStandardMethodology_nm, sm.bitCustom
FROM StandardMethodology sm, StandardMethodologyBySurveyType smst
WHERE smst.SurveyType_id=@SurveyTypeID
AND smst.StandardMethodologyID=sm.StandardMethodologyID
ORDER BY sm.strStandardMethodology_nm

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
