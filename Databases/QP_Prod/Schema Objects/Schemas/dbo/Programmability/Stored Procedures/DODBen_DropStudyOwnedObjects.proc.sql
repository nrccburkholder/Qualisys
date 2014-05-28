create procedure DODBen_DropStudyOwnedObjects
 @study_id int
AS
 declare @strstudy_id varchar(10),
  @studyuser_nm varchar(32),
  @tblnm varchar(100), 
  @strsql varchar(20),
  @myError int,
  @message varchar(8000), 
  @FilePath varchar(255)

set @FilePath='c:\temp\DeletionLog.txt'

 set @strstudy_id = convert(varchar(10),@study_id)
 set @studyuser_nm = 'S' + @strstudy_id

 declare styobjs cursor for
  select name from dbo.sysobjects
  where uid = user_id (@studyuser_nm)
  and type = 'U'
 declare stydrps cursor for
  select case type 
    when 'U' then 'DROP TABLE' 
    when 'V' then 'DROP VIEW'
   end, name
  from dbo.sysobjects
  where uid = user_id (@studyuser_nm)
  and type in ('U','V')

/* Drop the study tables & views */
  open stydrps
  fetch stydrps into @strsql, @tblnm
  while @@fetch_status = 0
  begin
   execute (@strsql + ' ' + @studyuser_nm + '.' + @tblnm)
   select @myError=@@error
   if @myError <> 0
	begin
		set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',''' + @tblnm +''',drop,null,0,''Error'''
		exec dbo.uspWriteToFile @FilePath, @message
		goto errexit
	end
   else 
	begin
		set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',''' + @tblnm +''',drop,null,1,''Success'''
		exec dbo.uspWriteToFile @FilePath, @message
	end
   fetch stydrps into @strsql, @tblnm
  end
  close stydrps
errexit:
 deallocate styobjs
 deallocate stydrps
completed:


