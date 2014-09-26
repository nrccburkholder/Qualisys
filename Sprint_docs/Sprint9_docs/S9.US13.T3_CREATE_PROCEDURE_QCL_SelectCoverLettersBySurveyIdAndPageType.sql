USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectCoverLettersBySurveyID]    Script Date: 9/25/2014 9:08:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[QCL_SelectCoverLettersBySurveyIdAndPageType]
@SurveyID INT,
@PageType INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT SelCover_id, [Description], Survey_id
FROM Sel_Cover 
WHERE Survey_id=@SurveyID
AND PageType = @PageType

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
