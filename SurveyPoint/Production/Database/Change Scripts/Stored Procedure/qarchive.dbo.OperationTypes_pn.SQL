/****** Object:  StoredProcedure [dbo].[OperationTypes_pn]    Script Date: 08/10/2006 16:43:32 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[OperationTypes_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[OperationTypes_pn]
GO
/****** Object:  StoredProcedure [dbo].[OperationTypes_pn]    Script Date: 08/10/2006 16:43:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[OperationTypes_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure OperationTypes_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       OperationTypes
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           OperationTypes''
 /* WARNING-  this table is not journalled!
The journales will be estimated via periodic runs .


*/

print ''no journal: synchronize''
 if (@mode = 0) or (@mode = 1) or (@mode = 3)
begin
print ''transferring the base table changes:''

print ''Step 1: sync deletes''



delete a
from OperationTypes a
where not exists (
select ''x''
from goliath.qms.dbo.OperationTypes b
where 
     a.[Operation]= b.[Operation]
)





print '' Warning- no update needed for this table because the only fields are the primary key''



print '' Step 3: insert''
insert into OperationTypes(
 [Operation]
)
select 
 a.[Operation]
 from goliath.qms.dbo.OperationTypes a
where not exists (select ''x''
from  OperationTypes b
 where 
     a.[Operation]= b.[Operation]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from OperationTypes a
where not exists (
select ''x''
from goliath.qms.dbo.OperationTypes b
where 
     a.[Operation]= b.[Operation]
)





print '' Warning- no update needed for this table because the only fields are the primary key''



print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.OperationTypes a
where not exists (select ''x''
from  OperationTypes b
 where 
     a.[Operation]= b.[Operation]
)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           OperationTypes done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
