CREATE PROCEDURE SP_SYS_MetaLookupView
	@Study_id	INT
AS

SELECT strTable_nm+'_Load' strTable_nm, strField_nm, LookupTableName+'_Load' LookupTableName, LookupFieldName
FROM MetaLookup_View
WHERE Study_id=@Study_id
AND strLkup_Type='L'


