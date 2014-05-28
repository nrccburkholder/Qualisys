create procedure DODBen_DeleteNonConstraintBoundTable
	@study_id int,
	@KeyColumnName varchar(42),
	@TableName varchar(42)
AS
declare @sql varchar(4000)

IF OBJECT_ID(@TableName, 'U') IS NOT NULL
  Begin
	set @sql=''
	print @sql
	exec(@sql)
  END


