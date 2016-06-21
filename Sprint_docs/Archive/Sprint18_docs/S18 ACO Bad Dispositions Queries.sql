--Chris Burkholder's updates to modify dispositions from 31 to 34 in preparation
--for a story to determine how the phone break-off interfered

use [QP_Comments]
go

--update s4878.Big_Table_2014_4 set ACODisposition = 34
select ACODisposition, * from s4878.Big_Table_View 
where samplepop_id in (107467701, 107467979)

--update s4890.Big_Table_2014_4 set ACODisposition = 34
select ACODisposition, * from s4890.Big_Table_View 
where samplepop_id in (107478525,107479158,107478744, 107478416)

--update s4879.Big_Table_2014_4 set ACODisposition = 34
select ACODisposition, * from s4879.Big_Table_View
where samplepop_id in (107469229,
107469234,
107468718,
107469221,
107468830,
107468942)

--update s4881.Big_Table_2014_4 set ACODisposition = 34
select ACODisposition, * from s4881.Big_Table_View
where samplepop_id in (107470350,
107470704,
107471035,
107471027
)

--update s4882.Big_Table_2014_4 set ACODisposition = 34
select ACODisposition, * from s4882.Big_Table_View
where samplepop_id in (
107471767,
107471208,
107471719)

--update s4886.Big_Table_2014_4 set ACODisposition = 34
select ACODisposition, * from s4886.Big_Table_View
where samplepop_id in (
107474877,
107475585)

--update s4885.Big_Table_2014_4 set ACODisposition = 34
select ACODisposition, * from s4885.Big_Table_View
where samplepop_id in (
107474174,
107474027,
107474121)

--update s4887.Big_Table_2014_4 set ACODisposition = 34
select ACODisposition, * from s4887.Big_Table_View
where samplepop_id in (
107475684,
107476407)

--update s4884.Big_Table_2014_4 set ACODisposition = 34
select ACODisposition, * from s4884.Big_Table_View
where samplepop_id in (
107473413)

--update s4889.Big_Table_2014_4 set ACODisposition = 34
select ACODisposition, * from s4889.Big_Table_View
where samplepop_id in (
107478174)

--update s4883.Big_Table_2014_4 set ACODisposition = 34
select ACODisposition, * from s4883.Big_Table_View
where samplepop_id in (
107472328,
107472277)

--update s4888.Big_Table_2014_4 set ACODisposition = 34
select ACODisposition, * from s4888.Big_Table_View
where samplepop_id in (
107476773,
107477337,
107476641,
107476781)

--update s4891.Big_Table_2014_4 set ACODisposition = 34
select ACODisposition, * from s4891.Big_Table_View
where samplepop_id in (
107479767)


