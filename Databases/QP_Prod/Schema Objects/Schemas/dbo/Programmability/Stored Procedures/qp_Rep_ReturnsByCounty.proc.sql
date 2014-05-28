CREATE procedure dbo.qp_Rep_ReturnsByCounty    
@BeginDate datetime, @EndDate datetime    
as     
set @enddate=dateadd(day,1,@enddate)
select left(convert(varchar,@BeginDate,1),5) + ' - ' + convert(varchar,@EndDate,1) as FileDate, sum(returns) as Returns, County_nm, FIPS, State_nm, MSA_nm, Div_nm  
from HCMG.hcmg_staging.dbo.ReturnsByCounty_view   
where FileDate between @BeginDate and @EndDate    
group by County_nm, FIPS, State_nm, MSA_nm, Div_nm


