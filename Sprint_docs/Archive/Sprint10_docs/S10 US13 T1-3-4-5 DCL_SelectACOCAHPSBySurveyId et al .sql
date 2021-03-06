/*
S10 US13 T1-3-4-5 DCL_SelectACOCAHPSBySurveyId et al .sql

13.1	Modify CRUD, data export library to accommodate the questionnaire version
13.2	Modify question response processing (app)
13.3	Add code to move all survey subtypes within Thrice Daily
13.4	Add questionnaire version field to submission file
13.5	Fix duplicate record collection bug

ALTER procedure [dbo].[DCL_SelectACOCAHPSBySurveyId] (13.5,13.4,13.1)
CREATE procedure [dbo].[ACOCAHPS_FixDispositionsBySurveyId] (13.5)
ALTER PROCEDURE [dbo].[SP_Extract_ApplicationTables] (13.3)
CREATE TABLE [dbo].[SurveySubtype] (13.3)
CREATE TABLE [dbo].[SurveyTypeQuestionMappings] (13.2)
CREATE FUNCTION [dbo].[fn_ACOCAHPSUpdateForVersion] (13.1)

Chris Burkholder
*/

USE [QP_Comments]
GO

IF EXISTS (SELECT *
           FROM   sys.objects
           WHERE  object_id = OBJECT_ID(N'[dbo].[fn_ACOCAHPSUpdateForVersion]')
                  AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
DROP FUNCTION [dbo].[fn_ACOCAHPSUpdateForVersion]
GO

CREATE FUNCTION [dbo].[fn_ACOCAHPSUpdateForVersion](@sql nvarchar(max),@survey_id int)
RETURNS nvarchar(max)
AS
BEGIN
	declare @SubType_nm char(50) = null
	select @SubType_nm = SubType_nm from SurveySubType where Survey_id = @Survey_id

	Declare @Old nvarchar(20), @New nvarchar(20)
	-------------Substitute New Questions for Old Questions--------------
	DECLARE sub_cursor CURSOR FOR  
	select 'Q0' + Convert(varchar,a.qstncore) as Old, 'Q0' + Convert(varchar,b.qstncore) as New from SurveyTypeQuestionMappings a
	inner join SurveyTypeQuestionMappings b on a.intOrder = b.intOrder and a.SurveyType_id = b.SurveyType_id and a.SubType_ID = 0 and b.SubType_Nm = @SubType_nm
	where b.qstncore not in (select qstncore from SurveyTypeQuestionMappings where surveytype_id = a.SurveyType_id and SubType_ID = 0)

	OPEN sub_cursor  
	FETCH NEXT FROM sub_cursor INTO @Old, @New

	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		select @Sql = Replace(@Sql, @Old, @New)
		FETCH NEXT FROM sub_cursor INTO @Old, @New
	END  

	CLOSE sub_cursor  
	DEALLOCATE sub_cursor 
	-------------Substitute "NA" for Removed Questions (unless already substituted for above)--------------
	DECLARE NA_cursor CURSOR FOR  
	select 'Q0' + Convert(varchar,a.qstncore) + '%10000' as Old from SurveyTypeQuestionMappings a
	where surveytype_id = 10 and SubType_id = 0 and qstncore not in (select qstncore from SurveyTypeQuestionMappings where surveytype_id = a.SurveyType_id and ((@Subtype_nm is null) or (SubType_Nm = @Subtype_nm)))

	OPEN NA_cursor  
	FETCH NEXT FROM NA_cursor INTO @Old

	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		select @Sql = Replace(@Sql, @Old, '-3')
		FETCH NEXT FROM NA_cursor INTO @Old  
	END  

	CLOSE NA_cursor
	DEALLOCATE NA_cursor

  return @sql
END
GO

/****** Object:  StoredProcedure [dbo].[DCL_SelectACOCAHPSBySurveyId]    Script Date: 10/14/2014 9:38:25 AM ******/

IF OBJECT_ID('DCL_SelectACOCAHPSBySurveyId', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[DCL_SelectACOCAHPSBySurveyId]
GO

/****** Object:  StoredProcedure [dbo].[DCL_SelectACOCAHPSBySurveyId]    Script Date: 10/9/2014 4:21:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE
procedure [dbo].[DCL_SelectACOCAHPSBySurveyId]
@Survey_id as integer,
@StartDate as datetime = null,
@EndDate as datetime = null
as

set nocount on

if @StartDate is null
	set @StartDate = DateAdd(m,-1,convert(date,getdate()))

if (@EndDate is null) or (@EndDate < @StartDate)
	set @EndDate = convert(date,getdate())

exec dbo.ACOCAHPS_FixDispositionsBySurveyId @Survey_Id

/*
select distinct study_id, survey_id, 0 as flag
from clientstudysurvey css
inner join qualisys.qp_prod.dbo.surveytype st on css.surveytype_id=st.surveytype_id
inner join sys.schemas ss on 's'+convert(varchar,css.study_id)=ss.name
inner join sys.views sv on ss.schema_id=sv.schema_id
where st.SurveyType_dsc='ACOCAHPS'
and sv.name ='study_results_view'
*/
declare @sql varchar(max), @study varchar(10)
select @study=study_id from clientstudysurvey where survey_id = @Survey_id

		declare @Q79 varchar(max)
		if exists (select 1 from Information_Schema.Columns where table_schema = 's'+@study and table_name = 'study_results_view' and column_name = 'Q050725')
		set @Q79 = ',coalesce(case when max(Q050255a)=1 then 1 end,max(Q050725%10000),-9) as [Q79a]
			,coalesce(case when max(Q050255b)=2 then 1 end,max(Q050726%10000),-9) as [Q79b]
			,coalesce(case when max(Q050255c)=3 then 1 end,max(Q050727%10000),-9) as [Q79c]
			,isnull(max(Q050728),-9) as [Q79d]
			,coalesce(case when max(Q050255d)=4 then 1 end,max(Q050729%10000),-9) as [Q79d1]
			,coalesce(case when max(Q050255e)=5 then 1 end,max(Q050730%10000),-9) as [Q79d2]
			,coalesce(case when max(Q050255f)=6 then 1 end,max(Q050731%10000),-9) as [Q79d3]
			,coalesce(case when max(Q050255g)=7 then 1 end,max(Q050732%10000),-9) as [Q79d4]
			,coalesce(case when max(Q050255h)=8 then 1 end,max(Q050733%10000),-9) as [Q79d5]
			,coalesce(case when max(Q050255i)=9 then 1 end,max(Q050734%10000),-9) as [Q79d6]
			,coalesce(case when max(Q050255j)=10 then 1 end,max(Q050735%10000),-9) as [Q79d7]
			,isnull(max(Q050736),-9) as [Q79e]
			,coalesce(case when max(Q050255k)=11 then 1 end,max(Q050737%10000),-9) as [Q79e1]
			,coalesce(case when max(Q050255l)=12 then 1 end,max(Q050738%10000),-9) as [Q79e2]
			,coalesce(case when max(Q050255m)=13 then 1 end,max(Q050739%10000),-9) as [Q79e3]
			,coalesce(case when max(Q050255n)=14 then 1 end,max(Q050740%10000),-9) as [Q79e4]
			'
		else
		set @Q79 = ',case when max(Q050255a)=1 then 1 end as [Q79a]
			,case when max(Q050255b)=2 then 1 end as [Q79b]
			,case when max(Q050255c)=3 then 1 end as [Q79c]
			,-9 as [Q79d]
			,case when max(Q050255d)=4 then 1 end as [Q79d1]
			,case when max(Q050255e)=5 then 1 end as [Q79d2]
			,case when max(Q050255f)=6 then 1 end as [Q79d3]
			,case when max(Q050255g)=7 then 1 end as [Q79d4]
			,case when max(Q050255h)=8 then 1 end as [Q79d5]
			,case when max(Q050255i)=9 then 1 end as [Q79d6]
			,case when max(Q050255j)=10 then 1 end as [Q79d7]
			,-9 as [Q79e]
			,case when max(Q050255k)=11 then 1 end as [Q79e1]
			,case when max(Q050255l)=12 then 1 end as [Q79e2]
			,case when max(Q050255m)=13 then 1 end as [Q79e3]
			,case when max(Q050255n)=14 then 1 end as [Q79e4]
			'

		declare @howhelped varchar(max)
		set @howhelped=',max(Q050744%10000) as [Q81]'

set @sql='select distinct '+
			convert(nvarchar(max), @study)+' as Study_ID'+
			','+convert(nvarchar(max), @Survey_id)+' as Survey_ID'+
			',bt.samplepop_id
			,max(left(bt.ACO_FinderNum,8)) as [FINDER]
			,max(left(bt.ACO_ACOID,5)) as [ACO_ID]
			,max(left(bt.ACODisposition,2)) as [DISPOSITN]
			,max(case when bt.ACODisposition in (10,31,34) then (case when ms.intSequence=4 then ''3'' else ''1'' end) else ''8'' end) as [MODE]
			,max(case when bt.ACODisposition in (10,31,34) then (left(IsNull(sm.LangID,8),1)) else ''8'' end) as [DISPO_LANG] --> this is the language the survey was /completed/ in.  "8" means "not applicable".
			,max(IsNull(convert(varchar,sr.DATRETURNED,112),''88888888'')) AS [RECEIVED]
			,max(bt.ACO_FocalType) AS [FOCALTYPE]
			,max(bt.DrTitle) as [PRTITLE]
			,max(bt.DrFirstName) as [PRFNAME]
			,max(bt.DrLastName) as [PRLNAME]
			,max(Q050175%10000) as [Q01]
			,max(Q050176%10000) as [Q02]
			,max(Q050177%10000) as [Q03]
			,max(Q051426%10000) as [Q04]
			,max(Q050179%10000) as [Q05]
			,max(Q050180%10000) as [Q06]
			,max(Q050181%10000) as [Q07]
			,max(Q050182%10000) as [Q08]
			,max(Q050183%10000) as [Q09]
			,max(Q050184%10000) as [Q10]
			,max(Q050185%10000) as [Q11]
			,max(Q050186%10000) as [Q12]
			,max(Q050187%10000) as [Q13]
			,max(Q050188%10000) as [Q14]
			,max(Q050189%10000) as [Q15]
			,max(Q050190%10000) as [Q16]
			,max(Q050191%10000) as [Q17]
			,max(Q050192%10000) as [Q18]
			,max(Q050193%10000) as [Q19]
			,max(Q050194%10000) as [Q20]
			,max(Q050195%10000) as [Q21]
			,max(Q050196%10000) as [Q22]
			,max(Q050197%10000) as [Q23]
			,max(Q050198%10000) as [Q24]
			,max(Q050199%10000) as [Q25]
			,max(Q050200%10000) as [Q26]
			,max(Q050201%10000) as [Q27]
			,max(Q050202%10000) as [Q28]
			,max(Q050203%10000) as [Q29]
			,max(Q050204%10000) as [Q30]
			,max(Q050205%10000) as [Q31]
			,max(Q050206%10000) as [Q32]
			,max(Q050207%10000) as [Q33]
			,max(Q050208%10000) as [Q34]
			,max(Q050209%10000) as [Q35]
			,max(Q050210%10000) as [Q36]
			,max(Q050211%10000) as [Q37]
			,max(Q050212%10000) as [Q38]
			,max(Q050213%10000) as [Q39]
			,max(Q050214%10000) as [Q40]
			,max(Q050215%10000) as [Q41]
			,max(Q050216%10000) as [Q42]
			,max(Q050217%10000) as [Q43]
			,max(Q050218%10000) as [Q44]
			,max(Q050219%10000) as [Q45]
			,max(Q050220%10000) as [Q46]
			,max(Q050221%10000) as [Q47]
			,max(Q050222%10000) as [Q48]
			,max(Q050223%10000) as [Q49]
			,max(Q050224%10000) as [Q50]
			,max(Q050225%10000) as [Q51]
			,max(Q050226%10000) as [Q52]
			,max(Q050227%10000) as [Q53]
			,max(Q050228%10000) as [Q54]
			,max(Q050229%10000) as [Q55]
			,max(Q050230%10000) as [Q56]
			,max(Q050231%10000) as [Q57a]
			,max(Q050232%10000) as [Q57b]
			,max(Q050233%10000) as [Q57c]
			,max(Q050234%10000) as [Q58]
			,max(Q050235%10000) as [Q59]
			,max(Q050236%10000) as [Q60]
			,max(Q050237%10000) as [Q61]
			,max(Q050238%10000) as [Q62]
			,max(Q050239%10000) as [Q63]
			,max(Q050240%10000) as [Q64]
			,max(Q050241%10000) as [Q65]
			,max(Q050699%10000) as [Q66]
			,max(Q050243%10000) as [Q67]
			,max(Q050700%10000) as [Q68]
			,max(Q050245%10000) as [Q69]
			,max(Q050246%10000) as [Q70]
			,max(Q050247%10000) as [Q71]
			,max(Q050248%10000) as [Q72]
			,max(Q050249%10000) as [Q73]
			,max(Q050250%10000) as [Q74]
			,max(Q050251%10000) as [Q75]
			,max(Q050252%10000) as [Q76]
			,max(Q050253%10000) as [Q77]
			,max(Q050254%10000) as [Q78]
			'+@Q79+'
			,max(Q050256%10000) as [Q80]
			'+@howhelped+'
			,cast (case when max(cast (sr.bitComplete as tinyint)) = 1 then 1 else 0 end as bit) as [bitComplete]
			,max(case when subtype_nm is null then ''NA'' when left(bt.ACODisposition,2) = ''40'' then ''88'' when subtype_nm = ''ACO-8'' then ''08'' when subtype_nm = ''ACO-12'' then ''12'' else ''NA'' end) AS [qversion]
			,max(ISNULL(sr.bitComplete * 0, -1))
			from s'+convert(nvarchar(max),@study)+'.big_table_view bt
			left outer join SurveySubtype sst on sst.Survey_id = '+convert(nvarchar(max),@Survey_id)+'
			left outer join qualisys.qp_prod.dbo.questionform qf on bt.samplepop_id=qf.samplepop_id
			left outer join qualisys.qp_prod.dbo.sentmailing sm on qf.sentmail_id=sm.sentmail_id
			left outer join qualisys.qp_prod.dbo.scheduledmailing scm on qf.sentmail_id=scm.sentmail_id
			left outer join qualisys.qp_prod.dbo.mailingstep ms on scm.mailingstep_id=ms.mailingstep_id
			left outer join s'+convert(nvarchar(max),@study)+'.study_results_view sr on bt.samplepop_id=sr.samplepop_id and bt.sampleunit_id=sr.sampleunit_id
			where bt.sampleunit_id in (select sampleunit_id from sampleunit where survey_id='+convert(nvarchar(max),@Survey_id)+') and
			bt.DatSampleEncounterDate between '''+convert(nvarchar(max),@startDate)+''' AND '''+convert(nvarchar(max),@EndDate)+ '''
			group by bt.samplepop_id
			order by max(ISNULL(sr.bitComplete * 0, -1)) desc, bt.samplepop_id'

  declare @sql2 nvarchar(max) = dbo.fn_ACOCAHPSUpdateForVersion(@sql, @survey_id)
--	print @sql
--	print @sql2
  exec(@sql2)
	
GO


/****** Object:  StoredProcedure [dbo].[ACOCAHPS_FixDispositionsBySurveyId]    Script Date: 10/13/2014 3:37:34 PM ******/
IF OBJECT_ID('ACOCAHPS_FixDispositionsBySurveyId', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[ACOCAHPS_FixDispositionsBySurveyId]
GO
/****** Object:  StoredProcedure [dbo].[ACOCAHPS_FixDispositionsBySurveyId]    Script Date: 10/13/2014 3:37:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ACOCAHPS_FixDispositionsBySurveyId]
@survey_id as int
as
if object_id('tempdb..#aco') is not null
	drop table #aco

select sp.SAMPLEPOP_ID, sp.study_id, convert(tinyint,null) as ACODisposition, convert(tinyint,null) as RecalcACODisposition, convert(varchar(50), NULL) as TableName
into #aco
from qualisys.qp_prod.dbo.samplepop sp
inner join qualisys.qp_prod.dbo.sampleset ss on sp.sampleset_id=ss.sampleset_id
inner join qualisys.qp_prod.dbo.survey_def sd on ss.survey_id=sd.survey_id
where sd.survey_id = @survey_id
order by sp.samplepop_id

update #aco set RecalcACODisposition = null 
set nocount on
declare @SQL varchar(max), @sp int
select top 1 @sp=samplepop_id from #aco where RecalcACODisposition is null
while @@rowcount>0
begin
	set @SQL='declare @d tinyint exec ACODispositionRecalc '+convert(varchar,@sp)+', @d OUTPUT, @verbose=0 update #aco set RecalcACODisposition=isnull(@d,255) where samplepop_id='+convert(varchar,@sp)
	exec (@SQL)
	select top 1 @sp=samplepop_id from #aco where RecalcACODisposition is null
end
set nocount off

-- update #aco set acodisposition=null, tablename=null
-- declare @SQL varchar(max)
declare @study varchar(10), @tn varchar(50)
select top 1 @study=study_id from #aco where ACODisposition is null
while @@rowcount>0
begin
	set @SQL = 'update a set tablename=v.tablename
	from #aco a
	inner join s'+@study+'.big_table_view v on a.samplepop_id=v.samplepop_id'
	exec (@SQL)
	
	select top 1 @tn=tablename from #aco where study_id=@study and acodisposition is null
		
	set @SQL = 'update bt set ACODisposition=a.RecalcACODisposition
	from #aco a
	inner join s'+@study+'.'+@tn+' bt on a.samplepop_id=bt.samplepop_id where isnull(bt.ACODisposition,255)<>isnull(a.RecalcACODisposition,255)'
	exec (@SQL)

	set @SQL = 'update a set ACODisposition=RecalcACODisposition
	from #aco a
	inner join s'+@study+'.'+@tn+' bt on a.samplepop_id=bt.samplepop_id'
	exec (@SQL)

	select top 1 @study=study_id from #aco where ACODisposition is null
end

drop table #ACO
GO

/*
QP_Comments.dbo.SP_Extract_ApplicationTables.sql

13.3	Add code to move all survey subtypes within Thrice Daily

ALTER PROCEDURE [dbo].[SP_Extract_ApplicationTables]

Chris Burkholder
*/





/****** Object:  Table [dbo].[SurveySubtype]    Script Date: 10/9/2014 2:15:50 PM ******/
IF (EXISTS (SELECT * 
             FROM INFORMATION_SCHEMA.TABLES 
             WHERE TABLE_SCHEMA = 'dbo' 
             AND  TABLE_NAME = 'SurveySubType'))
/****** Object:  Table [dbo].[SurveySubtype]    Script Date: 10/9/2014 2:42:02 PM ******/
DROP TABLE [dbo].[SurveySubtype]
GO


/****** Object:  Table [dbo].[SurveySubtype]    Script Date: 10/9/2014 2:15:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SurveySubtype](
	[SurveySubtype_id] [int] NOT NULL,
	[Survey_id] [int] NULL,
	[Subtype_nm] [varchar](50) NULL,
	CONSTRAINT [pk_SurveySubtype] PRIMARY KEY CLUSTERED 
(
	[SurveySubtype_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[SurveySubtype]    Script Date: 10/9/2014 2:15:50 PM ******/
IF (EXISTS (SELECT * 
             FROM INFORMATION_SCHEMA.TABLES 
             WHERE TABLE_SCHEMA = 'dbo' 
             AND  TABLE_NAME = 'SurveyTypeQuestionMappings'))
/****** Object:  Table [dbo].[SurveyTypeQuestionMappings]    Script Date: 10/9/2014 2:42:02 PM ******/
DROP TABLE [dbo].[SurveyTypeQuestionMappings]
GO


/****** Object:  Table [dbo].[SurveySubtype]    Script Date: 10/9/2014 2:15:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SurveyTypeQuestionMappings](
		[SurveyType_id] [int] NOT NULL,
		[QstnCore] [int] NOT NULL,
		[intOrder] [int] NULL,
		[bitFirstOnForm] [bit] NULL,
		[bitExpanded] [bit] NOT NULL,
		[datEncounterStart_dt] [datetime] NULL,
		[datEncounterEnd_dt] [datetime] NULL,
		[SubType_id] [int] NOT NULL,
		[Subtype_nm] [varchar](50) NULL,
	CONSTRAINT [pk_SurveyTypeQuestionMappings] PRIMARY KEY CLUSTERED 
(
	[SurveyType_id] ASC,	[SubType_ID] ASC,	[QstnCore] ASC,	[bitExpanded] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  StoredProcedure [dbo].[SP_Extract_ApplicationTables]    Script Date: 10/9/2014 1:41:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_Extract_ApplicationTables]        
AS        
        
SET ARITHABORT ON        
        
-- Basic concept: creat temp tbl , update joinable records on perm tbl,append on new records,        
        
-- Modified 5/24/05 SS        
-- Changed scales refresh to reorder #scales then update scales rather than update then reorder.        
        
-- Modified 10/19/206 SS        
-- Added strSampleEncounterDateField to ClientStudySurvey update section        
        
-- Modified 5/2/07 SS        
-- Updating str values in client and clientstudysurvey using client or study id's. Previous code used survey_id for update and caused problems with orphaned surveys.        
        
        
        
-- Modified 8/14/07 mb        
-- added code to update QuestionsTextIndex table b/c triggers could not handle when large updates        
-- of updates happened at the same time (like updating serveral thousand records at a time.        
        
-- Modified 9/12/07 mb        
-- same QuestionsTextIndex update like above only this time had to write in the insert statement        
-- due to same trigger error.        
        
-- MWB 4/1/2008        
-- modified to include not exists clause due to dups        
        
-- DRM 11/7/2008        
-- Added check that new sampleplan_ids don't already exist in sampleplan table.        
        
-- MWB 10/19/2009        
-- Modified Disposition table and added HCHAPSDisposition and HHCAHPSDisposition extract        
-- Modified sampleunit extract to include bitHHCAHPS field.        
        
-- MWB 10/30/2009        
-- Modified Sampleunit extract to include PENumber field for CHART Exports        
        
-- MWB 11/3/2009        
-- Modified sampleunit extract to include bitCHART field.        
        
-- MWB 04/08/2010        
-- Added logic to extract MNCMDisposition Table        
-- added bitMNCM to Sampleunit move.        
        
-- DRM 9/26/2011        
-- Added vendor_id to insert as it is not an identity on medusa.        
        
-- DGB 3/28/2013        
-- Created the table #Canada and populate it with all the studies and surveys from NRCC04.        
-- Use this table so we don't grab any data for Canadian studies from NRC10 for the following objects: MetaTable, MetaStructure, Study, ClientStudySurvey,         
-- Questions, Scales, SamplePlan, SampleUnit, SampleUnitSection, SampleUnit_Full, Unscaled_Questions, Global_Attribute, Employee_Access, SampleSet        
        
-- TSB 06/13/2014        
-- Added logic to extract SurveyTypeDisposition table        
    
--DRM 8/1/2014    
--Filter out legacy US data from CA server so that old data doesn't overwrite changes on US server.    

--CJB 10/9/2014
--Add logic to extract SurveySubtype companion table

--CJB 10/15/2014
--Add logic to extract SurveyTypeQuestionMappings companion table
        
--**********************************************************************************************        
DECLARE @Server VARCHAR(100), @sql VARCHAR(8000)        
        
--SELECT @Server=strParam_Value FROM DataMart_Params WHERE strParam_nm='QualPro Server'        
        
CREATE TABLE #Canada (study_id int, survey_id int)        
        
insert into #Canada (study_id, survey_id)        
select study_id, survey_id        
from datamartca.qp_comments.dbo.clientstudysurvey        
    
--DRM 8/1/2014    
--There is some legacy US data on the CA servers that is overwriting changes to US data in this step.    
--Therefore remove these US studies/clients from the update.    
--delete #Canada where study_id in (select * from StudiesCAThriceDailyShouldIgnore)  
delete #Canada where study_id in (select study_id from qualisys.qp_prod.dbo.study where country_id = 1)
  
--**********************************************************************************************        
  
CREATE TABLE #CommentTypes (CmntType_id INT,strCmntType_nm VARCHAR(15),bitRetired BIT)  
  
INSERT INTO #CommentTypes (CmntType_id,strCmntType_nm,bitRetired)        
SELECT CmntType_id,strCmntType_nm,bitRetired        
FROM QUALISYS.QP_Prod.dbo.CommentTypes        
        
UPDATE c        
SET c.strCmntType_nm=t.strCmntType_nm,c.bitRetired=t.bitRetired        
FROM CommentTypes c,#CommentTypes t        
WHERE c.CmntType_id=t.CmntType_id        
        
DELETE t        
FROM CommentTypes c,#CommentTypes t        
WHERE c.CmntType_id=t.CmntType_id        
        
INSERT INTO CommentTypes (CmntType_id,strCmntType_nm,bitRetired)        
SELECT CmntType_id,strCmntType_nm,bitRetired        
FROM #CommentTypes        
        
DROP TABLE #CommentTypes        
        
--**********************************************************************************************        
print 'Update CommentValences'        
CREATE TABLE #CommentValences (CmntValence_id INT,strCmntValence_nm VARCHAR(10),bitRetired BIT)        
        
INSERT INTO #CommentValences (CmntValence_id,strCmntValence_nm,bitRetired)        
SELECT CmntValence_id,strCmntValence_nm,bitRetired        
FROM QUALISYS.QP_Prod.dbo.CommentValences        
        
UPDATE cv        
SET cv.strCmntValence_nm=t.strCmntValence_nm,cv.bitRetired=t.bitRetired        
FROM CommentValences cv,#CommentValences t        
WHERE cv.CmntValence_id=t.CmntValence_id        
        
DELETE t        
FROM CommentValences cv,#CommentValences t        
WHERE cv.CmntValence_id=t.CmntValence_id        
        
INSERT INTO CommentValences (CmntValence_id,strCmntValence_nm,bitRetired)        
SELECT CmntValence_id,strCmntValence_nm,bitRetired        
FROM #CommentValences        
        
DROP TABLE #CommentValences        
        
--**********************************************************************************************        
print 'Update CommentCodes'        
CREATE TABLE #CommentCodes (CmntCode_id INT,CmntSubHeader_id INT,        
strCmntCode_nm VARCHAR(100),bitRetired bit,strModifiedby VARCHAR(50),        
datModified DATETIME)        
        
INSERT INTO #CommentCodes (CmntCode_id,CmntSubHeader_id,strCmntCode_nm,        
bitRetired,strModifiedby,datModified)        
--Modified the query to combine the SubHeader with the Code.        
SELECT CmntCode_id,h.CmntSubHeader_id,strCmntSubHeader_nm+': '+strCmntCode_nm,c.bitRetired,        
c.strModifiedby,c.datModified        
FROM QUALISYS.QP_Prod.dbo.CommentCodes c,QUALISYS.QP_Prod.dbo.CommentSubHeaders h        
WHERE c.CmntSubHeader_id=h.CmntSubHeader_id        
        
UPDATE c        
SET c.CmntSubHeader_id=t.CmntSubHeader_id,c.strCmntCode_nm=t.strCmntCode_nm,        
c.bitRetired=t.bitRetired,c.strModifiedby=t.strModifiedby,        
c.datModified=t.datModified        
FROM CommentCodes c,#CommentCodes t        
WHERE c.CmntCode_id=t.CmntCode_id        
        
DELETE t        
FROM CommentCodes c,#CommentCodes t        
WHERE c.CmntCode_id=t.CmntCode_id        
        
INSERT INTO CommentCodes (CmntCode_id,CmntSubHeader_id,strCmntCode_nm,bitRetired,        
strModifiedby,datModified)        
SELECT CmntCode_id,CmntSubHeader_id,strCmntCode_nm,bitRetired,        
strModifiedby,datModified        
FROM #CommentCodes        
        
DROP TABLE #CommentCodes        
        
        
--**********************************************************************************************        
-- listing of tables in each Study        
        
print '-- Update MetaTable'        
        
CREATE TABLE #MetaTable (Table_id INT,strTable_nm VARCHAR(20),strTable_dsc VARCHAR(80),Study_id INT,bitUsesAddress BIT)        
        
INSERT INTO #MetaTable (Table_id,strTable_nm,strTable_dsc,Study_id,bitUsesAddress)        
SELECT Table_id,strTable_nm,strTable_dsc,Study_id,bitUsesAddress        
FROM QUALISYS.QP_Prod.dbo.MetaTable        
        
DELETE t        
FROM #MetaTable t, #Canada c        
WHERE t.study_id=c.study_id        
        
UPDATE m        
SET m.strTable_nm=t.strTable_nm,m.strTable_dsc=t.strTable_dsc,        
m.Study_id=t.Study_id,m.bitUsesAddress=t.bitUsesAddress        
FROM MetaTable m,#MetaTable t        
WHERE m.Table_id=t.Table_id        
        
DELETE t        
FROM MetaTable m,#MetaTable t        
WHERE m.Table_id=t.Table_id        
        
INSERT INTO MetaTable (Table_id,strTable_nm,strTable_dsc,Study_id,bitUsesAddress)        
SELECT Table_id,strTable_nm,strTable_dsc,Study_id,bitUsesAddress        
FROM #MetaTable        
        
DROP TABLE #MetaTable        
        
--**********************************************************************************************        
-- Add and new users (new studies based upon contents of MetaTable.        
print '-- Add and new users (new studies based upon contents of MetaTable.'        
EXEC SP_Extract_AddUsers        
        
--**********************************************************************************************        
        
-- list of availble Fields that can be added to Study specific tables        
CREATE TABLE #MetaField (Field_id INT,strField_nm VARCHAR(20),        
strField_dsc VARCHAR(80),FieldGroup_id INT,strFieldDataType CHAR(1),        
intFieldLength INT,strFieldEditMask VARCHAR(20),intSpecialField_cd INT,        
strFieldShort_nm CHAR(8),bitSysKey BIT,bitPhase1Field bit,        
intAddrCleanCode INT,intAddrCleanGroup INT)        
        
INSERT INTO #MetaField (Field_id,strField_nm,strField_dsc,FieldGroup_id,        
strFieldDataType,intFieldLength,strFieldEditMask,intSpecialField_cd,        
strFieldShort_nm,bitSysKey,bitPhase1Field,intAddrCleanCode,intAddrCleanGroup)        
SELECT Field_id,strField_nm,strField_dsc,FieldGroup_id,        
strFieldDataType,intFieldLength,strFieldEditMask,intSpecialField_cd,        
strFieldShort_nm,bitSysKey,bitPhase1Field,intAddrCleanCode,intAddrCleanGroup        
FROM QUALISYS.QP_Prod.dbo.MetaField        
        
UPDATE m        
SET m.strField_nm=t.strField_nm ,m.strField_dsc=t.strField_dsc,        
--SET m.strField_nm=t.strField_nm,        
m.FieldGroup_id=t.FieldGroup_id,m.strFieldDataType=t.strFieldDataType,        
m.intFieldlength=t.intFieldlength,m.strFieldEditMask=t.strFieldEditMask,        
m.intSpecialField_cd=t.intSpecialField_cd,m.strFieldShort_nm=t.strFieldShort_nm,        
m.bitSysKey=t.bitSysKey,m.bitPhase1Field=t.bitPhase1Field,        
m.intAddrCleanCode=t.intAddrCleanCode,m.intAddrCleanGroup=t.intAddrCleanGroup        
FROM MetaField m,#MetaField t        
WHERE m.Field_id=t.Field_id        
        
DELETE t        
FROM MetaField m,#MetaField t        
WHERE m.Field_id=t.Field_id        
        
INSERT INTO MetaField (Field_id,strField_nm,strField_dsc,FieldGroup_id,        
strFieldDataType,intFieldLength,strFieldEditMask,intSpecialField_cd,        
strFieldShort_nm,bitSysKey,bitPhase1Field,intAddrCleanCode,intAddrCleanGroup)        
SELECT Field_id,strField_nm,strField_dsc,FieldGroup_id,        
strFieldDataType,intFieldLength,strFieldEditMask,intSpecialField_cd,        
strFieldShort_nm,bitSysKey,bitPhase1Field,intAddrCleanCode,intAddrCleanGroup        
FROM #MetaField        
        
DROP TABLE #MetaField        
        
        
--**********************************************************************************************        
        
-- listing of what Fields are in what table as it exists in Qualisys        
print '-- Update MetaStructure'        
CREATE TABLE #MetaStructure (Table_id INT,Field_id INT,bitKeyField_flg BIT,        
bitUserField_flg BIT,bitMatchField_flg BIT,bitPostedField_flg BIT,Study_id INT)        
        
INSERT INTO #MetaStructure (Table_id,Field_id,bitKeyField_flg,bitUserField_flg,        
bitMatchField_flg,bitPostedField_flg,Study_id)        
SELECT Table_id,Field_id,bitKeyField_flg,bitUserField_flg,bitMatchField_flg,        
bitPostedField_flg,Study_id        
FROM QUALISYS.QP_Prod.dbo.WEB_MetaStructure_View        
        
UPDATE ms        
SET ms.bitKeyField_flg=t.bitKeyField_flg,ms.bitUserField_flg=t.bitUserField_flg,        
ms.bitMatchField_flg=t.bitMatchField_flg,ms.bitPostedField_flg=t.bitPostedField_flg,        
ms.Study_id=t.Study_id        
FROM MetaStructure ms,#MetaStructure t        
WHERE ms.Table_id=t.Table_id        
AND ms.Field_id=t.Field_id        
        
DELETE t        
FROM MetaStructure ms,#MetaStructure t        
WHERE ms.Table_id=t.Table_id        
AND ms.Field_id=t.Field_id        
        
DELETE t        
FROM #MetaStructure t,#Canada c        
WHERE t.study_id=c.study_id        
        
--if we are adding records for a new Study,we need to add the default computed columns        
SELECT DISTINCT Study_id,MIN(Table_id) Table_id        
INTO #comp        
FROM #MetaStructure        
GROUP BY Study_id        
        
--DELETE studies that we are just adding new Fields        
DELETE c        
FROM #comp c,MetaStructure m        
WHERE c.Study_id=m.Study_id        
--and Field_id in (2,17)        
        
--insert the two default computed Fields        
INSERT INTO MetaStructure (Table_id,Field_id,bitKeyField_flg,bitUserField_flg,        
bitMatchField_flg,bitPostedField_flg,Study_id,bitCalculated,strFormula,bitAvailableFilter)        
SELECT Table_id,Field_id,0,0,0,1,Study_id,1,strFormulaDefault,1        
FROM #comp c,MetaField m        
WHERE m.Field_id IN (2,17)        
        
--drop the temp table        
DROP TABLE #comp        
        
INSERT INTO MetaStructure (Table_id,Field_id,bitKeyField_flg,bitUserField_flg,        
bitMatchField_flg,bitPostedField_flg,Study_id)        
SELECT Table_id,Field_id,bitKeyField_flg,bitUserField_flg,bitMatchField_flg,        
bitPostedField_flg,Study_id        
FROM #MetaStructure        
        
DROP TABLE #MetaStructure        
        
--**********************************************************************************************        
print '-- Update Client'        
CREATE TABLE #Client (Client_id INT,strClient_nm VARCHAR(40))        
        
-- list of Clients in qualisys        
INSERT INTO #Client (Client_id,strClient_nm)        
SELECT Client_id,strClient_nm        
FROM QUALISYS.QP_Prod.dbo.Client        
        
UPDATE c        
SET c.strClient_nm=t.strClient_nm        
FROM #Client t,Client c        
WHERE t.Client_id=c.Client_id        
        
UPDATE c        
SET c.strClient_nm=t.strClient_nm        
FROM #Client t,ClientStudySurvey c        
WHERE t.Client_id=c.Client_id        
        
DELETE t        
FROM #Client t,Client c        
WHERE t.Client_id=c.Client_id        
        
INSERT INTO Client (Client_id,strClient_nm)        
SELECT Client_id,strClient_nm        
FROM #Client        
        
DROP TABLE #Client        
        
--**********************************************************************************************        
print '-- Update Study'        
CREATE TABLE #Study (Study_id INT,strStudy_nm VARCHAR(40))        
        
-- list of Studies in qualisys        
INSERT INTO #Study (Study_id,strStudy_nm)        
SELECT Study_id,strStudy_nm        
FROM QUALISYS.QP_Prod.dbo.Study        
        
DELETE S        
from #Study s, #Canada C        
where s.study_id=c.study_id        
        
UPDATE c        
SET c.strStudy_nm=t.strStudy_nm        
FROM #Study t,ClientStudySurvey c        
WHERE t.Study_id=c.Study_id        
        
--**********************************************************************************************        
-- list of Studys and Surveys and acct dir / and the reporting Field        
        
print '-- update ClientStudySurvey'        
CREATE TABLE #ClientStudySurvey (ClientGroup_nm VARCHAR(40), clientgroup_ID int, strClient_NM VARCHAR(40),strStudy_NM VARCHAR(10), strQSurvey_NM VARCHAR(42), strSurvey_NM VARCHAR(42),        
Client_ID INT,Study_id INT,Survey_ID INT,ClientGroupActive bit, ClientActive bit, StudyActive bit, SurveyActive bit,AD VARCHAR(42),strReportDateField VARCHAR(42), strSampleEncounterDateField VARCHAR(42), SurveyType_id INT)        
        
        
INSERT INTO #ClientStudySurvey (ClientGroup_nm, clientgroup_ID, strClient_nm,strStudy_nm,strQSurvey_nm,strSurvey_nm,Client_id,Study_id,Survey_id,        
  ad, ClientGroupActive, ClientActive, StudyActive, SurveyActive,        
  strReportDateField, strSampleEncounterDateField, SurveyType_id)        
SELECT DISTINCT RTRIM(LTRIM(ClientGroup_nm)), clientgroup_ID, RTRIM(LTRIM(strClient_nm)),RTRIM(LTRIM(strStudy_nm)),        
  RTRIM(LTRIM(strQSurvey_nm)),RTRIM(LTRIM(strSurvey_nm)),Client_id,Study_id,Survey_id,        
  strntlogin_nm, ClientGroupActive, ClientActive, StudyActive, SurveyActive,        
  strReportDateField, strSampleEncounterDateField, SurveyType_id        
FROM QUALISYS.QP_Prod.dbo.WEB_ClientStudySurvey_View        
        
DELETE CSS    
from #ClientStudySurvey css, #Canada C        
where css.study_id=c.study_id        
        
UPDATE c        
SET c.strClientGroup_nm=t.ClientGroup_nm,c.ClientGroup_ID=t.ClientGroup_ID,c.strClient_nm=t.strClient_nm,c.strStudy_nm=t.strStudy_nm,        
c.strQSurvey_nm=t.strQSurvey_nm,c.strSurvey_nm=t.strSurvey_nm,c.ad=t.ad,        
c.strReportDateField=t.strReportDateField, c.strSampleEncounterDateField=t.strSampleEncounterDateField, c.Client_id=t.Client_id,        
c.Study_id=t.Study_id, c.SurveyType_id = t.SurveyType_id,c.ClientGroupActive=t.ClientGroupActive,c.ClientActive=t.ClientActive,        
c.StudyActive=t.StudyActive,c.SurveyActive=t.SurveyActive        
FROM #ClientStudySurvey t,ClientStudySurvey c        
WHERE t.Survey_id=c.Survey_id        
        
DELETE t        
FROM #ClientStudySurvey t,ClientStudySurvey c        
WHERE t.Survey_id=c.Survey_id        
        
INSERT INTO ClientStudySurvey (strClientGroup_nm, clientgroup_ID,strClient_nm,strStudy_nm,strQSurvey_nm,strSurvey_nm,        
  Client_id,Study_id,Survey_id,ad,strReportDateField, strSampleEncounterDateField, SurveyType_id, bitHasResults,        
  ClientGroupActive, ClientActive, StudyActive, SurveyActive )        
SELECT DISTINCT ClientGroup_nm, clientgroup_ID,strClient_nm,strStudy_nm,strQSurvey_nm,strSurvey_nm,Client_id,        
  Study_id,Survey_id,ad,strReportDateField,strSampleEncounterDateField, SurveyType_id, 0,        
  ClientGroupActive, ClientActive, StudyActive, SurveyActive        
FROM #ClientStudySurvey        
        
DROP TABLE #ClientStudySurvey        
        
--**********************************************************************************************        
        
-- list of Valid Questions for any given Survey        
print '-- Update Questions'        
        
CREATE TABLE #Questions (Survey_id INT,Language INT,Scaleid INT,Label VARCHAR(60),QstnCore INT,       Section_id INT,Item INT,subSection INT,numMarkCount INT,strQuestionLabel VARCHAR(60),strFullQuestion VARCHAR(6000),        
   bitMeanable BIT,strSection_nm VARCHAR(500))        
        
INSERT INTO #Questions (Survey_id,Language,Scaleid,Label,QstnCore,Section_id,Item,subSection,numMarkCount,strQuestionLabel,        
   strFullQuestion,bitMeanable,strSection_nm)        
SELECT Survey_id,Language,Scaleid,RTRIM(LTRIM(Label)),QstnCore,Section_id,Item,subSection,numMarkCount,        
   RTRIM(LTRIM(Label)),strfullquestion,bitMeanable,strSection_nm        
FROM QUALISYS.QP_Prod.dbo.WEB_Questions_View        
        
CREATE INDEX tmpq ON #Questions (Survey_id,QstnCore,Language)        
        
delete q        
from #Questions Q, #Canada C        
where Q.survey_id=c.survey_id        
        
UPDATE q        
SET q.Label=t.Label,q.Scaleid=t.Scaleid,q.Section_id=t.Section_id,q.Item=t.Item,        
q.subSection=t.subSection,q.numMarkCount=t.numMarkCount,        
q.strQuestionLabel=t.strQuestionLabel,q.strFullQuestion=t.strFullQuestion,        
q.bitMeanable=t.bitMeanable,q.strSection_nm=t.strSection_nm        
FROM #Questions t,Questions q        
WHERE t.Survey_id=q.Survey_id        
AND t.QstnCore=q.QstnCore        
AND t.Language=q.Language        
        
DELETE t        
FROM #Questions t,Questions q        
WHERE t.Survey_id=q.Survey_id        
AND t.QstnCore=q.QstnCore        
AND t.Language=q.Language        
        
SELECT DISTINCT Study_id,QstnCore        
INTO #qstnwork        
FROM #Questions t,ClientStudySurvey c        
WHERE t.Survey_id=c.Survey_id        
        
DELETE t        
FROM #qstnwork t,Questions q,ClientStudySurvey c        
WHERE t.Study_id=c.Study_id        
AND c.Survey_id=q.Survey_id        
AND t.QstnCore=q.QstnCore        
        
DECLARE @st INT,@sql2 VARCHAR(2000)        
        
SELECT TOP 1 @st=Study_id FROM #qstnwork        
        
        
WHILE @@ROWCOUNT > 0        
BEGIN        
      ---------------------------------------------------------------------------------------------------------------------        
      ---- ccaouette:  Add Create Schema code for Upgrade to SQL Server 2008        
---------------------------------------------------------------------------------------------------------------------        
      DECLARE @SchemaName Varchar(200)        
      SET @SchemaName = 'S' + cast(@st as varchar(199))        
        
        
      if not exists (select top 1 1 from information_schema.schemata where schema_name = @SchemaName)        
      begin        
            DECLARE @schemaSQL varchar(200)        
            SET @schemaSQL = 'CREATE SCHEMA ' + @SchemaName + ' AUTHORIZATION ' + @SchemaName        
            print @schemasql        
            EXEC(@schemaSQL)        
      end        
        
      if not exists (SELECT top 1 1 FROM information_schema.tables isc WHERE isc.table_name='QuestionRollup' AND isc.table_schema =@SchemaName)        
      begin        
        DECLARE @tableSQL varchar(200)        
            SET @tableSQL = 'CREATE TABLE S'+CONVERT(VARCHAR,@st)+'.QuestionRollup ( '+CHAR(10)+        
                                    'Dimension_id INT,QstnCore INT)'        
            print @tableSQL        
            EXEC(@tableSQL)        
      end        
      ---------------------------------------------------------------------------------------------------------------------        
        
      CREATE TABLE #rollup (Dimension_id INT,QstnCore INT)        
        
      --SET @sql2='IF NOT EXISTS (SELECT * '+CHAR(10)+        
      --  ' FROM sysobjects so,sysusers su '+CHAR(10)+        
      --  ' WHERE so.name=''QuestionRollup'' '+CHAR(10)+        
      --  ' AND so.uid=su.uid '+CHAR(10)+        
      --  ' AND su.name=''S'+CONVERT(VARCHAR,@st)+''') '+CHAR(10)+        
      --  ' CREATE TABLE S'+CONVERT(VARCHAR,@st)+'.QuestionRollup ( '+CHAR(10)+        
      --  ' Dimension_id INT,QstnCore INT)'        
        
      --EXEC (@sql2)        
        
      TRUNCATE TABLE #rollup        
        
      INSERT INTO #rollup        
      SELECT DISTINCT Dimension_id,qr.QstnCore        
      FROM QuestionRollup qr,ClientStudySurvey c,#qstnwork q        
      WHERE c.Study_id=@st        
      AND q.QstnCore=qr.QstnCore        
        
      --MWB 4/1/08        
      --modified to include not exists clause due to dups        
      SET @sql2='INSERT INTO S' + CONVERT(VARCHAR,@st) + '.QuestionRollup ' + CHAR(10) +        
        ' SELECT Dimension_id,QstnCore FROM #rollup r ' +        
        ' where not exists (select ''x'' from s' + CONVERT(VARCHAR,@st) + '.QuestionRollup qr where r.qstncore = qr.qstncore and r.Dimension_ID = qr.Dimension_ID)'        
        
      EXEC (@sql2)        
        
      DROP TABLE #rollup        
        
      DELETE #qstnwork WHERE Study_id=@st        
        
      SELECT TOP 1 @st=Study_id FROM #qstnwork        
        
END        
        
        
/***********************************************************************************************/        
print '--Update Questions Table'        
        
INSERT INTO Questions (Survey_id,Language,Scaleid,Label,QstnCore,Section_id,Item,subSection,        
   numMarkCount,strQuestionLabel,strFullQuestion,bitMeanable,strSection_nm)        
SELECT DISTINCT Survey_id,Language,Scaleid,Label,QstnCore,Section_id,Item,subSection,        
   numMarkCount,strQuestionLabel,strFullQuestion,bitMeanable,strSection_nm        
FROM #Questions        
        
DROP TABLE #qstnwork        
DROP TABLE #Questions        
        
--Now to make sure all Labels are updated.        
CREATE TABLE #ql (QstnCore INT, strQstnLabel VARCHAR(100))        
        
INSERT INTO #ql        
SELECT QstnCore, strQstnLabel        
FROM QUALISYS.QP_Prod.dbo.QuestionLabel        
        
UPDATE q        
SET q.strQuestionLabel=strQstnLabel, q.Label=strQstnLabel        
FROM Questions q,#ql ql        
WHERE q.QstnCore=ql.QstnCore        
        
DROP TABLE #ql        
        
-- mb 8/14/07 update above updates entire questions table.  this is to much data for trigger to handle        
--follwing SQL updates the QuestionsTextIndex directly looking at the now up to date questions table        
update QTI        
set QTI.survey_ID = Q.Survey_ID,        
QTI.QstnCore = Q.QstnCore,        
QTI.strFullQuestion = Q.strFullQuestion        
from QuestionsTextIndex QTI, Questions Q, QuestionRollup QR        
where Q.Survey_ID = QTI.Survey_ID AND        
    Q.QstnCore = QTI.QstnCore and        
    QTI.QstnCore = QR.QstnCore and        
    Q.QstnCore = QR.QstnCore and        
    Q.strFullQuestion <> QTI.strFullQuestion        
        
        
--mb 9/12/07 now insert all of the new records from the questions table that do not exist in the questionsTextIndex table        
--This process should replace the need for triggers on a mass scale.  The triggers will still be left in to handle the small        
--occurances of changes but this job should handle all of the large scale data changes.        
        
--mb 7/8/08 added distinct to the Select to remove duplicates.        
--this would only occur if job failed and was not fixed before the next run date        
--this will only catch if the question is the exact same if the questiontext has changed you will still        
--need to fix it manually.        
insert into QuestionsTextIndex (Survey_ID, QstnCore, strFullQuestion)        
select distinct Q.Survey_ID, Q.QstnCore, Q.strFullQuestion        
from Questions Q, QuestionRollup QR        
where Q.QstnCore = QR.QstnCore and strfullquestion is not null and        
  cast(Q.survey_ID as varchar(10)) + cast(Q.qstnCore as varchar(10)) not in        
  (select cast(QTI.survey_ID as varchar(10)) + cast(QTI.qstnCore as varchar(10)) from QuestionsTextIndex QTI)        
        
        
----------        
        
print '--Update Scales Table'        
CREATE TABLE #Scales (Survey_id INT,Language INT,Scaleid INT,Val INT,Label VARCHAR(60), strScaleLabel VARCHAR(60),bitMissing BIT,max_ScaleOrder INT, ScaleOrder INT)        
        
INSERT INTO #Scales (Survey_id,Language,Scaleid,Val,Label,strScaleLabel,bitMissing, max_ScaleOrder, ScaleOrder)        
SELECT DISTINCT Survey_id,Language,QPC_id,Val,RTRIM(LTRIM(Label)),RTRIM(LTRIM(Label)),Missing,NULL max_ScaleOrder,ScaleOrder        
FROM QUALISYS.QP_Prod.dbo.WEB_Scales_View        
        
CREATE INDEX tmps ON #Scales (Survey_id,Language,Scaleid,Val)        
        
delete S        
from #Scales s, #Canada c        
where s.survey_id=c.survey_id        
        
EXEC SP_Extract_ScaleRefresh        
        
BEGIN TRAN        
        
UPDATE s        
SET s.Label=t.Label,s.strScaleLabel=t.strScaleLabel,s.bitMissing=t.bitMissing,        
  s.ScaleOrder=t.ScaleOrder        
FROM #Scales t,Scales s        
WHERE t.Survey_id=s.Survey_id        
AND t.Language=s.Language        
AND t.Scaleid=s.Scaleid        
AND t.Val=s.Val        
        
IF @@ERROR <> 0        
BEGIN        
  ROLLBACK TRAN        
  RETURN        
END        
        
DELETE t        
FROM #Scales t,Scales s        
WHERE t.Survey_id=s.Survey_id        
AND t.Language=s.Language        
AND t.Val=s.Val        
AND t.Scaleid=s.Scaleid        
        
IF @@ERROR <> 0        
BEGIN        
  ROLLBACK TRAN        
  RETURN        
END        
        
DELETE t        
FROM #Scales t, (SELECT Survey_id,Language,Scaleid,Val FROM #Scales GROUP BY Survey_id,Language,Scaleid,Val HAVING COUNT(*)>1) b        
WHERE t.Survey_id=b.Survey_id        
AND t.Language=b.Language        
AND t.Scaleid=b.Scaleid        
AND t.Val=b.Val        
        
IF @@ERROR <> 0        
BEGIN        
  ROLLBACK TRAN        
  RETURN        
END        
        
INSERT INTO Scales (Survey_id,Language,Scaleid,Val,Label,strScaleLabel,bitMissing,max_ScaleOrder,ScaleOrder)        
  SELECT DISTINCT Survey_id,Language,Scaleid,Val,Label,strScaleLabel,bitMissing,max_ScaleOrder,ScaleOrder        
  FROM #Scales        
        
IF @@ERROR <> 0        
BEGIN        
  ROLLBACK TRAN        
RETURN        
END        
        
DROP TABLE #Scales        
        
IF @@ERROR <> 0        
BEGIN        
  ROLLBACK TRAN        
  RETURN        
END        
        
COMMIT TRAN        
----------        
        
-- Set numMarkCount equal to the maximun scale Value.      
SELECT q.Survey_id,QstnCore,MAX(Val) numMarkCount        
INTO #nmc        
FROM Questions q,Scales s        
WHERE q.numMarkCount>1        
AND q.Survey_id=s.Survey_id        
AND q.Scaleid=s.Scaleid        
GROUP BY q.Survey_id,QstnCore        
        
UPDATE q        
SET q.numMarkCount=t.numMarkCount        
FROM Questions q,#nmc t        
WHERE q.Survey_id=t.Survey_id        
AND q.QstnCore=t.QstnCore        
        
DROP TABLE #nmc        
        
CREATE TABLE #SamplePlan (SamplePlan_ID INT,ROOTSAMPLEUNIT_ID INT,EMPLOYEE_ID INT,Survey_ID INT,DATCREATE_DT DATETIME)        
        
INSERT INTO #SamplePlan (SamplePlan_ID,ROOTSAMPLEUNIT_ID,EMPLOYEE_ID,Survey_ID,DATCREATE_DT)        
SELECT DISTINCT SamplePlan_ID,ROOTSAMPLEUNIT_ID,EMPLOYEE_ID,Survey_ID,DATCREATE_DT        
FROM QUALISYS.QP_Prod.dbo.SamplePlan        
        
DELETE t        
FROM #SamplePlan t, #Canada c        
WHERE t.Survey_id=c.Survey_id        
        
DELETE t        
FROM #SamplePlan t,SamplePlan s        
WHERE t.Survey_id=s.Survey_id        
        
INSERT INTO SamplePlan (SamplePlan_ID,ROOTSAMPLEUNIT_ID,EMPLOYEE_ID,Survey_ID,DATCREATE_DT)        
SELECT DISTINCT SamplePlan_ID,ROOTSAMPLEUNIT_ID,EMPLOYEE_ID,Survey_ID,DATCREATE_DT        
FROM #SamplePlan        
--DRM added 11/7/2008        
where sampleplan_id not in (select distinct sampleplan_id from sampleplan)        
        
DROP TABLE #SamplePlan        
        
-- EXEC QUALISYS.QP_ProD.DBO.SP_DBM_Populate_ReportingHierarchy        
-- Update (t)SampleUnit ************************************************************************************************************        
        
print '-- Update Sampleunit'        
CREATE TABLE #SampleUnit (SampleUnit_id INT,ParentSampleUnit_id INT,strSampleUnit_nm VARCHAR(42),Survey_id INT,        
Study_id INT,strUnitSelectType CHAR(1),intLevel INT,strLevel_nm VARCHAR(20), bitSuppress BIT,        
bitHCAHPS BIT, bitHHCAHPS BIT, bitCHART BIT, bitMNCM BIT, MedicareNumber VARCHAR(20), MedicareName VARCHAR(45),        
MedicareActive bit, strFacility_nm VARCHAR(100), City VARCHAR(42), State CHAR(2), Country VARCHAR(42),        
strRegion_nm VARCHAR(42), AdmitNumber INT, BedSize INT, bitPeds BIT, bitTeaching BIT,        
bitTrauma BIT, bitReligious BIT, bitGovernment BIT, bitRural BIT, bitForProfit BIT,        
bitRehab BIT, bitCancerCenter BIT, bitPicker BIT, bitFreeStanding BIT, AHA_id INT, PENumber varchar(20))        
        
INSERT INTO #SampleUnit (SampleUnit_id,ParentSampleUnit_id,strSampleUnit_nm,Survey_id,Study_id,        
  strUnitSelectType,intLevel,strLevel_nm,bitSuppress,bitHCAHPS,bitHHCAHPS,bitCHART, bitMNCM, MedicareNumber, MedicareName,        
  MedicareActive,strFacility_nm,City,State,Country,strRegion_nm,AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,        
  bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,bitPicker,bitFreeStanding,AHA_id,PENumber)        
SELECT SampleUnit_id,ParentSampleUnit_id,RTRIM(LTRIM(strSampleUnit_nm)),Survey_id,Study_id,        
  strUnitSelectType,intLevel,RTRIM(LTRIM(strLevel_nm)),bitSuppress,bitHCAHPS,bitHHCAHPS,bitCHART, bitMNCM, MedicareNumber,        
  MedicareName,MedicareActive,strFacility_nm,City,State,Country,strRegion_nm,AdmitNumber,BedSize,bitPeds,        
  bitTeaching,bitTrauma,bitReligious,bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,        
  bitPicker,bitFreeStanding,AHA_id,PENumber        
FROM QUALISYS.QP_Prod.dbo.WEB_SampleUnits_View        
        
delete t        
from #sampleunit t, #Canada c        
where t.survey_id=c.survey_id        
        
UPDATE su        
SET su.strSampleUnit_nm=t.strSampleUnit_nm, su.Study_id=t.Study_id, su.Survey_id=t.Survey_id,        
su.strUnitSelectType=CASE WHEN su.strUnitSelectType <> t.strUnitSelectType THEN 'B' ELSE        
su.strUnitSelectType END, su.bitSuppress=t.bitSuppress,bitHCAHPS=t.bitHCAHPS, su.bitHHCAHPS=t.bitHHCAHPS,        
su.bitCHART = t.bitCHART, su.bitMNCM = t.bitMNCM, su.MedicareNumber=t.MedicareNumber,su.MedicareName=t.MedicareName,        
su.MedicareActive=t.MedicareActive,su.strFacility_nm=t.strFacility_nm,su.City=t.City,su.State=t.State,su.Country=t.Country,        
su.strRegion_nm=t.strRegion_nm,su.AdmitNumber=t.AdmitNumber,su.BedSize=t.BedSize,su.bitPeds=t.bitPeds,        
su.bitTeaching=t.bitTeaching,su.bitTrauma=t.bitTrauma,su.bitReligious=t.bitReligious,bitGovernment=t.bitGovernment,        
su.bitRural=t.bitRural,su.bitForProfit=t.bitForProfit,su.bitRehab=t.bitRehab,su.bitCancerCenter=t.bitCancerCenter,        
su.bitPicker=t.bitPicker,su.bitFreeStanding=t.bitFreeStanding,su.AHA_id=t.AHA_id, su.PENumber=t.PENumber        
FROM SampleUnit su,#SampleUnit t        
WHERE t.SampleUnit_id=su.SampleUnit_id        
        
DELETE t        
FROM SampleUnit su,#SampleUnit t        
WHERE t.SampleUnit_id=su.SampleUnit_id        
        
-- Figure out which plans need to be reordered        
CREATE TABLE #ReOrderSampleUnit (Survey_id INT,SamplePlan_id INT)        
        
INSERT INTO #ReOrderSampleUnit (Survey_id,SamplePlan_id)        
SELECT DISTINCT su.Survey_id,SamplePlan_id        
FROM #SampleUnit su,SamplePlan sp        
WHERE su.Survey_id=sp.Survey_id        
        
INSERT INTO SampleUnit (SampleUnit_id,ParentSampleUnit_id,strSampleUnit_nm,Survey_id,Study_id,        
strUnitSelectType,intLevel,strLevel_nm,bitSuppress,bitHCAHPS,bitHHCAHPS,bitCHART,bitMNCM, MedicareNumber, MedicareName,        
MedicareActive,strFacility_nm,City,State,Country,strRegion_nm,AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,        
bitReligious,bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,bitPicker,bitFreeStanding,AHA_id,PENumber)        
SELECT SampleUnit_id,ParentSampleUnit_id,strSampleUnit_nm,Survey_id,Study_id,strUnitSelectType,        
intLevel,strLevel_nm,bitSuppress,bitHCAHPS,bitHHCAHPS,bitCHART,bitMNCM,MedicareNumber, MedicareName,        
MedicareActive,strFacility_nm,City,State,Country,strRegion_nm,AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,        
bitReligious,bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,bitPicker,bitFreeStanding,AHA_id,PENumber        
FROM #SampleUnit        
        
DROP TABLE #SampleUnit        
        
-- Update (t)SampleUnitSection ************************************************************************************************************        
-- Create #temp table to hold QUALISYS.(t)SampleUnitSection records        
print '--Update SampleUnitSection'        
        
CREATE TABLE #SampleUnitSection (SampleUnitSection_id INT,SampleUnit_id INT,        
  SelQstnsSection INT,SelQstnsSurvey_id INT)        
        
-- Gather all QUALISYS.(t)SampleUnitSection records into a #temp table        
INSERT INTO #SampleUnitSection (SampleUnitSection_id,SampleUnit_id,        
SelQstnsSection,SelQstnsSurvey_id)        
SELECT SampleUnitSection_id,SampleUnit_id,SelQstnsSection,SelQstnsSurvey_id        
FROM QUALISYS.QP_Prod.dbo.SampleUnitSection        
        
delete t        
from #SampleUnitSection t, sampleunit su, #canada c        
where t.sampleunit_id=su.sampleunit_id        
and su.survey_id=c.survey_id        
        
BEGIN TRAN        
        
DELETE SampleUnitSection WHERE selqstnsSurvey_id  NOT IN (4,5,7) -- 4,5,7 are Demo Site info        
-- Changed 01/15/07 AndyG to remove hardcoding of "Demo" Survey ID's        
        
-- DELETE SampleUnitSection        
-- from SampleUnitSection sus join ClientStudySurvey css        
-- on sus.selqstnsSurvey_id = css.Survey_ID        
-- WHERE css.bitDemoData = 0 --Only clear data not related to Demo's        
        
IF @@ERROR <> 0        
BEGIN        
  ROLLBACK TRAN        
  RETURN        
END        
        
-- DELETE (#t)SampleUnitSection where not exists (f)SampleUnit_id in (t)SampleUnit        
-- Chg 5/2/03 SJS        
        
        
DELETE FROM #SampleUnitSection WHERE NOT EXISTS (SELECT * FROM SampleUnit su WHERE #SampleUnitSection.sampleunit_id=su.sampleunit_id)        
IF @@ERROR <> 0        
BEGIN        
  ROLLBACK TRAN        
  RETURN        
END        
        
--clear out any duplicate key info from the perm. table so it can be re-inserted without a primary key violation        
delete s        
from #SampleUnitSection t, SampleUnitSection s        
where t.sampleunit_ID = s.sampleunit_ID and        
  t.selqstnssection = s.SelQstnsSection        
        
        
IF @@ERROR <> 0        
BEGIN        
  ROLLBACK TRAN        
  RETURN        
END        
        
-- Insert net (#t)SampleUnitSection records in (t)SampleUnitSection        
INSERT INTO SampleUnitSection (SampleUnitSection_id,SampleUnit_id,        
  SelQstnsSection,SelQstnsSurvey_id)        
SELECT SampleUnitSection_id,SampleUnit_id,SelQstnsSection,SelQstnsSurvey_id        
FROM #SampleUnitSection        
        
        
        
IF @@ERROR <> 0        
BEGIN        
  ROLLBACK TRAN        
  RETURN        
END        
        
-- Commit the transaction (sections) that did NOT produce an error (@@ERROR<>0)        
COMMIT TRAN        
        
DROP TABLE #SampleUnitSection        
        
--Now to reorder (t)SampleUnit***********************************************************************************************************************        
DECLARE @SamplePlan INT        
        
WHILE (SELECT COUNT(*) FROM #ReOrderSampleUnit) > 0        
BEGIN        
        
      SET @SamplePlan=(SELECT TOP 1 SamplePlan_id FROM #ReOrderSampleUnit ORDER BY SamplePlan_id)        
        
      SET @sql='EXEC SP_Extract_SampleUnits '+CONVERT(VARCHAR,@SamplePlan)        
        
      EXEC (@sql)        
        
      DELETE #ReOrderSampleUnit WHERE SamplePlan_id=@SamplePlan        
        
END        
        
DROP TABLE #ReOrderSampleUnit        
        
CREATE TABLE #SampleUnit_Full (SAMPLEUNIT_ID INT,CRITERIASTMT_ID INT,SamplePlan_ID INT,PARENTSAMPLEUNIT_ID INT,STRSAMPLEUNIT_NM VARCHAR(42),INTTARGETRETURN INT,INTMINCONFIDENCE INT,        
INTMAXMARGIN INT,NUMINITRESPONSERATE INT,NUMRESPONSERATE INT,REPORTING_HIERARCHY_ID INT)        
        
INSERT INTO #SampleUnit_Full (SAMPLEUNIT_ID,CRITERIASTMT_ID,SamplePlan_ID,PARENTSAMPLEUNIT_ID,STRSAMPLEUNIT_NM,INTTARGETRETURN,INTMINCONFIDENCE,INTMAXMARGIN,NUMINITRESPONSERATE,        
NUMRESPONSERATE,REPORTING_HIERARCHY_ID)        
SELECT DISTINCT SAMPLEUNIT_ID,CRITERIASTMT_ID,SamplePlan_ID,PARENTSAMPLEUNIT_ID,STRSAMPLEUNIT_NM,INTTARGETRETURN,INTMINCONFIDENCE,INTMAXMARGIN,NUMINITRESPONSERATE,NUMRESPONSERATE,        
REPORTING_HIERARCHY_ID FROM QUALISYS.QP_Prod.dbo.sampleunit        
        
delete t        
from #SampleUnit_Full t, sampleunit su, #canada c        
where t.sampleunit_id=su.sampleunit_id        
and su.survey_id=c.survey_id        
        
UPDATE s        
SET s.criteriastmt_id=t.criteriastmt_id,s.SamplePlan_ID=t.SamplePlan_ID,s.PARENTSAMPLEUNIT_ID=t.PARENTSAMPLEUNIT_ID,        
s.STRSAMPLEUNIT_NM=t.STRSAMPLEUNIT_NM,s.INTTARGETRETURN=t.INTTARGETRETURN,s.INTMINCONFIDENCE=t.INTMINCONFIDENCE,        
s.INTMAXMARGIN=t.INTMAXMARGIN,s.NUMINITRESPONSERATE=t.NUMINITRESPONSERATE,s.NUMRESPONSERATE=t.NUMRESPONSERATE,        
s.REPORTING_HIERARCHY_ID=t.REPORTING_HIERARCHY_ID        
FROM #SampleUnit_Full t,SampleUnit_Full s        
WHERE t.sampleunit_id=s.sampleunit_id        
        
DELETE t        
FROM #SampleUnit_Full t,SampleUnit_Full s        
WHERE t.sampleunit_id=s.sampleunit_id        
        
INSERT INTO SampleUnit_Full (SAMPLEUNIT_ID,CRITERIASTMT_ID,SamplePlan_ID,PARENTSAMPLEUNIT_ID,STRSAMPLEUNIT_NM,INTTARGETRETURN,INTMINCONFIDENCE,INTMAXMARGIN,NUMINITRESPONSERATE,        
NUMRESPONSERATE,REPORTING_HIERARCHY_ID)        
SELECT DISTINCT SAMPLEUNIT_ID,CRITERIASTMT_ID,SamplePlan_ID,PARENTSAMPLEUNIT_ID,STRSAMPLEUNIT_NM,INTTARGETRETURN,INTMINCONFIDENCE,INTMAXMARGIN,NUMINITRESPONSERATE,NUMRESPONSERATE,        
REPORTING_HIERARCHY_ID        
FROM #SampleUnit_Full        
        
DROP TABLE #SampleUnit_Full        
        
CREATE TABLE #Unscaled_Questions (Survey_id INT,QstnCore INT,Label VARCHAR(60),strCmntorhand CHAR(1))        
        
INSERT INTO #Unscaled_Questions (Survey_id,QstnCore,Label,strCmntorhand)        
SELECT Survey_id,QstnCore,questionLabel,strCmntorhand        
FROM QUALISYS.QP_Prod.dbo.Comments_Unscaled_Questions_View        
        
delete t        
from #Unscaled_Questions t, #canada c        
where t.survey_id=c.survey_id        
        
UPDATE u        
SET u.Label=t.Label,u.strCmntorhand=t.strCmntorhand        
FROM #Unscaled_Questions t,Unscaled_Questions u        
WHERE t.Survey_id=u.Survey_id        
AND t.QstnCore=u.QstnCore        
        
DELETE t        
FROM #Unscaled_Questions t,Unscaled_Questions u        
WHERE t.Survey_id=u.Survey_id        
AND t.QstnCore=u.QstnCore        
        
INSERT INTO Unscaled_Questions (Survey_id,QstnCore,Label,strCmntorhand)        
SELECT Survey_id,QstnCore,Label,strCmntorhand        
FROM #Unscaled_Questions        
        
DROP TABLE #Unscaled_Questions        
        
-- removed 20030730-sjs (see sp_extract_resprate)        
-- CREATE TABLE #RespRateCount (Survey_id INT,SampleSet_id INT,SampleUnit_id INT,        
--  intSampled INT,intUD INT,intReturned INT,datSampleCreate_dt DATETIME)        
--        
-- INSERT INTO #RespRateCount (Survey_id,SampleSet_id,SampleUnit_id,intSampled,        
--   intUD,intReturned,datSampleCreate_dt)        
-- SELECT Survey_id,SampleSet_id,SampleUnit_id,intSampled,intUD,intReturned,        
--   datSampleCreate_dt        
-- FROM QUALISYS.QP_Prod.dbo.RespRateCount        
--        
-- BEGIN TRAN        
--        
--  DELETE RespRateCount        
--        
--  INSERT INTO RespRateCount (Survey_id,SampleSet_id,SampleUnit_id,intSampled,        
--intUD,intReturned,datSampleCreate_dt)        
--  SELECT Survey_id,SampleSet_id,SampleUnit_id,intSampled,intUD,intReturned,        
--datSampleCreate_dt        
--  FROM #RespRateCount        
--        
-- COMMIT TRAN        
--        
-- DROP TABLE #RespRateCount        
        
CREATE TABLE #Global_Attribute (Survey_id INT,Study_id INT,strContactName VARCHAR(40),        
strContactPhone VARCHAR(25),intQuarter INT)        
        
INSERT INTO #Global_Attribute (Survey_id,Study_id,strContactName,strContactPhone,intQuarter)        
SELECT Survey_id,Study_id,strContactName,strContactPhone,intQuarter        
FROM QUALISYS.QP_Prod.dbo.WEB_Global_Attribute_View        
        
delete t        
from #Global_Attribute t, #canada c        
where t.survey_id=c.survey_id  --> gilsdorf: This is safe to do even though Global_Attribute gets truncated next. The canadian records get repopulated during the call to "SP_Extract_ApplicationTables_DM_To_DM 'NRCC04.QP_Comments'"        
        
TRUNCATE TABLE Global_Attribute        
        
INSERT INTO Global_Attribute (Survey_id,Study_id,strContactName,strContactPhone,intQuarter)        
SELECT Survey_id,Study_id,strContactName,strContactPhone,intQuarter        
FROM #Global_Attribute        
        
DROP TABLE #Global_Attribute        
        
CREATE TABLE #Employee_Access (strNTLogin_nm VARCHAR(20),Study_id INT)        
        
INSERT INTO #Employee_Access (strNTLogin_nm,Study_id)        
SELECT strNTLogin_nm,Study_id        
FROM QUALISYS.QP_Prod.dbo.WEB_Employee_Access_View    
        
delete t        
from #Employee_Access t, #canada c        
where t.study_id=c.study_id --> This is safe to do even though Employee_Access gets truncated next. The canadian records get repopulated during the call to "SP_Extract_ApplicationTables_DM_To_DM 'NRCC04.QP_Comments'"        
        
TRUNCATE TABLE Employee_Access        
        
INSERT INTO Employee_Access (strNTLogin_nm,Study_id)        
SELECT strNTLogin_nm,Study_id        
FROM #Employee_Access        
        
DROP TABLE #Employee_Access        
        
CREATE TABLE #lu_EmployeeSecurity (strNTLogin_nm VARCHAR(20))        
        
INSERT INTO #lu_EmployeeSecurity (strNTLogin_nm)        
SELECT strNTLogin_nm        
FROM QUALISYS.QP_Prod.dbo.Employee        
        
DELETE t        
FROM #lu_EmployeeSecurity t,lu_EmployeeSecurity l        
WHERE t.strNTLogin_nm=l.strNTlogin_nm        
        
INSERT INTO lu_EmployeeSecurity (strNTLogin_nm,strPassword,dtiExpirationDate,        
  strPassword1,numLastPasswordUsed)        
SELECT strNTLogin_nm,strNTLogin_nm,DATEADD(MONTH,1,GETDATE()),strNTLogin_nm,1        
FROM #lu_EmployeeSecurity        
        
DROP TABLE #lu_EmployeeSecurity        
        
--Make sure all SampleUnits have an intOrder Value        
EXEC SP_DBM_ReorderSampleUnit        
        
        
-- Determine if any Questions are both single and multiple response and set the nummarkcnt Value to the maximum Value for the question. (bd/ss 11/21/03)        
SELECT Study_id,QstnCore,MAX(numMarkCount) AS nmk        
INTO #temp        
FROM Questions q,ClientStudySurvey c        
WHERE q.Survey_id=c.Survey_id        
GROUP BY Study_id,QstnCore        
        
delete t        
from #temp t, #canada c        
where t.study_id=c.study_id         
        
UPDATE q        
SET q.numMarkCount=t.nmk        
FROM #temp t,Questions q,ClientStudySurvey c        
WHERE t.Study_id=c.Study_id        
AND c.Survey_id=q.Survey_id        
AND t.QstnCore=q.QstnCore        
AND nmk<>numMarkCount        
        
-- Update (t)Disposition ************************************************************************************************************        
print '-- Update Disposition'        
CREATE TABLE #Disposition (        
Disposition_id INT,        
strDispositionLabel VARCHAR(100),        
Action_id INT,        
strReportLabel VARCHAR(100)        
)        
        
INSERT INTO #Disposition (Disposition_id,strDispositionLabel,Action_id,strReportLabel)        
SELECT Disposition_id,strDispositionLabel,Action_id,strReportLabel        
FROM QUALISYS.QP_Prod.dbo.Disposition        
        
UPDATE d        
SET strDispositionLabel=t.strDispositionLabel, Action_id=t.Action_id,        
    strReportLabel=t.strReportLabel        
FROM #Disposition t, Disposition d        
WHERE t.Disposition_id=d.Disposition_id        
        
DELETE t        
FROM #Disposition t, Disposition d        
WHERE t.Disposition_id=d.Disposition_id        
        
INSERT INTO Disposition (Disposition_id,strDispositionLabel,Action_id,strReportLabel)        
SELECT Disposition_id,strDispositionLabel,Action_id,strReportLabel        
FROM #Disposition        
        
DROP TABLE #Disposition        
        
-- Update HCAHPSDisposition ************************************************************************************************************        
print '-- Update HCAHPSDisposition'        
        
        
CREATE TABLE #HCAHPSDisposition (        
HCAHPSDispositionID INT,        
Disposition_id INT,        
HCAHPSValue VARCHAR(5),        
HCAHPSHierarchy INT,        
HCAHPSDesc VARCHAR(100),        
ExportReportResponses bit        
)        
INSERT INTO #HCAHPSDisposition (HCAHPSDispositionID, Disposition_id,HCAHPSValue,HCAHPSHierarchy,HCAHPSDesc,ExportReportResponses)        
SELECT HCAHPSDispositionID, Disposition_id,HCAHPSValue,HCAHPSHierarchy,HCAHPSDesc,ExportReportResponses        
FROM QUALISYS.QP_Prod.dbo.HCAHPSDispositions        
        
UPDATE d        
SET d.HCAHPSValue=t.HCAHPSValue, d.HCAHPSHierarchy=t.HCAHPSHierarchy,        
    d.HCAHPSDesc=t.HCAHPSDesc, d.ExportReportResponses = t.ExportReportResponses        
FROM #HCAHPSDisposition t, HCAHPSDispositions d        
WHERE t.HCAHPSDispositionID=d.HCAHPSDispositionID        
        
DELETE t        
FROM #HCAHPSDisposition t, HCAHPSDispositions d        
WHERE t.HCAHPSDispositionid=d.HCAHPSDispositionid        
        
INSERT INTO HCAHPSDispositions (HCAHPSDispositionID, Disposition_id,HCAHPSValue,HCAHPSHierarchy,HCAHPSDesc,ExportReportResponses)        
SELECT HCAHPSDispositionID, Disposition_id,HCAHPSValue,HCAHPSHierarchy,HCAHPSDesc,ExportReportResponses        
FROM #HCAHPSDisposition        
        
DROP TABLE #HCAHPSDisposition        
        
-- Update HHCAHPSDisposition ************************************************************************************************************        
        
print '-- Update HHCAHPSDisposition'        
CREATE TABLE #HHCAHPSDisposition (        
HHCAHPSDispositionID INT,        
Disposition_id INT,        
HHCAHPSValue VARCHAR(5),        
HHCAHPSHierarchy INT,        
HHCAHPSDesc VARCHAR(100),        
ExportReportResponses bit        
)        
INSERT INTO #HHCAHPSDisposition (HHCAHPSDispositionID, Disposition_id,HHCAHPSValue,HHCAHPSHierarchy,HHCAHPSDesc,ExportReportResponses)        
SELECT HHCAHPSDispositionID, Disposition_id,HHCAHPSValue,HHCAHPSHierarchy,HHCAHPSDesc,ExportReportResponses        
FROM QUALISYS.QP_Prod.dbo.HHCAHPSDispositions        
        
UPDATE d        
SET d.HHCAHPSValue=t.HHCAHPSValue, d.HHCAHPSHierarchy=t.HHCAHPSHierarchy,        
    d.HHCAHPSDesc=t.HHCAHPSDesc, d.ExportReportResponses=t.ExportReportResponses        
FROM #HHCAHPSDisposition t, HHCAHPSDispositions d        
WHERE t.HHCAHPSDispositionID=d.HHCAHPSDispositionID        
        
DELETE t        
FROM #HHCAHPSDisposition t, HHCAHPSDispositions d        
WHERE t.HHCAHPSDispositionid=d.HHCAHPSDispositionid        
        
INSERT INTO HHCAHPSDispositions (HHCAHPSDispositionID, Disposition_id,HHCAHPSValue,HHCAHPSHierarchy,HHCAHPSDesc,ExportReportResponses)        
SELECT HHCAHPSDispositionID, Disposition_id,HHCAHPSValue,HHCAHPSHierarchy,HHCAHPSDesc,ExportReportResponses        
FROM #HHCAHPSDisposition        
        
DROP TABLE #HHCAHPSDisposition        
        
        
        
        
        
-- Update MNCMDisposition ************************************************************************************************************        
print '-- Update MNCMDisposition'        
CREATE TABLE #MNCMDisposition (        
MNCMDispositionID INT,        
Disposition_id INT,        
MNCMValue VARCHAR(5),        
MNCMHierarchy INT,        
MNCMDesc VARCHAR(100),        
ExportReportResponses bit        
)        
INSERT INTO #MNCMDisposition (MNCMDispositionID, Disposition_id,MNCMValue,MNCMHierarchy,MNCMDesc,ExportReportResponses)        
SELECT MNCMDispositionID, Disposition_id,MNCMValue,MNCMHierarchy,MNCMDesc,ExportReportResponses        
FROM QUALISYS.QP_Prod.dbo.MNCMDispositions        
        
UPDATE d        
SET d.MNCMValue=t.MNCMValue, d.MNCMHierarchy=t.MNCMHierarchy,        
d.MNCMDesc=t.MNCMDesc, d.ExportReportResponses=t.ExportReportResponses        
FROM #MNCMDisposition t, MNCMDispositions d        
WHERE t.MNCMDispositionID=d.MNCMDispositionID        
        
DELETE t        
FROM #MNCMDisposition t, MNCMDispositions d        
WHERE t.MNCMDispositionid=d.MNCMDispositionid        
        
INSERT INTO MNCMDispositions (MNCMDispositionID, Disposition_id,MNCMValue,MNCMHierarchy,MNCMDesc,ExportReportResponses)        
SELECT MNCMDispositionID, Disposition_id,MNCMValue,MNCMHierarchy,MNCMDesc,ExportReportResponses        
FROM #MNCMDisposition        
        
DROP TABLE #MNCMDisposition        
        
-- Update SurveyTypeDisposition ************************************************************************************************************           
-- Added 06/13/2014 TSB Sprint2, Task 15.3                                   
print '-- Update SurveyTypeDisposition'                                     
CREATE TABLE #SurveyTypeDisposition (                          
SurveyTypeDispositionID INT,                                  
Disposition_id INT,                                      
Value VARCHAR(5),                         
Hierarchy INT,                                      
[Desc] VARCHAR(100),                
ExportReportResponses bit,        
SurveyType_ID int                                 
)                   
INSERT INTO #SurveyTypeDisposition (SurveyTypeDispositionID, Disposition_id,Value,Hierarchy,[Desc],ExportReportResponses,SurveyType_ID)                                      
SELECT SurveyTypeDispositionID, Disposition_id,Value,Hierarchy,[Desc],ExportReportResponses,SurveyType_ID                                      
FROM QUALISYS.QP_Prod.dbo.SurveyTypeDispositions                                     
                                      
UPDATE d                                      
SET d.Value=t.Value,         
 d.Hierarchy=t.Hierarchy,                                      
    d.[Desc]=t.[Desc],         
 d.ExportReportResponses=t.ExportReportResponses,        
 d.SurveyType_ID = t.SurveyType_ID                                  
FROM #SurveyTypeDisposition t, SurveyTypeDispositions d                                      
WHERE t.SurveyTypeDispositionID=d.SurveyTypeDispositionID                                      
                                      
DELETE t                                      
FROM #SurveyTypeDisposition t, SurveyTypeDispositions d                                      
WHERE t.SurveyTypeDispositionid=d.SurveyTypeDispositionid                                      
                                      
INSERT INTO SurveyTypeDispositions (SurveyTypeDispositionID, Disposition_id,Value,Hierarchy,[Desc],ExportReportResponses,SurveyType_ID)                                      
SELECT SurveyTypeDispositionID, Disposition_id,Value,Hierarchy,[Desc],ExportReportResponses,SurveyType_ID                                      
FROM #SurveyTypeDisposition                                      
                              
DROP TABLE #SurveyTypeDisposition                                        

-- Update SurveySubType variant ******************************************************************************************************
-- Added 10/9/2014 CJB Sprint 10 Task 13.3
print '-- Update SurveySubType variant'
CREATE TABLE #SurveySubtype (
		[SurveySubtype_id] [int] NOT NULL,
		[Survey_id] [int] NULL,
		[Subtype_nm] [varchar](50) NULL,
)

INSERT INTO #SurveySubtype (SurveySubtype_id, Survey_id, Subtype_nm)
SELECT SurveySubType_id, Survey_id, SubType_nm
from QUALISYS.QP_Prod.dbo.SurveySubType sst 
inner join QUALISYS.QP_Prod.dbo.SubType st on sst.subtype_id = st.subtype_id

UPDATE d
SET d.Survey_id = t.Survey_id,
d.Subtype_nm = t.subtype_nm
from #SurveySubtype t, SurveySubtype d
where t.SurveySubtype_id = d.SurveySubtype_id 

DELETE t
from #SurveySubtype t, SurveySubtype d
where t.SurveySubtype_id = d.SurveySubtype_id

INSERT INTO SurveySubtype (SurveySubtype_id, Survey_id, Subtype_nm)
select SurveySubtype_id, Survey_id, Subtype_nm
from #SurveySubtype

DROP TABLE #SurveySubtype
        
-- Update SurveyTypeQuestionMappings variant ******************************************************************************************************
-- Added 10/9/2014 CJB Sprint 10 Task 13.3
print '-- Update SurveyTypeQuestionMappings variant'
CREATE TABLE #SurveyTypeQuestionMappings (
		[SurveyType_id] [int] NOT NULL,
		[QstnCore] [int] NOT NULL,
		[intOrder] [int] NULL,
		[bitFirstOnForm] [bit] NULL,
		[bitExpanded] [bit] NOT NULL,
		[datEncounterStart_dt] [datetime] NULL,
		[datEncounterEnd_dt] [datetime] NULL,
		[SubType_id] [int] NOT NULL,
		[Subtype_nm] [varchar](50) NULL
)

INSERT INTO #SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_id, Subtype_nm)
SELECT SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, stqm.SubType_id, SubType_nm
from QUALISYS.QP_Prod.dbo.SurveyTypeQuestionMappings stqm 
left join QUALISYS.QP_Prod.dbo.SubType st on stqm.subtype_id = st.subtype_id

UPDATE d
SET d.Subtype_nm = t.subtype_nm,
d.bitFirstOnForm = t.bitFirstOnForm,
d.bitExpanded = t.bitExpanded,
d.datEncounterStart_dt = t.datEncounterStart_dt,
d.datEncounterEnd_dt = t.datEncounterEnd_dt
from #SurveyTypeQuestionMappings t, SurveyTypeQuestionMappings d
where t.SurveyType_id = d.SurveyType_id 
  and t.QstnCore = d.QstnCore
  and t.intOrder = d.intOrder
  and t.SubType_id = d.SubType_id

DELETE t
from #SurveyTypeQuestionMappings t, SurveyTypeQuestionMappings d
where t.SurveyType_id = d.SurveyType_id 
  and t.QstnCore = d.QstnCore
  and t.intOrder = d.intOrder
  and t.SubType_id = d.SubType_id

INSERT INTO SurveyTypeQuestionMappings (SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_id, Subtype_nm)
SELECT SurveyType_id, QstnCore, intOrder, bitFirstOnForm, bitExpanded, datEncounterStart_dt, datEncounterEnd_dt, SubType_id, SubType_nm
from #SurveyTypeQuestionMappings

DROP TABLE #SurveyTypeQuestionMappings
        
-- Update SAMPLESET table ************************************************************************************************************        
print '-- Update SAMPLESET'        
CREATE TABLE #Sampleset (        
[SAMPLESET_ID] [int] NOT NULL ,        
[SAMPLEPLAN_ID] [int] NOT NULL ,        
[SURVEY_ID] [int] NULL ,        
[EMPLOYEE_ID] [int] NOT NULL ,        
[DATSAMPLECREATE_DT] [datetime] NULL ,        
[intDateRange_Table_id] [int] NULL ,        
[intDateRange_Field_id] [int] NULL ,        
[datDateRange_FromDate] [datetime] NULL ,        
[datDateRange_ToDate] [datetime] NULL ,        
[tiOversample_flag] [tinyint] NULL ,        
[tiNewPeriod_flag] [tinyint] NULL ,        
[strSampleSurvey_nm] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,        
[extract_flg] [tinyint] NULL ,        
[datLastMailed] [datetime] NULL ,        
[tiUnikeysDeled] [tinyint] NULL ,        
[web_extract_flg] [tinyint] NULL ,        
[intSample_Seed] [int] NULL ,        
[PreSampleTime] [int] NULL ,        
[PostSampleTime] [int] NULL ,        
[datScheduled] [datetime] NULL ,        
[SamplingAlgorithmId] [int] NULL ,        
[SurveyType_Id] [int] NULL        
) ON [PRIMARY]        
        
INSERT INTO #Sampleset (SAMPLESET_ID,SAMPLEPLAN_ID,SURVEY_ID,EMPLOYEE_ID,DATSAMPLECREATE_DT,intDateRange_Table_id,intDateRange_Field_id,datDateRange_FromDate,datDateRange_ToDate,tiOversample_flag,        
tiNewPeriod_flag,strSampleSurvey_nm,extract_flg,datLastMailed,tiUnikeysDeled,web_extract_flg,intSample_Seed,PreSampleTime,PostSampleTime,datScheduled,SamplingAlgorithmId,SurveyType_Id)        
SELECT SAMPLESET_ID,SAMPLEPLAN_ID,SURVEY_ID,EMPLOYEE_ID,DATSAMPLECREATE_DT,intDateRange_Table_id,intDateRange_Field_id,datDateRange_FromDate,datDateRange_ToDate,tiOversample_flag,        
tiNewPeriod_flag,strSampleSurvey_nm,extract_flg,datLastMailed,tiUnikeysDeled,web_extract_flg,intSample_Seed,PreSampleTime,PostSampleTime,datScheduled,SamplingAlgorithmId,SurveyType_Id        
FROM QUALISYS.QP_Prod.dbo.WEB_Sampleset_View        
        
delete t        
from #sampleset t, #canada c        
where t.survey_id=c.survey_id          
        
UPDATE s        
SET        
s.SAMPLESET_ID = t.SAMPLESET_ID,        
s.SAMPLEPLAN_ID = t.SAMPLEPLAN_ID,        
s.SURVEY_ID = t.SURVEY_ID,        
s.EMPLOYEE_ID = t.EMPLOYEE_ID,        
s.DATSAMPLECREATE_DT= t.DATSAMPLECREATE_DT,        
s.intDateRange_Table_id = t.intDateRange_Table_id,        
s.intDateRange_Field_id = t.intDateRange_Field_id,        
s.datDateRange_FromDate = t.datDateRange_FromDate,        
s.datDateRange_ToDate = t.datDateRange_ToDate,        
s.tiOversample_flag = t.tiOversample_flag,        
s.tiNewPeriod_flag = t.tiNewPeriod_flag,        
s.strSampleSurvey_nm = t.strSampleSurvey_nm,        
s.extract_flg = t.extract_flg,        
s.datLastMailed = t.datLastMailed,        
s.tiUnikeysDeled  = t.tiUnikeysDeled,        
s.web_extract_flg = t.web_extract_flg,        
s.intSample_Seed = t.intSample_Seed,        
s.PreSampleTime = t.PreSampleTime,        
s.PostSampleTime = t.PostSampleTime,        
s.datScheduled = t.datScheduled,        
s.SamplingAlgorithmId = t.SamplingAlgorithmId,        
s.SurveyType_Id = t.SurveyType_Id        
FROM #Sampleset t INNER JOIN Sampleset s  ON t.sampleset_Id = s.sampleset_id        
        
DELETE t        
FROM #Sampleset t INNER JOIN Sampleset s  ON t.sampleset_Id = s.sampleset_id        
        
INSERT INTO Sampleset (SAMPLESET_ID,SAMPLEPLAN_ID,SURVEY_ID,EMPLOYEE_ID,DATSAMPLECREATE_DT,intDateRange_Table_id,intDateRange_Field_id,datDateRange_FromDate,datDateRange_ToDate,tiOversample_flag,        
tiNewPeriod_flag,strSampleSurvey_nm,extract_flg,datLastMailed,tiUnikeysDeled,web_extract_flg,intSample_Seed,PreSampleTime,PostSampleTime,datScheduled,SamplingAlgorithmId,SurveyType_Id)        
SELECT SAMPLESET_ID,SAMPLEPLAN_ID,SURVEY_ID,EMPLOYEE_ID,DATSAMPLECREATE_DT,intDateRange_Table_id,intDateRange_Field_id,datDateRange_FromDate,datDateRange_ToDate,tiOversample_flag,        
tiNewPeriod_flag,strSampleSurvey_nm,extract_flg,datLastMailed,tiUnikeysDeled,web_extract_flg,intSample_Seed,PreSampleTime,PostSampleTime,datScheduled,SamplingAlgorithmId,SurveyType_Id        
FROM #Sampleset        
        
DROP TABLE #Sampleset        
        
        
        
-- Update Vendor Table ************************************************************************************************************        
print '-- Update Vendor'        
--grab all records from qualisys vendor table.        
--table is small so this is not a performance concern        
Select Vendor_ID,VendorCode,Vendor_nm,Phone,Addr1,Addr2,City,StateCode,Province,Zip5,Zip4,DateCreated,DateModified,        
  bitAcceptFilesFromVendor,NoResponseChar,SkipResponseChar,MultiRespItemNotPickedChar,LocalFTPLoginName        
into #Vendors        
from QUALISYS.QP_Prod.dbo.Vendors qV        
        
--update all existing vendor information        
update V        
set        
V.VendorCode = qV.VendorCode,        
V.Vendor_nm = qV.Vendor_nm ,        
V.Phone = qV.Phone,        
V.Addr1 = qV.Addr1 ,        
V.Addr2 = qV.Addr2,        
V.City = qV.City,        
V.StateCode = qV.StateCode,        
V.Province = qV.Province,        
V.Zip5 = qV.Zip5,        
V.Zip4 = qV.Zip4,        
V.DateCreated = qV.DateCreated,        
V.DateModified = qV.DateModified,        
V.bitAcceptFilesFromVendor = qV.bitAcceptFilesFromVendor,        
V.NoResponseChar = qV.NoResponseChar,      
V.SkipResponseChar = qV.SkipResponseChar,        
V.MultiRespItemNotPickedChar = qV.MultiRespItemNotPickedChar,        
V.LocalFTPLoginName = qV.LocalFTPLoginName        
from Vendors V, #Vendors qV        
where v.Vendor_ID = qV.Vendor_ID        
        
--delete all records we just updated        
Delete qV        
from Vendors V, #Vendors qV        
where v.Vendor_ID = qV.Vendor_ID        
        
        
--insert the new records still left in the table        
--DRM 9/26/2011 Added vendor_id to insert and select as it is not an identity on medusa.        
Insert into Vendors (vendor_id, VendorCode,Vendor_nm,Phone,Addr1,Addr2,City,StateCode,Province,Zip5,Zip4,DateCreated,        
     DateModified,bitAcceptFilesFromVendor,NoResponseChar,SkipResponseChar,        
     MultiRespItemNotPickedChar,LocalFTPLoginName)        
select    vendor_id, VendorCode,Vendor_nm,Phone,Addr1,Addr2,City,StateCode,Province,Zip5,Zip4,DateCreated,        
     DateModified,bitAcceptFilesFromVendor,NoResponseChar,SkipResponseChar,        
     MultiRespItemNotPickedChar,LocalFTPLoginName        
from #Vendors        
        
        
        
-- The End (for now) *************************************************************************************************************************        
        
GO