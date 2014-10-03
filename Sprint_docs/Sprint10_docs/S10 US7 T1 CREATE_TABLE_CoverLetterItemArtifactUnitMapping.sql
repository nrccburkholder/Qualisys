/*
S10.US7	Change to Config Manager
		As a Client Services team member I want to be able to map text boxes to sample units that I can have dynamic cover letter text. 

T7.1	Modify tables & CRUD

Tim Butler

CREATE TABLE dbo.CoverLetterItemArtifactUnitMapping 
CREATE PROCEDURE [dbo].[QCL_InsertCoverLetterItemArtifactUnitMapping]
CREATE PROCEDURE [dbo].[QCL_DeleteCoverLetterItemArtifactUnitMapping]
CREATE PROCEDURE [dbo].[QCL_SelectCoverLetterItemArtifactUnitMapping]
CREATE PROCEDURE [dbo].[QCL_UpdateCoverLetterItemArtifactUnitMapping]

*/
use qp_prod
go
begin tran
go

IF EXISTS (SELECT * FROM sys.tables where schema_id=1 and name = 'CoverLetterItemArtifactUnitMapping')
	DROP TABLE dbo.CoverLetterItemArtifactUnitMapping 
IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_InsertCoverLetterItemArtifactUnitMapping')
	DROP PROCEDURE dbo.QCL_InsertCoverLetterItemArtifactUnitMapping
IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_DeleteCoverLetterItemArtifactUnitMapping')
	DROP PROCEDURE dbo.QCL_DeleteCoverLetterItemArtifactUnitMapping
IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_UpdateCoverLetterItemArtifactUnitMapping')
	DROP PROCEDURE dbo.QCL_UpdateCoverLetterItemArtifactUnitMapping
IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_SelectCoverLetterItemArtifactUnitMapping')
	DROP PROCEDURE dbo.QCL_SelectCoverLetterItemArtifactUnitMapping
	
GO
CREATE TABLE dbo.CoverLetterItemArtifactUnitMapping (
	CoverLetterItemArtifactUnitMapping_id int identity(1,1)
	, Survey_id int
	, SampleUnit_id int
	, CoverLetterItemType_id tinyint 
	, CoverLetter_dsc varchar(60)
	, CoverLetterItem_label varchar(60) 
	, Artifact_dsc varchar(60)
	, ArtifactItem_label varchar(60) 
)
go
CREATE PROCEDURE [dbo].[QCL_InsertCoverLetterItemArtifactUnitMapping]
	  @Survey_id int
	, @SampleUnit_id int
	, @CoverLetterItemType_id tinyint
	, @CoverLetter_dsc varchar(60)
	, @CoverLetterItem_label varchar(60) 
	, @Artifact_dsc varchar(60)
	, @ArtifactItem_label varchar(60) 
as

SET NOCOUNT ON

INSERT INTO dbo.CoverLetterItemArtifactUnitMapping (Survey_id, SampleUnit_id, CoverLetterItemType_id, CoverLetter_dsc, CoverLetterItem_label, Artifact_dsc, ArtifactItem_label)
VALUES (@Survey_id, @SampleUnit_id, @CoverLetterItemType_id, @CoverLetter_dsc, @CoverLetterItem_label, @Artifact_dsc, @ArtifactItem_label)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
go
CREATE PROCEDURE [dbo].[QCL_DeleteCoverLetterItemArtifactUnitMapping]
	@CoverLetterItemArtifactUnitMapping_id int
as

SET NOCOUNT ON

DELETE [dbo].[CoverLetterItemArtifactUnitMapping]
WHERE CoverLetterItemArtifactUnitMapping_id=@CoverLetterItemArtifactUnitMapping_id

SET NOCOUNT OFF
go
CREATE PROCEDURE [dbo].[QCL_SelectCoverLetterItemArtifactUnitMapping]
	@Survey_id int
as

SET NOCOUNT ON

SELECT m.CoverLetterItemArtifactUnitMapping_id, m.Survey_id
	, m.SampleUnit_id
	, su.strSampleUnit_nm
	, m.CoverLetterItemType_id
	, m.CoverLetter_dsc
	, m.CoverLetterItem_label
	, m.Artifact_dsc
	, m.ArtifactItem_label
FROM dbo.CoverLetterItemArtifactUnitMapping m
inner join sampleunit su on m.SampleUnit_id=su.SampleUnit_id
WHERE m.Survey_id=@Survey_id

SET NOCOUNT OFF
go
CREATE PROCEDURE [dbo].[QCL_UpdateCoverLetterItemArtifactUnitMapping]
	  @CoverLetterItemArtifactUnitMapping_id int
	, @SampleUnit_id int
	, @CoverLetterItemType_id tinyint
	, @CoverLetter_dsc varchar(60)
	, @CoverLetterItem_label varchar(60) 
	, @Artifact_dsc varchar(60)
	, @ArtifactItem_label varchar(60) 
as

SET NOCOUNT ON

UPDATE dbo.CoverLetterItemArtifactUnitMapping 
SET   SampleUnit_id = @Sampleunit_id
	, CoverLetterItemType_id = @CoverLetterItemType_id
	, CoverLetter_dsc = @CoverLetter_dsc
	, CoverLetterItem_label = @CoverLetterItem_label
	, Artifact_dsc = @Artifact_dsc
	, ArtifactItem_label = @ArtifactItem_label
WHERE CoverLetterItemArtifactUnitMapping_id = @CoverLetterItemArtifactUnitMapping_id 

SET NOCOUNT OFF
go
commit tran