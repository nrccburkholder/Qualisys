/****
S12.US10

T2.1	Fix any errors exposed (UAT)

Chris Burkholder

Related to Dynamic Cover Letters

Multiple Languages cause duplicates in cover letter mapping.  Hardcoded select to only bring back English, which must always be there.

ALTER QCL_SelectCoverLetterItems


****/
USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectCoverLetterItems]    Script Date: 10/30/2014 11:53:11 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[QCL_SelectCoverLetterItems]
@SurveyID INT,
@CoverID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT st.QPC_ID, st.COVERID, st.LABEL, 1 as ItemType
FROM SEL_TEXTBOX st 
WHERE st.Survey_id = @SurveyID
AND st.COVERID = @CoverID
AND LEN(st.LABEL) > 0
AND st.LANGUAGE = 1

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


GO


