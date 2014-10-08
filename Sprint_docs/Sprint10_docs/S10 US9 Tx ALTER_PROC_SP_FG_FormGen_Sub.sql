/*
S10.US9	Change to Formgen
		As a Client Services team member I want to be able to label text boxes in formlayout so that I can map text boxes to sample units. 

T9.1	Identify error conditions and logging
T9.2	Determine the different permutations of the different cover letters needed for an evening
T9.3	Construct cover letter variations with substitutions   
T9.4	Assign the proper variation to each samplepop (in FGPopCover)
T9.5	Make sure FGPopCodes is populated properly for any alternate textboxes
T9.6	Address any processes that are specific to test prints

Dave Gilsdorf

ALTER PROCEDURE [dbo].[SP_FG_FormGen_Sub]
*/
use qp_prod
go
begin tran
go
/*
   This stored PROCEDURE has been modified to allow multiple MailingSteps for a single person
   to be generated ON the same night.
   MODIFIED 3/20/2 BD added SampleSet join between #FG_MailingWork AND unikeys to
                                     populate #BVUK
   MODIFIED 5/22/2  BD set Langid=1 if current Langid is not valid for the Survey
   MODIFIED 1/13/3  BD Enclosed the criteria stmt by Parentheses within the minor exception rule processing.
   MODIFIED 11/17/3 BD Remove unikeys entries.  SelectedSample has everything we need.
   MODIFIED 1/21/04 SS Mods to accomodate TestPrints (bitTP added, BVUK update for de-personalization of TP, #FG_MailingWork changed to #FG_MailingWork)
   MODIFIED 2/5/04  BD Added tracking for skip patterns.  These will be used for the extract to the datamart.
   MODIFIED 5/21/04 BD Added tracking for skip patterns.  These will be used for the extract to the datamart.
   MODIFIED 5/24/04 BD If this is the first test print since a survey has been validated, clear the PCL_XXX_TP tables so the new form will load.
   MODIFIED 6/1/04  BD The query to populate #BVUK would occassionaly fill tempdb.  So I broke the single query into 3 smaller queries.
   MODIFIED 7/20/04 SS Tightened the "Address Information" criteria for the mockup recode.
   MODIFIED 7/21/04 SS Error trap for TP was using FormGenError instead of FormGenError_TP.  Changed to use FormGenError_TP
   MODIFIED 8/27/04 BD/SS FIX for Minor Exception Rule -- Added suvey_id = mw.survey_id in dynamic sql statement (approx Ln 416)
   MODIFIED 9/13/04 BD Save off the zip5, zip4, and postalcode values for bundling.
   MODIFIED 01/4/05 BD Only run 'update statistics SentMailing' if the last pass thru the sub routine has @survey%10=0(@survey is evenly divisible by 10).
   MODIFIED 6/17/05 SS Specified that @AgeCol / @SexCol will be sourced from the Population table. (Previous code allowed any table with valid field to be source.)
   MODIFIED 10/19/05 BD Now a section can only appear once on a form.  Taking personalization from the encounter tied to MAX(SampleUnit_id)
   MODIFIED 11/19/09 MB Added new tables to update (DL_SEL_QSTNS_BySampleSet and DL_SEL_SCLS_BySampleSet).  They will be used in the new Import Results application(s)
   MODIFIED 3/02/09 MB Added new tables to update (DL_SampleUnitSection_BySampleset).  It will also be used in the new Import Results application(s)
   MODIFIED 3/03/09 MB Added @SQL2, @SQL3, @SQL4 variables to the "INSERT INTO #bvuk" section (Line 230).  Dynamic SQL string grew larger than 8000 char.  Split the string into 4 variables
   then executed the string as EXEC( @sql + @sql2 + @sql3 + @sql4)
   MODIFIED 9/19/13 DG Added call to CalcCAHPSSupplemental
   MODIFIED 6/22/2014 TSB Added QuestionnaireType_ID to write to SentMailing table - AllCahps Sprint 2 R3.5
   MODIFIED 7/21/2014 DG Remove records from #PopSection if the section is mapped to a mode other than what is currently being generated.
   MODIFIED 10/6/2014 DG Implement Cover Letter Variations to accomodate dynamic cover letters
*/
ALTER PROCEDURE [dbo].[SP_FG_FormGen_Sub]
@Study INT, @Survey INT, @bitTP BIT
AS

 /*---------------*/
 --TESTING VARIABLES
 -- DECLARE @study INT, @survey INT, @bitTP BIT
 -- SET @study = 459
 -- SET @survey = 1520
 -- SET @bitTP = 0

 /*---------------*/

SET QUOTED_IDENTIFIER OFF

--Need to check and see if a newer version of the form exists
DECLARE @ValidationDate DATETIME, @LastValidationDate DATETIME, @ResetForm BIT
DECLARE @Sampleset int, @MaxQF int


SELECT @ResetForm=0
IF @bitTP = 1 
  BEGIN 
      SELECT @ValidationDate = Isnull(datvalidated, '1/1/2010') 
      FROM   survey_def 
      WHERE  survey_id = @Survey 

      SELECT @LastValidationDate = Max(datvalidated) 
      FROM   pcl_cover_tp 
      WHERE  survey_id = @Survey 

      SELECT @LastValidationDate = Isnull(@LastValidationDate, '1/1/1900') 

      IF @ValidationDate > @LastValidationDate 
        SELECT @ResetForm = 1 
      ELSE 
        SELECT @ResetForm = 0 
  END 

/* begin: moved from further down the proc. We want the PCL_xxx tables populated before figuring out dynamic cover letters */
/*---------------------------------*/
/*  Update PCL Tables              */
/*---------------------------------*/

SELECT DISTINCT Survey_id
INTO #Survey
FROM #FG_MailingWork

SELECT TOP 1 @Survey=Survey_id FROM #Survey
WHILE @@ROWCOUNT>0
BEGIN
	IF @bitTP = 0
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 * FROM PCL_Cover WHERE Survey_id=@Survey)
		BEGIN
		  INSERT INTO PCL_Cover (SelCover_id,Survey_id,PageType,Description,Integrated,bitLetterHead)
			  SELECT SelCover_id,Survey_id,PageType,Description,Integrated,bitLetterHead
			  FROM Sel_Cover
			  WHERE Survey_id=@Survey
		END

		IF NOT EXISTS (SELECT TOP 1 * FROM PCL_Logo WHERE Survey_id=@Survey)
		BEGIN
		  INSERT INTO PCL_Logo (QPC_ID,CoverID,Survey_ID,DESCRIPTION,X,Y,WIDTH,HEIGHT,SCALING,BITMAP,VISIBLE)
			  SELECT QPC_ID,CoverID,Survey_ID,DESCRIPTION,X,Y,WIDTH,HEIGHT,SCALING,BITMAP,VISIBLE
			  FROM Sel_Logo
			  WHERE Survey_id=@Survey
		END

		IF NOT EXISTS (SELECT TOP 1 * FROM PCL_PCL WHERE Survey_id=@Survey)
		BEGIN
		  INSERT INTO PCL_PCL (QPC_ID,Survey_ID,Language,CoverID,DESCRIPTION,X,Y,WIDTH,HEIGHT,PCLSTREAM,KNOWNDIMENSIONS)
			  SELECT QPC_ID,Survey_ID,Language,CoverID,DESCRIPTION,X,Y,WIDTH,HEIGHT,PCLSTREAM,KNOWNDIMENSIONS
			  FROM Sel_PCL
			  WHERE Survey_id=@Survey
		END

		IF NOT EXISTS (SELECT TOP 1 * FROM PCL_Qstns WHERE Survey_id=@Survey)
		BEGIN
		  INSERT INTO PCL_Qstns (SelQstns_ID,Survey_ID,Language,ScaleID,Section_ID,LABEL,PLUSMINUS,SUBSection,ITEM,SubType,WIDTH,HEIGHT,
				 RICHTEXT,ScalePOS,ScaleFLIPPED,NUMMARKCOUNT,BITMEANABLE,NUMBUBBLECOUNT,QSTNCORE,BITLANGREVIEW)
			  SELECT SelQstns_ID,Survey_ID,Language,ScaleID,Section_ID,LABEL,PLUSMINUS,SUBSection,ITEM,SubType,WIDTH,HEIGHT,
				 RICHTEXT,ScalePOS,ScaleFLIPPED,NUMMARKCOUNT,BITMEANABLE,NUMBUBBLECOUNT,QSTNCORE,BITLANGREVIEW
			  FROM Sel_Qstns
			  WHERE Survey_id=@Survey
		END

		IF NOT EXISTS (SELECT TOP 1 * FROM PCL_Scls WHERE Survey_id=@Survey)
		BEGIN
		  INSERT INTO PCL_Scls (Survey_ID,QPC_ID,ITEM,Language,VAL,LABEL,RICHTEXT,MISSING,CHARSET,ScaleORDER,INTRESPTYPE)
			  SELECT Survey_ID,QPC_ID,ITEM,Language,VAL,LABEL,RICHTEXT,MISSING,CHARSET,ScaleORDER,INTRESPTYPE
			  FROM Sel_Scls
			  WHERE Survey_id=@Survey
		END

		IF NOT EXISTS (SELECT TOP 1 * FROM PCL_Skip WHERE Survey_id=@Survey)
		BEGIN
		  INSERT INTO PCL_Skip (Survey_ID,SelQstns_ID,SELScls_ID,ScaleITEM,NUMSkip,NUMSkipTYPE)
			  SELECT Survey_ID,SelQstns_ID,SELScls_ID,ScaleITEM,NUMSkip,NUMSkipTYPE
			  FROM Sel_Skip
			  WHERE Survey_id=@Survey
		END

		IF NOT EXISTS (SELECT TOP 1 * FROM PCL_textbox WHERE Survey_id=@Survey)
		BEGIN
		  INSERT INTO PCL_textbox (QPC_ID,Survey_ID,Language,CoverID,X,Y,WIDTH,HEIGHT,RICHTEXT,BORDER,SHADING,BITLANGREVIEW)
			  SELECT QPC_ID,Survey_ID,Language,CoverID,X,Y,WIDTH,HEIGHT,RICHTEXT,BORDER,SHADING,BITLANGREVIEW
			  FROM Sel_TextBox
			  WHERE Survey_id=@Survey
		END
	END

	IF @bitTP = 1 -- ADDED 1/20/04 SS (test prints) -- start
	BEGIN

		IF @ResetForm=1
		BEGIN
			DELETE PCL_Cover_TP WHERE Survey_id=@Survey
			DELETE PCL_Logo_TP WHERE Survey_id=@Survey
			DELETE PCL_PCL_TP WHERE Survey_id=@Survey
			DELETE PCL_Qstns_TP WHERE Survey_id=@Survey
			DELETE PCL_Scls_TP WHERE Survey_id=@Survey
			DELETE PCL_Skip_TP WHERE Survey_id=@Survey
			DELETE PCL_TextBox_TP WHERE Survey_id=@Survey
		END

		IF NOT EXISTS (SELECT TOP 1 * FROM PCL_Cover_TP WHERE Survey_id=@Survey)
		BEGIN
		  INSERT INTO PCL_Cover_TP (SelCover_id,Survey_id,PageType,Description,Integrated,bitLetterHead,datValidated)
			 SELECT SelCover_id,Survey_id,PageType,Description,Integrated,bitLetterHead,@ValidationDate
			 FROM Sel_Cover
			 WHERE Survey_id=@Survey
		END

		IF NOT EXISTS (SELECT TOP 1 * FROM PCL_Logo_TP WHERE Survey_id=@Survey)
		BEGIN
		  INSERT INTO PCL_Logo_TP (QPC_ID,CoverID,Survey_ID,DESCRIPTION,X,Y,WIDTH,HEIGHT,SCALING,BITMAP,VISIBLE)
			  SELECT QPC_ID,CoverID,Survey_ID,DESCRIPTION,X,Y,WIDTH,HEIGHT,SCALING,BITMAP,VISIBLE
			  FROM Sel_Logo
			  WHERE Survey_id=@Survey
		END

		IF NOT EXISTS (SELECT TOP 1 * FROM PCL_PCL_TP WHERE Survey_id=@Survey)
		BEGIN
		  INSERT INTO PCL_PCL_TP (QPC_ID,Survey_ID,Language,CoverID,DESCRIPTION,X,Y,WIDTH,HEIGHT,PCLSTREAM,KNOWNDIMENSIONS)
			  SELECT QPC_ID,Survey_ID,Language,CoverID,DESCRIPTION,X,Y,WIDTH,HEIGHT,PCLSTREAM,KNOWNDIMENSIONS
			  FROM Sel_PCL
			  WHERE Survey_id=@Survey
		END

		IF NOT EXISTS (SELECT TOP 1 * FROM PCL_Qstns_TP WHERE Survey_id=@Survey)
		BEGIN
		  INSERT INTO PCL_Qstns_TP (SelQstns_ID,Survey_ID,Language,ScaleID,Section_ID,LABEL,PLUSMINUS,SUBSection,ITEM,SubType,WIDTH,HEIGHT,
				 RICHTEXT,ScalePOS,ScaleFLIPPED,NUMMARKCOUNT,BITMEANABLE,NUMBUBBLECOUNT,QSTNCORE,BITLANGREVIEW)
			  SELECT SelQstns_ID,Survey_ID,Language,ScaleID,Section_ID,LABEL,PLUSMINUS,SUBSection,ITEM,SubType,WIDTH,HEIGHT,
				 RICHTEXT,ScalePOS,ScaleFLIPPED,NUMMARKCOUNT,BITMEANABLE,NUMBUBBLECOUNT,QSTNCORE,BITLANGREVIEW
			  FROM Sel_Qstns
			  WHERE Survey_id=@Survey
		END

		IF NOT EXISTS (SELECT TOP 1 * FROM PCL_Scls_TP WHERE Survey_id=@Survey)
		BEGIN
		  INSERT INTO PCL_Scls_TP (Survey_ID,QPC_ID,ITEM,Language,VAL,LABEL,RICHTEXT,MISSING,CHARSET,ScaleORDER,INTRESPTYPE)
			  SELECT Survey_ID,QPC_ID,ITEM,Language,VAL,LABEL,RICHTEXT,MISSING,CHARSET,ScaleORDER,INTRESPTYPE
			  FROM Sel_Scls
			  WHERE Survey_id=@Survey
		END

		IF NOT EXISTS (SELECT TOP 1 * FROM PCL_Skip_TP WHERE Survey_id=@Survey)
		BEGIN
		  INSERT INTO PCL_Skip_TP (Survey_ID,SelQstns_ID,SELScls_ID,ScaleITEM,NUMSkip,NUMSkipTYPE)
			  SELECT Survey_ID,SelQstns_ID,SELScls_ID,ScaleITEM,NUMSkip,NUMSkipTYPE
			  FROM Sel_Skip
			  WHERE Survey_id=@Survey
		END

		IF NOT EXISTS (SELECT TOP 1 * FROM PCL_textbox_TP WHERE Survey_id=@Survey)
		BEGIN
		  INSERT INTO PCL_textbox_TP (QPC_ID,Survey_ID,Language,CoverID,X,Y,WIDTH,HEIGHT,RICHTEXT,BORDER,SHADING,BITLANGREVIEW)
			  SELECT QPC_ID,Survey_ID,Language,CoverID,X,Y,WIDTH,HEIGHT,RICHTEXT,BORDER,SHADING,BITLANGREVIEW
			  FROM Sel_TextBox
			  WHERE Survey_id=@Survey
		END
	END -- ADDED 1/20/04 SS (test prints) -- end

	DELETE #Survey WHERE Survey_id=@Survey
	SELECT TOP 1 @Survey=Survey_id FROM #Survey
END
/* end: moved from further down the proc */

-- declare @survey int, @bitTp bit, @resetform bit, @validationdate datetime set @bittp=0
-- DYNAMIC COVER LETTERS
-- get the list of all possible cover letter variations by calling CoverVariationList for each of the survey's Cover Letters 
--   that have one or more items mapped to an artifact	
INSERT INTO #Survey
SELECT DISTINCT Survey_id
FROM #FG_MailingWork

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


declare @cover_id int

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
		and Description in (select CoverLetter_Dsc from dbo.CoverLetterItemArtifactUnitMapping where survey_id=@survey)

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

/*
select * from #CoverVariation 
select * from #SurveyCoverVariation 
select * from #CoverLetterItemArtifactUnitMapping
*/

-- figure out which cover letter variation each samplepop in #FG_MailingWork should get
-- get the list off samplepops being generated 
select distinct survey_id, samplepop_id, 0 as CoverVariation_id, mw.selcover_id, 0 as intFlag
into #spCoverVariation
from #FG_MailingWork mw

-- get the list of all the items on the cover letter(s) we're examining
select distinct st.survey_id, st.coverid, st.qpc_id --> list of all textboxes on all the cover letters
into #CoverLetterTextboxes
from sel_textbox st
inner join (select distinct survey_id, selcover_id from #spCoverVariation) mc on st.survey_id=mc.survey_id and st.coverid=mc.selcover_id


-- cycle through each item on the cover letters and determine which (if any) artifact each samplepop should use instead.
select mw.samplepop_id, map.Survey_id, map.SampleUnit_id, map.CoverLetterItemType_id
	, mw.selcover_id as CoverID, map.CoverLetter_dsc, map.CoverItem_id, map.CoverLetterItem_label
	, map.ArtifactPage_id, map.Artifact_dsc, map.Artifact_id, map.ArtifactItem_label
into #spCoverMap
from #fg_mailingwork mw
inner join samplepop sp on mw.samplepop_id=sp.samplepop_id
inner join selectedsample ss on sp.sampleset_id=ss.sampleset_id and sp.pop_id=ss.pop_id
inner join #CoverLetterItemArtifactUnitMapping map on ss.sampleunit_id=map.sampleunit_id and mw.selcover_id=map.Cover_ID


-- declare @survey int
declare @cvr int, @tb varchar(10), @i varchar(10), @sql_join varchar(max), @sql varchar(max)
select @survey=min(survey_id) from #CoverLetterTextboxes
while @survey is not null
begin
	select @sql_join=''
	select @cvr=min(coverid) from #CoverLetterTextboxes where survey_id=@survey
	while @cvr is not null
	begin
		set @i='0'
		select @tb=min(qpc_id), @i=@i+1 from #CoverLetterTextboxes where coverid=@cvr and survey_id=@survey
		while @tb is not null
		begin
			if not exists (	select *
							from tempdb.sys.columns sc 
							where sc.object_id = object_id('Tempdb..#spCoverVariation')
							and name='Art_'+@i)
			begin
				set @SQL = 'alter table #spCoverVariation add TB_'+@i+' int, Art_'+@i+' int'
				print @SQL
				exec (@SQL)
				set @sql_join = @sql_join + ' and isnull(sp.tb_'+@i+',0)=isnull(cv.tb_'+@i+',0)'
			end
			
			set @SQL = 'update cv
			set TB_'+@i+'='+@tb+', Art_'+@i+'=Artifact_id
			from #spCoverVariation cv
			inner join #spCoverMap map on cv.samplepop_id=map.samplepop_id
			where cv.selcover_id='+convert(varchar,@cvr)+'
			and map.coveritem_id='+@tb
			print @SQL
			exec (@SQL)
			
			delete from #CoverLetterTextboxes where @tb=qpc_id and survey_id=@survey
			select @tb=min(qpc_id), @i=@i+1 from #CoverLetterTextboxes where coverid=@cvr and survey_id=@survey
		end
		select @cvr=min(coverid) from #CoverLetterTextboxes where survey_id=@survey
	end

	set @sql = 'update sp
	set CoverVariation_id=cv.CoverVariation_id
	from #SurveyCoverVariation cv
	inner join #spCoverVariation sp on cv.cover_id=sp.selcover_id and cv.survey_id=sp.survey_id
	' + @sql_Join + '
	' + replace(@sql_join,'tb','art')

	print @sql
	exec (@sql)

	select @survey=min(survey_id) from #CoverLetterTextboxes
end

-- delete samplepops that are getting the default cover letter 
delete from #spCoverVariation where CoverVariation_id=selcover_id

-- if there is anybody who needs a variation, assemble it now.
if exists (select * from #spCoverVariation)
begin
	-- create a copy of the default cover letters for each variation
	select cv.CoverVariation_id as SelCover_id, c.Survey_id, c.PageType, c.Description, c.Integrated, c.bitLetterHead
	into #CV_Cover
	from (select distinct survey_id, selcover_id, CoverVariation_id from #spCoverVariation) cv
	inner join sel_cover c on cv.survey_id=c.survey_id and cv.selcover_id=c.selcover_id

	select tb.QPC_ID, tb.SURVEY_ID, tb.LANGUAGE, cv.CoverVariation_id as COVERID, tb.X, tb.Y, tb.WIDTH, tb.HEIGHT, tb.RICHTEXT, tb.BORDER, tb.SHADING, tb.BITLANGREVIEW
	into #CV_TextBox
	from (select distinct survey_id, selcover_id, CoverVariation_id from #spCoverVariation) cv
	inner join sel_textbox tb on cv.survey_id=tb.survey_id and cv.selcover_id=tb.coverid

	select L.QPC_ID, cv.CoverVariation_id as COVERID, L.SURVEY_ID, L.DESCRIPTION, L.X, L.Y, L.WIDTH, L.HEIGHT, L.SCALING, L.BITMAP, L.VISIBLE
	into #CV_Logo
	from (select distinct survey_id, selcover_id, CoverVariation_id from #spCoverVariation) cv
	inner join sel_logo L on cv.survey_id=L.survey_id and cv.selcover_id=L.coverid

	select P.QPC_ID, P.SURVEY_ID, P.LANGUAGE, cv.CoverVariation_id as COVERID, P.DESCRIPTION, P.X, P.Y, P.WIDTH, P.HEIGHT, P.PCLSTREAM, P.KNOWNDIMENSIONS
	into #CV_PCL
	from (select distinct survey_id, selcover_id, CoverVariation_id from #spCoverVariation) cv
	inner join sel_PCL p on cv.survey_id=p.survey_id and cv.selcover_id=p.coverid
	
	-- replace textboxes with mapped artifacts
	--declare @SQL varchar(max)
	set @sql=''
	select @sql=@sql+'
		update tb set Richtext=st.Richtext, qpc_id=cv.'+name+'
		from #CV_textbox tb
		inner join #surveyCoverVariation cv on tb.coverid=cv.CoverVariation_id and tb.survey_id=cv.survey_id and tb.qpc_id=cv.'+replace(name,'Art','TB')+'
		inner join sel_textbox st on st.survey_id=cv.survey_id and st.qpc_id=cv.'+name+'
		where tb.coverid>100'
	from tempdb.sys.columns sc 
	where sc.object_id = object_id('Tempdb..#surveyCoverVariation')
	and name like 'art[_]%'
	print @SQL
	exec (@SQL)

	if @bitTP=0
	begin
		-- remove any records from the #CV_xxx temp tables that are already in the permanent PCL_xxxx tables
		delete cv
		from #CV_Cover cv
		inner join pcl_Cover p on cv.survey_id=p.survey_id and cv.selcover_id=p.selcover_id

		delete cv
		from #CV_Textbox cv
		inner join pcl_Textbox p on cv.survey_id=p.survey_id and cv.coverid=p.coverid and cv.qpc_id=p.qpc_id

		delete cv
		from #CV_Logo cv
		inner join pcl_Logo p on cv.survey_id=p.survey_id and cv.coverid=p.coverid and cv.qpc_id=p.qpc_id

		delete cv
		from #CV_Pcl cv
		inner join pcl_Pcl p on cv.survey_id=p.survey_id and cv.coverid=p.coverid and cv.qpc_id=p.qpc_id

		-- insert anything still in the #CV_xxx temp tables into the permanent PCL_xxx tables
		insert into pcl_Cover (SelCover_id, Survey_id, PageType, Description, Integrated, bitLetterHead)
		select SelCover_id, Survey_id, PageType, Description, Integrated, bitLetterHead
		from #CV_Cover

		insert into pcl_textbox (QPC_ID, SURVEY_ID, LANGUAGE, COVERID, X, Y, WIDTH, HEIGHT, RICHTEXT, BORDER, SHADING, BITLANGREVIEW)
		select QPC_ID, SURVEY_ID, LANGUAGE, COVERID, X, Y, WIDTH, HEIGHT, RICHTEXT, BORDER, SHADING, BITLANGREVIEW
		from #CV_textbox

		insert into pcl_logo (QPC_ID, COVERID, SURVEY_ID, DESCRIPTION, X, Y, WIDTH, HEIGHT, SCALING, BITMAP, VISIBLE)
		select QPC_ID, COVERID, SURVEY_ID, DESCRIPTION, X, Y, WIDTH, HEIGHT, SCALING, BITMAP, VISIBLE
		from #CV_Logo

		insert into pcl_pcl (QPC_ID, SURVEY_ID, LANGUAGE, COVERID, DESCRIPTION, X, Y, WIDTH, HEIGHT, PCLSTREAM, KNOWNDIMENSIONS)
		select QPC_ID, SURVEY_ID, LANGUAGE, COVERID, DESCRIPTION, X, Y, WIDTH, HEIGHT, PCLSTREAM, KNOWNDIMENSIONS
		from #CV_Pcl
	end
	
	if @bitTP=1
	begin
		-- remove any records from the #CV_xxx temp tables that are already in the permanent PCL_xxxx_tp tables
		delete cv
		from #CV_Cover cv
		inner join pcl_Cover_tp p on cv.survey_id=p.survey_id and cv.selcover_id=p.selcover_id

		delete cv
		from #CV_Textbox cv
		inner join pcl_Textbox_tp p on cv.survey_id=p.survey_id and cv.coverid=p.coverid and cv.qpc_id=p.qpc_id

		delete cv
		from #CV_Logo cv
		inner join pcl_Logo_tp p on cv.survey_id=p.survey_id and cv.coverid=p.coverid and cv.qpc_id=p.qpc_id

		delete cv
		from #CV_Pcl cv
		inner join pcl_Pcl_tp p on cv.survey_id=p.survey_id and cv.coverid=p.coverid and cv.qpc_id=p.qpc_id

		-- insert anything still in the #CV_xxx temp tables into the permanent PCL_xxx_tp tables
		insert into pcl_Cover_tp (SelCover_id, Survey_id, PageType, Description, Integrated, bitLetterHead)
		select SelCover_id, Survey_id, PageType, Description, Integrated, bitLetterHead
		from #CV_Cover

		insert into pcl_textbox_tp (QPC_ID, SURVEY_ID, LANGUAGE, COVERID, X, Y, WIDTH, HEIGHT, RICHTEXT, BORDER, SHADING, BITLANGREVIEW)
		select QPC_ID, SURVEY_ID, LANGUAGE, COVERID, X, Y, WIDTH, HEIGHT, RICHTEXT, BORDER, SHADING, BITLANGREVIEW
		from #CV_textbox

		insert into pcl_logo_tp (QPC_ID, COVERID, SURVEY_ID, DESCRIPTION, X, Y, WIDTH, HEIGHT, SCALING, BITMAP, VISIBLE)
		select QPC_ID, COVERID, SURVEY_ID, DESCRIPTION, X, Y, WIDTH, HEIGHT, SCALING, BITMAP, VISIBLE
		from #CV_Logo

		insert into pcl_pcl_tp (QPC_ID, SURVEY_ID, LANGUAGE, COVERID, DESCRIPTION, X, Y, WIDTH, HEIGHT, PCLSTREAM, KNOWNDIMENSIONS)
		select QPC_ID, SURVEY_ID, LANGUAGE, COVERID, DESCRIPTION, X, Y, WIDTH, HEIGHT, PCLSTREAM, KNOWNDIMENSIONS
		from #CV_Pcl
	end

	-- note: there's nothing we need to do with CodeTxtBox. The QPC_Id in pcl_textbox has been updated to point to the artifact and CodeTxtBox doesn't reference CoverID
	--select *
	--from pcl_textbox ptb
	--left join CodeTxtBox ctb on ptb.survey_id=ctb.survey_id and ptb.qpc_id=ctb.qpc_id
	--where ptb.coverid>100

	drop table #CV_Cover
	drop table #CV_Textbox
	drop table #CV_Logo
	drop table #CV_PCL
end

-- done assembling the various cover variations used in this FormGen run

-- update #fg_mailingwork so each samplepop uses their appropriate CoverVariation
update mw set selcover_id=cv.CoverVariation_id
--select mw.samplepop_id, mw.selcover_id, cv.CoverVariation_id
from #fg_mailingwork mw
inner join #spCoverVariation cv on mw.samplepop_id=cv.samplepop_id



--select * from #CoverVariation 
--select * from #SurveyCoverVariation 
--select * from #CoverLetterItemArtifactUnitMapping
--select * from #spCoverVariation
--select * from #CoverLetterTextBoxes
--select * from #spCoverMap

drop table #CoverVariation 
drop table #SurveyCoverVariation 
drop table #CoverLetterItemArtifactUnitMapping
drop table #spCoverVariation
drop table #CoverLetterTextBoxes
drop table #spCoverMap

-- /DYNAMIC COVER LETTERS





CREATE TABLE #criters (CriteriaStmt_id INT, strCriteriaStmt VARCHAR(2550), dummy_line INT)

-- Who needs a Survey?
--SELECT * FROM #FG_MailingWork

-- What Sections do they need?
-- Changed to not allow a section on a form more than once.
--  SELECT mw.ScheduledMailing_id, mw.SamplePop_id, mw.Survey_id, ss.SampleUnit_id,
--      sus.SelQstnsSection AS Section_id, 0 AS Langid, mw.bitMockup
--  INTO #PopSection
--  FROM #FG_MailingWork mw, dbo.SelectedSample ss, SampleUnitSection sus
--  WHERE mw.SampleSet_id=ss.SampleSet_id
--     AND mw.Study_id=ss.Study_id
--     AND mw.Pop_id=ss.Pop_id
--     AND ss.SampleUnit_id=sus.SampleUnit_id
--     AND mw.Survey_id=sus.SelQstnsSurvey_id
--     AND (mw.bitSendSurvey=1 OR sus.SelQstnsSection=-1)

SELECT mw.scheduledmailing_id, 
       mw.samplepop_id, 
       mw.survey_id, 
       Max(ss.sampleunit_id) SampleUnit_id, 
       sus.selqstnssection   AS Section_id, 
       0                     AS Langid, 
       mw.bitmockup, 
       mw.mailingstep_id 
INTO   #popsection 
FROM   #fg_mailingwork mw, 
       dbo.selectedsample ss, 
       sampleunitsection sus 
WHERE  mw.sampleset_id = ss.sampleset_id 
       AND mw.study_id = ss.study_id 
       AND mw.pop_id = ss.pop_id 
       AND ss.sampleunit_id = sus.sampleunit_id 
       AND mw.survey_id = sus.selqstnssurvey_id 
       AND ( mw.bitsendsurvey = 1 
              OR sus.selqstnssection = -1 ) 
GROUP  BY mw.scheduledmailing_id, 
          mw.samplepop_id, 
          mw.survey_id, 
          sus.selqstnssection, 
          mw.bitmockup, 
          mw.mailingstep_id 

CREATE INDEX ndx_temppopsection 
  ON #popsection (samplepop_id, sampleunit_id) 

-- remove records from #PopSection if the section is mapped to a mode other than what is currently being generated.
DELETE ps 
--select ps.survey_id as GeneratingSurvey 
--, ps.section_id as GeneratingSection_id 
--, ms.MailingStepMethod_id as GeneratingMode_id 
--, msm.MailingStepMethod_id as MappedMode_id 
--, msm.MailingStepMethod_nm as MappedMode_nm 
--, msm.Section_Id as MappedSection_ID 
--, msm.SectionLabel as MappedSection_nm 
FROM   #popsection ps 
       INNER JOIN mailingstep ms 
               ON ps.mailingstep_id = ms.mailingstep_id 
       INNER JOIN modesectionmapping msm 
               ON ps.survey_id = msm.survey_id 
                  AND ps.section_id = msm.section_id 
WHERE  ms.mailingstepmethod_id <> msm.mailingstepmethod_id 

-- Which Cover letter do they need? 
SELECT mw.scheduledmailing_id, 
       mw.samplepop_id, 
       mw.survey_id, 
       mw.selcover_id, 
       0 AS Langid 
INTO   #popcover 
FROM   #fg_mailingwork mw 

DECLARE @BVJoin VARCHAR(255), @SQL VARCHAR(max), @AllBVFields VARCHAR(max)
DECLARE @SQL2 VARCHAR(max), @SQL3 VARCHAR(max), @SQL4 VARCHAR(max)
DECLARE @SexCol VARCHAR(50), @AgeCol VARCHAR(50), @Group_IndvCol VARCHAR(50)

-- Added 1/22/04 SS (Get todays date to substitute for actual date when generating a mockup test print)
DECLARE @MockDate CHAR(8)
SET @MockDate = CONVERT(VARCHAR,GETDATE(),112)

-- get data FROM Big_View & Unikeys
--SELECT @BVJoin='uk.Table_id='+CONVERT(VARCHAR,Table_id)+' AND uk.KeyValue=bv.Encounterenc_id'
SELECT @BVJoin='ss.Enc_id=bv.EncounterEnc_id'
FROM MetaTable
WHERE Study_id=@Study
AND strTable_nm='Encounter'

IF @BVJoin IS NULL 
  -- SELECT @BVJoin='uk.Table_id='+CONVERT(VARCHAR,Table_id)+' AND uk.KeyValue=bv.PopulationPop_id' 
  SELECT @BVJoin = 'ss.Pop_id=bv.PopulationPop_id' 
  FROM   metatable 
  WHERE  study_id = @Study 
         AND strtable_nm = 'Population' 

--CREATE TABLE #BVUK (SampleSet_id INT, SampleUnit_id INT, Pop_id INT, Table_id INT, keyvalue int)
CREATE TABLE #BVUK (SampleSet_id INT, SampleUnit_id INT, Pop_id INT)
SET @AllBVFields=''
DECLARE curBVFields CURSOR FOR
SELECT DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, COLUMN_NAME
FROM	INFORMATION_SCHEMA.COLUMNS
WHERE	TABLE_SCHEMA = 's'+CONVERT(VARCHAR,@Study) and
		TABLE_NAME = 'Big_view'

DECLARE @type Varchar(15), @fld_nm VARCHAR(100), @len INT
OPEN curBVFields
FETCH next FROM curbvfields INTO @type, @len, @fld_nm 

WHILE @@FETCH_STATUS = 0 
  BEGIN 
      SET @SQL='ALTER TABLE #BVUK ADD ' + @fld_nm 

      IF @type = 'INT' 
        SET @SQL=@SQL + ' INTEGER' 
      ELSE IF @type = 'DATETIME' 
        SET @SQL=@SQL + ' DATETIME' 
      ELSE 
        SET @SQL=@SQL + ' VARCHAR(' + CONVERT(VARCHAR, @len) + ')' 

      EXEC (@SQL) 

      SET @AllBVFields=@AllBVFields + ', ' + @fld_nm 

      FETCH next FROM curbvfields INTO @type, @len, @fld_nm 
  END 
CLOSE curBVFields
DEALLOCATE curBVFields

SELECT @SexCol=strTable_nm+strField_nm
FROM MetaTable mt, MetaStructure ms, MetaField mf
WHERE mt.Table_id= ms.Table_id
  AND ms.Field_id=mf.Field_Id
  AND mt.Study_id= @Study
  AND mf.strField_nm='Sex'
  AND mt.strTable_nm = 'Population'

SELECT @AgeCol=strTable_nm+strField_nm
FROM MetaTable mt, MetaStructure ms, MetaField mf
WHERE mt.Table_id= ms.Table_id
  AND ms.Field_id=mf.Field_Id
  AND mt.Study_id= @Study
  AND mf.strField_nm='Age'
  AND mt.strTable_nm = 'Population'

SELECT @Group_IndvCol=strTable_nm+strField_nm
FROM MetaTable mt, MetaStructure ms, MetaField mf
WHERE mt.Table_id= ms.Table_id
  AND ms.Field_id=mf.Field_Id
  AND mt.Study_id= @Study
  AND mf.strField_nm ='Group_Indv'


IF @SexCol IS NULL 
  BEGIN 
      ALTER TABLE #bvuk ADD sex__ CHAR(1) DEFAULT 'M' 
      SET @SexCol='Sex__' 
  END 

IF @AgeCol IS NULL
  BEGIN 
      ALTER TABLE #BVUK ADD Age__ CHAR(1) DEFAULT 30
      SET @AgeCol='Age__'
  END 

IF @Group_IndvCol IS NULL
  BEGIN
      ALTER TABLE #BVUK ADD Group_Indv__ CHAR(1) DEFAULT 'G'
      SET @Group_IndvCol='Group_Indv__'
  END


--Start of Modification 6/1/4 BD
IF @bitTP = 0
  BEGIN
      SET @SQL='SELECT mw.sampleset_id, ps.sampleunit_id, mw.pop_id 
      INTO   #abc 
      FROM   #fg_mailingwork mw, #popsection ps 
      WHERE  mw.samplepop_id = ps.samplepop_id 

      SELECT t.sampleset_id, t.sampleunit_id, t.pop_id, ss.enc_id 
      INTO   #abcd 
      FROM   #abc t, selectedsample ss 
      WHERE  t.sampleset_id = ss.sampleset_id 
             AND t.pop_id = ss.pop_id 
             AND t.sampleunit_id = ss.sampleunit_id 

      INSERT INTO #bvuk (sampleset_id, sampleunit_id, pop_id'+@allbvfields+') 
      SELECT ss.sampleset_id, ss.sampleunit_id, ss.pop_id'+@allbvfields+' 
      FROM   #abcd ss, s'+CONVERT(VARCHAR,@Study)+'.big_view bv 
      WHERE  '+@bvjoin+'

      DROP TABLE #abc 
      DROP TABLE #abcd'
  END

IF @bitTP = 1
  BEGIN
      SET @SQL='SELECT mw.sampleset_id, ps.sampleunit_id, mw.pop_id 
      INTO   #abc 
      FROM   #fg_mailingwork mw, #popsection ps 
      WHERE  mw.samplepop_id = ps.samplepop_id 
             AND mw.bitmockup = ps.bitmockup 

      SELECT t.sampleset_id, t.sampleunit_id, t.pop_id, ss.enc_id 
      INTO   #abcd 
      FROM   #abc t, selectedsample ss 
      WHERE  t.sampleset_id = ss.sampleset_id 
             AND t.pop_id = ss.pop_id 
             AND t.sampleunit_id = ss.sampleunit_id 

      INSERT INTO #bvuk (sampleset_id, sampleunit_id, pop_id'+@allbvfields+') 
      SELECT ss.sampleset_id, ss.sampleunit_id, ss.pop_id'+@allbvfields+' 
      FROM   #abcd ss, s'+CONVERT(VARCHAR,@Study)+'.big_view bv 
      WHERE  '+@bvjoin+' 

      DROP TABLE #abc 
      DROP TABLE #abcd'
  END
--End of Modification 6/1/4 BD

EXEC (@SQL)

IF CHARINDEX('Enc_id',@BVJoin)>0
  CREATE INDEX ndx_tempBigView ON #BVUK (PopulationPop_id, Encounterenc_id, SampleUnit_id)
ELSE
  CREATE INDEX ndx_tempBigView ON #BVUK (PopulationPop_id, SampleUnit_id)

-- UPDATE Langid in #FG_MailingWork, #popSection AND #popCover
-- modified 7/18/02 JC use MailingStep.override_Langid if it has been set
-- modified 2/2/04 SS - Skip UPDATE mw section when processing a testprint (want to use specified language NOT BV.LANGID)

IF @bitTP = 0 
  BEGIN 
      UPDATE mw 
      SET    langid = bv.populationlangid 
      FROM   #fg_mailingwork mw, #bvuk bv 
      WHERE  mw.pop_id = bv.pop_id 
             AND mw.sampleset_id = bv.sampleset_id 

      UPDATE mw 
      SET    langid = ms.override_langid 
      FROM   #fg_mailingwork mw, mailingstep ms 
      WHERE  mw.mailingstep_id = ms.mailingstep_id 
             AND ms.override_langid IS NOT NULL 

      UPDATE mw 
      SET    langid = 1 
      FROM   #fg_mailingwork mw 
      LEFT OUTER JOIN surveylanguage sl 
             ON mw.langid = sl.langid AND mw.survey_id = sl.survey_id 
      WHERE  sl.langid IS NULL 
  END 

UPDATE ps 
SET    langid = mw.langid 
FROM   #popsection ps, #fg_mailingwork mw 
WHERE  mw.scheduledmailing_id = ps.scheduledmailing_id 
--AND mw.Survey_id=@Survey 

UPDATE pc 
SET    langid = mw.langid 
FROM   #popcover pc, #fg_mailingwork mw 
WHERE  mw.scheduledmailing_id = pc.scheduledmailing_id 
--AND mw.Survey_id=@Survey 

CREATE INDEX ndx_tempPopSection2 ON #PopSection (Survey_id, Section_id, Langid)

-- What are the Code values needed?
CREATE TABLE #PopCode (ScheduledMailing_id INT, SamplePop_id INT, Survey_id INT, SampleUnit_id INT, Language INT,
     Code INT, Age CHAR(1), sex CHAR(1), doctor CHAR(1), Codetext_id INT, Codetext VARCHAR(255), bitUseNurse BIT, bitMockup BIT)
INSERT INTO #PopCode
SELECT DISTINCT ps.ScheduledMailing_id, ps.SamplePop_id, ps.Survey_id, ps.SampleUnit_id, sq.Language, cq.Code, NULL, NULL, NULL, NULL, NULL, 0, ps.bitMockup
FROM #PopSection ps, PCL_Qstns sq, CodeQstns cq
WHERE ps.Survey_id=sq.Survey_id
  AND ps.Section_id=sq.Section_id
  AND ps.Langid=sq.Language
  AND sq.SelQstns_id=cq.SelQstns_id
  AND sq.Survey_id=cq.Survey_id
  AND sq.Language=cq.Language
UNION
SELECT DISTINCT ps.ScheduledMailing_id, ps.SamplePop_id, ps.Survey_id, ps.SampleUnit_id, sq.Language, cs.Code, NULL, NULL, NULL, NULL, NULL, 0, ps.bitMockup
FROM #PopSection ps, PCL_Qstns sq, CodeScls cs
WHERE ps.Survey_id=sq.Survey_id
  AND ps.Section_id=sq.Section_id
  AND ps.Langid=sq.Language
  AND sq.Scaleid=cs.QPC_id
  AND sq.Survey_id=cs.Survey_id
  AND sq.Language=cs.Language
  AND sq.SubType=1
UNION
-- Modified 2/26/2 BD added UNION to eliminate duplicate Codes between Cover letter AND questionaire
--INSERT INTO #PopCode
SELECT DISTINCT mw.ScheduledMailing_id, mw.SamplePop_id, mw.Survey_id, su.SampleUnit_id, mw.Langid, ctb.Code, NULL, NULL, NULL, NULL, NULL, 0, mw.bitMockup
FROM #FG_MailingWork mw, PCL_TextBox st, CodeTxtBox ctb, SamplePlan sp, SampleUnit su
WHERE mw.Survey_id=st.Survey_id
AND mw.Langid=st.Language
AND mw.SelCover_id=st.Coverid
AND st.QPC_id=ctb.QPC_id
AND st.Survey_id=ctb.Survey_id
AND st.Language=ctb.Language
AND st.Survey_id=sp.Survey_id
AND sp.SamplePlan_id=su.SamplePlan_id
AND su.ParentSampleUnit_id IS NULL
--AND mw.Survey_id=@Survey


CREATE INDEX ndx_temppopCode ON #PopCode (SamplePop_id,SampleUnit_id)

-- Remove people who do not have entries in Unikeys.
SELECT DISTINCT ps.samplepop_id 
INTO   #sp 
FROM   #popsection ps 
       LEFT OUTER JOIN (SELECT samplepop_id, sampleunit_id 
                        FROM   #bvuk b, samplepop sp 
                        WHERE  b.sampleset_id = sp.sampleset_id 
                               AND b.pop_id = sp.pop_id) b2 
                    ON ps.samplepop_id = b2.samplepop_id 
                       AND ps.sampleunit_id = b2.sampleunit_id 
WHERE  b2.sampleunit_id IS NULL 

-- Mod 1/20/04 SS (Log TestPrints to different FormGenError Log)
IF @bitTP = 0
  BEGIN
      INSERT INTO FormGenError (ScheduledMailing_id, datGenerated, FGErrorType_id)
      SELECT DISTINCT ScheduledMailing_id, GETDATE(), 36
      FROM #popSection ps, #sp sp
      WHERE sp.SamplePop_id=ps.SamplePop_id
  END
  
IF @bitTP = 1
  BEGIN
      INSERT INTO FormGenError_TP (TP_id, datGenerated, FGErrorType_id)
      SELECT DISTINCT ScheduledMailing_id, GETDATE(), 36
      FROM #popSection ps, #sp sp
      WHERE sp.SamplePop_id=ps.SamplePop_id
  END

DELETE ps
FROM #popSection ps, #sp sp
WHERE sp.SamplePop_id=ps.SamplePop_id

DELETE pc
FROM #popCover pc, #sp sp
WHERE sp.SamplePop_id=pc.SamplePop_id

DELETE pc
FROM #popCode pc, #sp sp
WHERE sp.SamplePop_id=pc.SamplePop_id

DELETE fm
FROM #FG_MailingWork fm, #sp sp
WHERE fm.SamplePop_id=sp.SamplePop_id
-- End of Addition


SET @SQL=
'UPDATE pc 
SET    age = CASE 
               WHEN bvuk.'+@agecol+' < 18 THEN ''M'' 
               ELSE ''A'' 
             END, 
       sex = CASE 
               WHEN bvuk.'+@sexcol+' = ''M'' THEN ''M'' 
               ELSE ''F'' 
             END, 
       doctor = CASE 
                  WHEN bvuk.'+@group_indvcol+' = ''G'' THEN ''G'' 
                  ELSE ''D'' 
                END 
FROM   #popcode pc, #fg_mailingwork mw, #bvuk bvuk 
WHERE  pc.samplepop_id = mw.samplepop_id 
       AND mw.pop_id = bvuk.populationpop_id 
       AND pc.sampleunit_id = bvuk.sampleunit_id'
EXEC (@SQL)

-- minor exception rule
SELECT DISTINCT sd.Survey_id
INTO #S
FROM Survey_def sd, BusinessRule br
WHERE sd.Study_id=@Study
AND sd.Survey_id=br.Survey_id
AND sd.bitMinor_Except_flg=1
AND br.BusRule_cd='M'

SELECT TOP 1 @Survey=Survey_id FROM #S

--  MODIFIED 8/27/04 BD/SS FIX for Minor Exception Rule -- Added suvey_id = mw.survey_id in dynamic sql statement (approx Ln 416)
--IF @@ROWCOUNT >0
WHILE @@ROWCOUNT > 0 
  BEGIN 
      INSERT INTO #criters (criteriastmt_id) 
      SELECT criteriastmt_id 
      FROM   businessrule 
      WHERE  busrule_cd = 'M' 
             AND survey_id = @Survey 

      EXEC Sp_criteriastatements2 1 

      SELECT @SQL = strcriteriastmt 
      FROM   #criters 

      SET @SQL= '
      UPDATE pc 
      SET    age="A" 
      FROM   #popcode pc, #fg_mailingwork mw, #bvuk bv 
      WHERE  pc.samplepop_id=mw.samplepop_id 
      AND    mw.pop_id=bv.populationpop_id 
      AND    pc.sampleunit_id=bv.sampleunit_id 
      AND    mw.survey_id = ' + convert(varchar,@survey) + ' 
      AND    ( '+@sql+')' 

      EXEC (@SQL) 

      TRUNCATE TABLE #criters 

      DELETE #s 
      WHERE  survey_id = @Survey 

      SELECT TOP 1 @Survey = survey_id 
      FROM   #s 
  END 

UPDATE pc
SET CodeText=ct.QPC_Text, Codetext_id=ct.Codetext_id
FROM #PopCode pc, Codestext ct
WHERE pc.Code=ct.Code
AND pc.age=ISNULL(ct.age,pc.age)
AND pc.sex=ISNULL(ct.sex,pc.sex)
AND pc.doctor=ISNULL(ct.doctor,pc.doctor)

/*------------------------------------------*/

-- Proposed changes: 1/22/04 SS
/*
Select cursor curtag inpput dat into #curtag table first
Then update #curtag PerInfo source data field with tagfield.tag_dsc when bitmockup = 1
Last Create cursor curtag from #curtag temporary table
Proceed as previously coded.
*/

SELECT DISTINCT ctt.codetext_id, 
                ctt.intstartpos, 
                ctt.intlength, 
                'bvuk.' + mt.strtable_nm + mf.strfield_nm strFieldInfo, 
                mf.strfield_nm, 
                CASE 
                  WHEN @bitTP = 0 THEN NULL 
                  ELSE pc.bitmockup 
                END                                       AS bitMockup 
INTO   #curtag 
FROM   #popcode pc, 
       codetexttag ctt, 
       tagfield tf, 
       metatable mt, 
       metafield mf 
WHERE  pc.codetext_id = ctt.codetext_id 
       AND ctt.tag_id = tf.tag_id 
       AND tf.study_id = @Study 
       AND tf.table_id = mt.table_id 
       AND tf.field_id = mf.field_id 
       AND mf.strfielddatatype = 'S' 
UNION 
SELECT DISTINCT ctt.codetext_id, 
                ctt.intstartpos, 
                ctt.intlength, 
                'CONVERT(VARCHAR,bvuk.' + mt.strtable_nm + mf.strfield_nm + ')' strFieldInfo, 
                mf.strfield_nm, 
                pc.bitmockup 
FROM   #popcode pc, 
       codetexttag ctt, 
       tagfield tf, 
       metatable mt, 
       metafield mf 
WHERE  pc.codetext_id = ctt.codetext_id 
       AND ctt.tag_id = tf.tag_id 
       AND tf.study_id = @Study 
       AND tf.table_id = mt.table_id 
       AND tf.field_id = mf.field_id 
       AND mf.strfielddatatype = 'I' 
UNION
SELECT DISTINCT ctt.codetext_id, 
                ctt.intstartpos, 
                ctt.intlength, 
                CASE  WHEN pc.bitMockup = 1 THEN
                   'datename(month,'+''''+@MockDate+''''+')+'' ''+CONVERT(VARCHAR,day('+''''+@MockDate+''''+'))+'', ''++CONVERT(VARCHAR,year('+''''+@MockDate+''''+'))'
                ELSE
                   'datename(month,bvuk.'+mt.strTable_nm+mf.strField_nm+')+'' ''+CONVERT(VARCHAR,day(bvuk.'+mt.strTable_nm+mf.strField_nm+'))+'', ''+CONVERT(VARCHAR,year(bvuk.'+mt.strTable_nm+mf.strField_nm+'))'
                END strFieldInfo, 
                mf.strfield_nm, 
                pc.bitmockup 
FROM   #popcode pc, 
       codetexttag ctt, 
       tagfield tf, 
       metatable mt, 
       metafield mf 
WHERE  pc.codetext_id = ctt.codetext_id 
       AND ctt.tag_id = tf.tag_id 
       AND tf.study_id = @Study 
       AND tf.table_id = mt.table_id 
       AND tf.field_id = mf.field_id 
       AND mf.strfielddatatype = 'D' 
UNION
SELECT DISTINCT ctt.codetext_id, 
                ctt.intstartpos, 
                ctt.intlength, 
                '"' + tf.strreplaceliteral + '"', 
                NULL, 
                pc.bitmockup 
FROM   #popcode pc, 
       codetexttag ctt, 
       tagfield tf 
WHERE  pc.codetext_id = ctt.codetext_id 
       AND ctt.tag_id = tf.tag_id 
       AND tf.study_id = @Study 
       AND tf.table_id IS NULL 
ORDER  BY ctt.codetext_id, intstartpos DESC 


UPDATE #curtag 
SET    strfieldinfo = + '''' + t2.tag_dsc + '''' 
FROM   #curtag, 
       (SELECT DISTINCT mf.strfield_nm, t.tag_dsc 
        FROM   codeqstns cq, 
               PCL_qstns sq, 
               survey_def sd, 
               codes c, 
               codestext ct, 
               codetexttag ctt, 
               tag t, 
               tagfield tf, 
               metafield mf 
        WHERE  cq.selqstns_id = sq.selqstns_id 
               AND cq.survey_id = sq.survey_id 
               AND sd.study_id = @study 
               AND cq.survey_id = sd.survey_id 
               AND cq.language = sq.language 
               AND sq.language = 1 
               AND sq.section_id = -1 
               AND sq.subsection = 1 
               AND sq.subtype = 6 -- and sq.label='Address information' 
               AND cq.code = c.code 
               AND c.code = ct.code 
               AND ct.codetext_id = ctt.codetext_id 
               AND ctt.tag_id = t.tag_id 
               AND ctt.tag_id = tf.tag_id 
               AND tf.study_id = sd.study_id 
               AND tf.field_id = mf.field_id) t2 
WHERE  #curtag.strfield_nm = t2.strfield_nm 
       AND bitmockup = 1 
/*------------------------------------------*/

DECLARE @CT_id INT, @Start INT, @Length INT, @Field_nm VARCHAR(255), @bitMockup BIT
IF @bitTP = 0 
  BEGIN 
      DECLARE curtag CURSOR FOR 
        SELECT codetext_id, intstartpos, intlength, strfieldinfo 
        FROM   #curtag 
      OPEN curtag 

      FETCH next FROM curtag INTO @CT_id, @Start, @Length, @Field_nm 

      WHILE @@FETCH_STATUS = 0 
        BEGIN 
            SET @SQL= 'SET QUOTED_IDENTIFIER OFF    
            UPDATE pc    
            SET Codetext = LEFT(pc.CodeText,'+ CONVERT(VARCHAR, @Start-1) + ')+ISNULL(' + @Field_nm + ','''')+SUBSTRING(pc.CodeText,' + CONVERT(VARCHAR, @Start+@Length) + ',255)    
            FROM #PopCode pc, #FG_MailingWork mw, #BVUK bvuk    
            WHERE pc.SamplePop_id=mw.SamplePop_id
              AND mw.Pop_id=bvuk.PopulationPop_id
              AND mw.SampleSet_ID = bvuk.SampleSet_ID
              AND pc.SampleUnit_id=bvuk.SampleUnit_id
              AND pc.CodeText_id=' + CONVERT(VARCHAR, @CT_id)
            EXEC (@SQL) 

            FETCH next FROM curtag INTO @CT_id, @Start, @Length, @Field_nm 
        END 

      CLOSE curtag 
      DEALLOCATE curtag 
  END 
  
IF @bitTP = 1 
  BEGIN 
      DECLARE curtag CURSOR FOR 
        SELECT codetext_id, intstartpos, intlength, strfieldinfo, bitmockup 
        FROM   #curtag 

      OPEN curtag 
      FETCH next FROM curtag INTO @CT_id, @Start, @Length, @Field_nm, @bitMockup 

      WHILE @@FETCH_STATUS = 0 
        BEGIN 
            SET @SQL=  
             'SET QUOTED_IDENTIFIER OFF
              UPDATE pc
              SET Codetext=LEFT(pc.CodeText,'+CONVERT(VARCHAR,@Start-1)+')+ISNULL('+@Field_nm+','''')+SUBSTRING(pc.CodeText,'+CONVERT(VARCHAR,@Start+@Length)+',255)
              FROM #PopCode pc, #FG_MailingWork mw, #BVUK bvuk
              WHERE pc.SamplePop_id=mw.SamplePop_id
                AND mw.Pop_id=bvuk.PopulationPop_id
                AND mw.SampleSet_ID = bvuk.SampleSet_ID
                AND pc.SampleUnit_id=bvuk.SampleUnit_id 
                AND pc.CodeText_id='+CONVERT(VARCHAR,@CT_id) + '
                AND pc.bitMockup = mw.bitMockup 
                AND pc.bitMockup = ' + STR(@bitMockup,1,0)
            EXEC (@SQL) 

            FETCH next FROM curtag INTO @CT_id, @Start, @Length, @Field_nm, 
            @bitMockup 
        END 

      CLOSE curtag 
      DEALLOCATE curtag 
  END 


/*------------------------------------------*/

--Modified 2/29/2 BD This will remove the dash FROM the address line if Zip4 IS NULL
UPDATE #PopCode
set CodeText=case when PatIndex('%-',CodeText)=Len(CodeText) then Left(CodeText,(Len(CodeText)-1)) else CodeText end
WHERE Code=30

-- Modified 3/29/04 SS - Replaces Male fname with femanle fname for mockups (bitMockup = 1) and sex = 'F'
UPDATE #PopCode 
SET codetext = REPLACE(codetext,'Christopher','Christina') 
WHERE bitMockup = 1 AND sex = 'F'

--  INSERT INTO SS_POPCODE SELECT *  FROM #POPCODE

/*------------------------------------------*/      /*------------------------------------------*/      /*------------------------------------------*/
/*------------------------------------------*/      /*------------------------------------------*/      /*------------------------------------------*/


BEGIN TRANSACTION
DECLARE @GetDate DATETIME
SELECT @GetDate=GETDATE()

-- MOD 1/20/04 SS (Flow Logic for Production = 0 / Ttest prints = 1)
IF @bitTP = 0 
  BEGIN 
      -- Add to SentMailing 
      INSERT INTO sentmailing (datgenerated, methodology_id, scheduledmailing_id, langid, questionnairetype_id) 
      SELECT @GetDate, methodology_id, scheduledmailing_id, langid, questionnairetype_id 
      FROM   #fg_mailingwork 

      --WHERE #FG_MailingWork.Survey_id=@Survey 
      IF @@ERROR <> 0 
        BEGIN 
            ROLLBACK TRANSACTION 
            INSERT INTO formgenerror (scheduledmailing_id, datgenerated, fgerrortype_id) 
            SELECT scheduledmailing_id, Getdate(), 3 
            FROM   #fg_mailingwork 

            TRUNCATE TABLE #fg_mailingwork 
            RETURN 
        END 

      SELECT DISTINCT survey_id 
      INTO   #tt 
      FROM   #fg_mailingwork 

      SELECT TOP 1 @Survey = survey_id FROM #tt 

      WHILE @@ROWCOUNT > 0 
        BEGIN 
            --We will generate the skip pattern information for all outgo, even postcards because of Canada. 
            EXEC Sp_fg_populateskippatterns @Survey, @GetDate 

            DELETE #tt WHERE survey_id = @Survey 

            SELECT TOP 1 @Survey = survey_id FROM #tt 
        END 

      IF @@ERROR <> 0 
        BEGIN 
            ROLLBACK TRANSACTION 
            INSERT INTO formgenerror (scheduledmailing_id, datgenerated, fgerrortype_id) 
            SELECT scheduledmailing_id, Getdate(), 3 
            FROM   #fg_mailingwork 

            TRUNCATE TABLE #fg_mailingwork 
            RETURN 
        END 

      -- UPDATE ScheduledMailing with new SentMail_id's 
      UPDATE scheduledmailing 
      SET    sentmail_id = SM.sentmail_id 
      FROM   sentmailing SM, 
             scheduledmailing SC 
      WHERE  SM.scheduledmailing_id = SC.scheduledmailing_id 
             AND SC.sentmail_id IS NULL 

      IF @@ERROR <> 0 
        BEGIN 
            ROLLBACK TRANSACTION 

            INSERT INTO formgenerror (scheduledmailing_id, datgenerated, fgerrortype_id) 
            SELECT scheduledmailing_id, Getdate(), 3 
            FROM   #fg_mailingwork 

            TRUNCATE TABLE #fg_mailingwork 

            RETURN 
        END 

      --Start of Modification BD 9/13/4 
      --Save off the bundling code fields 
      CREATE TABLE #bundlingcodecolumns (needcolumn VARCHAR(60), hascolumn  BIT) 

      INSERT INTO #bundlingcodecolumns (needcolumn, hascolumn) 
      SELECT 'POPULATION' + strfield_nm, 0 
      FROM   metafield 
      WHERE  strfield_nm IN ( 'Zip5', 'Zip4', 'Postal_Code' ) 

      --What columns do we have? 
      UPDATE t 
      SET    t.hascolumn = 1 
      FROM   #bundlingcodecolumns t, 
             tempdb.dbo.syscolumns sc 
      WHERE  sc.id = Object_id('TempDB.dbo.#BVUK') 
             AND t.needcolumn = sc.NAME 

      SELECT @SQL = 'schm.SentMail_id' 

      SELECT @SQL = @SQL 
				+ CASE hascolumn 
                    WHEN 1 THEN ','+needcolumn 
                    ELSE        ',NULL' 
                  END 
      FROM   #bundlingcodecolumns 
      ORDER  BY needcolumn DESC 

      SELECT @SQL = 'INSERT INTO BundlingCodes  
      SELECT DISTINCT ' + @SQL + '
      FROM #BVUK b, #FG_MailingWork f, ScheduledMailing schm  
      WHERE f.SampleSet_id=b.SampleSet_id
        AND f.Pop_id=b.PopulationPop_id
          AND f.ScheduledMailing_id=schm.ScheduledMailing_id' 

      --  SELECT * FROM #BVUK 
      --  PRINT @SQL 
      EXEC (@SQL) 

      IF @@ERROR <> 0 
        BEGIN 
            ROLLBACK TRANSACTION 

            INSERT INTO formgenerror (scheduledmailing_id, datgenerated, fgerrortype_id) 
            SELECT scheduledmailing_id, Getdate(), 38 
            FROM   #fg_mailingwork 

            TRUNCATE TABLE #fg_mailingwork 
            RETURN 
        END 

      --End of Modification BD 9/13/4 
      SELECT @MaxQF = Max(questionform_id) 
      FROM   dbo.questionform 

      -- Add to QuestionForm 
      INSERT INTO questionform (sentmail_id, samplepop_id, survey_id) 
      SELECT SC.sentmail_id, SC.samplepop_id, MW.survey_id 
      FROM   scheduledmailing SC, #fg_mailingwork MW 
      WHERE  SC.scheduledmailing_id = MW.scheduledmailing_id 
             AND MW.bitsendsurvey = 1 --AND MW.Survey_id=@Survey 
      IF @@ERROR <> 0 
        BEGIN 
            ROLLBACK TRANSACTION 

            INSERT INTO formgenerror (scheduledmailing_id, datgenerated, fgerrortype_id) 
            SELECT scheduledmailing_id, Getdate(), 3 
            FROM   #fg_mailingwork 

            TRUNCATE TABLE #fg_mailingwork 
            RETURN 
        END 

      EXEC dbo.Calccahpssupplemental @MaxQF 

      -- Only want to schedule the next ungenerated record 
      INSERT INTO scheduledmailing (mailingstep_id, samplepop_id, methodology_id, datgenerate) 
      SELECT mw.nextmailingstep_id, mw.samplepop_id, mw.methodology_id, 
             CONVERT(DATETIME, '12/31/4172') 
      FROM   #fg_mailingwork mw 
             LEFT OUTER JOIN #fg_mailingwork mw2 
                          ON mw.nextmailingstep_id = mw2.mailingstep_id 
                             AND mw.samplepop_id = mw2.samplepop_id 
      WHERE  mw.nextmailingstep_id IS NOT NULL 
             AND mw.overrideitem_id IS NULL 
             AND mw2.mailingstep_id IS NULL 

      IF @@ERROR <> 0 
        BEGIN 
            ROLLBACK TRANSACTION 

            INSERT INTO formgenerror (scheduledmailing_id, datgenerated, fgerrortype_id) 
            SELECT scheduledmailing_id, Getdate(), 3 
            FROM   #fg_mailingwork 

            TRUNCATE TABLE #fg_mailingwork 
            RETURN 
        END 

      INSERT INTO fgpopsection (sentmail_id, survey_id, sampleunit_id, section_id, langid) 
      SELECT sentmail_id, survey_id, sampleunit_id, section_id, langid 
      FROM   #popsection p, 
             scheduledmailing schm 
      WHERE  p.scheduledmailing_id = schm.scheduledmailing_id 

      IF @@ERROR <> 0 
        BEGIN 
            ROLLBACK TRANSACTION 

            INSERT INTO formgenerror (scheduledmailing_id, datgenerated, fgerrortype_id) 
            SELECT scheduledmailing_id, Getdate(), 3 
            FROM   #fg_mailingwork 

            TRUNCATE TABLE #fg_mailingwork 
            RETURN 
        END 

      INSERT INTO fgpopcover (sentmail_id, survey_id, selcover_id, langid) 
      SELECT sentmail_id, survey_id, selcover_id, langid 
      FROM   #popcover p, 
             scheduledmailing schm 
      WHERE  p.scheduledmailing_id = schm.scheduledmailing_id 

      IF @@ERROR <> 0 
        BEGIN 
            ROLLBACK TRANSACTION 

            INSERT INTO formgenerror (scheduledmailing_id, datgenerated, fgerrortype_id) 
            SELECT scheduledmailing_id, Getdate(), 3 
            FROM   #fg_mailingwork 

            TRUNCATE TABLE #fg_mailingwork 
            RETURN 
        END 

      INSERT INTO fgpopcode (sentmail_id, survey_id, sampleunit_id, language, code, codetext) 
      SELECT sentmail_id, survey_id, sampleunit_id, language, code, codetext 
      FROM   #popcode p, scheduledmailing schm 
      WHERE  p.scheduledmailing_id = schm.scheduledmailing_id 

      IF @@ERROR <> 0 
        BEGIN 
            ROLLBACK TRANSACTION 

            INSERT INTO formgenerror (scheduledmailing_id, datgenerated, fgerrortype_id) 
            SELECT scheduledmailing_id, Getdate(), 3 
            FROM   #fg_mailingwork 

            TRUNCATE TABLE #fg_mailingwork 
            RETURN 
        END 
  END 
  
IF @bitTP = 1 
  BEGIN 
      -- UPDATE Scheduled_TP with bitDone = 1 
      UPDATE SC 
      SET    sc.bitdone = 1 
      FROM   #fg_mailingwork mw, scheduled_tp SC 
      WHERE  mw.scheduledmailing_id = SC.tp_id 
             AND SC.bitdone = 0 

      IF @@ERROR <> 0 
        BEGIN 
            ROLLBACK TRANSACTION 

            INSERT INTO formgenerror_tp (tp_id, datgenerated, fgerrortype_id) 
            -- Changed the log file to FormGenError_TP from FormGenError / SJS 7/21/04 
            SELECT scheduledmailing_id, Getdate(), 3 
            FROM   #fg_mailingwork 

            TRUNCATE TABLE #fg_mailingwork 
            RETURN 
        END 

      INSERT INTO fgpopsection_tp (tp_id, survey_id, sampleunit_id, section_id, langid) 
      SELECT scheduledmailing_id, survey_id, sampleunit_id, section_id, langid 
      FROM   #popsection 

      IF @@ERROR <> 0 
        BEGIN 
            ROLLBACK TRANSACTION 

            INSERT INTO formgenerror_tp (tp_id, datgenerated, fgerrortype_id) 
            SELECT scheduledmailing_id, Getdate(), 3 
            FROM   #fg_mailingwork 

            TRUNCATE TABLE #fg_mailingwork 
            RETURN 
        END 

      INSERT INTO fgpopcover_tp (tp_id, survey_id, selcover_id, langid) 
      SELECT scheduledmailing_id, survey_id, selcover_id, langid 
      FROM   #popcover 

      IF @@ERROR <> 0 
        BEGIN 
            ROLLBACK TRANSACTION 

            INSERT INTO formgenerror_tp (tp_id, datgenerated, fgerrortype_id) 
            SELECT scheduledmailing_id, Getdate(), 3 
            FROM   #fg_mailingwork 

            TRUNCATE TABLE #fg_mailingwork 
            RETURN 
        END 

      INSERT INTO fgpopcode_tp (tp_id, survey_id, sampleunit_id, language, code, codetext) 
      SELECT scheduledmailing_id, survey_id, sampleunit_id, language, code, codetext 
      FROM   #popcode 

      IF @@ERROR <> 0 
        BEGIN 
            ROLLBACK TRANSACTION 

            INSERT INTO formgenerror_tp (tp_id, datgenerated, fgerrortype_id) 
            SELECT scheduledmailing_id, Getdate(), 3 
            FROM   #fg_mailingwork 

            TRUNCATE TABLE #fg_mailingwork 
            RETURN 
        END 
  END 
  
COMMIT TRANSACTION


--MB 11/19/08
--Update Dataload tables for validation.
--these tables hold a snapshot of what sel_qstns and sel_scles looks like when the survey is generated
IF @bitTP = 0 
  BEGIN 
      SELECT DISTINCT survey_id, sampleset_id 
      INTO   #surveysset 
      FROM   #fg_mailingwork 

      SELECT TOP 1 @Survey = survey_id, @SampleSet = sampleset_id 
      FROM   #surveysset 

      WHILE @@ROWCOUNT > 0 
        BEGIN 
            IF NOT EXISTS (SELECT TOP 1 * 
                           FROM   dl_sel_qstns_bysampleset 
                           WHERE  survey_id = @Survey 
                                  AND sampleset_id = @Sampleset) 
              BEGIN 
                  INSERT INTO dl_sel_qstns_bysampleset 
                              (sampleset_id, 
                               selqstns_id, 
                               survey_id, 
                               language, 
                               scaleid, 
                               section_id, 
                               label, 
                               plusminus, 
                               subsection, 
                               item, 
                               subtype, 
                               width, 
                               height, 
                               richtext, 
                               scalepos, 
                               scaleflipped, 
                               nummarkcount, 
                               bitmeanable, 
                               numbubblecount, 
                               qstncore, 
                               bitlangreview, 
                               strfullquestion) 
                  SELECT @Sampleset AS Sampleset_ID, 
                         selqstns_id, 
                         survey_id, 
                         language, 
                         scaleid, 
                         section_id, 
                         label, 
                         plusminus, 
                         subsection, 
                         item, 
                         subtype, 
                         width, 
                         height, 
                         richtext, 
                         scalepos, 
                         scaleflipped, 
                         nummarkcount, 
                         bitmeanable, 
                         numbubblecount, 
                         qstncore, 
                         bitlangreview, 
                         strfullquestion 
                  FROM   sel_qstns 
                  WHERE  survey_id = @Survey 
              END 

            IF NOT EXISTS (SELECT TOP 1 * 
                           FROM   dl_sel_scls_bysampleset 
                           WHERE  survey_id = @Survey 
                                  AND sampleset_id = @Sampleset) 
              BEGIN 
                  INSERT INTO dl_sel_scls_bysampleset 
                              (sampleset_id, 
                               survey_id, 
                               qpc_id, 
                               item, 
                               language, 
                               val, 
                               label, 
                               richtext, 
                               missing, 
                               charset, 
                               scaleorder, 
                               intresptype) 
                  SELECT @Sampleset AS Sampleset_ID, 
                         survey_id, 
                         qpc_id, 
                         item, 
                         language, 
                         val, 
                         label, 
                         richtext, 
                         missing, 
                         charset, 
                         scaleorder, 
                         intresptype 
                  FROM   sel_scls 
                  WHERE  survey_id = @Survey 
              END 

            IF NOT EXISTS (SELECT TOP 1 * 
                           FROM   dl_sampleunitsection_bysampleset 
                           WHERE  selqstnssurvey_id = @Survey 
                                  AND sampleset_id = @Sampleset) 
              BEGIN 
                  INSERT INTO dl_sampleunitsection_bysampleset 
                              (sampleset_id, 
                               sampleunitsection_id, 
                               sampleunit_id, 
                               selqstnssection, 
                               selqstnssurvey_id) 
                  SELECT @Sampleset AS Sampleset_ID, 
                         sampleunitsection_id, 
                         sampleunit_id, 
                         selqstnssection, 
                         selqstnssurvey_id 
                  FROM   sampleunitsection 
                  WHERE  selqstnssurvey_id = @Survey 
              END 

            DELETE #surveysset 
            WHERE  survey_id = @Survey 
                   AND sampleset_id = @Sampleset 

            SELECT TOP 1 @Survey = survey_id, 
                         @SampleSet = sampleset_id 
            FROM   #surveysset 
        END 
  END --@bitTP=0 


IF @bitTP=0 AND @Survey%10=0
	UPDATE STATISTICS SentMailing

DROP TABLE #PopSection
DROP TABLE #PopCover
DROP TABLE #PopCode
DROP TABLE #criters
DROP TABLE #BVUK
DROP TABLE #Survey
DROP TABLE #S
DROP TABLE #sp
DROP TABLE #curtag

IF (SELECT OBJECT_ID('TempDB.dbo.#BundlingCodeColumns')) IS NOT NULL 
	DROP TABLE #BundlingCodeColumns

SET QUOTED_IDENTIFIER ON
go
commit tran