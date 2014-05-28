CREATE procedure sp_Export_NewMRD3_VA_Second
@cutoff_id integer, @ReturnsOnly bit = 0, @DirectOnly bit = 0
as
declare @study_id int, @sql varchar(1000), @datStartProc datetime

select @study_id=sd.study_id, @datStartProc=getdate()
from cutoff co, survey_def sd
where co.cutoff_id=@cutoff_id
  and co.survey_id=sd.survey_id

select @sql = 
'if exists (select * from sysobjects where id = object_id(N''[S'+convert(varchar,@study_id)+'].[MRD2_'+convert(varchar,@cutoff_id)+']'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1) '+
'drop table [S'+convert(varchar,@study_id)+'].[MRD2_'+convert(varchar,@cutoff_id)+']'
Exec (@SQL)

select @sql = 
'create table s' + convert(varchar,@study_id)+'.MRD2_'+convert(varchar,@cutoff_id)+
'  (SampSet integer,'+
'   Samp_dt datetime,'+
'   SampUnit integer,'+
'   Unit_nm char(42),'+
'   SampType char(1),'+
'   SampPop integer,'+
'   QstnForm integer,'+
'   lithocd char(10),'+
'   Rtrn_dt datetime,'+
'   Undel_dt datetime,'+
'   MailStep int)'
Exec (@SQL)

exec sp_Export_NewMRD3_VA_Sub_Second @cutoff_id, @ReturnsOnly, @DirectOnly


