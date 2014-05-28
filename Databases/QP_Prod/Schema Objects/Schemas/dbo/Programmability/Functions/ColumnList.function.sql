--Returns a comma delimited list of the columns
CREATE FUNCTION dbo.ColumnList (@TableName VARCHAR(100)) 
RETURNS VARCHAR(8000) AS
BEGIN

DECLARE @List VARCHAR(8000), @TableSchema VARCHAR(20)

SET @List=''

IF CHARINDEX('.',@TableName)=0
BEGIN

SELECT @TableSchema='dbo'

END
ELSE
BEGIN

SET @TableSchema=SUBSTRING(@TableName,1,CHARINDEX('.',@TableName)-1)
SET @TableName=SUBSTRING(@TableName,CHARINDEX('.',@TableName)+1,8000)

END

IF NOT EXISTS (SELECT *
	FROM Information_Schema.Columns 
	WHERE Table_Name=@TableName
	AND Table_Schema=@Tableschema)
BEGIN
SET @List='Table '+@TableSchema+'.'+@TableName+' does not exist'
RETURN @List
END

SELECT @List=@List+Column_Name+',' 
FROM Information_Schema.Columns 
WHERE Table_Name=@TableName
AND Table_Schema=@Tableschema
ORDER BY Ordinal_Position

SET @List=SUBSTRING(@List,1,LEN(@List)-1)

RETURN @List
END


