CREATE PROCEDURE [dbo].[QCL_InsertSampleUnit]
@CriteriaStmt_id INT,
@SamplePlan_id INT,
@ParentSampleUnit_id INT,
@strSampleUnit_nm VARCHAR(42),
@intTargetReturn INT,
@numInitResponseRate INT,
@SUFacility_id INT,
@bitSuppress BIT,
--@bitHCAHPS BIT,
--@bitACOCAHPS BIT,
--@bitHHCAHPS BIT,
--@bitCHART BIT,
--@bitMNCM BIT,
@Priority INT,
@SampleSelectionType_id INT,
@DontSampleUnit tinyint,
@CAHPSType_id INT
AS
BEGIN
	DECLARE @su INT

	INSERT INTO SampleUnit (CriteriaStmt_id, SamplePlan_id, ParentSampleUnit_id, strSampleUnit_nm,
	  intTargetReturn, numInitResponseRate, SUFacility_id, bitSuppress, 
	  --bitHCAHPS, bitACOCAHPS, bitHHCAHPS, bitCHART, bitMNCM, 
	  Priority, SampleSelectionType_id, DontSampleUnit, CAHPSType_id)
	SELECT @CriteriaStmt_id, @SamplePlan_id, @ParentSampleUnit_id, @strSampleUnit_nm,
	  @intTargetReturn, @numInitResponseRate, @SUFacility_id, @bitSuppress, 
	  --@bitHCAHPS, @bitACOCAHPS, @bitHHCAHPS, @bitCHART, @bitMNCM, 
	  @Priority, @SampleSelectionType_id, @DontSampleUnit, @CAHPSType_id

	SELECT @su=SCOPE_IDENTITY()

	WHILE @ParentSampleUnit_id IS NOT NULL
	BEGIN

	INSERT INTO SampleUnitTreeIndex (SampleUnit_id, AncestorUnit_id)
	SELECT @su, @ParentSampleUnit_id

	SELECT @ParentSampleUnit_id=ParentSampleUnit_id
	FROM SampleUnit
	WHERE SampleUnit_id=@ParentSampleUnit_id

	END

	SELECT @su SampleUnit_id


END
