/****** Object:  StoredProcedure [dbo].[Questions_pn]    Script Date: 08/10/2006 16:40:37 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Questions_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Questions_pn]
GO
/****** Object:  StoredProcedure [dbo].[Questions_pn]    Script Date: 08/10/2006 16:40:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Questions_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure Questions_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       Questions
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           Questions''


declare @jn_operation varchar(1)
declare @jn_user varchar(100)
declare @jn_datetime datetime
declare @jn_endtime datetime 
declare @jn_notes varchar(240)
declare @jn_appln varchar(30)
declare @jn_session smallint
declare @QuestionID int
declare @QuestionFolderID int
declare @Text varchar(3000)
declare @ShortDesc varchar(100)
declare @QuestionTypeID int
declare @ItemOrder int

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
		  from Questions_jn
		  if @jn_mindate > dateadd(hour,-1,getdate())
			begin
			set @jn_mindate = dateadd(hour,-1,getdate())
			end
	  end
		else
		  begin
		  select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		  from goliath.qms.dbo.Questions_jn
		  end
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
	
declare read_main cursor for
select jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [QuestionID]
,[QuestionFolderID]
,[Text]
,[ShortDesc]
,[QuestionTypeID]
,[ItemOrder]
from goliath.qms.dbo.Questions_jl where jn_datetime >= @jn_mindate
open read_main
set @jn_loop_count=0

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @QuestionID
,@QuestionFolderID
,@Text
,@ShortDesc
,@QuestionTypeID
,@ItemOrder
while @@fetch_status=0
  begin

if (@jn_loop_count % 100) = 0
  begin
  print ''Questions_jn '' + convert(varchar(10),@jn_loop_count) + '' '' 
    + convert(varchar(100),@jn_datetime)
  end
set @jn_loop_count = @jn_loop_count + 1

	
		/* replace existing Questions_jn */
		delete 
		from Questions_jn
		where 
[QuestionID] = @QuestionID
           and jn_datetime = @jn_datetime
	
	

		/* now update the prior end date */
		update a
		set jn_endtime= (select min(jn_datetime)
           		from (select jn_datetime from Questions_jn b
			where 
     a.[QuestionID]= b.[QuestionID]
 and a.jn_datetime <= b.jn_datetime 
union all select @jn_datetime where @jn_datetime >= a.jn_datetime) c )
from Questions_jn a
where
a.[QuestionID] = @QuestionID
/*and a.jn_endtime> @jn_datetime*/ 
		

		
	
	
	
	
	
	

/* now see if this journal record is the latest and greatest.
*/

select  @jn_endtime = min(@jn_datetime) from Questions_jn 
where 
[QuestionID] = @QuestionID
 and jn_datetime > @jn_datetime
if @jn_endtime is null
begin
set @jn_endtime = CAST(''2500-12-27 12:00:00.000''
  AS datetime)


	if @jn_operation = ''D''
	begin
		delete from Questions
		where 
[QuestionID] = @QuestionID
end
else
begin
	
			update Questions
			set 
   [QuestionFolderID]= @QuestionFolderID
,  [Text]= @Text
,  [ShortDesc]= @ShortDesc
,  [QuestionTypeID]= @QuestionTypeID
,  [ItemOrder]= @ItemOrder
		where 
[QuestionID] = @QuestionID

		
		
		
		

		
		insert into Questions (
 [QuestionID]
,[QuestionFolderID]
,[Text]
,[ShortDesc]
,[QuestionTypeID]
,[ItemOrder]
)
		select 
 @QuestionID
,@QuestionFolderID
,@Text
,@ShortDesc
,@QuestionTypeID
,@ItemOrder
where not exists (Select ''x'' from Questions where 
[QuestionID] = @QuestionID
)



end


end /* if we are the most recent record,  and therefore have to update the base tables */
	
	insert into Questions_jn(jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [QuestionID]
,[QuestionFolderID]
,[Text]
,[ShortDesc]
,[QuestionTypeID]
,[ItemOrder]
)
values (
@jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @QuestionID
,@QuestionFolderID
,@Text
,@ShortDesc
,@QuestionTypeID
,@ItemOrder
)

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @QuestionID
,@QuestionFolderID
,@Text
,@ShortDesc
,@QuestionTypeID
,@ItemOrder

end
close read_main
deallocate read_main

  print ''Questions_jn DONE with '' + convert(varchar(10),@jn_loop_count) + '' last date  '' 
    + convert(varchar(100),@jn_datetime)
		
		end
	else if (@mode = 2)
		begin
	
	
	

		select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		from goliath.qms.dbo.Questions_jn
		
		select @jn_maxdate = isnull(max(jn_datetime),''10-jun-1970'')
		from Questions_jn
		
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
		print ''maxdate is '' + convert(varchar(20),@jn_maxdate)
		
		print ''deleting from production''
		/* If the row is in both tables,  we can delete it */
		delete a
		from goliath.qms.dbo.Questions_jn  a,
		Questions_jn  b
		where a.jn_datetime >= @jn_mindate
		and a.jn_datetime < @jn_maxdate
		and b.jn_datetime >= @jn_mindate
		and b.jn_datetime < @jn_maxdate
		and a.jn_datetime = b.jn_datetime
	        and 
     a.[QuestionID]= b.[QuestionID]
end
else if (@mode = 3)
begin
print ''doing a sync of the base tables and ignoring the journalls:''

print ''Step 1: sync deletes''



delete a
from Questions a
where not exists (
select ''x''
from goliath.qms.dbo.Questions b
where 
     a.[QuestionID]= b.[QuestionID]
)





print '' step 2: update ''

	update f 
	set 
   f.[QuestionFolderID]= a.[QuestionFolderID]
,  f.[Text]= a.[Text]
,  f.[ShortDesc]= a.[ShortDesc]
,  f.[QuestionTypeID]= a.[QuestionTypeID]
,  f.[ItemOrder]= a.[ItemOrder]
 from Questions f,goliath.qms.dbo.Questions a
	where 
     a.[QuestionID]= f.[QuestionID]
and (
   a.[QuestionFolderID] != f.[QuestionFolderID]
or  a.[Text] != f.[Text]
or (a.[ShortDesc]  is null and f.[ShortDesc] is not null) or (a.[ShortDesc]  is not null and f.[ShortDesc] is null) or  (a.[ShortDesc] != f.[ShortDesc])
or  a.[QuestionTypeID] != f.[QuestionTypeID]
or  a.[ItemOrder] != f.[ItemOrder]
)
	
	
	

print '' Step 3: insert''
insert into Questions(
 [QuestionID]
,[QuestionFolderID]
,[Text]
,[ShortDesc]
,[QuestionTypeID]
,[ItemOrder]
)
select 
 a.[QuestionID]
,a.[QuestionFolderID]
,a.[Text]
,a.[ShortDesc]
,a.[QuestionTypeID]
,a.[ItemOrder]
 from goliath.qms.dbo.Questions a
where not exists (select ''x''
from  Questions b
 where 
     a.[QuestionID]= b.[QuestionID]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from Questions a
where not exists (
select ''x''
from goliath.qms.dbo.Questions b
where 
     a.[QuestionID]= b.[QuestionID]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from Questions f,goliath.qms.dbo.Questions a
	where 
     a.[QuestionID]= f.[QuestionID]
and (
   a.[QuestionFolderID] != f.[QuestionFolderID]
or  a.[Text] != f.[Text]
or (a.[ShortDesc]  is null and f.[ShortDesc] is not null) or (a.[ShortDesc]  is not null and f.[ShortDesc] is null) or  (a.[ShortDesc] != f.[ShortDesc])
or  a.[QuestionTypeID] != f.[QuestionTypeID]
or  a.[ItemOrder] != f.[ItemOrder]
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.Questions a
where not exists (select ''x''
from  Questions b
 where 
     a.[QuestionID]= b.[QuestionID]
)
end
else if (@mode = 5)
begin
print ''doing a verify of the journal tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from Questions_jn a
where not exists (
select ''x''
from goliath.qms.dbo.Questions_jn b
where 
     a.[QuestionID]= b.[QuestionID]
and a.jn_datetime = b.jn_datetime)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from Questions_jn f,goliath.qms.dbo.Questions_jn a
	where 
     a.[QuestionID]= f.[QuestionID]
and a.jn_datetime = f.jn_datetime and (
   a.[QuestionFolderID] != f.[QuestionFolderID]
or  a.[Text] != f.[Text]
or (a.[ShortDesc]  is null and f.[ShortDesc] is not null) or (a.[ShortDesc]  is not null and f.[ShortDesc] is null) or  (a.[ShortDesc] != f.[ShortDesc])
or  a.[QuestionTypeID] != f.[QuestionTypeID]
or  a.[ItemOrder] != f.[ItemOrder]
 and
 f.jn_datetime != a.jn_datetime
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.Questions_jn a
where not exists (select ''x''
from  Questions_jn b
 where 
     a.[QuestionID]= b.[QuestionID]
 and a.jn_datetime = b.jn_datetime)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           Questions done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
