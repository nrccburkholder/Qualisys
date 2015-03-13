USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_fg_CoverVariationErrorChecking] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_fg_CoverVariationErrorChecking
as

if object_id('CoverVariationLog_spCoverVariation') is NOT NULL
	delete from CoverVariationLog_spCoverVariation where CV_RunDate < dateadd(month,-3,getdate())
if object_id('CoverVariationLog_SurveyCoverVariation') is NOT NULL
	delete from CoverVariationLog_SurveyCoverVariation where CV_RunDate < dateadd(month,-3,getdate())

SELECT DISTINCT w.Survey_id
INTO #Survey
FROM FG_PreMailingWork w
inner join CoverLetterItemArtifactUnitMapping map on w.survey_id=map.survey_id

create table #CoverVariation (CoverVariation_id int identity(101,1), survey_id int, cover_id int)
create table #SurveyCoverVariation (SurveyCoverVariation_id int identity(1,1), CoverVariation_id int, survey_id int, cover_id int)
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

-- get the list of all possible cover letter variations by calling CoverVariationList for each survey's Cover Letters 
--   that have one or more items mapped to an artifact	
declare @Survey int, @cover_id int

SELECT TOP 1 @Survey=Survey_id FROM #Survey
WHILE @@ROWCOUNT>0
BEGIN
	-- get a list of the survey's current mappings. CoverVariationGetMap adds current Cover_IDs and QPC_IDs (textbox_IDs)	
	exec dbo.CoverVariationGetMap @survey

	truncate table #CoverVariation
	set @cover_id=0
	while @cover_id is not null
	begin
		select @cover_id=min(selcover_id) 
		from sel_cover
		where survey_id=@survey
		and PageType <> 4
		and SelCover_id not in (select Cover_id from #CoverVariation)
		and SelCover_id in (select Cover_id from #CoverLetterItemArtifactUnitMapping where survey_id=@survey)

		if @Cover_id is not null
			exec dbo.CoverVariationList @survey, @cover_id
	end
	insert into #SurveyCoverVariation 
	select *
	from #CoverVariation
	order by CoverVariation_id

	DELETE #Survey WHERE Survey_id=@Survey
	SELECT TOP 1 @Survey=Survey_id FROM #Survey
END

if exists (select * from #CoverLetterItemArtifactUnitMapping where coverItem_id=-1 or Artifact_id=-1 or ArtifactPage_id=-1)
begin
	-- FGErrorType_id=41 --> One or more of the named cover letter items or artifacts don't exist
    INSERT INTO formgenerror (scheduledmailing_id, datgenerated, fgerrortype_id) 
    SELECT scheduledmailing_id, Getdate(), 41
    FROM   FG_PreMailingWork mw
    where mw.survey_id in (select survey_id from #CoverLetterItemArtifactUnitMapping where coverItem_id=-1 or Artifact_id=-1 or ArtifactPage_id=-1)

    delete mw
    from FG_PreMailingWork mw
	where mw.survey_id in (select survey_id from #CoverLetterItemArtifactUnitMapping where coverItem_id=-1 or Artifact_id=-1 or ArtifactPage_id=-1)
end

/*
select * from #CoverVariation 
select * from #SurveyCoverVariation 
select * from #CoverLetterItemArtifactUnitMapping
*/

-- figure out which cover letter variation each samplepop in FG_PreMailingWork should get
-- get the list off samplepops being generated 
select distinct mw.survey_id, mw.samplepop_id, 0 as CoverVariation_id, ms.selcover_id, 0 as intFlag
into #spCoverVariation
from FG_PreMailingWork mw
inner join mailingstep ms on mw.mailingstep_id=ms.mailingstep_id

-- get the list of all the items on the cover letter(s) we're examining
select distinct st.survey_id, st.coverid, st.qpc_id --> list of all textboxes on all the cover letters
into #CoverLetterTextboxes
from sel_textbox st
inner join (select distinct survey_id, selcover_id from #spCoverVariation) mc on st.survey_id=mc.survey_id and st.coverid=mc.selcover_id


-- cycle through each item on the cover letters and determine which (if any) artifact each samplepop should use instead.
select mw.samplepop_id, map.Survey_id, map.SampleUnit_id, map.CoverLetterItemType_id
	, ms.selcover_id as CoverID, map.CoverLetter_dsc, map.CoverItem_id, map.CoverLetterItem_label
	, map.ArtifactPage_id, map.Artifact_dsc, map.Artifact_id, map.ArtifactItem_label
into #spCoverMap
from fg_Premailingwork mw
inner join mailingstep ms on mw.mailingstep_id=ms.mailingstep_id
inner join samplepop sp on mw.samplepop_id=sp.samplepop_id
inner join selectedsample ss on sp.sampleset_id=ss.sampleset_id and sp.pop_id=ss.pop_id
inner join #CoverLetterItemArtifactUnitMapping map on ss.sampleunit_id=map.sampleunit_id and ms.selcover_id=map.Cover_ID

if exists (	select survey_id, samplepop_id, coverID, CoverItem_id, count(distinct artifact_id) 
			from #spcovermap
			group by survey_id, samplepop_id, coverID, CoverItem_id
			having count(distinct artifact_id)>1 )
begin
	-- FGErrorType_id=42 --> One or more of the named cover letter items are mapped to different artifacts for this samplepop's sampled units.
	-- FGErrorType_id=43 --> Can't generate the survey because others in the survey had FGErrorType_id=42
	
	declare @ErroredSurveys table (survey_id int)
	insert into @ErroredSurveys (survey_id)
	select distinct survey_id
	from (	select survey_id, samplepop_id, coverID, CoverItem_id
			from #spcovermap
			group by survey_id, samplepop_id, coverID, CoverItem_id
			having count(distinct artifact_id)>1 ) x
	
	declare @FormGenError table (scheduledmailing_id int, fgerrortype_id int)
	-- these are the samplepops we actually have a problem with
    INSERT INTO @formgenerror (scheduledmailing_id, fgerrortype_id) 
    SELECT distinct scheduledmailing_id, 42
    FROM   fg_premailingwork mw
    inner join (select survey_id, samplepop_id, coverID, CoverItem_id
			from #spcovermap
			group by survey_id, samplepop_id, coverID, CoverItem_id
			having count(distinct artifact_id)>1 ) es on mw.survey_id=es.survey_id and mw.samplepop_id=es.samplepop_id
			
	-- these are the samplepops that have the same survey_id as people we have a problem with (we don't want to generate them either, cuz we'd just have to roll them back.)
	INSERT INTO @formgenerror (scheduledmailing_id, fgerrortype_id) 
    SELECT distinct scheduledmailing_id, 43
    FROM   fg_premailingwork mw
    inner join @erroredSurveys es on mw.survey_id=es.survey_id 
    where scheduledmailing_id not in (select scheduledmailing_id from @formgenerror)
    
    insert into FormGenError (scheduledmailing_id, datGenerated, fgerrortype_id)
    select scheduledmailing_id, getdate(), fgerrortype_id
    from @FormGenError

	delete pmw
	from FG_PreMailingWork pmw
    inner join @ErroredSurveys es on pmw.survey_id=es.survey_id
	
end

drop table #Survey
drop table #CoverVariation 
drop table #SurveyCoverVariation 
drop table #spCoverVariation
drop TABLE #CoverLetterItemArtifactUnitMapping 
drop table #spcovermap
drop table #CoverLetterTextboxes