/****** Object:  StoredProcedure [dbo].[ScorePercentiles_pn]    Script Date: 08/10/2006 10:23:46 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ScorePercentiles_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ScorePercentiles_pn]
GO
/****** Object:  StoredProcedure [dbo].[ScorePercentiles_pn]    Script Date: 08/10/2006 10:23:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ScorePercentiles_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure ScorePercentiles_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       ScorePercentiles
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           ScorePercentiles''
 /* WARNING-  this table is not journalled!
The journales will be estimated via periodic runs .


*/

print ''no journal: synchronize''
 if (@mode = 0) or (@mode = 1) or (@mode = 3)
begin
print ''transferring the base table changes:''

print ''Step 1: sync deletes''



delete a
from ScorePercentiles a
where not exists (
select ''x''
from goliath.qms.dbo.ScorePercentiles b
where 
     a.[score_type]= b.[score_type]
AND  a.[score_value]= b.[score_value]
)





print '' step 2: update ''

	update f 
	set 
   f.[respondent_count]= a.[respondent_count]
,  f.[percentile]= a.[percentile]
 from ScorePercentiles f,goliath.qms.dbo.ScorePercentiles a
	where 
     a.[score_type]= f.[score_type]
AND  a.[score_value]= f.[score_value]
and (
   a.[respondent_count] != f.[respondent_count]
or  a.[percentile] != f.[percentile]
)
	
	
	

print '' Step 3: insert''
insert into ScorePercentiles(
 [score_type]
,[score_value]
,[respondent_count]
,[percentile]
)
select 
 a.[score_type]
,a.[score_value]
,a.[respondent_count]
,a.[percentile]
 from goliath.qms.dbo.ScorePercentiles a
where not exists (select ''x''
from  ScorePercentiles b
 where 
     a.[score_type]= b.[score_type]
AND  a.[score_value]= b.[score_value]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from ScorePercentiles a
where not exists (
select ''x''
from goliath.qms.dbo.ScorePercentiles b
where 
     a.[score_type]= b.[score_type]
AND  a.[score_value]= b.[score_value]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from ScorePercentiles f,goliath.qms.dbo.ScorePercentiles a
	where 
     a.[score_type]= f.[score_type]
AND  a.[score_value]= f.[score_value]
and (
   a.[respondent_count] != f.[respondent_count]
or  a.[percentile] != f.[percentile]
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.ScorePercentiles a
where not exists (select ''x''
from  ScorePercentiles b
 where 
     a.[score_type]= b.[score_type]
AND  a.[score_value]= b.[score_value]
)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           ScorePercentiles done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
