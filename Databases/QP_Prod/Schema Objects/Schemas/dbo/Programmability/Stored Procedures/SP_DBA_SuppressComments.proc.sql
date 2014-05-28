Create Proc SP_DBA_SuppressComments @Cmnt_ID int = null, @StrLithoCode varchar(10) = null, @indebug bit =0
as

/*
--Test Code
--By cmnt_ID
SP_DBA_SuppressComments 32, null, 1

--by litho
SP_DBA_SuppressComments null, '17400', 1
*/

Declare @strCmntID varchar(5000)
Create table #CmntsToupdate (cmnt_ID int)

if @indebug = 1
begin
	print '@Cmnt_ID = ' + cast(@Cmnt_ID as varchar(100))
	print '@StrLithoCode = ' + cast(@StrLithoCode as varchar(100))
end

If @Cmnt_ID is not null
begin
	print 'Suppressing Comments Using passed in Cmnt_ID'
	
	Insert into #CmntsToupdate
	select @Cmnt_ID
end
else	

if @StrLithoCode is not null
begin

	print 'Suppressing Comments Using passed in Litho codes'

	insert into #CmntsToupdate
	select	c.cmnt_ID 
	from	QUESTIONFORM qf, SENTMAILING sm, comments c
	where	qf.SENTMAIL_ID = sm.SENTMAIL_ID and
			qf.QUESTIONFORM_ID = c.QuestionForm_id and
			SM.STRLITHOCODE = @StrLithoCode
end


update c
set bitSuppressed = 1
from comments c, #CmntsToupdate cu
where c.Cmnt_id = cu.cmnt_ID

--now call out to Medusa
set @strCmntID= ''
select @strCmntID = @strCmntID + cast(cmnt_ID as varchar(100)) + ','
from #CmntsToupdate

if @indebug = 1 print 'Calling SP_WA_Suppress_Comment_ByCmntID'
Exec Datamart.qp_comments.dbo.SP_WA_Suppress_Comment_ByCmntID @strCmntID, @indebug


