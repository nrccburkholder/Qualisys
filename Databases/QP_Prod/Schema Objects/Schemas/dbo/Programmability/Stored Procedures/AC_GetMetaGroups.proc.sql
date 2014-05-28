CREATE PROCEDURE dbo.AC_GetMetaGroups
    @StudyID int

AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Create the temp table to hold the key field names for each study table
CREATE TABLE #KeyField (Table_id int, strField_Nm varchar(20))

--Populate the temp table with the key field names for each study table
INSERT INTO #KeyField (Table_id, strField_Nm)
SELECT Table_id, strField_Nm
FROM MetaData_View
WHERE Study_id = @StudyID
  AND bitKeyField_Flg = 1

--Generate the dataset for all of the required MetaGroups
--NOTE: We are only including address and name groups contained
--      within the population table
SELECT mg.FieldGroup_id, mg.strFieldGroup_Nm, mg.strAddrCleanType, 
       mg.bitAddrCleanDefault, mt.Table_id, mt.strTable_Nm, mf.Field_id, 
       mf.strField_Nm, mf.strFieldDataType, mf.intFieldLength, 
       mf.intAddrCleanCode, mf.intAddrCleanGroup, qp.strParam_Nm, 
       st.bitProperCase, kf.strField_Nm AS strKeyField_Nm 
FROM MetaTable mt, MetaStructure ms, MetaField mf, MetaFieldGroupDef mg, 
     QualPro_Params qp, Study st, #KeyField kf 
WHERE mt.Table_id = ms.Table_id 
  AND ms.Field_id = mf.Field_id 
  AND mf.intAddrCleanGroup = mg.FieldGroup_id 
  AND mt.Study_id = @StudyID
  AND mt.strTable_Nm like 'pop%'
  AND mg.strAddrCleanType IN ('A', 'N') 
  AND qp.numParam_Value = mf.intAddrCleanCode 
  AND qp.strParam_Grp = 'Address' 
  AND kf.Table_id = mt.Table_id
  AND st.Study_id = mt.Study_id
ORDER BY mg.FieldGroup_id, mt.Table_id

--Cleanup
DROP TABLE #KeyField

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


