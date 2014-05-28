CREATE PROCEDURE QP_Rep_ASHP_NonSurveyed_old
   @Associate varchar(50),
   @Client varchar(50),
   @Study varchar(50)
AS
set transaction isolation level read uncommitted
declare @study_id int
declare @strsql varchar(8000)

select @Study_id=s.study_id 
from study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and c.client_id=s.client_id

set @strsql = 'select distinct p.pop_id,p.NewRecordDate,LangID,AddrErr,City,Zip5,Addr,ST, '
set @strsql = @strsql + 'Del_Pt,Zip4,AddrStat,DOB,Employer,Marital,Title,FName,Sex,LName,Middle,Age, '
set @strsql = @strsql + 'Race,enc_id,ServiceDate,FinClass,PlanNumber,DrID,ClinicNum,e.MRN '
set @strsql = @strsql + 'from s' + ltrim(rtrim(convert(char(10),@study_id))) + '.population p, '
set @strsql = @strsql + 's' + ltrim(rtrim(convert(char(10),@study_id))) + '.encounter e '
set @strsql = @strsql + 'where p.pop_id = e.pop_id '
set @strsql = @strsql + 'and p.pop_id not in (select pop_id from samplepop '
set @strsql = @strsql + 'where study_id = ' + ltrim(rtrim(convert(char(10),@study_id))) + ') '
set @strsql = @strsql + 'and p.pop_id not in (select pop_id from tocl '
set @strsql = @strsql + 'where study_id = ' + ltrim(rtrim(convert(char(10),@study_id))) + ') '
set @strsql = @strsql + 'order by p.pop_id'

exec(@strsql)

set transaction isolation level read committed


