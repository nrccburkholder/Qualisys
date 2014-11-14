CREATE PROCEDURE [dbo].[sp_TestPrints]    
@survey_id INT, @Sexes CHAR(2)='DC', @Ages CHAR(2)='DC',  -- DC=Don't Care    
@bitSchedule BIT=0, @bitMockup BIT=1, @Languages VARCHAR(20)='1', @covers VARCHAR(20)='',    
@Employee_id INT=0, @eMail VARCHAR(50)=''    
AS    

/*
declare @survey_id INT, @Sexes CHAR(2), @Ages CHAR(2),
@bitSchedule BIT, @bitMockup BIT, @Languages VARCHAR(20), @covers VARCHAR(20),    
@Employee_id INT, @eMail VARCHAR(50)

select @survey_id=11392, @Sexes='DC', @Ages='DC',  
@bitSchedule =1, @bitMockup=1, @Languages ='1', @covers ='1,2',    
@Employee_id =90, @eMail='dgilsdorf@nationalresearch.com'
-- */


DECLARE @SampleSet_id INT, @Study_id INT, @sql VARCHAR(max), @Valid BIT    
    
SELECT @Study_id=Study_id, @Valid=bitValidated_flg    
FROM Survey_def    
WHERE Survey_id=@survey_id    
    
IF @Valid=0    
	RETURN 1    -- survey not validated
    
IF NOT EXISTS (	SELECT *     
				FROM sysobjects     
				WHERE id=object_id(N'[s'+CONVERT(VARCHAR,@Study_id)+'].[Population]')     
				AND OBJECTPROPERTY(id, N'IsTable')=1)    
	RETURN 2    -- study's population table doesn't exist
	
CREATE TABLE #SampleSet (SampleSet_id INT, intcount INT)    
    
SELECT @SampleSet_id=MAX(ss.SampleSet_id)    
FROM SampleSet ss INNER JOIN SamplePop sp ON sp.SampleSet_id=ss.SampleSet_id    
WHERE Survey_id=@survey_id    
    
IF @SampleSet_id IS NULL -- i.e. no samples have been pulled for the Survey yet    
BEGIN    
	RETURN 3    -- no samples have been pulled yet
END    
ELSE     
BEGIN    
	WHILE @SampleSet_id IS NOT NULL     
	BEGIN    
		INSERT INTO #SampleSet    
		SELECT SampleSet_id, COUNT(*)    
		FROM SamplePop    
		WHERE SampleSet_id=@SampleSet_id    
		GROUP BY SampleSet_id    
		 
		IF (SELECT SUM(intCount) FROM #SampleSet)<1000    
		BEGIN    
			SELECT @SampleSet_id=MAX(ss.SampleSet_id)    
			FROM SampleSet ss 
				INNER JOIN SamplePop sp ON sp.SampleSet_id=ss.SampleSet_id    
			WHERE Survey_id=@survey_id    
			AND ss.SampleSet_id NOT IN (SELECT SampleSet_id FROM #SampleSet)    
			AND datSampleCreate_dt>(select max(datChanged)
									from changelog 
									where idname in ('SectionMapping','CoverLetterMapping')
									and property in ('surveyid','Survey_id')
									and actiontype = 'A'
									and newvalue=convert(varchar,@survey_id))
		END 
		ELSE     
			SET @SampleSet_id=NULL    
	END    
END    

CREATE TABLE #UniqueSections (Pop_id INT, SampleSet_id INT, Samplepop_id int, Sections VARCHAR(1000), CoverVariation_id int, intFlag INT)    
    
INSERT INTO #UniqueSections (Pop_id, Sampleset_id, Samplepop_id, Sections, CoverVariation_id, intFlag)
	SELECT DISTINCT Pop_id, sp.SampleSet_id, Samplepop_id, '', 0, 0
	FROM SamplePop sp
		INNER JOIN #SampleSet s ON sp.SampleSet_id=s.SampleSet_id    

SELECT DISTINCT SelQstnsSection, 0 intFlag    
INTO #Sections    
FROM SampleUnitSection sus
	INNER JOIN Sel_Qstns sq ON sus.SelQstnsSurvey_id=sq.Survey_id AND sus.SelQstnsSection=sq.Section_id 
WHERE sus.SelQstnsSurvey_ID=@survey_id     
AND sus.SelQstnsSection>-1    
ORDER BY 1    
    
WHILE @@ROWCOUNT>0    
BEGIN    
	SET @SQL=''    

	SET ROWCOUNT 20    
	UPDATE #Sections SET intFlag=1    
	SET ROWCOUNT 0    

	SELECT @sql=@sql+'    
		UPDATE us
		SET Sections=Sections + '''+RIGHT(CONVERT(CHAR(3),100+SelQstnsSection),2)+' ''    
		FROM #UniqueSections us
		INNER JOIN SelectedSample ss ON us.Pop_id=ss.Pop_id AND us.SampleSet_id=ss.SampleSet_id
		INNER JOIN SampleUnitSection sus ON sus.SampleUnit_id=ss.SampleUnit_id
		INNER JOIN #SampleSet s ON ss.SampleSet_id=s.SampleSet_id
		WHERE sus.SelQstnsSection='+CONVERT(VARCHAR,SelQstnsSection)    
	FROM #Sections    
	WHERE intFlag=1    

	DELETE FROM #Sections WHERE intFlag=1    
	IF @@ROWCOUNT>0 EXEC (@SQL)    
END    
    
DROP TABLE #Sections    
    
SET @sql='SELECT MAX(us.Samplepop_id) samplepop_id 
FROM #UniqueSections us, s'+CONVERT(VARCHAR,@Study_id)+'.Population p
WHERE us.Pop_id=p.Pop_id '    
    
IF @Sexes <> 'DC'     
	SET @SQL=@SQL + 'AND Sex IN ('''+LEFT(@Sexes,1)+''','''+RIGHT(@Sexes,1)+''') '    
IF @Ages <> 'DC'    
	SET @SQL=@SQL + 'AND CASE WHEN Age<18 THEN ''M'' ELSE ''A'' END IN ('''+LEFT(@Ages,1)+''','''+RIGHT(@Ages,1)+''') ' 
    
SET @SQL=@SQL + 'GROUP BY Sections'    
    
IF @Sexes<>'DC' SET @SQL=@SQL+', Sex'    
IF @Ages<>'DC' SET @SQL=@SQL+', CASE WHEN Age<18 THEN ''M'' ELSE ''A'' END'    
    
SET @SQL='UPDATE #UniqueSections SET intFlag=1 WHERE samplepop_id IN ('+@sql+')'    
EXEC (@SQL)    

-- DYNAMIC COVER LETTERS
-- get a list of the survey's current mappings. CoverVariationGetMap adds current Cover_IDs and QPC_IDs (textbox_IDs)
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
exec dbo.CoverVariationGetMap @survey_id

if exists (select * from #CoverLetterItemArtifactUnitMapping where coverItem_id=-1 or Artifact_id=-1 or ArtifactPage_id=-1)
begin
	RAISERROR ('One or more of the named cover letter items or artifacts don''t exist.',15,1)    
	RETURN 8
end

-- get the list of all possible cover letter variations by calling CoverVariationList for each of the survey's Cover Letters 
-- that have one or more items mapped to an artifact	
create table #CoverVariation (CoverVariation_id int identity(101,1), survey_id int, cover_id int)

declare @cover_id int
set @cover_id=0
while @cover_id is not null
begin
	select @cover_id=min(selcover_id) 
	from sel_cover
	where survey_id=@survey_id
	and PageType <> 4
	and SelCover_id not in (select Cover_id from #CoverVariation)
	and Description in (select CoverLetter_Dsc from dbo.CoverLetterItemArtifactUnitMapping where survey_id=@survey_id)

	if @Cover_id is not null
		exec dbo.CoverVariationList @survey_id, @cover_id
end

if exists (	select Sampleunit_id, Cover_id, CoverItem_id, count(distinct Artifact_id) 
			from #CoverLetterItemArtifactUnitMapping map
			group by Sampleunit_id, Cover_id, CoverItem_id
			having count(distinct Artifact_id) > 1)
begin
	/*
	select su.strSampleUnit_nm, map.*
	from #CoverLetterItemArtifactUnitMapping map
	inner join sampleunit su on map.sampleunit_id=su.sampleunit_id
	inner join (select Sampleunit_id, Cover_id, CoverItem_id
				from #CoverLetterItemArtifactUnitMapping map
				group by Sampleunit_id, Cover_id, CoverItem_id
				having count(distinct Artifact_id)>1 ) err
			on map.Sampleunit_id=err.SampleUnit_id and map.Cover_id=err.Cover_id and map.CoverItem_id=err.CoverItem_id
	order by map.cover_id, map.coverItem_id, map.sampleunit_id
	*/
	RAISERROR ('One or more of the named cover letter items are mapped to different artifacts for the same sample unit.',15,1)    
	RETURN 8
end			


-- figure out which cover letter variation each samplepop in #UniqueSections should get
-- get the list off samplepops being considered & join that with sel_covers, to produce a record for each samplepop/cover letter combo.
select distinct samplepop_id, 0 as CoverVariation_id, selcover_id, intFlag
into #spCoverVariation
from #UniqueSections us, sel_cover sc
where sc.survey_id=@survey_id
and sc.selcover_id in (select items from dbo.split(@covers,','))
and sc.pagetype <> 4

-- get the list of all the items that might get swapped out on the cover letter(s) we're examining
select distinct st.survey_id, st.coverid, st.qpc_id --> list of all textboxes on all the cover letters
into #CoverLetterTextboxes
from sel_textbox st
inner join (select distinct selcover_id from #spCoverVariation) mc on st.coverid=mc.selcover_id
inner join #CoverLetterItemArtifactUnitMapping map on st.coverid=map.cover_id and st.qpc_id=map.coveritem_id
where st.survey_id=@survey_id

-- cycle through each item on the cover letters and determine which (if any) artifact each samplepop should use instead.
select mw.samplepop_id, map.Survey_id, map.SampleUnit_id, map.CoverLetterItemType_id
	, mw.selcover_id as CoverID, map.CoverLetter_dsc, map.CoverItem_id, map.CoverLetterItem_label
	, map.ArtifactPage_id, map.Artifact_dsc, map.Artifact_id, map.ArtifactItem_label
into #spArtifactSwap
from #spCoverVariation mw
inner join samplepop sp on mw.samplepop_id=sp.samplepop_id
inner join selectedsample ss on sp.sampleset_id=ss.sampleset_id and sp.pop_id=ss.pop_id
inner join #CoverLetterItemArtifactUnitMapping map on ss.sampleunit_id=map.sampleunit_id and mw.selcover_id=map.Cover_ID

--declare @sql varchar(max)
declare @cvr int, @tb varchar(10), @i varchar(10), @sql_join varchar(max)
select @sql_join=''
select @cvr=min(coverid) from #CoverLetterTextboxes
while @cvr is not null
begin
	set @i='0'
	select @tb=min(qpc_id), @i=@i+1 from #CoverLetterTextboxes where coverid=@cvr
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
		
		set @SQL = 'update #spCoverVariation set TB_'+@i+'='+convert(varchar,@tb)+' where selcover_id='+convert(varchar,@cvr)
		print @SQL
		exec (@SQL)
		
		set @SQL = 'update cv
		set TB_'+@i+'='+@tb+', Art_'+@i+'=Artifact_id
		from #spCoverVariation cv
		inner join #spArtifactSwap swap on cv.samplepop_id=swap.samplepop_id
		where cv.selcover_id='+convert(varchar,@cvr)+'
		and swap.coveritem_id='+@tb
		print @SQL
		exec (@SQL)
		
		delete from #CoverLetterTextboxes where @tb=qpc_id 
		select @tb=min(qpc_id), @i=@i+1 from #CoverLetterTextboxes where coverid=@cvr
	end
	select @cvr=min(coverid) from #CoverLetterTextboxes
end

set @sql = 'update sp
set CoverVariation_id=cv.CoverVariation_id
from #CoverVariation cv
inner join #spCoverVariation sp on cv.cover_id=sp.selcover_id
' + @sql_Join + '
' + replace(@sql_join,'tb','art')

print @sql
exec (@sql)

-- mark the appropriate #UniqueSection records for any additional test prints that are needed to cover all CoverVariations
-- update #UniqueSections.CoverVariation_id
update us
set CoverVariation_id=sp.CoverVariation_id
from #UniqueSections us
inner join #spCoverVariation sp on us.samplepop_id=sp.samplepop_id

-- get rid of variations that are already selected to get a testprint:
delete 
from #spCoverVariation
where CoverVariation_id in (select distinct CoverVariation_id from #UniqueSections where intFlag=1)

-- flag samplepops for testprints for any remaining variations:
update us
set intflag=1, CoverVariation_id=sp.CoverVariation_id
from #UniqueSections us
inner join #spCoverVariation sp on us.samplepop_id=sp.samplepop_id
where us.samplepop_id in (	select max(samplepop_id)
							from #spCoverVariation
							group by CoverVariation_id )
-- /END OF DYNAMIC COVER LETTERS

-- dedup to a Unique Pop_id, SampleSet, Sections combination    
SELECT Pop_id, Sections, CoverVariation_id, MAX(SampleSet_id) SampleSet_id    
INTO #dedup    
FROM #UniqueSections    
WHERE intFlag=1    
GROUP BY Pop_id, Sections, CoverVariation_id
    
UPDATE us    
SET intFlag=0    
FROM #dedup d
INNER JOIN #UniqueSections us ON d.Pop_id=us.Pop_id AND d.Sections=us.Sections
WHERE d.SampleSet_id<>us.SampleSet_id    
    
DROP TABLE #dedup    
    
IF @bitSchedule=0    
BEGIN    
	SET @SQL=''''''    

	-- grab whatever Fields are associated with name Codes FROM the address label    
	SELECT @SQL=@SQL+'+cast(ISNULL('+strField_nm+','''') as varchar)+'' '''    
	FROM CodeQstns cq
	INNER JOIN Sel_Qstns sq ON cq.SelQstns_id=sq.SelQstns_id AND cq.Survey_id=sq.Survey_id AND cq.Language=sq.Language
	INNER JOIN Codes c ON cq.Code=c.Code
	INNER JOIN CodesText ct ON c.Code=ct.Code
	INNER JOIN CodeTextTag ctt ON ct.CodeText_id=ctt.CodeText_id
--	INNER JOIN Tag t ON 
	INNER JOIN TagField tf ON ctt.Tag_id=tf.Tag_id
	INNER JOIN MetaField mf ON tf.Field_id=mf.Field_id   
	WHERE cq.Survey_id=@survey_id    	
	AND sq.Section_id=-1    
	AND sq.Language=1    
	AND sq.subtype=6    
	AND c.description LIKE '%name%'    
	AND tf.Study_id=@Study_id    
	GROUP BY mf.strField_nm    
	ORDER BY MIN(ctt.intStartpos)    

	-- grab whatever literals are associated with name Codes FROM the address label    
	SELECT @SQL=@SQL + '+'''+strReplaceLiteral + ' '''    
	FROM CodeQstns cq
	INNER JOIN Sel_Qstns sq ON cq.SelQstns_id=sq.SelQstns_id AND cq.Survey_id=sq.Survey_id AND cq.Language=sq.Language
	INNER JOIN Codes c ON cq.Code=c.Code
	INNER JOIN CodesText ct ON c.Code=ct.Code
	INNER JOIN CodeTextTag ctt ON ct.CodeText_id=ctt.CodeText_id
	--INNER JOIN Tag t ON 
	INNER JOIN TagField tf ON ctt.Tag_id=tf.Tag_id
	WHERE cq.Survey_id=@survey_id    
	AND sq.Section_id=-1    
	AND sq.Language=1    
	AND sq.label='Address information'    
	AND c.description LIKE '%name%'    
	AND tf.Study_id=@Study_id    
	AND tf.Field_id IS NULL    
	GROUP BY strReplaceLiteral    
	ORDER BY MIN(ctt.intStartpos)    

	SET @SQL='SELECT '+CONVERT(VARCHAR,@survey_id)+' Survey_id, sp.Study_id,    
	p.Pop_id, sp.SamplePop_id,     
	'+@SQL+' name, Age, Sex, Sections, CoverVariation_id    
	FROM #UniqueSections us
	INNER JOIN s'+CONVERT(VARCHAR,@Study_id)+'.Population p ON us.Pop_id=p.Pop_id 
	INNER JOIN SamplePop sp ON us.SampleSet_id=sp.SampleSet_id AND p.Pop_id=sp.Pop_id 
	INNER JOIN #SampleSet s ON sp.SampleSet_id=s.SampleSet_id
	WHERE us.intFlag=1
	AND sp.Study_id='+CONVERT(VARCHAR,@Study_id)
	
	EXEC (@SQL)    
END    
ELSE -- @bitSchedule=1    
BEGIN    
	CREATE TABLE #Language (LangID INT, Language VARCHAR(20))     
	INSERT INTO #Language     
		SELECT l.LangID, l.Language     
		FROM Languages l 
		INNER JOIN SurveyLanguage sl ON l.Langid=sl.Langid
		WHERE sl.Survey_id= @survey_id 
		AND l.Langid IN (select items from dbo.split(@languages,','))
	IF @@ROWCOUNT=0    
		RETURN 4    -- the survey hasn't been set up for any of the languages passed into the @languages parameter 

	CREATE TABLE #Cover (Cover_id INT, MailingStep_id INT)    
	insert into #Cover
		SELECT SelCover_id, MIN(MailingStep_id)     
		FROM MailingStep 
		WHERE Survey_id=@survey_id
		AND selCover_id IN (select items from dbo.split(@covers,','))
		GROUP BY selCover_id
	IF @@ROWCOUNT=0    
		RETURN 5    -- the survey doesn't have a cover letter defined for any of the covers passed into the @covers parameter

	IF NOT EXISTS (SELECT * FROM Employee WHERE Employee_id=@Employee_id)    
		RETURN 6    -- the associate doesn't exist in the employee table

	IF NOT EXISTS (SELECT * FROM Employee WHERE streMail=@eMail)    
		RETURN 7    -- the associates email isn't registered in the employee table

	BEGIN TRANSACTION    
	INSERT INTO Scheduled_TP (Study_id, Survey_id, SampleSet_id, Pop_id,    
		methodology_id, MailingStep_id, OverRideItem_id, [Language], bitMockup,    
		strSections, streMail, Employee_id, bitDone, datScheduled)    
	SELECT @Study_id, @survey_id, s.SampleSet_id, sp.Pop_id, methodology_id,    
		c.MailingStep_id, NULL, l.Langid, @bitMockup, Sections, @eMail, @Employee_id,     
		0, GETDATE()    
	FROM #Cover c, #Language L, MailingMethodology mm, #UniqueSections us   --> cartesian joins. i'm not thrilled with this (dbg)
	INNER JOIN SamplePop sp ON us.Pop_id=sp.Pop_id AND us.SampleSet_id=sp.SampleSet_id
	INNER JOIN #SampleSet s ON sp.SampleSet_id=s.SampleSet_id
	WHERE us.intFlag=1    
	AND sp.Study_id=@Study_id    
	AND mm.Survey_id=@survey_id
	AND mm.bitActiveMethodology=1    
	IF @@ROWCOUNT=0    
	BEGIN    
		ROLLBACK TRAN    
		RAISERROR ('Unable to schedule test prints.  Please verify that an active mailing methodology exists.',15,1)    
		RETURN 8    
	END    
	WAITFOR DELAY '00:00:00.01'    

	COMMIT TRANSACTION
	DROP TABLE #Cover
	DROP TABLE #Language
END    

DROP TABLE #UniqueSections
DROP TABLE #SampleSet
drop table #CoverVariation
drop table #spCoverVariation
drop table #CoverLetterTextboxes
drop table #spArtifactSwap
drop table #CoverLetterItemArtifactUnitMapping

RETURN 0


