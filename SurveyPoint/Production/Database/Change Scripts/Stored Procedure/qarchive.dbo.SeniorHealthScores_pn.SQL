/****** Object:  StoredProcedure [dbo].[SeniorHealthScores_pn]    Script Date: 08/10/2006 10:08:42 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SeniorHealthScores_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SeniorHealthScores_pn]
GO
/****** Object:  StoredProcedure [dbo].[SeniorHealthScores_pn]    Script Date: 08/10/2006 10:08:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SeniorHealthScores_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure SeniorHealthScores_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       SeniorHealthScores
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           SeniorHealthScores''
 /* WARNING-  this table is not journalled!
The journales will be estimated via periodic runs .


*/

print ''no journal: synchronize''
 if (@mode = 0) or (@mode = 1) or (@mode = 3)
begin
print ''transferring the base table changes:''

print ''Step 1: sync deletes''



delete a
from SeniorHealthScores a
where not exists (
select ''x''
from goliath.qms.dbo.SeniorHealthScores b
where 
     a.[RespondentID]= b.[RespondentID]
)





print '' step 2: update ''

	update f 
	set 
   f.[PraScore]= a.[PraScore]
,  f.[FrailtyScore]= a.[FrailtyScore]
,  f.[DepressionScore]= a.[DepressionScore]
,  f.[RedFlagFactors]= a.[RedFlagFactors]
,  f.[PraFactors]= a.[PraFactors]
,  f.[FrailtyFactors]= a.[FrailtyFactors]
,  f.[DepressionFactors]= a.[DepressionFactors]
,  f.[HighRisk]= a.[HighRisk]
 from SeniorHealthScores f,goliath.qms.dbo.SeniorHealthScores a
	where 
     a.[RespondentID]= f.[RespondentID]
and (
  (a.[PraScore]  is null and f.[PraScore] is not null) or (a.[PraScore]  is not null and f.[PraScore] is null) or  (a.[PraScore] != f.[PraScore])
or (a.[FrailtyScore]  is null and f.[FrailtyScore] is not null) or (a.[FrailtyScore]  is not null and f.[FrailtyScore] is null) or  (a.[FrailtyScore] != f.[FrailtyScore])
or (a.[DepressionScore]  is null and f.[DepressionScore] is not null) or (a.[DepressionScore]  is not null and f.[DepressionScore] is null) or  (a.[DepressionScore] != f.[DepressionScore])
or (a.[RedFlagFactors]  is null and f.[RedFlagFactors] is not null) or (a.[RedFlagFactors]  is not null and f.[RedFlagFactors] is null) or  (a.[RedFlagFactors] != f.[RedFlagFactors])
or (a.[PraFactors]  is null and f.[PraFactors] is not null) or (a.[PraFactors]  is not null and f.[PraFactors] is null) or  (a.[PraFactors] != f.[PraFactors])
or (a.[FrailtyFactors]  is null and f.[FrailtyFactors] is not null) or (a.[FrailtyFactors]  is not null and f.[FrailtyFactors] is null) or  (a.[FrailtyFactors] != f.[FrailtyFactors])
or (a.[DepressionFactors]  is null and f.[DepressionFactors] is not null) or (a.[DepressionFactors]  is not null and f.[DepressionFactors] is null) or  (a.[DepressionFactors] != f.[DepressionFactors])
or (a.[HighRisk]  is null and f.[HighRisk] is not null) or (a.[HighRisk]  is not null and f.[HighRisk] is null) or  (a.[HighRisk] != f.[HighRisk])
)
	
	
	

print '' Step 3: insert''
insert into SeniorHealthScores(
 [RespondentID]
,[PraScore]
,[FrailtyScore]
,[DepressionScore]
,[RedFlagFactors]
,[PraFactors]
,[FrailtyFactors]
,[DepressionFactors]
,[HighRisk]
)
select 
 a.[RespondentID]
,a.[PraScore]
,a.[FrailtyScore]
,a.[DepressionScore]
,a.[RedFlagFactors]
,a.[PraFactors]
,a.[FrailtyFactors]
,a.[DepressionFactors]
,a.[HighRisk]
 from goliath.qms.dbo.SeniorHealthScores a
where not exists (select ''x''
from  SeniorHealthScores b
 where 
     a.[RespondentID]= b.[RespondentID]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from SeniorHealthScores a
where not exists (
select ''x''
from goliath.qms.dbo.SeniorHealthScores b
where 
     a.[RespondentID]= b.[RespondentID]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from SeniorHealthScores f,goliath.qms.dbo.SeniorHealthScores a
	where 
     a.[RespondentID]= f.[RespondentID]
and (
  (a.[PraScore]  is null and f.[PraScore] is not null) or (a.[PraScore]  is not null and f.[PraScore] is null) or  (a.[PraScore] != f.[PraScore])
or (a.[FrailtyScore]  is null and f.[FrailtyScore] is not null) or (a.[FrailtyScore]  is not null and f.[FrailtyScore] is null) or  (a.[FrailtyScore] != f.[FrailtyScore])
or (a.[DepressionScore]  is null and f.[DepressionScore] is not null) or (a.[DepressionScore]  is not null and f.[DepressionScore] is null) or  (a.[DepressionScore] != f.[DepressionScore])
or (a.[RedFlagFactors]  is null and f.[RedFlagFactors] is not null) or (a.[RedFlagFactors]  is not null and f.[RedFlagFactors] is null) or  (a.[RedFlagFactors] != f.[RedFlagFactors])
or (a.[PraFactors]  is null and f.[PraFactors] is not null) or (a.[PraFactors]  is not null and f.[PraFactors] is null) or  (a.[PraFactors] != f.[PraFactors])
or (a.[FrailtyFactors]  is null and f.[FrailtyFactors] is not null) or (a.[FrailtyFactors]  is not null and f.[FrailtyFactors] is null) or  (a.[FrailtyFactors] != f.[FrailtyFactors])
or (a.[DepressionFactors]  is null and f.[DepressionFactors] is not null) or (a.[DepressionFactors]  is not null and f.[DepressionFactors] is null) or  (a.[DepressionFactors] != f.[DepressionFactors])
or (a.[HighRisk]  is null and f.[HighRisk] is not null) or (a.[HighRisk]  is not null and f.[HighRisk] is null) or  (a.[HighRisk] != f.[HighRisk])
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.SeniorHealthScores a
where not exists (select ''x''
from  SeniorHealthScores b
 where 
     a.[RespondentID]= b.[RespondentID]
)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           SeniorHealthScores done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
