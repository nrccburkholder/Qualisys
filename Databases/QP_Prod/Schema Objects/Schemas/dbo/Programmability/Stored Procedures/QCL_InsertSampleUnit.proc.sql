CREATE PROCEDURE [dbo].[QCL_InsertSampleUnit]
@CriteriaStmt_id INT,
@SamplePlan_id INT,
@ParentSampleUnit_id INT,
@strSampleUnit_nm VARCHAR(42),
@intTargetReturn INT,
--@intMinConfidence INT,
--@intMaxMargin INT,
@numInitResponseRate INT,
--@numResponseRate INT,
--@Reporting_Hierarchy_id INT,
@SUFacility_id INT,
--@SUServices VARCHAR(300),
@bitSuppress BIT,
@bitHCAHPS BIT,
@bitACOCAHPS BIT,
@bitHHCAHPS BIT,
@bitCHART BIT,
@bitMNCM BIT,
--@MedicareNumber VARCHAR(20),
--@AHANumber INT,
--@FacilityState VARCHAR(42),
@Priority INT,
@SampleSelectionType_id INT,
@DontSampleUnit tinyint
AS
BEGIN
	DECLARE @su INT

	INSERT INTO SampleUnit (CriteriaStmt_id, SamplePlan_id, ParentSampleUnit_id, strSampleUnit_nm,
	  intTargetReturn, /*intMinConfidence, intMaxMargin,*/ numInitResponseRate, /*numResponseRate, 
	  Reporting_Hierarchy_id,*/ SUFacility_id, /*SUServices,*/ bitSuppress, bitHCAHPS, bitACOCAHPS, bitHHCAHPS, bitCHART, bitMNCM, /*MedicareNumber,
	  AHANumber, FacilityState,*/ Priority, SampleSelectionType_id, DontSampleUnit)
	SELECT @CriteriaStmt_id, @SamplePlan_id, @ParentSampleUnit_id, @strSampleUnit_nm,
	  @intTargetReturn, /*@intMinConfidence, @intMaxMargin, */@numInitResponseRate, /*@numResponseRate, 
	  @Reporting_Hierarchy_id,*/ @SUFacility_id, /*@SUServices, */@bitSuppress, @bitHCAHPS, @bitACOCAHPS, @bitHHCAHPS, @bitCHART, @bitMNCM, /*@MedicareNumber,
	  @AHANumber, @FacilityState,*/ @Priority, @SampleSelectionType_id, @DontSampleUnit

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


