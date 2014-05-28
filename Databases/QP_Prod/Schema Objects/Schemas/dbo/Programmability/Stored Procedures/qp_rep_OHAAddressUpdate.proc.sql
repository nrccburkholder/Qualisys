create procedure dbo.qp_rep_OHAAddressUpdate
  @associate varchar(30), @TableName varchar(100)
as
set nocount on
create table #SQLCmnd (SQLCmnd_id int identity(1,1), study_id int, strSQL varchar(7000))
create table #study (study_id int, RecsInFile int, RecsUpdated int, bitAddr2 bit, Corrected int, AlreadyValid int, Invalid int)
declare @SQL varchar(7000)

set @SQL='insert into #study (study_id, RecsInFile, bitAddr2) select study_id, count(*), 0 from '+@TableName+' group by study_id'
exec (@SQL)

update #study
set bitAddr2=1
from metatable mt, metastructure ms, metafield mf
where #study.study_id=mt.study_id
and mt.strTable_nm='POPULATION'
and mt.table_id=ms.table_id
and ms.field_id=mf.field_id
and mf.strfield_nm = 'addr2'

insert into #SQLCmnd (study_id, strSQL)
select study_id, 
'update p
set addr	= rtrim(ca.addr),
    city	= rtrim(ca.city),
    Province	= rtrim(ca.province),
    postal_code	= rtrim(ca.postal_code),
    addrStat  	= ca.strResult,
    AddrErr     = left(ca.strResult,1)
from s'+convert(varchar,study_id)+'.population p, '+@TableName+' ca
where p.pop_id=ca.pop_id 
and ca.study_id='+convert(varchar,study_id)
from #study 
where bitaddr2=0
order by study_id


insert into #SQLCmnd (study_id, strSQL)
select study_id, 
'update p
set addr	= rtrim(left(rtrim(isnull(ca.addr,'''')+'' ''+isnull(ca.addr2,'''')),42)),
    addr2	= rtrim(substring(rtrim(isnull(ca.addralt1,'''')+'' ''+isnull(ca.addr2,'''')),43,42)),
    city	= rtrim(ca.city),
    Province	= rtrim(ca.Province),
    postal_code	= rtrim(ca.postal_code),
    addrStat  	= ca.strResult,
    AddrErr     = left(ca.strResult,1)
from s'+convert(varchar,study_id)+'.population p, '+@TableName+' ca
where p.pop_id=ca.pop_id 
and ca.study_id='+convert(varchar,study_id)
from #study 
where bitaddr2=1
order by study_id

set @SQL='update #study
set Corrected=sub.Corrected, AlreadyValid=sub.AlreadyValid, Invalid=sub.Invalid
from (	select Study_id, count(*) as total, 
	sum(case when left(strResult,1)=''C'' then 1 else 0 end) as Corrected,
	sum(case when left(strResult,1)=''V'' then 1 else 0 end) as AlreadyValid,
	sum(case when left(strResult,1)=''N'' then 1 else 0 end) as Invalid,
	sum(case when left(strResult,1)=''N'' then 1 else 0 end)/sum(0.01) as [%Invalid]
	from '+@TableName+'
	group by study_id) sub
where #study.study_id=sub.study_id'
exec(@SQL)

declare @studyid int, @id int

BEGIN TRANSACTION

select @id=min(SQLCmnd_id) from #SQLCmnd
while @id is not null
begin
  select @studyid=study_id, @SQL=strSQL from #SQLCmnd where SQLCmnd_id=@id
  exec (@SQL)
  update #study set RecsUpdated = @@rowcount where study_id=@studyid
  delete from #SQLCmnd where SQLCmnd_id=@id
  select @id=min(SQLCmnd_id) from #SQLCmnd
end

declare @RecsInFile int, @RecsUpdated int
select @recsinfile=sum(recsinfile), @recsupdated=sum(recsupdated) from #study
if @recsinfile=@recsupdated
  begin
    COMMIT TRANSACTION
    --PRINT convert(varchar,@recsupdated)+' records updated.'
  end
else
  begin
    ROLLBACK TRANSACTION
    --PRINT 'At least one study wasn''t able to update all its records.  No changes were commited for ANY of the studies!'
  end

drop table #SQLCmnd

select study_id, RecsInFile, RecsUpdated, case when RecsInFile<>RecsUpdated then 'ERROR!!' else 'OK' end as Status, 
Corrected, AlreadyValid, Invalid, Invalid/(RecsInFile*.01) as [%Invalid]
from #study

drop table #study

set nocount off


