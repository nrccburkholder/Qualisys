CREATE procedure qp_rep_Postal_Sortation
@Associate varchar(30)
as
select ZIP3_CD, SCHEME, SCHEMELBL, AADC, AADCLBL, DIST, ADC, ADCLBL 
from dbo.usps 
order by zip3_cd


