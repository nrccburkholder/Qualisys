CREATE procedure dbo.qp_Rep_HCMG_NeedsCodingByCounty
@associate varchar(20)
as     
select Category, Returns, County_nm, FIPS, State_nm, MSA_nm, Div_nm, Flagged
from HCMG.hcmg_staging.dbo.NeedsCodingByCounty_view


