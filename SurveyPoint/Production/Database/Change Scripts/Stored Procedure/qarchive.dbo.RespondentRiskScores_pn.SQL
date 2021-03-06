/****** Object:  StoredProcedure [dbo].[RespondentRiskScores_pn]    Script Date: 08/10/2006 16:39:38 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[RespondentRiskScores_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[RespondentRiskScores_pn]
GO
/****** Object:  StoredProcedure [dbo].[RespondentRiskScores_pn]    Script Date: 08/10/2006 16:39:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[RespondentRiskScores_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure RespondentRiskScores_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       RespondentRiskScores
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           RespondentRiskScores''


declare @jn_operation varchar(1)
declare @jn_user varchar(100)
declare @jn_datetime datetime
declare @jn_endtime datetime 
declare @jn_notes varchar(240)
declare @jn_appln varchar(30)
declare @jn_session smallint
declare @respondentID int
declare @a int
declare @b int
declare @c int
declare @d int
declare @e int
declare @f int
declare @g int
declare @h int
declare @noncontrib int
declare @other int
declare @none int
declare @predicted_expenditure float

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
		  from RespondentRiskScores_jn
		  if @jn_mindate > dateadd(hour,-1,getdate())
			begin
			set @jn_mindate = dateadd(hour,-1,getdate())
			end
	  end
		else
		  begin
		  select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		  from goliath.qms.dbo.RespondentRiskScores_jn
		  end
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
	
declare read_main cursor for
select jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [respondentID]
,[a]
,[b]
,[c]
,[d]
,[e]
,[f]
,[g]
,[h]
,[noncontrib]
,[other]
,[none]
,[predicted_expenditure]
from goliath.qms.dbo.RespondentRiskScores_jl where jn_datetime >= @jn_mindate
open read_main
set @jn_loop_count=0

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @respondentID
,@a
,@b
,@c
,@d
,@e
,@f
,@g
,@h
,@noncontrib
,@other
,@none
,@predicted_expenditure
while @@fetch_status=0
  begin

if (@jn_loop_count % 100) = 0
  begin
  print ''RespondentRiskScores_jn '' + convert(varchar(10),@jn_loop_count) + '' '' 
    + convert(varchar(100),@jn_datetime)
  end
set @jn_loop_count = @jn_loop_count + 1

	
		/* replace existing RespondentRiskScores_jn */
		delete 
		from RespondentRiskScores_jn
		where 
[respondentID] = @respondentID
           and jn_datetime = @jn_datetime
	
	

		/* now update the prior end date */
		update a
		set jn_endtime= (select min(jn_datetime)
           		from (select jn_datetime from RespondentRiskScores_jn b
			where 
     a.[respondentID]= b.[respondentID]
 and a.jn_datetime <= b.jn_datetime 
union all select @jn_datetime where @jn_datetime >= a.jn_datetime) c )
from RespondentRiskScores_jn a
where
a.[respondentID] = @respondentID
/*and a.jn_endtime> @jn_datetime*/ 
		

		
	
	
	
	
	
	

/* now see if this journal record is the latest and greatest.
*/

select  @jn_endtime = min(@jn_datetime) from RespondentRiskScores_jn 
where 
[respondentID] = @respondentID
 and jn_datetime > @jn_datetime
if @jn_endtime is null
begin
set @jn_endtime = CAST(''2500-12-27 12:00:00.000''
  AS datetime)


	if @jn_operation = ''D''
	begin
		delete from RespondentRiskScores
		where 
[respondentID] = @respondentID
end
else
begin
	
			update RespondentRiskScores
			set 
   [a]= @a
,  [b]= @b
,  [c]= @c
,  [d]= @d
,  [e]= @e
,  [f]= @f
,  [g]= @g
,  [h]= @h
,  [noncontrib]= @noncontrib
,  [other]= @other
,  [none]= @none
,  [predicted_expenditure]= @predicted_expenditure
		where 
[respondentID] = @respondentID

		
		
		
		

		
		insert into RespondentRiskScores (
 [respondentID]
,[a]
,[b]
,[c]
,[d]
,[e]
,[f]
,[g]
,[h]
,[noncontrib]
,[other]
,[none]
,[predicted_expenditure]
)
		select 
 @respondentID
,@a
,@b
,@c
,@d
,@e
,@f
,@g
,@h
,@noncontrib
,@other
,@none
,@predicted_expenditure
where not exists (Select ''x'' from RespondentRiskScores where 
[respondentID] = @respondentID
)



end


end /* if we are the most recent record,  and therefore have to update the base tables */
	
	insert into RespondentRiskScores_jn(jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [respondentID]
,[a]
,[b]
,[c]
,[d]
,[e]
,[f]
,[g]
,[h]
,[noncontrib]
,[other]
,[none]
,[predicted_expenditure]
)
values (
@jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @respondentID
,@a
,@b
,@c
,@d
,@e
,@f
,@g
,@h
,@noncontrib
,@other
,@none
,@predicted_expenditure
)

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @respondentID
,@a
,@b
,@c
,@d
,@e
,@f
,@g
,@h
,@noncontrib
,@other
,@none
,@predicted_expenditure

end
close read_main
deallocate read_main

  print ''RespondentRiskScores_jn DONE with '' + convert(varchar(10),@jn_loop_count) + '' last date  '' 
    + convert(varchar(100),@jn_datetime)
		
		end
	else if (@mode = 2)
		begin
	
	
	

		select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		from goliath.qms.dbo.RespondentRiskScores_jn
		
		select @jn_maxdate = isnull(max(jn_datetime),''10-jun-1970'')
		from RespondentRiskScores_jn
		
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
		print ''maxdate is '' + convert(varchar(20),@jn_maxdate)
		
		print ''deleting from production''
		/* If the row is in both tables,  we can delete it */
		delete a
		from goliath.qms.dbo.RespondentRiskScores_jn  a,
		RespondentRiskScores_jn  b
		where a.jn_datetime >= @jn_mindate
		and a.jn_datetime < @jn_maxdate
		and b.jn_datetime >= @jn_mindate
		and b.jn_datetime < @jn_maxdate
		and a.jn_datetime = b.jn_datetime
	        and 
     a.[respondentID]= b.[respondentID]
end
else if (@mode = 3)
begin
print ''doing a sync of the base tables and ignoring the journalls:''

print ''Step 1: sync deletes''



delete a
from RespondentRiskScores a
where not exists (
select ''x''
from goliath.qms.dbo.RespondentRiskScores b
where 
     a.[respondentID]= b.[respondentID]
)





print '' step 2: update ''

	update f 
	set 
   f.[a]= a.[a]
,  f.[b]= a.[b]
,  f.[c]= a.[c]
,  f.[d]= a.[d]
,  f.[e]= a.[e]
,  f.[f]= a.[f]
,  f.[g]= a.[g]
,  f.[h]= a.[h]
,  f.[noncontrib]= a.[noncontrib]
,  f.[other]= a.[other]
,  f.[none]= a.[none]
,  f.[predicted_expenditure]= a.[predicted_expenditure]
 from RespondentRiskScores f,goliath.qms.dbo.RespondentRiskScores a
	where 
     a.[respondentID]= f.[respondentID]
and (
  (a.[a]  is null and f.[a] is not null) or (a.[a]  is not null and f.[a] is null) or  (a.[a] != f.[a])
or (a.[b]  is null and f.[b] is not null) or (a.[b]  is not null and f.[b] is null) or  (a.[b] != f.[b])
or (a.[c]  is null and f.[c] is not null) or (a.[c]  is not null and f.[c] is null) or  (a.[c] != f.[c])
or (a.[d]  is null and f.[d] is not null) or (a.[d]  is not null and f.[d] is null) or  (a.[d] != f.[d])
or (a.[e]  is null and f.[e] is not null) or (a.[e]  is not null and f.[e] is null) or  (a.[e] != f.[e])
or (a.[f]  is null and f.[f] is not null) or (a.[f]  is not null and f.[f] is null) or  (a.[f] != f.[f])
or (a.[g]  is null and f.[g] is not null) or (a.[g]  is not null and f.[g] is null) or  (a.[g] != f.[g])
or (a.[h]  is null and f.[h] is not null) or (a.[h]  is not null and f.[h] is null) or  (a.[h] != f.[h])
or (a.[noncontrib]  is null and f.[noncontrib] is not null) or (a.[noncontrib]  is not null and f.[noncontrib] is null) or  (a.[noncontrib] != f.[noncontrib])
or (a.[other]  is null and f.[other] is not null) or (a.[other]  is not null and f.[other] is null) or  (a.[other] != f.[other])
or (a.[none]  is null and f.[none] is not null) or (a.[none]  is not null and f.[none] is null) or  (a.[none] != f.[none])
or (a.[predicted_expenditure]  is null and f.[predicted_expenditure] is not null) or (a.[predicted_expenditure]  is not null and f.[predicted_expenditure] is null) or  (a.[predicted_expenditure] != f.[predicted_expenditure])
)
	
	
	

print '' Step 3: insert''
insert into RespondentRiskScores(
 [respondentID]
,[a]
,[b]
,[c]
,[d]
,[e]
,[f]
,[g]
,[h]
,[noncontrib]
,[other]
,[none]
,[predicted_expenditure]
)
select 
 a.[respondentID]
,a.[a]
,a.[b]
,a.[c]
,a.[d]
,a.[e]
,a.[f]
,a.[g]
,a.[h]
,a.[noncontrib]
,a.[other]
,a.[none]
,a.[predicted_expenditure]
 from goliath.qms.dbo.RespondentRiskScores a
where not exists (select ''x''
from  RespondentRiskScores b
 where 
     a.[respondentID]= b.[respondentID]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from RespondentRiskScores a
where not exists (
select ''x''
from goliath.qms.dbo.RespondentRiskScores b
where 
     a.[respondentID]= b.[respondentID]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from RespondentRiskScores f,goliath.qms.dbo.RespondentRiskScores a
	where 
     a.[respondentID]= f.[respondentID]
and (
  (a.[a]  is null and f.[a] is not null) or (a.[a]  is not null and f.[a] is null) or  (a.[a] != f.[a])
or (a.[b]  is null and f.[b] is not null) or (a.[b]  is not null and f.[b] is null) or  (a.[b] != f.[b])
or (a.[c]  is null and f.[c] is not null) or (a.[c]  is not null and f.[c] is null) or  (a.[c] != f.[c])
or (a.[d]  is null and f.[d] is not null) or (a.[d]  is not null and f.[d] is null) or  (a.[d] != f.[d])
or (a.[e]  is null and f.[e] is not null) or (a.[e]  is not null and f.[e] is null) or  (a.[e] != f.[e])
or (a.[f]  is null and f.[f] is not null) or (a.[f]  is not null and f.[f] is null) or  (a.[f] != f.[f])
or (a.[g]  is null and f.[g] is not null) or (a.[g]  is not null and f.[g] is null) or  (a.[g] != f.[g])
or (a.[h]  is null and f.[h] is not null) or (a.[h]  is not null and f.[h] is null) or  (a.[h] != f.[h])
or (a.[noncontrib]  is null and f.[noncontrib] is not null) or (a.[noncontrib]  is not null and f.[noncontrib] is null) or  (a.[noncontrib] != f.[noncontrib])
or (a.[other]  is null and f.[other] is not null) or (a.[other]  is not null and f.[other] is null) or  (a.[other] != f.[other])
or (a.[none]  is null and f.[none] is not null) or (a.[none]  is not null and f.[none] is null) or  (a.[none] != f.[none])
or (a.[predicted_expenditure]  is null and f.[predicted_expenditure] is not null) or (a.[predicted_expenditure]  is not null and f.[predicted_expenditure] is null) or  (a.[predicted_expenditure] != f.[predicted_expenditure])
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.RespondentRiskScores a
where not exists (select ''x''
from  RespondentRiskScores b
 where 
     a.[respondentID]= b.[respondentID]
)
end
else if (@mode = 5)
begin
print ''doing a verify of the journal tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from RespondentRiskScores_jn a
where not exists (
select ''x''
from goliath.qms.dbo.RespondentRiskScores_jn b
where 
     a.[respondentID]= b.[respondentID]
and a.jn_datetime = b.jn_datetime)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from RespondentRiskScores_jn f,goliath.qms.dbo.RespondentRiskScores_jn a
	where 
     a.[respondentID]= f.[respondentID]
and a.jn_datetime = f.jn_datetime and (
  (a.[a]  is null and f.[a] is not null) or (a.[a]  is not null and f.[a] is null) or  (a.[a] != f.[a])
or (a.[b]  is null and f.[b] is not null) or (a.[b]  is not null and f.[b] is null) or  (a.[b] != f.[b])
or (a.[c]  is null and f.[c] is not null) or (a.[c]  is not null and f.[c] is null) or  (a.[c] != f.[c])
or (a.[d]  is null and f.[d] is not null) or (a.[d]  is not null and f.[d] is null) or  (a.[d] != f.[d])
or (a.[e]  is null and f.[e] is not null) or (a.[e]  is not null and f.[e] is null) or  (a.[e] != f.[e])
or (a.[f]  is null and f.[f] is not null) or (a.[f]  is not null and f.[f] is null) or  (a.[f] != f.[f])
or (a.[g]  is null and f.[g] is not null) or (a.[g]  is not null and f.[g] is null) or  (a.[g] != f.[g])
or (a.[h]  is null and f.[h] is not null) or (a.[h]  is not null and f.[h] is null) or  (a.[h] != f.[h])
or (a.[noncontrib]  is null and f.[noncontrib] is not null) or (a.[noncontrib]  is not null and f.[noncontrib] is null) or  (a.[noncontrib] != f.[noncontrib])
or (a.[other]  is null and f.[other] is not null) or (a.[other]  is not null and f.[other] is null) or  (a.[other] != f.[other])
or (a.[none]  is null and f.[none] is not null) or (a.[none]  is not null and f.[none] is null) or  (a.[none] != f.[none])
or (a.[predicted_expenditure]  is null and f.[predicted_expenditure] is not null) or (a.[predicted_expenditure]  is not null and f.[predicted_expenditure] is null) or  (a.[predicted_expenditure] != f.[predicted_expenditure])
 and
 f.jn_datetime != a.jn_datetime
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.RespondentRiskScores_jn a
where not exists (select ''x''
from  RespondentRiskScores_jn b
 where 
     a.[respondentID]= b.[respondentID]
 and a.jn_datetime = b.jn_datetime)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           RespondentRiskScores done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
