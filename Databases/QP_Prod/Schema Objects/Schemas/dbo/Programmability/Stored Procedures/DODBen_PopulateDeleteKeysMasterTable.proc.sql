create procedure DODBen_PopulateDeleteKeysMasterTable
	@study_id int
AS
declare @message varchar(8000), @FilePath varchar(255), @myError int, @myRowCount int
set @FilePath='c:\temp\DeletionLog.txt'

DELETE
FROM DeleteKeysMasterTable
WHERE study_id=@study_id
SELECT @myError = @@Error, @myRowCount=@@rowcount
IF @MyError<>0 return -1

INSERT INTO DeleteKeysMasterTable (Study_Id, KeyColumnName, Id)
SELECT @study_id, 'Table_id', Table_id
from dbo.METATABLE 
where study_id = @study_id
SELECT @myError = @@Error, @myRowCount=@@rowcount
IF @MyError<>0 
begin
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 0,''Error Inserting ID Values For Table_id'''
	exec dbo.uspWriteToFile @FilePath, @message
return -1
end
else
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 1,''Inserting ID Values For Table_id'''
	exec dbo.uspWriteToFile @FilePath, @message


INSERT INTO DeleteKeysMasterTable (Study_Id, KeyColumnName, Id)
SELECT @study_id, 'NUMLKUPTABLE_ID', Table_id
from dbo.METATABLE 
where study_id = @study_id
SELECT @myError = @@Error, @myRowCount=@@rowcount
IF @MyError<>0 
begin
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 0,''Error Inserting ID Values For NUMLKUPTABLE_ID'''
	exec dbo.uspWriteToFile @FilePath, @message
return -1
end
else
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 1,''Inserting ID Values For NUMLKUPTABLE_ID'''
	exec dbo.uspWriteToFile @FilePath, @message

INSERT INTO DeleteKeysMasterTable (Study_Id, KeyColumnName, Id)
SELECT @study_id, 'NUMMASTERTABLE_ID', Table_id
from dbo.METATABLE 
where study_id = @study_id
SELECT @myError = @@Error, @myRowCount=@@rowcount
IF @MyError<>0 
begin
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 0,''Error Inserting ID Values For NUMMASTERTABLE_ID'''
	exec dbo.uspWriteToFile @FilePath, @message
return -1
end
else
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 1,''Inserting ID Values For NUMMASTERTABLE_ID'''
	exec dbo.uspWriteToFile @FilePath, @message

INSERT INTO DeleteKeysMasterTable (Study_Id, KeyColumnName, Id)
SELECT @study_id, 'CRITERIASTMT_ID', CRITERIASTMT_ID
from dbo.CRITERIASTMT 
where study_id = @study_id
SELECT @myError = @@Error, @myRowCount=@@rowcount
IF @MyError<>0 
begin
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 0,''Error Inserting ID Values For CRITERIASTMT_ID'''
	exec dbo.uspWriteToFile @FilePath, @message
return -1
end
else
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 1,''Inserting ID Values For CRITERIASTMT_ID'''
	exec dbo.uspWriteToFile @FilePath, @message

INSERT INTO DeleteKeysMasterTable (Study_Id, KeyColumnName, Id)
SELECT @study_id, 'criteriaclause_id', criteriaclause_id
from dbo.CRITERIACLAUSE cc, dbo.CRITERIASTMT MT
where mt.study_id = @study_id
	and cc.CRITERIASTMT_id=mt.CRITERIASTMT_id
SELECT @myError = @@Error, @myRowCount=@@rowcount
IF @MyError<>0 
begin
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 0,''Error Inserting ID Values For criteriaclause_id'''
	exec dbo.uspWriteToFile @FilePath, @message
return -1
end
else
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 1,''Inserting ID Values For criteriaclause_id'''
	exec dbo.uspWriteToFile @FilePath, @message

INSERT INTO DeleteKeysMasterTable (Study_Id, KeyColumnName, Id)
SELECT @study_id, 'DATASET_ID', DATASET_ID
from dbo.DATA_SET
where study_id = @study_id
SELECT @myError = @@Error, @myRowCount=@@rowcount
IF @MyError<>0 
begin
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 0,''Error Inserting ID Values For DATASET_ID'''
	exec dbo.uspWriteToFile @FilePath, @message
return -1
end
else
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 1,''Inserting ID Values For DATASET_ID'''
	exec dbo.uspWriteToFile @FilePath, @message

INSERT INTO DeleteKeysMasterTable (Study_Id, KeyColumnName, Id)
SELECT @study_id, 'cmnt_id', cm.cmnt_id
from dbo.QDECOMMENTS CM, dbo.sampleunit su, dbo.sampleplan ss, dbo.survey_def sd
where cm.sampleunit_id=su.sampleunit_id
	and ss.survey_id=sd.survey_id
	and su.sampleplan_id=ss.sampleplan_id
	and sd.study_id = @study_id
SELECT @myError = @@Error, @myRowCount=@@rowcount
IF @MyError<>0 
begin
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 0,''Error Inserting ID Values For cmnt_id'''
	exec dbo.uspWriteToFile @FilePath, @message
return -1
end
else
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 1,''Inserting ID Values For cmnt_id'''
	exec dbo.uspWriteToFile @FilePath, @message

INSERT INTO DeleteKeysMasterTable (Study_Id, KeyColumnName, Id)
SELECT @study_id, 'PeriodDef_id', PeriodDef_id
FROM Survey_def sd, PeriodDef pd
WHERE sd.survey_id=pd.survey_id
	and study_id = @study_id
SELECT @myError = @@Error, @myRowCount=@@rowcount
IF @MyError<>0 
begin
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 0,''Error Inserting ID Values For PeriodDef_id'''
	exec dbo.uspWriteToFile @FilePath, @message
return -1
end
else
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 1,''Inserting ID Values For PeriodDef_id'''
	exec dbo.uspWriteToFile @FilePath, @message

INSERT INTO DeleteKeysMasterTable (Study_Id, KeyColumnName, Id)
SELECT @study_id, 'Questionform_id', Questionform_id
from dbo.questionform qf, dbo.survey_def s
where s.survey_id = qf.survey_id
and s.study_id = @study_id
SELECT @myError = @@Error, @myRowCount=@@rowcount
IF @MyError<>0 
begin
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 0,''Error Inserting ID Values For Questionform_id'''
	exec dbo.uspWriteToFile @FilePath, @message
return -1
end
else
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 1,''Inserting ID Values For Questionform_id'''
	exec dbo.uspWriteToFile @FilePath, @message

INSERT INTO DeleteKeysMasterTable (Study_Id, KeyColumnName, Id)
SELECT @study_id, 'samplepop_id', samplepop_id
from dbo.samplepop 
where study_id = @study_id
SELECT @myError = @@Error, @myRowCount=@@rowcount
IF @MyError<>0 
begin
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 0,''Error Inserting ID Values For samplepop_id'''
	exec dbo.uspWriteToFile @FilePath, @message
return -1
end
else
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 1,''Inserting ID Values For samplepop_id'''
	exec dbo.uspWriteToFile @FilePath, @message

INSERT INTO DeleteKeysMasterTable (Study_Id, KeyColumnName, Id)
SELECT @study_id, 'SAMPLESET_ID', SAMPLESET_ID
from dbo.sampleset ss, dbo.survey_def sd
where ss.survey_id=sd.survey_id
and sd.study_id = @study_id
SELECT @myError = @@Error, @myRowCount=@@rowcount
IF @MyError<>0 
begin
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 0,''Error Inserting ID Values For SAMPLESET_ID'''
	exec dbo.uspWriteToFile @FilePath, @message
return -1
end
else
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 1,''Inserting ID Values For SAMPLESET_ID'''
	exec dbo.uspWriteToFile @FilePath, @message

INSERT INTO DeleteKeysMasterTable (Study_Id, KeyColumnName, Id)
SELECT @study_id, 'SampleUnit_id', SampleUnit_id
from dbo.sampleunit su, dbo.sampleplan ss, dbo.survey_def sd
where ss.survey_id=sd.survey_id
and su.sampleplan_id=ss.sampleplan_id
and sd.study_id = @study_id
SELECT @myError = @@Error, @myRowCount=@@rowcount
IF @MyError<>0 
begin
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 0,''Error Inserting ID Values For SampleUnit_id'''
	exec dbo.uspWriteToFile @FilePath, @message
return -1
end
else
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 1,''Inserting ID Values For SampleUnit_id'''
	exec dbo.uspWriteToFile @FilePath, @message

INSERT INTO DeleteKeysMasterTable (Study_Id, KeyColumnName, Id)
SELECT @study_id, 'ScheduledMailing_id', ScheduledMailing_id
from dbo.scheduledmailing scm, dbo.mailingmethodology mm, dbo.survey_def s
where s.survey_id = mm.survey_id and mm.methodology_id = scm.methodology_id
and s.study_id = @study_id
SELECT @myError = @@Error, @myRowCount=@@rowcount
IF @MyError<>0 
begin
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 0,''Error Inserting ID Values For ScheduledMailing_id'''
	exec dbo.uspWriteToFile @FilePath, @message
return -1
end
else
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 1,''Inserting ID Values For ScheduledMailing_id'''
	exec dbo.uspWriteToFile @FilePath, @message

INSERT INTO DeleteKeysMasterTable (Study_Id, KeyColumnName, Id)
SELECT @study_id, 'SENTMAIL_ID', sm.SENTMAIL_ID
from dbo.sentmailing sm, scheduledmailing scm, dbo.mailingmethodology mm, dbo.survey_def s
where s.survey_id = mm.survey_id 
	and mm.methodology_id = scm.methodology_id and
	sm.sentmail_id=scm.sentmail_id
	and s.study_id = @study_id
SELECT @myError = @@Error, @myRowCount=@@rowcount
IF @MyError<>0 
begin
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 0,''Error Inserting ID Values For SENTMAIL_ID'''
	exec dbo.uspWriteToFile @FilePath, @message
return -1
end
else
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 1,''Inserting ID Values For SENTMAIL_ID'''
	exec dbo.uspWriteToFile @FilePath, @message

INSERT INTO DeleteKeysMasterTable (Study_Id, KeyColumnName, Id)
SELECT @study_id, 'strLithoCode', strLithoCode
from dbo.sentmailing sm, scheduledmailing scm, dbo.mailingmethodology mm, dbo.survey_def s
where s.survey_id = mm.survey_id 
	and mm.methodology_id = scm.methodology_id and
	sm.sentmail_id=scm.sentmail_id
	and s.study_id = @study_id
	and strLithoCode is not null
SELECT @myError = @@Error, @myRowCount=@@rowcount
IF @MyError<>0 
begin
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 0,''Error Inserting ID Values For strLithoCode'''
	exec dbo.uspWriteToFile @FilePath, @message
return -1
end
else
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 1,''Inserting ID Values For strLithoCode'''
	exec dbo.uspWriteToFile @FilePath, @message

INSERT INTO DeleteKeysMasterTable (Study_Id, KeyColumnName, Id)
SELECT @study_id, 'SURVEY_ID', SURVEY_ID
FROM Survey_def
WHERE study_id=@study_id
SELECT @myError = @@Error, @myRowCount=@@rowcount
IF @MyError<>0 
begin
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 0,''Error Inserting ID Values For SURVEY_ID'''
	exec dbo.uspWriteToFile @FilePath, @message
return -1
end
else
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 1,''Inserting ID Values For SURVEY_ID'''
	exec dbo.uspWriteToFile @FilePath, @message

INSERT INTO DeleteKeysMasterTable (Study_Id, KeyColumnName, Id)
SELECT @study_id, 'STUDY_ID', @study_id
SELECT @myError = @@Error, @myRowCount=@@rowcount
IF @MyError<>0 
begin
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 0,''Error Inserting ID Values For STUDY_ID'''
	exec dbo.uspWriteToFile @FilePath, @message
return -1
end
else
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,' 
		+ convert(varchar,@myrowcount) + ', 1,''Inserting ID Values For STUDY_ID'''
	exec dbo.uspWriteToFile @FilePath, @message


