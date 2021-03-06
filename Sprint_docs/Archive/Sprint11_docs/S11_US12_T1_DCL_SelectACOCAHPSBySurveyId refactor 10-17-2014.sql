/*
S11_US12_T1_DCL_SelectACOCAHPSBySurveyId refactor 10-17-2014.sql

12.1	Refactor Export Manager ACO-CAHPS SP

ALTER procedure [dbo].[DCL_SelectACOCAHPSBySurveyId] (12.1)

Chris Burkholder
*/

USE [QP_Comments]
GO
/****** Object:  StoredProcedure [dbo].[DCL_SelectACOCAHPSBySurveyId]    Script Date: 10/8/2014 9:24:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--CREATE
ALTER
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
		declare @Q79 varchar(max)
		set @Q79 = ',coalesce(case when Q050255a=1 then 1 end,Q050725%10000,-9) as [Q79a]
			,coalesce(case when Q050255b=2 then 1 end,Q050726%10000,-9) as [Q79b]
			,coalesce(case when Q050255c=3 then 1 end,Q050727%10000,-9) as [Q79c]
			,isnull(Q050728,-9) as [Q79d]
			,coalesce(case when Q050255d=4 then 1 end,Q050729%10000,-9) as [Q79d1]
			,coalesce(case when Q050255e=5 then 1 end,Q050730%10000,-9) as [Q79d2]
			,coalesce(case when Q050255f=6 then 1 end,Q050731%10000,-9) as [Q79d3]
			,coalesce(case when Q050255g=7 then 1 end,Q050732%10000,-9) as [Q79d4]
			,coalesce(case when Q050255h=8 then 1 end,Q050733%10000,-9) as [Q79d5]
			,coalesce(case when Q050255i=9 then 1 end,Q050734%10000,-9) as [Q79d6]
			,coalesce(case when Q050255j=10 then 1 end,Q050735%10000,-9) as [Q79d7]
			,isnull(Q050736,-9) as [Q79e]
			,coalesce(case when Q050255k=11 then 1 end,Q050737%10000,-9) as [Q79e1]
			,coalesce(case when Q050255l=12 then 1 end,Q050738%10000,-9) as [Q79e2]
			,coalesce(case when Q050255m=13 then 1 end,Q050739%10000,-9) as [Q79e3]
			,coalesce(case when Q050255n=14 then 1 end,Q050740%10000,-9) as [Q79e4]
			'

		declare @howhelped varchar(max)
		set @howhelped=',case when q050744a>0 then 1 when q050701%10000=1 then 1 else -9 end as [Q81a]
						,case when Q050744b>0 then 1 when q050701%10000=2 then 1 else -9 end as [Q81b]
						,case when Q050744c>0 then 1 when q050701%10000=3 then 1 else -9 end as [Q81c]
						,case when Q050744d>0 then 1 when q050701%10000=4 then 1 else -9 end as [Q81d]
						,case when Q050744e>0 then 1 when q050701%10000=5 then 1 else -9 end as [Q81e]'
declare @sql varchar(max), @study varchar(10)
select @study=study_id from clientstudysurvey where survey_id = @Survey_id
set @sql='select '+
			convert(nvarchar(max), @study)+' as Study_ID'+
			','+convert(nvarchar(max), @Survey_id)+' as Survey_ID'+
			',bt.samplepop_id
			,left(bt.ACO_FinderNum,8) as [FINDER]
			,left(bt.ACO_ACOID,5) as [ACO_ID]
			,left(bt.ACODisposition,2) as [DISPOSITN]
			,case when bt.ACODisposition in (10,31,34) then (case when ms.intSequence=4 then ''3'' else ''1'' end) else ''8'' end as [MODE]
			,case when bt.ACODisposition in (10,31,34) then (left(IsNull(sm.LangID,8),1)) else ''8'' end as [DISPO_LANG] --> this is the language the survey was /completed/ in.  "8" means "not applicable".
			,IsNull(convert(varchar,sr.DATRETURNED,112),''88888888'') AS [RECEIVED]
			,bt.ACO_FocalType AS [FOCALTYPE]
			,bt.DrTitle as [PRTITLE]
			,bt.DrFirstName as [PRFNAME]
			,bt.DrLastName as [PRLNAME]
			,Q050175%10000 as [Q01]
			,Q050176%10000 as [Q02]
			,Q050177%10000 as [Q03]
			,case when (Q050178%10000) between 1 and 7 then (Q050178%10000)-1 else Q050178 end  as [Q04]-- we have an incorrect scale in the library. This means our current response data for that question is off by one.  
			,Q050179%10000 as [Q05]
			,Q050180%10000 as [Q06]
			,Q050181%10000 as [Q07]
			,Q050182%10000 as [Q08]
			,Q050183%10000 as [Q09]
			,Q050184%10000 as [Q10]
			,Q050185%10000 as [Q11]
			,Q050186%10000 as [Q12]
			,Q050187%10000 as [Q13]
			,Q050188%10000 as [Q14]
			,Q050189%10000 as [Q15]
			,Q050190%10000 as [Q16]
			,Q050191%10000 as [Q17]
			,Q050192%10000 as [Q18]
			,Q050193%10000 as [Q19]
			,Q050194%10000 as [Q20]
			,Q050195%10000 as [Q21]
			,Q050196%10000 as [Q22]
			,Q050197%10000 as [Q23]
			,Q050198%10000 as [Q24]
			,Q050199%10000 as [Q25]
			,Q050200%10000 as [Q26]
			,Q050201%10000 as [Q27]
			,Q050202%10000 as [Q28]
			,Q050203%10000 as [Q29]
			,Q050204%10000 as [Q30]
			,Q050205%10000 as [Q31]
			,Q050206%10000 as [Q32]
			,Q050207%10000 as [Q33]
			,Q050208%10000 as [Q34]
			,Q050209%10000 as [Q35]
			,Q050210%10000 as [Q36]
			,Q050211%10000 as [Q37]
			,Q050212%10000 as [Q38]
			,Q050213%10000 as [Q39]
			,Q050214%10000 as [Q40]
			,Q050215%10000 as [Q41]
			,Q050216%10000 as [Q42]
			,Q050217%10000 as [Q43]
			,Q050218%10000 as [Q44]
			,Q050219%10000 as [Q45]
			,Q050220%10000 as [Q46]
			,Q050221%10000 as [Q47]
			,Q050222%10000 as [Q48]
			,Q050223%10000 as [Q49]
			,Q050224%10000 as [Q50]
			,Q050225%10000 as [Q51]
			,Q050226%10000 as [Q52]
			,Q050227%10000 as [Q53]
			,Q050228%10000 as [Q54]
			,Q050229%10000 as [Q55]
			,Q050230%10000 as [Q56]
			,Q050231%10000 as [Q57a]
			,Q050232%10000 as [Q57b]
			,Q050233%10000 as [Q57c]
			,Q050234%10000 as [Q58]
			,Q050235%10000 as [Q59]
			,Q050236%10000 as [Q60]
			,Q050237%10000 as [Q61]
			,Q050238%10000 as [Q62]
			,Q050239%10000 as [Q63]
			,Q050240%10000 as [Q64]
			,Q050241%10000 as [Q65]
			,Q050699%10000 as [Q66]
			,Q050243%10000 as [Q67]
			,Q050700%10000 as [Q68]
			,Q050245%10000 as [Q69]
			,Q050246%10000 as [Q70]
			,Q050247%10000 as [Q71]
			,Q050248%10000 as [Q72]
			,Q050249%10000 as [Q73]
			,Q050250%10000 as [Q74]
			,Q050251%10000 as [Q75]
			,Q050252%10000 as [Q76]
			,Q050253%10000 as [Q77]
			,Q050254%10000 as [Q78]
			'+@Q79+'
			,Q050256%10000 as [Q80]
			'+@howhelped+'
			,sr.bitComplete,
			case when subtype_nm is null then ''NA'' when sr.DATRETURNED is null then ''88'' when subtype_nm = ''ACO-8'' then ''08'' when subtype_nm = ''ACO-12'' then ''12'' else ''NA'' end AS [qversion]
			from s'+convert(nvarchar(max),@study)+'.big_table_view bt
			left outer join SurveySubtype sst on sst.Survey_id = '+convert(nvarchar(max),@Survey_id)+'
			left outer join qualisys.qp_prod.dbo.questionform qf on bt.samplepop_id=qf.samplepop_id
			left outer join qualisys.qp_prod.dbo.sentmailing sm on qf.sentmail_id=sm.sentmail_id
			left outer join qualisys.qp_prod.dbo.scheduledmailing scm on qf.sentmail_id=scm.sentmail_id
			left outer join qualisys.qp_prod.dbo.mailingstep ms on scm.mailingstep_id=ms.mailingstep_id
			left outer join s'+convert(nvarchar(max),@study)+'.study_results_view sr on bt.samplepop_id=sr.samplepop_id and bt.sampleunit_id=sr.sampleunit_id
			where bt.sampleunit_id in (select sampleunit_id from sampleunit where survey_id='+convert(nvarchar(max),@Survey_id)+') and
			bt.DatSampleEncounterDate between '''+convert(nvarchar(max),@startDate)+''' AND '''+convert(nvarchar(max),@EndDate)+ '''
			order by ISNULL(sr.bitComplete * 0, -1) desc, bt.samplepop_id'

  declare @sql2 nvarchar(max) = dbo.fn_ACOCAHPSUpdateForVersion(@sql, @survey_id)
--	print @sql
--	print @sql2
  exec(@sql2)
	
GO