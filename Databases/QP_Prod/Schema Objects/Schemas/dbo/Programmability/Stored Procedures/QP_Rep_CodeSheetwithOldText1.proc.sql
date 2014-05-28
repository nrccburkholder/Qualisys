CREATE PROCEDURE QP_Rep_CodeSheetwithOldText1
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50)
AS
set transaction isolation level read uncommitted
Declare @intSurvey_id int
select @intSurvey_id=sd.survey_id 
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id

select ss.qpc_id, ss.item, ss.val, ss.label, ss.missing
into #MyTempTbl
from sel_scls ss, (select sel_scls.qpc_id, min(sel_scls.item) as item from sel_scls where sel_scls.survey_id=@intSurvey_id group by qpc_id) x
where ss.qpc_id=x.qpc_id and ss.item=x.item and ss.survey_id=@intSurvey_id

CREATE TABLE #Subtype (Subtype int,Subtype_nm char(10))
insert into #subtype (Subtype,subtype_nm) values (1,'Question')
insert into #subtype (Subtype,subtype_nm) values (2,'Subsection')
insert into #subtype (Subtype,subtype_nm) values (3,'Section')
insert into #subtype (Subtype,subtype_nm) values (4,'Comment')

select 	st.Subtype_nm, SQ.QstnCore,SQ.Label,SQ.Scaleid, ss.val, ss.label as scalelbl, ss.missing, SQ.section_id, SQ.Subsection, SQ.Item, 
		ss.item as SItem, SQ.bitmeanable as Meanable, SQ.nummarkcount as MultResponse
into	#MyTempTbl2
FROM	sel_Qstns SQ	left outer join Sel_Scls SS on SQ.Scaleid=ss.qpc_id and ss.Survey_id=@intSurvey_id 
						inner join #SubType ST on sq.SubType=st.SubType 
WHERE	sq.Survey_id=@intSurvey_id      

  
  and sq.subtype=st.subtype

select t2.qstncore, t2.label, t2.scaleid, t2.val, t2.scalelbl, t2.missing, t2.section_id, t2.subsection, t2.item, t2.subtype_nm, 
t1.item as flag, t2.sitem as dummy1, Meanable, MultResponse
into #MyTempTbl3 
from #MyTempTbl2 t2 left outer join #MyTempTbl T1 on T2.scaleid=t1.qpc_id and t2.sitem=t1.item
order by section_id, subsection, t2.item, t1.item

select subtype_nm, label, '                                                            ' as oldlabel, qstncore, val, scalelbl, missing, section_id, subsection, item, dummy1, 
(case when Meanable = 0 then 'NO' 
when meanable = 1 then 'Yes' end) as Meanable, 
(case when MultResponse = null then 'No' 
when multresponse = 1 then 'No' 
when multresponse > 1 then 'Yes' end) as MultResponse
into #MyTempTbl4
from #MyTempTbl3 where flag is not null or item=0 or subtype_nm='Comment'
union 
select '' as subtype_nm, '' as label, '' as oldlabel, null as qstncore, val, scalelbl, missing, section_id, subsection, item, dummy1, 
case when Meanable = 0 then 'NO' 
when meanable = 1 then 'Yes' end, 
case when MultResponse = null then 'No' 
when multresponse = 1 then 'No' 
when multresponse > 1 then 'Yes' end

from #MyTempTbl3 where flag is null and item>0 and subtype_nm<>'Comment'
order by section_id,subsection,item,dummy1

update t4
set oldlabel = left(report1,60)
from #mytemptbl4 t4, convql c
where t4.subtype_nm = 'question'
and t4.qstncore = c.core

select qstncore, label, oldlabel, subsection from #mytemptbl4
where qstncore is not null
and subtype_nm = 'Question'
order by subsection

drop table #Mytemptbl
drop table #Mytemptbl2
drop table #Mytemptbl3
drop table #Mytemptbl4
drop table #subtype

set transaction isolation level read committed


