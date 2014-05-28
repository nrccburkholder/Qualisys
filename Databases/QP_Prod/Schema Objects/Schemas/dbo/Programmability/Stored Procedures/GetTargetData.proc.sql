CREATE proc GetTargetData       
 @client_id int,       
 @mindate datetime,      
 @maxdate datetime      
as    
/*    
--GetTargetData 1089,'9/1/2009','11/10/2009'    
declare @client_id int, @mindate datetime, @maxdate datetime      
set @client_id = 1007
set @mindate = '05/01/2010'    
set @maxdate = '05/20/2010'    
*/
    
    
declare @samplesets varchar(1000)      
      
set @maxdate = @maxdate + 1      
      
      
select distinct sampleset_id --, c.client_id, strclient_nm, s.study_id, strstudy_nm, sd.survey_id, strsurvey_nm      
into #samples      
from study s inner join survey_def sd      
 on s.study_id = sd.study_id      
inner join sampleset ss      
 on sd.survey_id = ss.survey_id      
--inner join client c      
-- on s.client_id = c.client_id      
where datdaterange_fromdate >= @mindate      
 and datdaterange_todate <= @maxdate       
 and s.client_id = @client_id     


set @samplesets = ''      
select @samplesets = @samplesets + cast(sampleset_id as varchar) + ',' from #samples    

if (len(@samplesets)=0)
begin
	select '' as client_id, '' as strclient_nm, 0 as study_id, '' as strstudy_nm, '' as strstudy_dsc, 0 as survey_id, 
	'' as strsurvey_nm, '' as strsurvey_dsc, 0 as sampleunit_id, 0 as strsampleunit_nm, 0 as target,  
	'' as period, 0 as available, 0 as sentout, 0 as returned, 0 as totaldq, 0 as rr, 0 as intUD
	into #tmp2

	delete #tmp2
	select * from #tmp2
	drop table #tmp2
	return
end

select @samplesets = left(@samplesets, len(@samplesets)-1)      
      
      
create table #all       
(Part varchar(20),sampleset_id int,      
sampleunit_id int,Tier int,TreeOrder int,strSampleUnit_nm varchar(50),PRT int,DRR int,HRR float,TPO int,                
APON float,ONTS int,STS int,D int,Avail int,ISTS int,TotalDQ int,HCAHPSSampled int)      
      
insert #all (Part,sampleset_id,sampleunit_id,Tier,TreeOrder,strSampleUnit_nm,PRT,DRR,HRR,TPO,APON,ONTS,ISTS,STS,D,Avail,TotalDQ,HCAHPSSampled)                
exec ssrs_ms_sampleplanworksheet @samplesets, 1        
      
      
select sampleunit_id, 0 as prt, sum(STS) as sts, sum(Avail) as avail, sum(TotalDQ) as TotalDQ       
into #counts      
from #all       
where sampleunit_id is not null      
group by sampleunit_id      
  
select survey_id, max(perioddef_id) perioddef_id into #tmp from perioddef   
where survey_id in (select distinct survey_id from #counts c inner join datamart.qp_comments.dbo.sampleunit su on c.sampleunit_id = su.sampleunit_id)  
group by survey_id  
  
select survey_id,   
case   
 when datediff(d, datexpectedencstart, datexpectedencend) between 28 and 32 then 'Monthly'  
 when datediff(d, datexpectedencstart, datexpectedencend) between 85 and 93 then 'Quarterly'  
 else ''  
end as period  
into #periods  
from perioddef   
where perioddef_id in (select perioddef_id from #tmp)  
  
--get most recent target and replace the prt in previous step  
update c  
set prt = tmpcounts.prt  
from #counts c inner join  
 (select a.sampleunit_id, a.prt  
 from #all a inner join  
  (select distinct max(sampleset_id) sampleset_id, sampleunit_id from #all where sampleunit_id is not null group by sampleunit_id) tmp  
   on a.sampleset_id = tmp.sampleset_id  
   and a.sampleunit_id = tmp.sampleunit_id  
 ) tmpcounts  
on c.sampleunit_id = tmpcounts.sampleunit_id  
  
      
select sampleunit_id, sum(intsampled) as sampled, sum(intreturned) as returned, cast(sum(intreturned) as float)/cast(sum(intsampled) as float) as RR, sum(intUD) as intUD    
into #returns      
from respratecount       
where sampleset_id in (select sampleset_id from #samples)      
and sampleunit_id > 0      
group by sampleunit_id      
      
    
select cl.client_id, cl.strclient_nm,       
 s.study_id, s.strstudy_nm, s.strstudy_dsc,      
 sd.survey_id, case when sd.strclientfacingname is null then sd.strsurvey_nm else sd.strclientfacingname end as strsurvey_nm, sd.strsurvey_dsc,      
 c.sampleunit_id, su.strsampleunit_nm, prt as target,  
 case   
  when prt = 0 then ''   
  when prt = 999 then ''  
  else period   
 end as period,   
 avail as available, sts as sentout, isnull(returned, 0) as returned, totaldq, round((isnull(rr, 0)*100), 1) as rr, isnull(intUD, 0) as intUD    
from #counts c left join #returns r       
 on c.sampleunit_id = r.sampleunit_id      
inner join datamart.qp_comments.dbo.sampleunit su      
 on c.sampleunit_id = su.sampleunit_id      
inner join survey_def sd      
 on sd.survey_id = su.survey_id      
inner join study s       
 on sd.study_id = s.study_id      
inner join client cl      
 on s.client_id = cl.client_id      
inner join #periods p  
 on p.survey_id = su.survey_id  
where prt+avail+sts+isnull(returned, 0)+totaldq+isnull(rr, 0)>0      
order by c.sampleunit_id      
    
drop table #all      
drop table #samples      
drop table #returns      
drop table #counts      
drop table #tmp


