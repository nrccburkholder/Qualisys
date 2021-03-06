/*
S10.US7	Change to Config Manager
		As a Client Services team member I want to be able to map text boxes to sample units that I can have dynamic cover letter text. 

T7.4	Modify the QSI application UI

Tim Butler

ALTER PROCEDURE [dbo].[QCL_SelectCoverLettersBySurveyID]
CREATE PROCEDURE [dbo].[QCL_SelectCoverLettersBySurveyIdAndPageType]
CREATE PROCEDURE [dbo].[QCL_SelectCoverLettersBySurveyIdAndPageTypes]
CREATE PROCEDURE [dbo].[QCL_SelectCoverLetterItems]
CREATE PROCEDURE [dbo].[QCL_SelectCoverLetterMappingById]

*/


USE [QP_Prod]
begin tran
go

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_SelectCoverLettersBySurveyIdAndPageType')
	DROP PROCEDURE dbo.QCL_SelectCoverLettersBySurveyIdAndPageType

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_SelectCoverLettersBySurveyIdAndPageTypes')
	DROP PROCEDURE dbo.QCL_SelectCoverLettersBySurveyIdAndPageTypes

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_SelectCoverLetterItems')
	DROP PROCEDURE dbo.QCL_SelectCoverLetterItems

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_SelectCoverLetterMappingById')
	DROP PROCEDURE dbo.QCL_SelectCoverLetterMappingById


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
/****** Object:  StoredProcedure [dbo].[QCL_SelectCoverLettersBySurveyIdAndPageTypes]    Script Date: 10/2/2014 8:51:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[QCL_SelectCoverLettersBySurveyIdAndPageTypes]
@SurveyID INT,
@PageTypes VARCHAR(10)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @SQL as varchar(500)

SET @SQL = 'SELECT SelCover_id, [Description], Survey_id
FROM Sel_Cover 
WHERE Survey_id=' + CAST(@SurveyID as varchar) + 
' AND PageType in (' + @PageTypes + ')'

EXEC (@Sql)

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
AND st.LANGUAGE = 1


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

SELECT m.CoverLetterItemArtifactUnitMapping_id
    , m.Survey_id
	, m.SampleUnit_id
	, su.strSampleUnit_nm
	, m.CoverLetterItemType_id
	, m.CoverLetter_dsc
	, m.CoverLetterItem_label
	, m.Artifact_dsc
	, m.ArtifactItem_label
FROM dbo.CoverLetterItemArtifactUnitMapping m
inner join sampleunit su on m.SampleUnit_id=su.SampleUnit_id
WHERE CoverLetterItemArtifactUnitMapping_id=@id

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

go
commit tran