CREATE procedure dbo.qp_Rep_HCMG_CodingFreq  
@BeginDate datetime, @EndDate datetime    
as    
set @enddate=dateadd(day,1,@enddate)

declare @results table (Freq int, QuestionCode varchar(50), Scale int, GFValue varchar(15), Status int, Status_dsc varchar(25), Label varchar(70), Type varchar(20))

insert into @results (freq, questioncode, scale, gfvalue, status, status_dsc, label, type)
select sum(Freq) as Freq, QuestionCode, Scale_nm, GFValue, cf.status, l.label as Status_dsc, cf.Label, 'Standard'
from hcmg.hcmg_staging.dbo.CodingFreq cf   
 left outer join (select 0 as status, 'In range from GF' as label  
				 union select 9, 'blank from GF'  
				 union select 10, 'null from GF'  
				 union select 11, '99998 from GF'  
				 union select 20, 'needs coding'  
				 union select 21, 'don''t know/blank'  
				 union select 22, 'autocoded') L  
		on cf.status=l.status  
where filedate between @begindate and @enddate  
group by QuestionCode, Scale_nm, GFValue, cf.status, l.label, cf.Label  
order by 3,6,5  

update r
set type = 'Hospital'
from @Results r, hcmg.hcmg_staging.dbo.fieldscale fs
where r.questioncode=fs.field_nm
and fs.step=4

update r
set type = 'MultiResponse'
from @Results r, hcmg.hcmg_staging.dbo.fieldscale fs
where r.questioncode=fs.field_nm
and fs.intScale=0

select questioncode as dummy, QuestionCode, Scale, GFValue+0 as GFValue, Status, Status_dsc, Label, Freq, Type
from @results
union all
select distinct questioncode, null, null, null, null, null, null, null, null
from @results
union all
select '_', 'File Dates', null, null, null, null, left(convert(varchar,@BeginDate,1),5) + ' - ' + convert(varchar,@EndDate,1), sum([rowcount]), null 
from hcmg.hcmg_staging.dbo.[file] where [timestamp] between @begindate and @enddate
order by 1,2,4,5


