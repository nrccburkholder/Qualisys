create procedure SP_DBM_DupFields as
select case when strfieldshort_nm is null then left(strfield_nm,8) else strfieldshort_nm end as strfieldshort_nm
into #fields
from metafield

select strfieldshort_nm from #fields group by strfieldshort_nm having count(*) > 1

drop table #fields


