
/*

ATL-1284
Consolidate Address cleaning calls from Name & Address to a single call

CREATE PROCEDURE [dbo].[AC_GetMetadata]
Add QualPro Params for personator actions, options and columns

*/

USE [QP_Prod]
GO


if exists (select * from sys.procedures where schema_id=1 and name = 'AC_GetMetadata')
	drop procedure dbo.AC_GetMetadata

GO

/****** Object:  StoredProcedure [dbo].[AC_GetMetadata]    Script Date: 12/22/2016 2:08:39 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[AC_GetMetadata]
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

SELECT top 1 mt.Table_id, mt.strTable_Nm, st.bitProperCase, kf.strField_Nm AS strKeyField_Nm
FROM MetaTable mt 
INNER JOIN MetaStructure ms on mt.Table_id = ms.Table_id
INNER JOIN MetaField mf on  ms.Field_id = mf.Field_id
INNER JOIN MetaFieldGroupDef mg on mf.intAddrCleanGroup = mg.FieldGroup_id
INNER JOIN QualPro_Params qp on qp.numParam_Value = mf.intAddrCleanCode
INNER JOIN Study st on st.Study_id = mt.Study_id
INNER JOIN #KeyField kf on kf.Table_id = mt.Table_id
WHERE mt.Study_id = @StudyID
  AND mt.strTable_Nm like 'pop%'
  AND mg.strAddrCleanType IN ('A', 'N') 
  AND qp.strParam_Grp = 'Address' 
  and mg.bitAddrCleanDefault = 1
GROUP BY mt.Table_id, mt.strTable_Nm, st.bitProperCase, kf.strField_Nm

--this will return the field groups Address and Name
SELECT mg.FieldGroup_id, mg.strFieldGroup_Nm, mg.strAddrCleanType
FROM MetaTable mt 
INNER JOIN MetaStructure ms on mt.Table_id = ms.Table_id
INNER JOIN MetaField mf on  ms.Field_id = mf.Field_id
INNER JOIN MetaFieldGroupDef mg on mf.intAddrCleanGroup = mg.FieldGroup_id
INNER JOIN QualPro_Params qp on qp.numParam_Value = mf.intAddrCleanCode
INNER JOIN Study st on st.Study_id = mt.Study_id
INNER JOIN #KeyField kf on kf.Table_id = mt.Table_id
WHERE mt.Study_id = @StudyID
  AND mt.strTable_Nm like 'pop%'
  AND mg.strAddrCleanType IN ('A', 'N') 
  AND qp.strParam_Grp = 'Address' 
  and mg.bitAddrCleanDefault = 1
GROUP BY mg.FieldGroup_id, mg.strFieldGroup_Nm, mg.strAddrCleanType 

--Generate the dataset for all of the required MetaGroups
--NOTE: We are only including address and name groups contained
--      within the population table
SELECT mg.FieldGroup_id, mg.strFieldGroup_Nm, mg.strAddrCleanType, 
       mg.bitAddrCleanDefault, mt.Table_id, mt.strTable_Nm, mf.Field_id, 
       mf.strField_Nm, mf.strFieldDataType, mf.intFieldLength, 
       mf.intAddrCleanCode, mf.intAddrCleanGroup, qp.strParam_Nm, 
       st.bitProperCase, kf.strField_Nm AS strKeyField_Nm 
FROM MetaTable mt 
INNER JOIN MetaStructure ms on mt.Table_id = ms.Table_id
INNER JOIN MetaField mf on  ms.Field_id = mf.Field_id
INNER JOIN MetaFieldGroupDef mg on mf.intAddrCleanGroup = mg.FieldGroup_id
INNER JOIN QualPro_Params qp on qp.numParam_Value = mf.intAddrCleanCode
INNER JOIN Study st on st.Study_id = mt.Study_id
INNER JOIN #KeyField kf on kf.Table_id = mt.Table_id
WHERE mt.Study_id = @StudyID
  AND mt.strTable_Nm like 'pop%'
  AND mg.strAddrCleanType IN ('A', 'N') 
  AND qp.strParam_Grp = 'Address' 
  and mg.bitAddrCleanDefault = 1
ORDER BY mg.FieldGroup_id, mt.Table_id

--Cleanup
DROP TABLE #KeyField

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


GO

USE [QP_Prod]
GO


if not exists (select 1 from dbo.QUALPRO_PARAMS where STRPARAM_NM = 'AddressCleaningActions')
begin

	insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
	VALUES 
		('AddressCleaningActions','S','AddressCleaner','Check',NULL,NULL,'Determines what action the service will perform on the input data'),
		('AddressCleaningOptions','S','AddressCleaner','AdvancedAddressCorrection:on;NameHint:DefinitelyFull',NULL,NULL,'Configure options that change the way the service behaves'),
		('AddressCleaningColumns','S','AddressCleaner','GrpCensus,GrpGeocode, GrpNameDetails,GrpAddressDetails,PrivateMailBox,GrpParsedAddress,Plus4',NULL,NULL,'Configures what data the service will output')

end

select * from dbo.QUALPRO_PARAMS
where STRPARAM_GRP = 'AddressCleaner'

GO


