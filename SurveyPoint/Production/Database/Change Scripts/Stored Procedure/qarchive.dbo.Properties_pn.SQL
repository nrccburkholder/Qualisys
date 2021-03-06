/****** Object:  StoredProcedure [dbo].[Properties_pn]    Script Date: 08/10/2006 16:42:19 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Properties_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Properties_pn]
GO
/****** Object:  StoredProcedure [dbo].[Properties_pn]    Script Date: 08/10/2006 16:42:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Properties_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure Properties_pn(@mode int) /* 0 - full, 1 - incremental , 2 - delete from old system
Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.


Table:       Properties
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           Properties''


declare @jn_operation varchar(1)
declare @jn_user varchar(100)
declare @jn_datetime datetime
declare @jn_endtime datetime 
declare @jn_notes varchar(240)
declare @jn_appln varchar(30)
declare @jn_session smallint
declare @PropertyName varchar(100)
declare @PropertyLevel tinyint
declare @DefaultDescription varchar(1000)
declare @notes varchar(1000)

	declare @jn_mindate datetime
	declare @jn_maxdate datetime
	declare @jn_loop_count int
	
	
	if (@mode != 2)
	  begin
	  set nocount on
		if (@mode = 1) 
		  begin
		  /* This mindate will not look at the production server
		  The other mindate will */
		  select @jn_mindate = isnull(max(jn_datetime),''10-jun-1970'')
		  from Properties_jn
		  if @jn_mindate > dateadd(day,-3,getdate())
			begin
			set @jn_mindate = dateadd(day,-3,getdate())
			end
	  end
		else
		  begin
		  select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		  from goliath.qms.dbo.Properties_jn
		  end
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
	
declare read_main cursor for
select jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [PropertyName]
,[PropertyLevel]
,[DefaultDescription]
,[notes]
from goliath.qms.dbo.Properties_jn where jn_datetime >= @jn_mindate
order by jn_datetime
open read_main
set @jn_loop_count=0

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @PropertyName
,@PropertyLevel
,@DefaultDescription
,@notes
while @@fetch_status=0
  begin

if (@jn_loop_count % 100) = 0
  begin
  print ''Properties_jn '' + convert(varchar(10),@jn_loop_count) + '' '' 
    + convert(varchar(100),@jn_datetime)
  end
set @jn_loop_count = @jn_loop_count + 1

	
		/* replace existing Properties_jn */
		delete 
		from Properties_jn
		where 
[PropertyName] = @PropertyName
           and jn_datetime = @jn_datetime
	
	

		/* now update the prior end date */
		update Properties_jn
		set jn_endtime= @jn_datetime
		where 
[PropertyName] = @PropertyName
	and jn_endtime > @jn_datetime
		and jn_datetime <= @jn_datetime
		
		
	
	
	
	
	
	
	

	if @jn_operation = ''D''
	begin
		delete from Properties
		where 
[PropertyName] = @PropertyName
end
else
begin
	
			update Properties
			set 
   [PropertyLevel]= @PropertyLevel
,  [DefaultDescription]= @DefaultDescription
,  [notes]= @notes
		where 
[PropertyName] = @PropertyName

		
		
		
		

		
		insert into Properties (
 [PropertyName]
,[PropertyLevel]
,[DefaultDescription]
,[notes]
)
		select 
 @PropertyName
,@PropertyLevel
,@DefaultDescription
,@notes
where not exists (Select ''x'' from Properties where 
[PropertyName] = @PropertyName
)



end
	
	insert into Properties_jn(jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [PropertyName]
,[PropertyLevel]
,[DefaultDescription]
,[notes]
)
values (
@jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @PropertyName
,@PropertyLevel
,@DefaultDescription
,@notes
)

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @PropertyName
,@PropertyLevel
,@DefaultDescription
,@notes

end
close read_main
deallocate read_main

  print ''Properties_jn DONE with '' + convert(varchar(10),@jn_loop_count) + '' last date  '' 
    + convert(varchar(100),@jn_datetime)
		
		end
	else
		begin
	
	
	

		select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		from goliath.qms.dbo.Properties_jn
		
		select @jn_maxdate = isnull(dateadd(day,-2,max(jn_datetime)),''10-jun-1970'')
		from Properties_jn
		
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
		print ''maxdate is '' + convert(varchar(20),@jn_maxdate)
		
		print ''deleting from production''
		/* If the row is in both tables,  we can delete it */
		delete a
		from goliath.qms.dbo.Properties_jn  a,
		Properties_jn  b
		where a.jn_datetime >= @jn_mindate
		and a.jn_datetime < @jn_maxdate
		and b.jn_datetime >= @jn_mindate
		and b.jn_datetime < @jn_maxdate
		and a.jn_datetime = b.jn_datetime
	        and 
     a.[PropertyName]= b.[PropertyName]
end

print ''           Properties done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
