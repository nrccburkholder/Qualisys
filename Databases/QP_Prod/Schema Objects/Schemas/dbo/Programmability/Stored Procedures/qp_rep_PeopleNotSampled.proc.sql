CREATE procedure qp_rep_PeopleNotSampled
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @FirstDataset varchar(50),
 @LastDataset varchar(50)
as
set transaction isolation level read uncommitted

Declare @intStudy_id int, @intFirstDataSet_id int, @intLastDataSet_id int, @SQL varchar(800)

select @intstudy_id=s.study_id
from study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and c.client_id=s.client_id


select @intFirstDataset_id =DataSet_id
from Data_Set
where study_id=@intstudy_id
  and abs(datediff(second,datload_Dt,convert(datetime,@FirstDataset)))<=1

select @intLastDataset_id =DataSet_id
from Data_Set
where study_id=@intstudy_id
  and abs(datediff(second,datload_Dt,convert(datetime,@LastDataset)))<=1

select distinct pop_id, enc_id 
into #Pop
from datasetmember dsm, data_set ds
where dsm.dataset_id = ds.dataset_id
and ds.study_id = @intstudy_id
and ds.dataset_id between @intFirstdataset_id and @intLastdataset_id

delete p
from #pop p left outer join samplepop sp on p.pop_id = sp.pop_id and 
sp.study_id = @intstudy_id
where sp.samplepop_id is not null

if exists (select * from metatable where study_id = @intstudy_id and strtable_nm='ENCOUNTER')
begin
 set @SQL = 'select bv.* from s' + convert(varchar,@intstudy_id) + '.big_view bv, #pop p where bv.encounterenc_id = p.enc_id'
 exec(@SQL)
end
else
begin
 set @SQL = 'select bv.* from s' + convert(varchar,@intstudy_id) + '.big_view bv, #pop p where bv.populationpop_id = p.pop_id'
 exec(@SQL)
end

drop table #pop


