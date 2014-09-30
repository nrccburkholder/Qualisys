/*
S9.US10	HCAHPS Phone Lag Time Fix
		As an Authorized Vendor, we want to correctly calculate the lag time for phone non-response dispositions, so that we can report correct data to CMS

T10.4	Modify the QSI application UI

Tim Butler

ALTER PROCEDURE [dbo].[QCL_SelectCoverLettersBySurveyID]
CREATE PROCEDURE [dbo].[QCL_SelectCoverLettersBySurveyIdAndPageType]
CREATE PROCEDURE [dbo].[QCL_SelectCoverLetterItems]
CREATE PROCEDURE [dbo].[QCL_SelectCoverLetterMappingById]

*/

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

GO

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


GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectCoverLetterItems]    Script Date: 9/25/2014 3:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[QCL_SelectCoverLetterItems]
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


SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectCoverLetterMappingById]    Script Date: 9/25/2014 1:18:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[QCL_SelectCoverLetterMappingById]
	@id int
as

SET NOCOUNT ON

SELECT CoverLetterItemArtifactUnitMapping_id, Survey_id, SampleUnit_id, CoverLetterItemType_id, CoverID, CoverLetterItem_id, CoverLetterItem_label, ArtifactPage_id, Artifact_id, Artifact_label
FROM dbo.CoverLetterItemArtifactUnitMapping 
WHERE CoverLetterItemArtifactUnitMapping_id=@id

SET NOCOUNT OFF

GO