/****** Object:  StoredProcedure [dbo].[SurveyInstanceDefaultScripts_pn]    Script Date: 08/09/2006 12:57:07 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SurveyInstanceDefaultScripts_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SurveyInstanceDefaultScripts_pn]
GO
/****** Object:  StoredProcedure [dbo].[SurveyInstanceDefaultScripts_pn]    Script Date: 08/09/2006 12:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SurveyInstanceDefaultScripts_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure SurveyInstanceDefaultScripts_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       SurveyInstanceDefaultScripts
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           SurveyInstanceDefaultScripts''
 /* WARNING-  this table is not journalled!
The journales will be estimated via periodic runs .


*/

print ''no journal: synchronize''
 if (@mode = 0) or (@mode = 1) or (@mode = 3)
begin
print ''transferring the base table changes:''

print ''Step 1: sync deletes''



delete a
from SurveyInstanceDefaultScripts a
where not exists (
select ''x''
from goliath.qms.dbo.SurveyInstanceDefaultScripts b
where 
     a.[SurveyInstanceScriptID]= b.[SurveyInstanceScriptID]
)





print '' step 2: update ''

	update f 
	set 
   f.[SurveyInstanceID]= a.[SurveyInstanceID]
,  f.[ScriptTypeID]= a.[ScriptTypeID]
,  f.[ScriptID]= a.[ScriptID]
 from SurveyInstanceDefaultScripts f,goliath.qms.dbo.SurveyInstanceDefaultScripts a
	where 
     a.[SurveyInstanceScriptID]= f.[SurveyInstanceScriptID]
and (
   a.[SurveyInstanceID] != f.[SurveyInstanceID]
or  a.[ScriptTypeID] != f.[ScriptTypeID]
or  a.[ScriptID] != f.[ScriptID]
)
	
	
	

print '' Step 3: insert''
insert into SurveyInstanceDefaultScripts(
 [SurveyInstanceScriptID]
,[SurveyInstanceID]
,[ScriptTypeID]
,[ScriptID]
)
select 
 a.[SurveyInstanceScriptID]
,a.[SurveyInstanceID]
,a.[ScriptTypeID]
,a.[ScriptID]
 from goliath.qms.dbo.SurveyInstanceDefaultScripts a
where not exists (select ''x''
from  SurveyInstanceDefaultScripts b
 where 
     a.[SurveyInstanceScriptID]= b.[SurveyInstanceScriptID]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from SurveyInstanceDefaultScripts a
where not exists (
select ''x''
from goliath.qms.dbo.SurveyInstanceDefaultScripts b
where 
     a.[SurveyInstanceScriptID]= b.[SurveyInstanceScriptID]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from SurveyInstanceDefaultScripts f,goliath.qms.dbo.SurveyInstanceDefaultScripts a
	where 
     a.[SurveyInstanceScriptID]= f.[SurveyInstanceScriptID]
and (
   a.[SurveyInstanceID] != f.[SurveyInstanceID]
or  a.[ScriptTypeID] != f.[ScriptTypeID]
or  a.[ScriptID] != f.[ScriptID]
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.SurveyInstanceDefaultScripts a
where not exists (select ''x''
from  SurveyInstanceDefaultScripts b
 where 
     a.[SurveyInstanceScriptID]= b.[SurveyInstanceScriptID]
)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           SurveyInstanceDefaultScripts done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
