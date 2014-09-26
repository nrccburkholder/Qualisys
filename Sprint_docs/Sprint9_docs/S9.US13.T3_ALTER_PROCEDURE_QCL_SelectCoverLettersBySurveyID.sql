USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectCoverLettersBySurveyID]    Script Date: 9/25/2014 8:28:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[QCL_SelectCoverLettersBySurveyID]
@SurveyID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT SelCover_id, [Description], Survey_id
FROM Sel_Cover 
WHERE Survey_id=@SurveyID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
