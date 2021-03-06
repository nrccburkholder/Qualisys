/****** Object:  StoredProcedure [dbo].[Criteria_pn]    Script Date: 08/09/2006 13:36:56 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Criteria_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Criteria_pn]
GO
/****** Object:  StoredProcedure [dbo].[Criteria_pn]    Script Date: 08/09/2006 13:36:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Criteria_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure Criteria_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       Criteria
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           Criteria''


declare @jn_operation varchar(1)
declare @jn_user varchar(100)
declare @jn_datetime datetime
declare @jn_endtime datetime 
declare @jn_notes varchar(240)
declare @jn_appln varchar(30)
declare @jn_session smallint
declare @CriteriaID int
declare @CriteriaName char(100)
declare @SurveyID int
declare @CriteriaTypeID int
declare @AnswerCategoryID int
declare @CriteriaDataTypeID smallint
declare @ParameterName varchar(100)
declare @TextValue varchar(1000)
declare @ReferenceCriteriaID int
declare @ReferenceCriteriaSequence int
declare @Flag int
declare @Lvl int
declare @Hierarchy varbinary

	declare @jn_mindate datetime
	declare @jn_maxdate datetime
	declare @jn_loop_count int
	
	
	if ((@mode =0) or (@mode = 1))
	  begin
	  set nocount on
		if (@mode = 1) 
		  begin
		  /* This mindate will not look at the production server
		  The other mindate will */
		  select @jn_mindate = isnull(dateadd(hour,-1,max(jn_datetime)),''10-jun-1970'')
		  from Criteria_jn
		  if @jn_mindate > dateadd(hour,-1,getdate())
			begin
			set @jn_mindate = dateadd(hour,-1,getdate())
			end
	  end
		else
		  begin
		  select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		  from goliath.qms.dbo.Criteria_jn
		  end
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
	
declare read_main cursor for
select jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [CriteriaID]
,[CriteriaName]
,[SurveyID]
,[CriteriaTypeID]
,[AnswerCategoryID]
,[CriteriaDataTypeID]
,[ParameterName]
,[TextValue]
,[ReferenceCriteriaID]
,[ReferenceCriteriaSequence]
,[Flag]
,[Lvl]
,[Hierarchy]
from goliath.qms.dbo.Criteria_jl where jn_datetime >= @jn_mindate
open read_main
set @jn_loop_count=0

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @CriteriaID
,@CriteriaName
,@SurveyID
,@CriteriaTypeID
,@AnswerCategoryID
,@CriteriaDataTypeID
,@ParameterName
,@TextValue
,@ReferenceCriteriaID
,@ReferenceCriteriaSequence
,@Flag
,@Lvl
,@Hierarchy
while @@fetch_status=0
  begin

if (@jn_loop_count % 100) = 0
  begin
  print ''Criteria_jn '' + convert(varchar(10),@jn_loop_count) + '' '' 
    + convert(varchar(100),@jn_datetime)
  end
set @jn_loop_count = @jn_loop_count + 1

	
		/* replace existing Criteria_jn */
		delete 
		from Criteria_jn
		where 
[CriteriaID] = @CriteriaID
           and jn_datetime = @jn_datetime
	
	

		/* now update the prior end date */
		update a
		set jn_endtime= (select min(jn_datetime)
           		from (select jn_datetime from Criteria_jn b
			where 
     a.[CriteriaID]= b.[CriteriaID]
 and a.jn_datetime <= b.jn_datetime 
union all select @jn_datetime where @jn_datetime >= a.jn_datetime) c )
from Criteria_jn a
where
a.[CriteriaID] = @CriteriaID
/*and a.jn_endtime> @jn_datetime*/ 
		

		
	
	
	
	
	
	

/* now see if this journal record is the latest and greatest.
*/

select  @jn_endtime = min(@jn_datetime) from Criteria_jn 
where 
[CriteriaID] = @CriteriaID
 and jn_datetime > @jn_datetime
if @jn_endtime is null
begin
set @jn_endtime = CAST(''2500-12-27 12:00:00.000''
  AS datetime)


	if @jn_operation = ''D''
	begin
		delete from Criteria
		where 
[CriteriaID] = @CriteriaID
end
else
begin
	
			update Criteria
			set 
   [CriteriaName]= @CriteriaName
,  [SurveyID]= @SurveyID
,  [CriteriaTypeID]= @CriteriaTypeID
,  [AnswerCategoryID]= @AnswerCategoryID
,  [CriteriaDataTypeID]= @CriteriaDataTypeID
,  [ParameterName]= @ParameterName
,  [TextValue]= @TextValue
,  [ReferenceCriteriaID]= @ReferenceCriteriaID
,  [ReferenceCriteriaSequence]= @ReferenceCriteriaSequence
,  [Flag]= @Flag
,  [Lvl]= @Lvl
,  [Hierarchy]= @Hierarchy
		where 
[CriteriaID] = @CriteriaID

		
		
		
		

		
		insert into Criteria (
 [CriteriaID]
,[CriteriaName]
,[SurveyID]
,[CriteriaTypeID]
,[AnswerCategoryID]
,[CriteriaDataTypeID]
,[ParameterName]
,[TextValue]
,[ReferenceCriteriaID]
,[ReferenceCriteriaSequence]
,[Flag]
,[Lvl]
,[Hierarchy]
)
		select 
 @CriteriaID
,@CriteriaName
,@SurveyID
,@CriteriaTypeID
,@AnswerCategoryID
,@CriteriaDataTypeID
,@ParameterName
,@TextValue
,@ReferenceCriteriaID
,@ReferenceCriteriaSequence
,@Flag
,@Lvl
,@Hierarchy
where not exists (Select ''x'' from Criteria where 
[CriteriaID] = @CriteriaID
)



end


end /* if we are the most recent record,  and therefore have to update the base tables */
	
	insert into Criteria_jn(jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [CriteriaID]
,[CriteriaName]
,[SurveyID]
,[CriteriaTypeID]
,[AnswerCategoryID]
,[CriteriaDataTypeID]
,[ParameterName]
,[TextValue]
,[ReferenceCriteriaID]
,[ReferenceCriteriaSequence]
,[Flag]
,[Lvl]
,[Hierarchy]
)
values (
@jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @CriteriaID
,@CriteriaName
,@SurveyID
,@CriteriaTypeID
,@AnswerCategoryID
,@CriteriaDataTypeID
,@ParameterName
,@TextValue
,@ReferenceCriteriaID
,@ReferenceCriteriaSequence
,@Flag
,@Lvl
,@Hierarchy
)

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @CriteriaID
,@CriteriaName
,@SurveyID
,@CriteriaTypeID
,@AnswerCategoryID
,@CriteriaDataTypeID
,@ParameterName
,@TextValue
,@ReferenceCriteriaID
,@ReferenceCriteriaSequence
,@Flag
,@Lvl
,@Hierarchy

end
close read_main
deallocate read_main

  print ''Criteria_jn DONE with '' + convert(varchar(10),@jn_loop_count) + '' last date  '' 
    + convert(varchar(100),@jn_datetime)
		
		end
	else if (@mode = 2)
		begin
	
	
	

		select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		from goliath.qms.dbo.Criteria_jn
		
		select @jn_maxdate = isnull(max(jn_datetime),''10-jun-1970'')
		from Criteria_jn
		
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
		print ''maxdate is '' + convert(varchar(20),@jn_maxdate)
		
		print ''deleting from production''
		/* If the row is in both tables,  we can delete it */
		delete a
		from goliath.qms.dbo.Criteria_jn  a,
		Criteria_jn  b
		where a.jn_datetime >= @jn_mindate
		and a.jn_datetime < @jn_maxdate
		and b.jn_datetime >= @jn_mindate
		and b.jn_datetime < @jn_maxdate
		and a.jn_datetime = b.jn_datetime
	        and 
     a.[CriteriaID]= b.[CriteriaID]
end
else if (@mode = 3)
begin
print ''doing a sync of the base tables and ignoring the journalls:''

print ''Step 1: sync deletes''



delete a
from Criteria a
where not exists (
select ''x''
from goliath.qms.dbo.Criteria b
where 
     a.[CriteriaID]= b.[CriteriaID]
)





print '' step 2: update ''

	update f 
	set 
   f.[CriteriaName]= a.[CriteriaName]
,  f.[SurveyID]= a.[SurveyID]
,  f.[CriteriaTypeID]= a.[CriteriaTypeID]
,  f.[AnswerCategoryID]= a.[AnswerCategoryID]
,  f.[CriteriaDataTypeID]= a.[CriteriaDataTypeID]
,  f.[ParameterName]= a.[ParameterName]
,  f.[TextValue]= a.[TextValue]
,  f.[ReferenceCriteriaID]= a.[ReferenceCriteriaID]
,  f.[ReferenceCriteriaSequence]= a.[ReferenceCriteriaSequence]
,  f.[Flag]= a.[Flag]
,  f.[Lvl]= a.[Lvl]
,  f.[Hierarchy]= a.[Hierarchy]
 from Criteria f,goliath.qms.dbo.Criteria a
	where 
     a.[CriteriaID]= f.[CriteriaID]
and (
  (a.[CriteriaName]  is null and f.[CriteriaName] is not null) or (a.[CriteriaName]  is not null and f.[CriteriaName] is null) or  (a.[CriteriaName] != f.[CriteriaName])
or  a.[SurveyID] != f.[SurveyID]
or  a.[CriteriaTypeID] != f.[CriteriaTypeID]
or (a.[AnswerCategoryID]  is null and f.[AnswerCategoryID] is not null) or (a.[AnswerCategoryID]  is not null and f.[AnswerCategoryID] is null) or  (a.[AnswerCategoryID] != f.[AnswerCategoryID])
or (a.[CriteriaDataTypeID]  is null and f.[CriteriaDataTypeID] is not null) or (a.[CriteriaDataTypeID]  is not null and f.[CriteriaDataTypeID] is null) or  (a.[CriteriaDataTypeID] != f.[CriteriaDataTypeID])
or (a.[ParameterName]  is null and f.[ParameterName] is not null) or (a.[ParameterName]  is not null and f.[ParameterName] is null) or  (a.[ParameterName] != f.[ParameterName])
or (a.[TextValue]  is null and f.[TextValue] is not null) or (a.[TextValue]  is not null and f.[TextValue] is null) or  (a.[TextValue] != f.[TextValue])
or (a.[ReferenceCriteriaID]  is null and f.[ReferenceCriteriaID] is not null) or (a.[ReferenceCriteriaID]  is not null and f.[ReferenceCriteriaID] is null) or  (a.[ReferenceCriteriaID] != f.[ReferenceCriteriaID])
or (a.[ReferenceCriteriaSequence]  is null and f.[ReferenceCriteriaSequence] is not null) or (a.[ReferenceCriteriaSequence]  is not null and f.[ReferenceCriteriaSequence] is null) or  (a.[ReferenceCriteriaSequence] != f.[ReferenceCriteriaSequence])
or  a.[Flag] != f.[Flag]
or (a.[Lvl]  is null and f.[Lvl] is not null) or (a.[Lvl]  is not null and f.[Lvl] is null) or  (a.[Lvl] != f.[Lvl])
or (a.[Hierarchy]  is null and f.[Hierarchy] is not null) or (a.[Hierarchy]  is not null and f.[Hierarchy] is null) or  (a.[Hierarchy] != f.[Hierarchy])
)
	
	
	

print '' Step 3: insert''
insert into Criteria(
 [CriteriaID]
,[CriteriaName]
,[SurveyID]
,[CriteriaTypeID]
,[AnswerCategoryID]
,[CriteriaDataTypeID]
,[ParameterName]
,[TextValue]
,[ReferenceCriteriaID]
,[ReferenceCriteriaSequence]
,[Flag]
,[Lvl]
,[Hierarchy]
)
select 
 a.[CriteriaID]
,a.[CriteriaName]
,a.[SurveyID]
,a.[CriteriaTypeID]
,a.[AnswerCategoryID]
,a.[CriteriaDataTypeID]
,a.[ParameterName]
,a.[TextValue]
,a.[ReferenceCriteriaID]
,a.[ReferenceCriteriaSequence]
,a.[Flag]
,a.[Lvl]
,a.[Hierarchy]
 from goliath.qms.dbo.Criteria a
where not exists (select ''x''
from  Criteria b
 where 
     a.[CriteriaID]= b.[CriteriaID]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from Criteria a
where not exists (
select ''x''
from goliath.qms.dbo.Criteria b
where 
     a.[CriteriaID]= b.[CriteriaID]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from Criteria f,goliath.qms.dbo.Criteria a
	where 
     a.[CriteriaID]= f.[CriteriaID]
and (
  (a.[CriteriaName]  is null and f.[CriteriaName] is not null) or (a.[CriteriaName]  is not null and f.[CriteriaName] is null) or  (a.[CriteriaName] != f.[CriteriaName])
or  a.[SurveyID] != f.[SurveyID]
or  a.[CriteriaTypeID] != f.[CriteriaTypeID]
or (a.[AnswerCategoryID]  is null and f.[AnswerCategoryID] is not null) or (a.[AnswerCategoryID]  is not null and f.[AnswerCategoryID] is null) or  (a.[AnswerCategoryID] != f.[AnswerCategoryID])
or (a.[CriteriaDataTypeID]  is null and f.[CriteriaDataTypeID] is not null) or (a.[CriteriaDataTypeID]  is not null and f.[CriteriaDataTypeID] is null) or  (a.[CriteriaDataTypeID] != f.[CriteriaDataTypeID])
or (a.[ParameterName]  is null and f.[ParameterName] is not null) or (a.[ParameterName]  is not null and f.[ParameterName] is null) or  (a.[ParameterName] != f.[ParameterName])
or (a.[TextValue]  is null and f.[TextValue] is not null) or (a.[TextValue]  is not null and f.[TextValue] is null) or  (a.[TextValue] != f.[TextValue])
or (a.[ReferenceCriteriaID]  is null and f.[ReferenceCriteriaID] is not null) or (a.[ReferenceCriteriaID]  is not null and f.[ReferenceCriteriaID] is null) or  (a.[ReferenceCriteriaID] != f.[ReferenceCriteriaID])
or (a.[ReferenceCriteriaSequence]  is null and f.[ReferenceCriteriaSequence] is not null) or (a.[ReferenceCriteriaSequence]  is not null and f.[ReferenceCriteriaSequence] is null) or  (a.[ReferenceCriteriaSequence] != f.[ReferenceCriteriaSequence])
or  a.[Flag] != f.[Flag]
or (a.[Lvl]  is null and f.[Lvl] is not null) or (a.[Lvl]  is not null and f.[Lvl] is null) or  (a.[Lvl] != f.[Lvl])
or (a.[Hierarchy]  is null and f.[Hierarchy] is not null) or (a.[Hierarchy]  is not null and f.[Hierarchy] is null) or  (a.[Hierarchy] != f.[Hierarchy])
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.Criteria a
where not exists (select ''x''
from  Criteria b
 where 
     a.[CriteriaID]= b.[CriteriaID]
)
end
else if (@mode = 5)
begin
print ''doing a verify of the journal tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from Criteria_jn a
where not exists (
select ''x''
from goliath.qms.dbo.Criteria_jn b
where 
     a.[CriteriaID]= b.[CriteriaID]
and a.jn_datetime = b.jn_datetime)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from Criteria_jn f,goliath.qms.dbo.Criteria_jn a
	where 
     a.[CriteriaID]= f.[CriteriaID]
and a.jn_datetime = f.jn_datetime and (
  (a.[CriteriaName]  is null and f.[CriteriaName] is not null) or (a.[CriteriaName]  is not null and f.[CriteriaName] is null) or  (a.[CriteriaName] != f.[CriteriaName])
or  a.[SurveyID] != f.[SurveyID]
or  a.[CriteriaTypeID] != f.[CriteriaTypeID]
or (a.[AnswerCategoryID]  is null and f.[AnswerCategoryID] is not null) or (a.[AnswerCategoryID]  is not null and f.[AnswerCategoryID] is null) or  (a.[AnswerCategoryID] != f.[AnswerCategoryID])
or (a.[CriteriaDataTypeID]  is null and f.[CriteriaDataTypeID] is not null) or (a.[CriteriaDataTypeID]  is not null and f.[CriteriaDataTypeID] is null) or  (a.[CriteriaDataTypeID] != f.[CriteriaDataTypeID])
or (a.[ParameterName]  is null and f.[ParameterName] is not null) or (a.[ParameterName]  is not null and f.[ParameterName] is null) or  (a.[ParameterName] != f.[ParameterName])
or (a.[TextValue]  is null and f.[TextValue] is not null) or (a.[TextValue]  is not null and f.[TextValue] is null) or  (a.[TextValue] != f.[TextValue])
or (a.[ReferenceCriteriaID]  is null and f.[ReferenceCriteriaID] is not null) or (a.[ReferenceCriteriaID]  is not null and f.[ReferenceCriteriaID] is null) or  (a.[ReferenceCriteriaID] != f.[ReferenceCriteriaID])
or (a.[ReferenceCriteriaSequence]  is null and f.[ReferenceCriteriaSequence] is not null) or (a.[ReferenceCriteriaSequence]  is not null and f.[ReferenceCriteriaSequence] is null) or  (a.[ReferenceCriteriaSequence] != f.[ReferenceCriteriaSequence])
or  a.[Flag] != f.[Flag]
or (a.[Lvl]  is null and f.[Lvl] is not null) or (a.[Lvl]  is not null and f.[Lvl] is null) or  (a.[Lvl] != f.[Lvl])
or (a.[Hierarchy]  is null and f.[Hierarchy] is not null) or (a.[Hierarchy]  is not null and f.[Hierarchy] is null) or  (a.[Hierarchy] != f.[Hierarchy])
 and
 f.jn_datetime != a.jn_datetime
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.Criteria_jn a
where not exists (select ''x''
from  Criteria_jn b
 where 
     a.[CriteriaID]= b.[CriteriaID]
 and a.jn_datetime = b.jn_datetime)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           Criteria done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
