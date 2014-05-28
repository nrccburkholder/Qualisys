CREATE PROCEDURE QP_Rep_ASHP_NonSurveyed
   @Associate varchar(50),
   @Client varchar(50),
   @Study varchar(50)
AS
set transaction isolation level read uncommitted
declare @procedurebegin datetime
set @procedurebegin = getdate()

insert into dashboardlog (report, associate, client, study, procedurebegin) select 'ASHP NonSurveyed', @associate, @client, @study, @procedurebegin

declare @study_id int
declare @strsql varchar(8000)

select @Study_id=s.study_id 
from study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and c.client_id=s.client_id

set @strsql = 'select * from s' + ltrim(rtrim(convert(char(10),@study_id))) + '.big_view bv ' 
set @strsql = @strsql + ' where bv.populationpop_id not in (select pop_id from samplepop '
set @strsql = @strsql + ' where study_id = ' + ltrim(rtrim(convert(char(10),@study_id))) + ') '
set @strsql = @strsql + ' and bv.populationpop_id not in (select pop_id from tocl '
set @strsql = @strsql + ' where study_id = ' + ltrim(rtrim(convert(char(10),@study_id))) + ') '
--print @strsql

exec(@strsql)

update dashboardlog
set procedureend = getdate()
where report = 'ASHP NonSurveyed'
and associate = @associate
and client = @client
and study = @study
and procedurebegin = @procedurebegin
and procedureend is null

set transaction isolation level read committed


