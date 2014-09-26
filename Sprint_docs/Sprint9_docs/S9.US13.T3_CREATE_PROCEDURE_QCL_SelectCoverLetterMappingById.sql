USE [QP_Prod]
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
