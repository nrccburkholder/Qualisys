/****** Object:  StoredProcedure [dbo].[DbFileSizeLog_pn]    Script Date: 08/09/2006 13:38:36 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DbFileSizeLog_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[DbFileSizeLog_pn]
GO
/****** Object:  StoredProcedure [dbo].[DbFileSizeLog_pn]    Script Date: 08/09/2006 13:38:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DbFileSizeLog_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure DbFileSizeLog_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       DbFileSizeLog
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           DbFileSizeLog''
 /* WARNING-  this table is not journalled!
The journales will be estimated via periodic runs .


*/

print ''no journal: synchronize''
 if (@mode = 0) or (@mode = 1) or (@mode = 3)
begin
print ''transferring the base table changes:''

print ''Step 1: sync deletes''



delete a
from DbFileSizeLog a
where not exists (
select ''x''
from goliath.qms.dbo.DbFileSizeLog b
where 
     a.[StatusDate]= b.[StatusDate]
AND  a.[Name]= b.[Name]
)





print '' step 2: update ''

	update f 
	set 
   f.[FileGroupName]= a.[FileGroupName]
,  f.[FileId]= a.[FileId]
,  f.[FileName]= a.[FileName]
,  f.[FileSizeMb]= a.[FileSizeMb]
,  f.[UsageSizeMb]= a.[UsageSizeMb]
,  f.[PercentUsage]= a.[PercentUsage]
 from DbFileSizeLog f,goliath.qms.dbo.DbFileSizeLog a
	where 
     a.[StatusDate]= f.[StatusDate]
AND  a.[Name]= f.[Name]
and (
   a.[FileGroupName] != f.[FileGroupName]
or (a.[FileId]  is null and f.[FileId] is not null) or (a.[FileId]  is not null and f.[FileId] is null) or  (a.[FileId] != f.[FileId])
or (a.[FileName]  is null and f.[FileName] is not null) or (a.[FileName]  is not null and f.[FileName] is null) or  (a.[FileName] != f.[FileName])
or  a.[FileSizeMb] != f.[FileSizeMb]
or  a.[UsageSizeMb] != f.[UsageSizeMb]
or  a.[PercentUsage] != f.[PercentUsage]
)
	
	
	

print '' Step 3: insert''
insert into DbFileSizeLog(
 [StatusDate]
,[FileGroupName]
,[FileId]
,[Name]
,[FileName]
,[FileSizeMb]
,[UsageSizeMb]
,[PercentUsage]
)
select 
 a.[StatusDate]
,a.[FileGroupName]
,a.[FileId]
,a.[Name]
,a.[FileName]
,a.[FileSizeMb]
,a.[UsageSizeMb]
,a.[PercentUsage]
 from goliath.qms.dbo.DbFileSizeLog a
where not exists (select ''x''
from  DbFileSizeLog b
 where 
     a.[StatusDate]= b.[StatusDate]
AND  a.[Name]= b.[Name]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from DbFileSizeLog a
where not exists (
select ''x''
from goliath.qms.dbo.DbFileSizeLog b
where 
     a.[StatusDate]= b.[StatusDate]
AND  a.[Name]= b.[Name]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from DbFileSizeLog f,goliath.qms.dbo.DbFileSizeLog a
	where 
     a.[StatusDate]= f.[StatusDate]
AND  a.[Name]= f.[Name]
and (
   a.[FileGroupName] != f.[FileGroupName]
or (a.[FileId]  is null and f.[FileId] is not null) or (a.[FileId]  is not null and f.[FileId] is null) or  (a.[FileId] != f.[FileId])
or (a.[FileName]  is null and f.[FileName] is not null) or (a.[FileName]  is not null and f.[FileName] is null) or  (a.[FileName] != f.[FileName])
or  a.[FileSizeMb] != f.[FileSizeMb]
or  a.[UsageSizeMb] != f.[UsageSizeMb]
or  a.[PercentUsage] != f.[PercentUsage]
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.DbFileSizeLog a
where not exists (select ''x''
from  DbFileSizeLog b
 where 
     a.[StatusDate]= b.[StatusDate]
AND  a.[Name]= b.[Name]
)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           DbFileSizeLog done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
