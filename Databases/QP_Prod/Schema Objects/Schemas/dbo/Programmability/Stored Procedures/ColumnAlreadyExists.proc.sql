CREATE procedure ColumnAlreadyExists(@Owner nvarchar(50),@TableName NVARCHAR(128),@ColumnName NVARCHAR(128))   
  
AS  
BEGIN   
--See if the Table already contains the column.  
IF EXISTS  
 (SELECT * FROM Sys.Objects O INNER JOIN SysColumns C ON O.object_id=C.ID  
 WHERE o.Type = 'U'  
 AND O.Name=@TableName  
 AND C.Name=@ColumnName and SCHEMA_NAME(o.schema_ID)=  @Owner)   
 begin  
  RETURN 1  
 end  
else  
--Table does not contain the column.  
 begin  
  RETURN 0  
 end  
END


