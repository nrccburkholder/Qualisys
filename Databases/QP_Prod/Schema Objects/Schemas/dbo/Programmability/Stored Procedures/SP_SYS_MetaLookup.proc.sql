CREATE PROCEDURE SP_SYS_MetaLookup @Tables VARCHAR(200)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @sql VARCHAR(8000)

SELECT @sql='SELECT numMasterTable_id, mf.strField_nm MasterField, numLkupTable_id, mf2.strField_nm LkupField
FROM MetaLookup ml, MetaField mf, MetaField mf2
WHERE ml.numMasterTable_id IN ('+@Tables+')
AND ml.numLkupTable_id IN ('+@Tables+')
AND ml.numMasterField_id=mf.Field_id
AND ml.numLkupField_id=mf2.Field_id'

EXEC (@sql)

SET TRANSACTION ISOLATION LEVEL READ COMMITTED


