USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[CoverVariationGetMap] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure dbo.CoverVariationGetMap
@survey_id int 
as
-- this procedure expects the following temp table to already exist, but be empty:
/*
	CREATE TABLE #CoverLetterItemArtifactUnitMapping (
		[Survey_id] [int] NULL,
		[SampleUnit_id] [int] NULL,
		[CoverLetterItemType_id] [tinyint] NULL,
		[CoverLetter_dsc] [varchar](60) NULL,
		[CoverLetterItem_label] [varchar](60) NULL,
		[Artifact_dsc] [varchar](60) NULL,
		[ArtifactItem_label] [varchar](60) NULL,
		[Cover_id] [int] NULL,
		[CoverItem_id] [int] NULL,
		[ArtifactPage_id] [int] NULL,
		[Artifact_id] [int] NULL
	)
*/

insert into #CoverLetterItemArtifactUnitMapping (
	Survey_id, SampleUnit_id, CoverLetterItemType_id, CoverLetter_dsc, CoverLetterItem_label, Artifact_dsc, ArtifactItem_label
	, Cover_id, CoverItem_id, ArtifactPage_id, Artifact_id)
select Survey_id, SampleUnit_id, CoverLetterItemType_id, CoverLetter_dsc, CoverLetterItem_label, Artifact_dsc, ArtifactItem_label
	, -1 as Cover_id, -1 as CoverItem_id, -1 as ArtifactPage_id, -1 as Artifact_id
from dbo.CoverLetterItemArtifactUnitMapping 
where survey_id=@survey_id 

update m set Cover_id=sc.selcover_id
from #CoverLetterItemArtifactUnitMapping m
inner join sel_cover sc on m.survey_id=sc.survey_id and m.CoverLetter_dsc=sc.description

update m set artifactPage_id=sc.selcover_id
from #CoverLetterItemArtifactUnitMapping m
inner join sel_cover sc on m.survey_id=sc.survey_id and m.artifact_dsc=sc.description

update m set CoverItem_id=st.qpc_id
from #CoverLetterItemArtifactUnitMapping m
inner join sel_textbox st on m.survey_id=st.survey_id and m.cover_id=st.coverid and rtrim(m.CoverLetterItem_label)=rtrim(st.label) and st.language=1

update m set Artifact_id=st.qpc_id
from #CoverLetterItemArtifactUnitMapping m
inner join sel_textbox st on m.survey_id=st.survey_id and m.ArtifactPage_id=st.coverid and rtrim(m.ArtifactItem_label)=rtrim(st.label) and st.language=1