CREATE Proc ETL_Get_Qualisys_TableID (@sStudy varchar(10), @Table_Name varchar(100), @View_id int OUTPUT)  
as   
begin  
  
  
     
SELECT @View_id=so.object_id FROM Sys.Objects so  
WHERE schema_name(so.schema_Id) = @sStudy  
AND so.name=@Table_Name  
  
end


