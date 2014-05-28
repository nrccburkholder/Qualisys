CREATE procedure sp_Export_NewMRD
@cutoff_id integer, @ReturnsOnly bit = 0 
as
RETURN

create table #MRD 
  (SampSet integer,
   Samp_dt datetime,
   SampUnit integer,
   Unit_nm char(42),
   SampType char(1),
   SampPop integer,
   QstnForm integer,
   lithocd char(10),
   Rtrn_dt datetime,
   Undel_dt datetime)

exec sp_Export_NewMRD_sub @cutoff_id, @ReturnsOnly

select * from #MRD


