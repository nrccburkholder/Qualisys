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
CREATE FUNCTION [dbo].[fn_ACOCAHPSUpdateForVersion]

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
CREATE procedure [dbo].[DCL_SelectACOCAHPSBySurveyId]
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

if object_id('tempdb..#sub') is not null
	drop table #sub
	
if object_id('tempdb..#studysurvey') is not null
	drop table #studysurvey
	
if object_id('tempdb..#dispositionlog') is not null
	drop table #dispositionlog
--declare @survey_id int = 15677, @startdate datetime = '1/1/2014', @enddate datetime = '2/1/2014'
create table #sub (sub_id int identity(1,1)
,study_id int
,survey_id int
,samplepop_id int
,FINDER  char(8)
,ACO_ID  char(5)
,DISPOSITN  char(2)
,MODE  char(1)
,DISPO_LANG  char(1)
,RECEIVED  char(8)
,FOCALTYPE  char(1)
,QVERSION char(2)
,PRTITLE  char(35)
,PRFNAME char(30) 
,PRLNAME char(50)
,notes varchar(100)
,ActionItem varchar(100)
,intSequence tinyint
,bitComplete bit
)
/*
select distinct study_id, survey_id, 0 as flag
into #studysurvey
from clientstudysurvey css
inner join qualisys.qp_prod.dbo.surveytype st on css.surveytype_id=st.surveytype_id
inner join sys.schemas ss on 's'+convert(varchar,css.study_id)=ss.name
inner join sys.views sv on ss.schema_id=sv.schema_id
where st.SurveyType_dsc='ACOCAHPS'
and sv.name ='study_results_view'
*/
declare @sql varchar(max), @study varchar(10)
declare @howhelped varchar(max)
select @study=study_id from clientstudysurvey where survey_id = @Survey_id

	set @sql='insert into #sub
				select distinct
				'+@study+'
				,'+convert(varchar,@survey_id)+'
				,bt.samplepop_id
				,left(bt.ACO_FinderNum,8) as [FINDER]
				,left(bt.ACO_ACOID,5) as [ACO_ID]
				,left(bt.ACODisposition,2) as [DISPOSITN]
				,''8'' as [MODE]
				,''8'' as [DISPO_LANG] --> this is the language the survey was /completed/ in.  "8" means "not applicable".
				,convert(varchar,sr.DATRETURNED,112) AS [RECEIVED]
				,bt.ACO_FocalType AS [FOCALTYPE]
				, ''NA'' as [QVERSION]
				,bt.DrTitle as [PRTITLE]
				,bt.DrFirstName as [PRFNAME]
				,bt.DrLastName as [PRLNAME]
				,'''','''', 0, sr.bitComplete
				from s'+@study+'.big_table_view bt
				left outer join s'+@study+'.study_results_view sr on bt.samplepop_id=sr.samplepop_id and bt.sampleunit_id=sr.sampleunit_id
				where bt.sampleunit_id in (select sampleunit_id from sampleunit where survey_id='+convert(varchar,@survey_id)+') and
				bt.DatSampleEncounterDate between '''+convert(nvarchar(max),@startDate)+''' AND '''+convert(nvarchar(max),@EndDate)+ ''''
--	print @sql
	exec (@SQL)
	
update s set QVERSION = case when subtype_nm = 'ACO-8' then '08' when subtype_nm = 'ACO-12' then '12' else 'NA' end from #sub s inner join SurveySubtype sst on s.survey_id = sst.Survey_id 
--select * from #sub s inner join SurveySubtype sst on s.survey_id = sst.Survey_id 
update #sub set dispositn='33' where dispositn is null 

create index #sub_sp on #sub (samplepop_id)

--select s.*, qf.datreturned, qf.unusedreturn_id, qf.datresultsimported
update #sub set notes='Returned, not imported / '
from #sub s
inner join qualisys.qp_prod.dbo.questionform qf on s.samplepop_id=qf.samplepop_id
where s.dispositn <> '10' 
and qf.datreturned is not null and datediff(day,isnull(qf.datresultsimported,getdate()),getdate())=0
--order by s.dispositn

--select s.*, schm.* 
update s set notes = notes + 'ScheduledForPhone / '
from #sub s 
inner join qualisys.qp_prod.dbo.scheduledmailing schm on s.samplepop_id=schm.samplepop_id
where schm.sentmail_id is null
--	order by s.dispositn --> 539 dispositn=null, 7 disp=35 (bad addr)

--select s.*, sm.* 
update s set DISPO_LANG=sm.LangID, intSequence=ms.intSequence 
from #sub S
inner join qualisys.qp_prod.dbo.questionform qf on s.samplepop_id=qf.samplepop_id
inner join qualisys.qp_prod.dbo.sentmailing sm on qf.sentmail_id=sm.sentmail_id
inner join qualisys.qp_prod.dbo.scheduledmailing scm on qf.sentmail_id=scm.sentmail_id
inner join qualisys.qp_prod.dbo.mailingstep ms on scm.mailingstep_id=ms.mailingstep_id
where s.dispositn in ('31','34','10')
and qf.datReturned is not null

select dl.*
into #dispositionlog
from qualisys.qp_prod.dbo.dispositionlog dl
inner join #sub on dl.samplepop_id=#sub.samplepop_id

update s set notes = notes + 'dead /'
from #sub s
left join #dispositionlog dl on s.samplepop_id=dl.samplepop_id
where dl.disposition_id=3

update s set notes = notes + 'refusal /'
from #sub s
left join #dispositionlog dl on s.samplepop_id=dl.samplepop_id
where dl.disposition_id=2

--update #sub set dispositn='32',received='88888888' where notes like '%refus%' and dispositn in ('31','34') --> returned a blank survey and refused (this was only in effect for the interimsubmission file)
--select * from #sub where notes like '%refus%' order by dispositn

--select * from datamart.qp_comments.dbo.acocahpsdispositions

update s set notes = notes + 'bad addr /'
from #sub s
left join #dispositionlog dl on s.samplepop_id=dl.samplepop_id
where dl.disposition_id=5

--select * from #sub where notes like '%bad addr%' and notes not like '%ScheduledForPhone%'
update #sub set ActionItem='--> Should have phone step scheduled'
where notes like '%bad addr%' and notes not like '%ScheduledForPhone%'

/*
select s.*, dl.disposition_id, dl.datlogged, d.strDispositionLabel
from #sub s
left join dispositionlog dl on s.samplepop_id=dl.samplepop_id
left join disposition d on dl.disposition_id=d.disposition_id
where (s.notes='' or s.notes like '%bad addr%')
and s.dispositn<>'10'
order by dispositn , datlogged
*/

update s set notes = notes + 'not applicable /'
from #sub s
left join #dispositionlog dl on s.samplepop_id=dl.samplepop_id
where dl.disposition_id=8

--select * from #sub where FINDER is null or ACO_ID is null or DISPOSITN is null or MODE is null or DISPO_LANG is null or RECEIVED is null or FOCALTYPE is null or PRTITLE is null or PRFNAME is null or PRLNAME is null
--select * from DispositionLog dl inner join disposition d on dl.disposition_id=d.disposition_id where samplepop_id=95466218

update #sub set QVERSION = '88' where dispositn not in ('10','31','34') and QVERSION not in ('NA')

update #sub set received='88888888' where dispositn not in ('10','31','34')
-- intSequence=4 is the phone step. Mode '3' is Outbound CATI, Mode '1' is Mail  (Mode '2' is Inbound CATI, which we don't do.)
update #sub set mode=case when intSequence=4 then '3' else '1' end where dispositn in ('10','31','34')


if object_id('tempdb..#resp') is not null
	drop table #resp

create table #resp (study_id int, survey_id int, samplepop_id int
,q01  int
,q02  int
,q03  int
,q04  int
,q05  int
,q06  int
,q07  int
,q08  int
,q09  int
,q10  int
,q11  int
,q12  int
,q13  int
,q14  int
,q15  int
,q16  int
,q17  int
,q18  int
,q19  int
,q20  int
,q21  int
,q22  int
,q23  int
,q24  int
,q25  int
,q26  int
,q27  int
,q28  int
,q29  int
,q30  int
,q31  int
,q32  int
,q33  int
,q34  int
,q35  int
,q36  int
,q37  int
,q38  int
,q39  int
,q40  int
,q41  int
,q42  int
,q43  int
,q44  int
,q45  int
,q46  int
,q47  int
,q48  int
,q49  int
,q50  int
,q51  int
,q52  int
,q53  int
,q54  int
,q55  int
,q56  int
,q57a int
,q57b int
,q57c int
,q58  int
,q59  int
,q60  int
,q61  int
,q62  int
,q63  int
,q64  int
,q65  int
,q66  int
,q67  int
,q68  int
,q69  int
,q70  int
,q71  int
,q72  int
,q73  int
,q74  int
,q75  int
,q76  int
,q77  int
,q78  int
,q79a int
,q79b int
,q79c int
,q79d int
,q79d1 int
,q79d2 int
,q79d3 int
,q79d4 int
,q79d5 int
,q79d6 int
,q79d7 int
,q79e int
,q79e1 int
,q79e2 int
,q79e3 int
,q79e4 int
,q80  int
,q81a int
,q81b int
,q81c int
,q81d int
,q81e int
)



	set @howhelped=',case when q050744a>0 then 1 else -9 end
					,case when q050744b>0 then 1 else -9 end
					,case when q050744c>0 then 1 else -9 end
					,case when q050744d>0 then 1 else -9 end
					,case when q050744e>0 then 1 else -9 end'
					
	-- the "how were you helped filling this survey out" question was initially fielded as single response (Q050701). 
	-- it should be fielded as multiple response (Q050744)
	-- at some point, the code referencing Q050701 can be removed.
	if exists (select *
				from sys.schemas ss
					inner join sys.views sv on ss.schema_id=sv.schema_id
					inner join sys.columns sc on sv.object_id=sc.object_id 
				where ss.name='s'+@study and sv.name='study_results_view' and sc.name ='q050701')
		set @howhelped=',case when q050744a>0 then 1 when q050701%10000=1 then 1 else -9 end
						,case when Q050744b>0 then 1 when q050701%10000=2 then 1 else -9 end
						,case when Q050744c>0 then 1 when q050701%10000=3 then 1 else -9 end
						,case when Q050744d>0 then 1 when q050701%10000=4 then 1 else -9 end
						,case when Q050744e>0 then 1 when q050701%10000=5 then 1 else -9 end'
	
	set @sql='insert into #resp (study_id, survey_id, samplepop_id
						,q01 
						,q02 
						,q03 
						,q04 
						,q05 
						,q06 
						,q07 
						,q08 
						,q09 
						,q10 
						,q11 
						,q12 
						,q13 
						,q14 
						,q15 
						,q16 
						,q17 
						,q18 
						,q19 
						,q20 
						,q21 
						,q22 
						,q23 
						,q24 
						,q25 
						,q26 
						,q27 
						,q28 
						,q29 
						,q30 
						,q31 
						,q32 
						,q33 
						,q34 
						,q35 
						,q36 
						,q37 
						,q38 
						,q39 
						,q40 
						,q41 
						,q42 
						,q43 
						,q44 
						,q45 
						,q46 
						,q47 
						,q48 
						,q49 
						,q50 
						,q51 
						,q52 
						,q53 
						,q54 
						,q55 
						,q56 
						,q57a
						,q57b
						,q57c
						,q58 
						,q59 
						,q60 
						,q61 
						,q62 
						,q63 
						,q64 
						,q65 
						,q66 
						,q67 
						,q68 
						,q69 
						,q70 
						,q71 
						,q72 
						,q73 
						,q74 
						,q75 
						,q76 
						,q77 
						,q78 
						,q79a
						,q79b
						,q79c
						,q79d
						,q79d1
						,q79d2
						,q79d3
						,q79d4
						,q79d5
						,q79d6
						,q79d7
						,q79e
						,q79e1
						,q79e2
						,q79e3
						,q79e4
						,q80 
						,q81a
						,q81b
						,q81c
						,q81d
						,q81e
						)
				select '+@study+', '+convert(varchar,@survey_id)+', samplepop_id
						,Q050175%10000
						,Q050176%10000
						,Q050177%10000
						,case when (Q050178%10000) between 1 and 7 then (Q050178%10000)-1 else Q050178 end-- we have an incorrect scale in the library. This means our current response data for that question is off by one.  
						,Q050179%10000
						,Q050180%10000
						,Q050181%10000
						,Q050182%10000
						,Q050183%10000
						,Q050184%10000
						,Q050185%10000
						,Q050186%10000
						,Q050187%10000
						,Q050188%10000
						,Q050189%10000
						,Q050190%10000
						,Q050191%10000
						,Q050192%10000
						,Q050193%10000
						,Q050194%10000
						,Q050195%10000
						,Q050196%10000
						,Q050197%10000
						,Q050198%10000
						,Q050199%10000
						,Q050200%10000
						,Q050201%10000
						,Q050202%10000
						,Q050203%10000
						,Q050204%10000
						,Q050205%10000
						,Q050206%10000
						,Q050207%10000
						,Q050208%10000
						,Q050209%10000
						,Q050210%10000
						,Q050211%10000
						,Q050212%10000
						,Q050213%10000
						,Q050214%10000
						,Q050215%10000
						,Q050216%10000
						,Q050217%10000
						,Q050218%10000
						,Q050219%10000
						,Q050220%10000
						,Q050221%10000
						,Q050222%10000
						,Q050223%10000
						,Q050224%10000
						,Q050225%10000
						,Q050226%10000
						,Q050227%10000
						,Q050228%10000
						,Q050229%10000
						,Q050230%10000
						,Q050231%10000
						,Q050232%10000
						,Q050233%10000
						,Q050234%10000
						,Q050235%10000
						,Q050236%10000
						,Q050237%10000
						,Q050238%10000
						,Q050239%10000
						,Q050240%10000
						,Q050241%10000
						,Q050699%10000
						,Q050243%10000
						,Q050700%10000
						,Q050245%10000
						,Q050246%10000
						,Q050247%10000
						,Q050248%10000
						,Q050249%10000
						,Q050250%10000
						,Q050251%10000
						,Q050252%10000
						,Q050253%10000
						,Q050254%10000
						,coalesce(case when Q050255a=1 then 1 end,Q050725,-9)
						,coalesce(case when Q050255b=2 then 1 end,Q050726,-9)
						,coalesce(case when Q050255c=3 then 1 end,Q050727,-9)
						,isnull(Q050728,-9)
						,coalesce(case when Q050255d=4 then 1 end,Q050729,-9)
						,coalesce(case when Q050255e=5 then 1 end,Q050730,-9)
						,coalesce(case when Q050255f=6 then 1 end,Q050731,-9)
						,coalesce(case when Q050255g=7 then 1 end,Q050732,-9)
						,coalesce(case when Q050255h=8 then 1 end,Q050733,-9)
						,coalesce(case when Q050255i=9 then 1 end,Q050734,-9)
						,coalesce(case when Q050255j=10 then 1 end,Q050735,-9)
						,isnull(Q050736,-9)
						,coalesce(case when Q050255k=11 then 1 end,Q050737,-9)
						,coalesce(case when Q050255l=12 then 1 end,Q050738,-9)
						,coalesce(case when Q050255m=13 then 1 end,Q050739,-9)
						,coalesce(case when Q050255n=14 then 1 end,Q050740,-9)
						,Q050256%10000
						'+@howhelped+'
				from s'+@study+'.study_results_view 
				where sampleunit_id in (select sampleunit_id from sampleunit where survey_id='+convert(varchar,@survey_id)+')'

  declare @sql2 nvarchar(max) = dbo.fn_ACOCAHPSUpdateForVersion(@sql, @survey_id)
--	print @sql
--	print @sql2
  exec(@sql2)

-- if they're a refusal or dead or have any disposition that shouldn't have responses
-- delete their responses
delete r
	from #sub s
	inner join acocahpsdispositions ad on s.DISPOSITN=ad.ACOCAHPSValue
	left join #resp r on s.samplepop_id=r.samplepop_id
where ad.ExportReportResponses=0
and r.samplepop_id is not null

	select s.study_id, s.survey_id, s.samplepop_id, FINDER,ACO_ID,DISPOSITN,MODE,DISPO_LANG,RECEIVED,FOCALTYPE,PRTITLE,PRFNAME,PRLNAME
	,Q01,Q02,Q03,Q04,Q05,Q06,Q07,Q08,Q09,Q10,Q11,Q12,Q13,Q14,Q15,Q16,Q17,Q18,Q19,Q20,Q21,Q22,Q23,Q24,Q25,Q26,Q27,Q28,Q29,Q30,Q31,Q32,Q33,Q34,Q35,Q36,Q37,Q38,Q39,Q40,Q41
	,Q42,Q43,Q44,Q45,Q46,Q47,Q48,Q49,Q50,Q51,Q52,Q53,Q54,Q55,Q56,Q57a,Q57b,Q57c,Q58,Q59,Q60,Q61,Q62,Q63,Q64,Q65,Q66,Q67,Q68,Q69,Q70,Q71,Q72,Q73,Q74,Q75,Q76,Q77,Q78
	,Q79a,Q79b,Q79c,Q79d,Q79d1,Q79d2,Q79d3,Q79d4,Q79d5,Q79d6,Q79d7,Q79e,Q79e1,Q79e2,Q79e3,Q79e4,Q80,Q81a,Q81b,Q81c,Q81d,Q81e,bitComplete,qversion
	from #sub s
	left join #resp r on s.samplepop_id=r.samplepop_id
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