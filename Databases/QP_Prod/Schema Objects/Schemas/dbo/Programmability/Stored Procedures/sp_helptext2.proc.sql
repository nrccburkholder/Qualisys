create proc sp_helptext2
@proc_name varchar(4000)
as
SELECT text
FROM syscomments
WHERE OBJECT_NAME(id) = @proc_name


