create procedure sp_CriteriaStatements_loop
  @BigView bit = 0
as 
create table #criters2
  (criters_id int identity(1,1) primary key clustered, 
   criteriastmt_id int, 
   criteriaclause_id int, 
   criteriaphrase_id int,
   strCriteriaStmt varchar(6500))

insert into #criters2 (criteriastmt_id,criteriaclause_id,criteriaphrase_id) 
  select criteriastmt_id,criteriaclause_id,criteriaphrase_id
  from criteriaclause
  where criteriastmt_id in (select criteriastmt_id from #criters)

update #criters2
  set strcriteriastmt = 
     case @BigView 
       when 1 then 'BV.' + mt.strtable_nm + mf.strfield_nm
       else mt.strtable_nm + '.' + mf.strfield_nm
     end 
     +' '+ rtrim(op.stroperator) + ' '+ 
     case mf.strFieldDataType 
       when 'I' then cc.strlowvalue + ' AND ' + cc.strhighvalue 
       else '"' + cc.strlowvalue + '" AND "' + cc.strhighvalue + '"'
     end
from criteriaclause cc, metatable mt, metafield mf, operator op
where cc.table_id=mt.table_id
  and cc.field_id=mf.field_id
  and cc.intoperator=op.operator_num
  and op.strLogic = '%strLowValue% AND %strHighValue%'
  and cc.criteriastmt_id = #criters2.CriteriaStmt_id
  and cc.criteriaclause_id = #criters2.Criteriaclause_id
  and cc.criteriaphrase_id = #criters2.Criteriaphrase_id

update #criters2
 set strcriteriastmt = 
     case @BigView 
       when 1 then 'BV.' + mt.strtable_nm + mf.strfield_nm
       else mt.strtable_nm + '.' + mf.strfield_nm
     end 
     + ' ' + rtrim(op.stroperator) + ' '+ 
     case
       when mf.strFieldDataType = 'I' or cc.strLowValue = 'NULL' then cc.strlowvalue 
       else '"' + cc.strlowvalue + '"'
     end
from criteriaclause cc, metatable mt, metafield mf, operator op
where cc.table_id=mt.table_id
  and cc.field_id=mf.field_id
  and cc.intoperator=op.operator_num
  and op.strLogic in ('%strLowValue%','NULL')
  and cc.criteriastmt_id = #criters2.CriteriaStmt_id
  and cc.criteriaclause_id = #criters2.Criteriaclause_id
  and cc.criteriaphrase_id = #criters2.Criteriaphrase_id

select cc.criteriastmt_id, cc.criteriaclause_id, cc.criteriaphrase_id,
     case @BigView 
       when 1 then 'BV.' + mt.strtable_nm + mf.strfield_nm
       else mt.strtable_nm + '.' + mf.strfield_nm
     end as fld,
     case mf.strFieldDataType 
       when 'I' then cil.strlistvalue
       else '"' + cil.strlistvalue + '"'
     end as strlistvalue
into #inlist
from criteriaclause cc, metatable mt, metafield mf, operator op, CriteriaInList cil, #criters2
where cc.table_id=mt.table_id
  and cc.field_id=mf.field_id
  and cc.intoperator=op.operator_num
  and cc.criteriaclause_id*=cil.criteriaclause_id
  and op.strLogic = '%INLIST%'
  and cc.criteriastmt_id = #criters2.CriteriaStmt_id
  and cc.criteriaclause_id = #criters2.Criteriaclause_id
  and cc.criteriaphrase_id = #criters2.Criteriaphrase_id

create table #instmt
 (criteriastmt_id int, criteriaclause_id int, Criteriaphrase_id int, strcriteriastatement varchar(6550))

insert into #instmt (criteriastmt_id, criteriaclause_id, Criteriaphrase_id, strcriteriastatement) 
select distinct criteriastmt_id, criteriaclause_id, Criteriaphrase_id, fld + ' IN (' 
  from #inlist

while (@@rowcount > 0)
begin
  update #instmt
  set #instmt.strcriteriastatement = #instmt.strcriteriastatement + L.strlistvalue+','
  from (select criteriastmt_id,criteriaclause_id,criteriaphrase_id,min(strlistvalue) as strlistvalue 
        from #inlist 
        group by criteriastmt_id,criteriaclause_id,criteriaphrase_id) L
  where #instmt.criteriastmt_id=L.criteriastmt_id
    and #instmt.criteriaclause_id=L.criteriaclause_id
    and #instmt.Criteriaphrase_id=L.Criteriaphrase_id

  delete #inlist
  from (select criteriastmt_id,criteriaclause_id,Criteriaphrase_id,min(strlistvalue) as strlistvalue 
        from #inlist 
        group by criteriastmt_id,criteriaclause_id,Criteriaphrase_id) L
  where #inlist.criteriastmt_id=L.criteriastmt_id
    and #inlist.criteriaclause_id=L.criteriaclause_id
    and #inlist.Criteriaphrase_id=L.Criteriaphrase_id
    and #inlist.strlistvalue=L.strlistvalue
end

update #criters2 
 set strcriteriastmt=left(strcriteriastatement,len(strcriteriastatement)-1) + ')' 
 from #instmt
 where #criters2.criteriastmt_id=#instmt.criteriastmt_id
   and #criters2.criteriaclause_id=#instmt.criteriaclause_id
   and #criters2.Criteriaphrase_id=#instmt.Criteriaphrase_id

drop table #inlist
drop table #instmt

truncate table #criters

insert into #criters (criteriastmt_id, strcriteriastmt)
 select criteriastmt_id, '('+strCriteriaStmt
 from #criters2 
 where criters_id in (select min(criters_id) from #criters2 group by criteriastmt_id)

delete #criters2
 where criters_id in (select min(criters_id) from #criters2 group by criteriastmt_id)

declare @cnt int
select @cnt=Count(*) from #criters2
while @cnt>0 
begin
  update #criters
  set #criters.strCriteriaStmt = #criters.strCriteriaStmt + 
        case c2.criteriaphrase_id when 1 then ') and ('+c2.strcriteriastmt else ' or ' +c2.strcriteriastmt end
  from #criters2 c2
  where c2.criteriastmt_id=#criters.criteriastmt_id
    and c2.criters_id in (select min(criters_id) from #criters2 group by criteriastmt_id)

  delete from #criters2
  where criters_id in (select min(criters_id) from #criters2 group by criteriastmt_id)

  select @cnt=Count(*) from #criters2
end
update #criters
  set strcriteriastmt = strcriteriastmt + ')'

drop table #criters2


