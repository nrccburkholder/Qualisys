/****** Object:  StoredProcedure [dbo].[Processors_pn]    Script Date: 08/10/2006 16:43:20 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Processors_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Processors_pn]
GO
/****** Object:  StoredProcedure [dbo].[Processors_pn]    Script Date: 08/10/2006 16:43:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Processors_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure Processors_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       Processors
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           Processors''
 /* WARNING-  this table is not journalled!
The journales will be estimated via periodic runs .


*/

print ''no journal: synchronize''
 if (@mode = 0) or (@mode = 1) or (@mode = 3)
begin
print ''transferring the base table changes:''

print ''Step 1: sync deletes''



delete a
from Processors a
where not exists (
select ''x''
from goliath.qms.dbo.Processors b
where 
     a.[processorID]= b.[processorID]
)





print '' step 2: update ''

	update f 
	set 
   f.[ProcessorName]= a.[ProcessorName]
,  f.[ProcessorCode]= a.[ProcessorCode]
 from Processors f,goliath.qms.dbo.Processors a
	where 
     a.[processorID]= f.[processorID]
and (
   a.[ProcessorName] != f.[ProcessorName]
or  a.[ProcessorCode] != f.[ProcessorCode]
)
	
	
	

print '' Step 3: insert''
insert into Processors(
 [processorID]
,[ProcessorName]
,[ProcessorCode]
)
select 
 a.[processorID]
,a.[ProcessorName]
,a.[ProcessorCode]
 from goliath.qms.dbo.Processors a
where not exists (select ''x''
from  Processors b
 where 
     a.[processorID]= b.[processorID]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from Processors a
where not exists (
select ''x''
from goliath.qms.dbo.Processors b
where 
     a.[processorID]= b.[processorID]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from Processors f,goliath.qms.dbo.Processors a
	where 
     a.[processorID]= f.[processorID]
and (
   a.[ProcessorName] != f.[ProcessorName]
or  a.[ProcessorCode] != f.[ProcessorCode]
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.Processors a
where not exists (select ''x''
from  Processors b
 where 
     a.[processorID]= b.[processorID]
)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           Processors done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
