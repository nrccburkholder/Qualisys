/*

	S33 US17 - HHCAHPS QLoader ICD-10 Function

	As a Data Mgmt Associate, I want a new funtion in QLoader to check if a value is an ICD-10, so that we load data correctly into the correct fields.


	Task 17.1: Create new function in Q loader and use code from similar Hospice cahps function


	Tim Butler

*/
USE [QP_Load]
GO

DECLARE @FunctionGroup_id int
DECLARE @strFunctionGroup_dsc varchar(42) 
SET @strFunctionGroup_dsc = 'HHCAHPS'

Select @FunctionGroup_id = FunctionGroup_id FROM [dbo].[FunctionGroup] WHERE [strFunctionGroup_dsc] = @strFunctionGroup_dsc


IF @FunctionGroup_id is null return

DECLARE @strFunction_nm varchar(42)
DECLARE @strFunction_Sig varchar(200)
DECLARE @strFunction_dsc varchar(200)
DECLARE @strFunction_Code varchar(5000)
DECLARE @bitVBS bit
DECLARE @Client_id int

DECLARE @IsUpdateFunction bit


SET @strFunction_nm = 'GetHomeHealthICD10'


SET @bitVBS = 0
SET @Client_id = 0
SET @IsUpdateFunction = 1


IF Exists (Select 1 FROM [dbo].[Functions] WHERE [strFunction_nm] = @strFunction_nm and [FunctionGroup_id] = @FunctionGroup_id)
BEGIN

	DELETE [dbo].[Functions]
	 WHERE [strFunction_nm] = @strFunction_nm

END

 SELECT *
 FROM functiongroup
 WHERE FunctionGroup_id = @FunctionGroup_id

 SELECT * 
 FROM [dbo].[Functions] 
 WHERE FunctionGroup_id = @FunctionGroup_id

 GO