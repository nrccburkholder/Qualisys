CREATE procedure qp_rep_FileLayout  
 @Associate varchar(50),  
 @Client varchar(50),  
 @Study varchar(50),  
 @Survey varchar(50)  
as  
set transaction isolation level read uncommitted  
Declare @intSurvey_id int  
select @intSurvey_id=sd.survey_id   
from survey_def sd, study s, client c  
where c.strclient_nm=@Client  
  and s.strstudy_nm=@Study  
  and sd.strsurvey_nm=@survey  
  and c.client_id=s.client_id  
  and s.study_id=sd.study_id  
  
select ss.qpc_id, ss.item, ss.val, ss.label  
into #MyTempTbl  
from sel_scls ss, (select sel_scls.qpc_id, min(sel_scls.item) as item from sel_scls where sel_scls.survey_id=@intSurvey_id group by qpc_id) x  
where ss.qpc_id=x.qpc_id and ss.item=x.item and ss.survey_id=@intSurvey_id  
  
CREATE TABLE #FileLayout   
(subtype_nm char(10),   
 Label char(60),   
 Field_Nm char(10),  
 Val int,   
 scalelbl char(60),   
 section_id int,   
 subsection int,   
 item int,   
 dummy1 int)  
  
insert #FileLayout (subtype_nm,label,field_nm,section_id,subsection)  
 values ('NRCField','Sample set ID','SampSet',-2,1)  
insert #FileLayout (subtype_nm,label,field_nm,section_id,subsection)  
 values ('NRCField','Sample date','Samp_dt',-2,2)  
insert #FileLayout (subtype_nm,label,field_nm,section_id,subsection)  
 values ('NRCField','Sample unit ID','SampUnit',-2,3)  
insert #FileLayout (subtype_nm,label,field_nm,section_id,subsection)  
 values ('NRCField','Sample unit name','Unit_nm',-2,4)  
insert #FileLayout (subtype_nm,label,field_nm,section_id,subsection)  
 values ('NRCField','Sample type','SampType',-2,5)  
insert #FileLayout (subtype_nm,label,field_nm,section_id,subsection)  
 values ('NRCField','Sample population ID','SampPop',-2,6)  
insert #FileLayout (subtype_nm,label,field_nm,section_id,subsection)  
 values ('NRCField','Form ID','QstnForm',-2,7)  
insert #FileLayout (subtype_nm,label,field_nm,section_id,subsection)  
 values ('NRCField','Lithocode','Lithocd',-2,8)  
insert #FileLayout (subtype_nm,label,field_nm,section_id,subsection)  
 values ('NRCField','Return date','Rtrn_dt',-2,9)  
insert #FileLayout (subtype_nm,label,field_nm,section_id,subsection)  
 values ('NRCField','Undeliverable date','Undel_dt',-2,10)  
  
insert into #FileLayout (subtype_nm,label,field_nm,section_id,subsection,item)  
  select 'PopField',   
         min(isnull(strField_dsc,strField_nm)),  
         min(isnull(strFieldShort_nm, left(strField_nm,8))),  
         -1 as section_id,   
         min(mt.table_id),  
         min(mf.field_id)  
  from metafield mf, metastructure ms, metatable mt, survey_def sd  
  where mf.field_id=ms.field_id   
    and mt.table_id=ms.table_id   
    and mt.study_id=sd.study_id  
    and sd.survey_id=@intSurvey_id  
  group by sd.survey_id, isnull(strFieldShort_nm, left(strField_nm,8))  
  
CREATE TABLE #Subtype (Subtype int,Subtype_nm char(10))  
insert into #subtype (Subtype,subtype_nm) values (1,'Question')  
insert into #subtype (Subtype,subtype_nm) values (2,'Heading')  
insert into #subtype (Subtype,subtype_nm) values (3,'Section')  
--insert into #subtype (Subtype,subtype_nm) values (4,'Comment')  
  
select   
		st.Subtype_nm, SQ.QstnCore,SQ.Label,SQ.Scaleid, ss.val, ss.label as scalelbl, SQ.section_id, SQ.Subsection, SQ.Item,   
		ss.item as SItem, SQ.nummarkcount as MultResponse  
into	#MyTempTbl2  
from	sel_Qstns SQ	left outer join  Sel_Scls SS on SQ.Scaleid=ss.qpc_id and ss.survey_id=@intSurvey_id 
						inner join #Subtype ST on sq.subtype=st.subtype
where	sq.survey_id=@intSurvey_id  
		and sq.section_id>0  
  
select t2.qstncore, t2.label, t2.scaleid, t2.val, t2.scalelbl, t2.section_id, t2.subsection, t2.item, t2.subtype_nm,   
t1.item as flag, t2.sitem as dummy1, MultResponse  
into #MyTempTbl3   
from #MyTempTbl2 t2 left outer join  #MyTempTbl T1 on T2.scaleid=t1.qpc_id and t2.sitem=t1.item
order by section_id, subsection, t2.item, t1.item  
  
delete from #MyTempTbl3   
where (section_id*1000) + subsection not in   
  (select distinct (section_id*1000) + subsection  
   from #MyTempTbl3   
   where subtype_nm='Question')  
  
insert into #FileLayout  
  select subtype_nm, Label, case when subtype_nm='Question' then 'Q' + right('000000'+convert(varchar,qstncore),6) else null end, val, scalelbl, section_id, subsection, item, dummy1  
  from #MyTempTbl3   
  where (flag is not null  
     or item=0  
     or subtype_nm='Comment')  
    and (multResponse=1 or subtype_nm <> 'Question')  
  
insert into #FileLayout  
  select '' as subtype_nm, '' as label, null, val, scalelbl, section_id, subsection, item, dummy1  
  from #MyTempTbl3   
  where flag is null  
    and item>0  
    and subtype_nm<>'Comment'  
    and (multResponse=1 or subtype_nm <> 'Question')  
  
insert into #FileLayout  
  select subtype_nm, Label,   
   case when subtype_nm='Question' then 'Q' + right('000000'+convert(varchar,qstncore),6)+char(val+64) else null end,   
    val, scalelbl, section_id, subsection, item, dummy1  
  from #MyTempTbl3   
  where (flag is not null  
     or item=0  
     or subtype_nm='Comment')  
    and (multResponse=2 and subtype_nm = 'Question')  
  
insert into #FileLayout  
  select '' as subtype_nm, '' as label, case when subtype_nm='Question' then 'Q' + right('000000'+convert(varchar,qstncore),6)+char(val+64) else null end, val, scalelbl, section_id, subsection, item, dummy1  
  from #MyTempTbl3   
  where flag is null  
    and item>0  
    and subtype_nm<>'Comment'  
    and (multResponse=2 and subtype_nm = 'Question')  
  
select subtype_nm as [Field Type],   
       Label,   
       field_nm as [Field Name],   
       val as [Value],  
       scalelbl as [Response]  
from #fileLayout  
order by section_id,subsection,item,dummy1  
  
drop table #Mytemptbl  
drop table #Mytemptbl2  
drop table #Mytemptbl3  
drop table #subtype  
drop table #FileLayout  
  
set transaction isolation level read committed


