/***********************************************************************************************************************************
SP Name: sp_CriteriaStatements2
Purpose:  returns the where clauses for a set of criteria statments
Input:  
  #criters   Temp table containing at least two fields: CriteriaStmt_id (int) and 
             strCriteriaStmt varchar(2500).  CriteriaStmt_id must be filled out and
             all other fields (strCriteriaStmt and any other fields you might have in
             there) must be NULL
  @BigView   1 = populate strCriteriaStmt using Big_View fieldnames (e.g. BV.POPULATIONpop_id)
             0/NULL = populate strCriteriaStmt using normal fieldnames (e.g. POPULATION.pop_id)
             (default = 0)
Output:  
  strCriteriaStmt field will be filled out

Date		By	Description
-----------------------------------
04-11-2000	DG	Created
04-12-2000	DG	v2.0.1
			added @BigView parameter; put double-quotes around string and date fields; 
			used CriteriaPhrase_id to determine AND vs OR relationships.
01-06-2003	SH	added the codes to handle multiple criteria statements for 'OR' relationship.
09-29-2009  MWB modified *= syntax to left outer join for sql 2008 Upgrade.
***********************************************************************************************************************************/

CREATE procedure sp_CriteriaStatements2
  @BigView bit = 0
as 
create table #criters2
  (criters_id int identity(1,1) primary key clustered, 
   criteriastmt_id int, 
   criteriaclause_id int, 
   criteriaphrase_id int,
   strCriteriaStmt varchar(7000))

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
       else '''' + cc.strlowvalue + ''' AND ''' + cc.strhighvalue + ''''
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
       else '''' + cc.strlowvalue + ''''
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
       else '''' + cil.strlistvalue + ''''
     end as strlistvalue
into #inlist
from  metatable mt, metafield mf, operator op, #criters2,
	  criteriaclause cc left outer join CriteriaInList cil on cc.criteriaclause_id=cil.criteriaclause_id 
where cc.table_id=mt.table_id
  and cc.field_id=mf.field_id
  and cc.intoperator=op.operator_num
  and op.strLogic = '%INLIST%'
  and cc.criteriastmt_id = #criters2.CriteriaStmt_id
  and cc.criteriaclause_id = #criters2.Criteriaclause_id
  and cc.criteriaphrase_id = #criters2.Criteriaphrase_id

create table #instmt
 (criteriastmt_id int, criteriaclause_id int, Criteriaphrase_id int, strcriteriastatement varchar(7000))

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

-- Modified 01-06-2003 SH

-- Declare the variables to store the values returned by FETCH.
declare @Criteriastmt_id int, @CriteriaPhrase_id int  
declare @strCriteriaStmt varchar(7000)
declare @tempstmt_id int, @tempPhrase_id int
declare @where varchar(7000)

declare criter_cursor CURSOR FOR

select criteriastmt_id, criteriaphrase_id, strCriteriaStmt
from #criters2
order by criteriastmt_id, criteriaphrase_id

open criter_cursor

-- Perform the first fetch and store the values in variables.
-- Note: The variables are in the same order as the columns
-- in the SELECT statement. 
fetch next from criter_cursor into @Criteriastmt_id, @Criteriaphrase_id, @strCriteriaStmt
if @@fetch_status = 0
begin
   set @tempstmt_id = @Criteriastmt_id
   set @tempPhrase_id = @CriteriaPhrase_id
   set @where = '(' + @strCriteriastmt   
end

-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
while @@fetch_status = 0
   begin	  
      -- This is executed as long as the previous fetch succeeds.
      fetch next from criter_cursor into @Criteriastmt_id, @CriteriaPhrase_id, @strCriteriaStmt
      if @@fetch_status <> 0 -- no more rows.
         begin
            insert into #criters (Criteriastmt_id, strCriteriastmt)
            values (@tempstmt_id, @where + ')')
         end
      else
         -- Check if Criteriastmt_id is the same as the previous row.
         if @tempstmt_id <> @Criteriastmt_id     
            begin
               insert into #criters (Criteriastmt_id, strCriteriastmt)
               values (@tempstmt_id, @where + ')')
               set @tempstmt_id = @Criteriastmt_id
               set @tempPhrase_id = @CriteriaPhrase_id
               set @where = '(' + @strCriteriastmt
            end
         else -- same criteriastmt_id
            -- Check if CriteriaPhrase_id is the same as the previous row.
            -- if it's the same, it's "AND" relationship otherwise "OR".
            if @tempPhrase_id = @CriteriaPhrase_id
               begin
                  set @where = @where + ' AND ' + @strCriteriastmt
               end
            else
               begin
      set @where = @where + ') OR (' + @strCriteriastmt
                  set @tempPhrase_id = @CriteriaPhrase_id
               end
end

close criter_cursor
deallocate criter_cursor

-- Removed 01-06-2003 SH
/*
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

*/

drop table #criters2


