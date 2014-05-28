CREATE procedure SP_DTS_GetFieldList @Study_id int
as

declare @StudyID varchar(5)
set @StudyID = convert(varchar,@Study_id)

select so.name TableName, sc.name FieldName, st.name FieldType, sc.length FieldLength, '' strScript
from sysobjects so, syscolumns sc, systypes st 
where so.id = sc.id 
and sc.xtype = st.xtype 
and so.uid = user_id('S' + @StudyID) 
and so.name like '%_load' 
and so.type = 'U'
order by so.name, sc.colorder


