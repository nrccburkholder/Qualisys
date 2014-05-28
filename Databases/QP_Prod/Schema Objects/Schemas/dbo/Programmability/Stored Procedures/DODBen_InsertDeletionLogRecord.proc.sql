create Procedure DODBen_InsertDeletionLogRecord
	@study_id int,
	@Object varchar(42),
	@action varchar(42),
	@affectedRows int,
	@Error int,
	@ExpectedCount int = null
AS

declare @message varchar(8000), @FilePath varchar(255)

set @FilePath='c:\temp\DeletionLog.txt'
set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+','+@object+','+@action+','+
			convert(varchar,isnull(@affectedRows,0)) 

if @Error <> 0 
begin
	select @message= @message + ',' +'0' + ',' + description
	from master.dbo.sysmessages
	where error=@Error
		and msglangId=1033

	exec dbo.uspWriteToFile @FilePath, @message
end
else if @ExpectedCount is not null and @expectedCount<>@affectedRows
begin
	set @message= @message + ',' +'0' + ',' + 'Expected Row Count and actual do not match'
	exec dbo.uspWriteToFile @FilePath, @message
end
else
begin
	set @message= @message + ',' +'1' + ',' + 'Success'
	exec dbo.uspWriteToFile @FilePath, @message
end


