/*
Business Purpose: 

This procedure is used to Select existing HouseHolding Field records for a survey

Created:  03/14/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_SelectHouseHoldingFieldsBySurveyId]
@survey_Id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

 SELECT MV.Table_id, MV.Field_id, strField_nm, strFieldDataType, bitKeyField_FLG, strField_DSC, 
     intFieldLength, bitUserField_FLG
 FROM MetaData_View MV, HOUSEHOLDRULE HH
 WHERE HH.survey_Id=@survey_Id  
	AND MV.table_id=HH.Table_Id 
	AND MV.field_id=HH.field_id 
 ORDER BY bitKeyField_FLG DESC, strField_nm


