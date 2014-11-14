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