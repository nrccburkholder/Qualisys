CREATE PROCEDURE [dbo].[QCL_UpdateSampleUnit]
@SampleUnit_id INT,
@CriteriaStmt_id INT,
@SamplePlan_id INT,
@ParentSampleUnit_id INT,
@strSampleUnit_nm VARCHAR(42),
@intTargetReturn INT,
@numInitResponseRate INT,
@SUFacility_id INT,
@bitSuppress BIT,
@bitHCAHPS BIT,
@bitACOCAHPS BIT,
@bitHHCAHPS BIT,
@bitCHART BIT,
@bitMNCM BIT,
@Priority INT,
@SampleSelectionType_id INT,
@DontSampleUnit tinyint
AS

UPDATE SampleUnit 
SET CriteriaStmt_id=@CriteriaStmt_id, SamplePlan_id=@SamplePlan_id, 
  ParentSampleUnit_id=@ParentSampleUnit_id, strSampleUnit_nm=@strSampleUnit_nm,
  intTargetReturn=@intTargetReturn, numInitResponseRate=@numInitResponseRate, 
  SUFacility_id=@SUFacility_id, bitSuppress=@bitSuppress, 
  bitHCAHPS=@bitHCAHPS, bitACOCAHPS=@bitACOCAHPS, bitHHCAHPS=@bitHHCAHPS, bitCHART = @bitCHART,
  bitMNCM = @bitMNCM, Priority=@Priority,
  SampleSelectionType_id=@SampleSelectionType_id,
  DontSampleUnit=@DontSampleUnit
WHERE SampleUnit_id=@SampleUnit_id


