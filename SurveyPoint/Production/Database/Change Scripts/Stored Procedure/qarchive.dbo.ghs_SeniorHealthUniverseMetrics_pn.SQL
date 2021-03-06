/****** Object:  StoredProcedure [dbo].[ghs_SeniorHealthUniverseMetrics_pn]    Script Date: 08/09/2006 16:18:49 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ghs_SeniorHealthUniverseMetrics_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ghs_SeniorHealthUniverseMetrics_pn]
GO
/****** Object:  StoredProcedure [dbo].[ghs_SeniorHealthUniverseMetrics_pn]    Script Date: 08/09/2006 16:18:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ghs_SeniorHealthUniverseMetrics_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure ghs_SeniorHealthUniverseMetrics_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       ghs_SeniorHealthUniverseMetrics
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           ghs_SeniorHealthUniverseMetrics''
 /* WARNING-  this table is not journalled!
The journales will be estimated via periodic runs .


*/

print ''no journal: synchronize''
 if (@mode = 0) or (@mode = 1) or (@mode = 3)
begin
print ''transferring the base table changes:''

print ''Step 1: sync deletes''



delete a
from ghs_SeniorHealthUniverseMetrics a
where not exists (
select ''x''
from goliath.qms.dbo.ghs_SeniorHealthUniverseMetrics b
where 
     a.[metric_name]= b.[metric_name]
)





print '' step 2: update ''

	update f 
	set 
   f.[metric_value]= a.[metric_value]
 from ghs_SeniorHealthUniverseMetrics f,goliath.qms.dbo.ghs_SeniorHealthUniverseMetrics a
	where 
     a.[metric_name]= f.[metric_name]
and (
  (a.[metric_value]  is null and f.[metric_value] is not null) or (a.[metric_value]  is not null and f.[metric_value] is null) or  (a.[metric_value] != f.[metric_value])
)
	
	
	

print '' Step 3: insert''
insert into ghs_SeniorHealthUniverseMetrics(
 [metric_name]
,[metric_value]
)
select 
 a.[metric_name]
,a.[metric_value]
 from goliath.qms.dbo.ghs_SeniorHealthUniverseMetrics a
where not exists (select ''x''
from  ghs_SeniorHealthUniverseMetrics b
 where 
     a.[metric_name]= b.[metric_name]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from ghs_SeniorHealthUniverseMetrics a
where not exists (
select ''x''
from goliath.qms.dbo.ghs_SeniorHealthUniverseMetrics b
where 
     a.[metric_name]= b.[metric_name]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from ghs_SeniorHealthUniverseMetrics f,goliath.qms.dbo.ghs_SeniorHealthUniverseMetrics a
	where 
     a.[metric_name]= f.[metric_name]
and (
  (a.[metric_value]  is null and f.[metric_value] is not null) or (a.[metric_value]  is not null and f.[metric_value] is null) or  (a.[metric_value] != f.[metric_value])
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.ghs_SeniorHealthUniverseMetrics a
where not exists (select ''x''
from  ghs_SeniorHealthUniverseMetrics b
 where 
     a.[metric_name]= b.[metric_name]
)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           ghs_SeniorHealthUniverseMetrics done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
