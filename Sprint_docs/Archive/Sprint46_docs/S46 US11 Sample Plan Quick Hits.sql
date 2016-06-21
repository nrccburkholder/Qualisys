/*


	S46 US11 Sample Plan Quick Hits  
	As Service Associates, we would like some minor adjustments to the Sample Plan interface, so it is easier to use.

	Task 2 - Change interface: *widen facility name *widen Medicare Num & rename "CCN" *Move CAHPS Type dropdown above target-related fields *Get rid of AHA ID field

	Remove validation of ACA ID for HCAHPS
	
	Tim Butler 


*/


use QP_Prod


declare @SurveyType_id int
select @SurveyType_id = SurveyType_Id from SurveyType where SurveyType_dsc = 'HCAHPS IP'


DECLARE @SurveyValidationProcs_id int 

select @SurveyValidationProcs_id = SurveyValidationProcs_id
from dbo.SurveyValidationProcs
where ProcedureName = 'SV_CAHPS_AHA_Id'

begin tran

update sv
	SET CAHPSType_ID = 0
from dbo.SurveyValidationProcsBySurveyType sv
where SurveyValidationProcs_id = @SurveyValidationProcs_id
and CAHPSType_ID = @SurveyType_id

commit tran


SELECT * from dbo.SurveyValidationProcsBySurveyType
where SurveyValidationProcs_id = @SurveyValidationProcs_id



use QP_Prod

if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'SampleUnit' 
					   AND sc.NAME = 'bitLowVolumeUnit' )
BEGIN
	alter table [dbo].[SampleUnit] add bitLowVolumeUnit bit NOT NULL DEFAULT(0)
END


GO


USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectSampleUnit]    Script Date: 4/6/2016 2:22:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[QCL_SelectSampleUnit]
@SampleUnitId INT
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	SELECT su.SampleUnit_id, su.ParentSampleUnit_id, sp.Survey_id, 
	 su.strSampleUnit_nm, su.intTargetReturn, su.priority,   
	 su.SampleSelectionType_id, su.CriteriaStmt_id, su.numInitResponseRate,  
	 su.numResponseRate, su.Reporting_Hierarchy_id, su.SUFacility_id,   
	 su.SUServices, su.bitSuppress, --su.bitHCAHPS, su.bitACOCAHPS, su.bitHHCAHPS, su.bitCHART, su.bitMNCM,
	 su.CAHPSType_id, su.SampleSelectionType_id, su.samplePlan_id, su.DontSampleUnit, su.bitLowVolumeUnit    
	FROM SampleUnit su, SamplePlan sp 
	WHERE su.SamplePlan_id = sp.SamplePlan_id  
	AND su.SampleUnit_id=@SampleUnitId

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	SET NOCOUNT OFF

END

GO

USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectSampleUnitsByParentId]    Script Date: 4/6/2016 2:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[QCL_SelectSampleUnitsByParentId]
@SampleUnitId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT su.SampleUnit_id, su.ParentSampleUnit_id, sp.Survey_id, 
 su.strSampleUnit_nm, su.intTargetReturn, su.priority, 
 su.SampleSelectionType_id, su.CriteriaStmt_id, su.numInitResponseRate,
 su.numResponseRate, su.Reporting_Hierarchy_id, su.SUFacility_id, 
 su.SUServices, su.bitSuppress, --su.bitHCAHPS, su.bitHHCAHPS, su.bitCHART, su.bitMNCM, 
 su.CAHPSType_id, su.SampleSelectionType_id, su.samplePlan_id, su.DontSampleUnit, su.bitLowVolumeUnit
FROM SampleUnit su, SamplePlan sp 
WHERE su.SamplePlan_id = sp.SamplePlan_id
 AND su.ParentSampleUnit_id=@SampleUnitId

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO

USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectSampleUnitsBySurveyId]    Script Date: 4/6/2016 2:27:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[QCL_SelectSampleUnitsBySurveyId]
@SurveyId INT
AS

/*
2014-0815 CAMELINCKX Re-enabling return of fields:
					 su.bitHCAHPS, su.bitACOCAHPS, su.bitHHCAHPS, su.bitCHART, su.bitMNCM
					 having to cast them as bit since the computed columns were made ints
*/

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT su.SampleUnit_id, su.ParentSampleUnit_id, sp.Survey_id, 
 su.strSampleUnit_nm, su.intTargetReturn, su.priority, 
 su.SampleSelectionType_id, su.CriteriaStmt_id, su.numInitResponseRate,
 su.numResponseRate, su.Reporting_Hierarchy_id, su.SUFacility_id, 
 su.SUServices, su.bitSuppress, 
/* 
 CAST(su.bitHCAHPS AS bit) AS bitHCAHPS,
 CAST(su.bitACOCAHPS AS bit) AS bitACOCAHPS,
 CAST(su.bitHHCAHPS AS bit) AS bitHHCAHPS,
 CAST(su.bitCHART AS bit) AS bitCHART,
 CAST(su.bitMNCM AS bit) AS bitMNCM,
*/ 
 su.CAHPSType_id, su.SampleSelectionType_id, su.samplePlan_id, su.DontSampleUnit, su.bitLowVolumeUnit
FROM SampleUnit su, SamplePlan sp
WHERE su.SamplePlan_id = sp.SamplePlan_id
AND sp.Survey_id = @SurveyId

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO

USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_InsertSampleUnit]    Script Date: 4/6/2016 3:27:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[QCL_InsertSampleUnit]
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
@CAHPSType_id INT,
@IsLowVolumeUnit BIT = 0
AS
BEGIN
	DECLARE @su INT

	INSERT INTO SampleUnit (CriteriaStmt_id, SamplePlan_id, ParentSampleUnit_id, strSampleUnit_nm,
	  intTargetReturn, numInitResponseRate, SUFacility_id, bitSuppress, 
	  --bitHCAHPS, bitACOCAHPS, bitHHCAHPS, bitCHART, bitMNCM, 
	  Priority, SampleSelectionType_id, DontSampleUnit, CAHPSType_id, bitLowVolumeUnit)
	SELECT @CriteriaStmt_id, @SamplePlan_id, @ParentSampleUnit_id, @strSampleUnit_nm,
	  @intTargetReturn, @numInitResponseRate, @SUFacility_id, @bitSuppress, 
	  --@bitHCAHPS, @bitACOCAHPS, @bitHHCAHPS, @bitCHART, @bitMNCM, 
	  @Priority, @SampleSelectionType_id, @DontSampleUnit, @CAHPSType_id, @IsLowVolumeUnit

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

GO

USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_UpdateSampleUnit]    Script Date: 4/6/2016 3:29:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[QCL_UpdateSampleUnit]
@SampleUnit_id INT,
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
@CAHPSType_id INT,
@IsLowVolumeUnit BIT = 0
AS

UPDATE SampleUnit 
SET CriteriaStmt_id=@CriteriaStmt_id, SamplePlan_id=@SamplePlan_id, 
  ParentSampleUnit_id=@ParentSampleUnit_id, strSampleUnit_nm=@strSampleUnit_nm,
  intTargetReturn=@intTargetReturn, numInitResponseRate=@numInitResponseRate, 
  SUFacility_id=@SUFacility_id, bitSuppress=@bitSuppress, 
  --bitHCAHPS=@bitHCAHPS, bitACOCAHPS=@bitACOCAHPS, bitHHCAHPS=@bitHHCAHPS, bitCHART = @bitCHART, bitMNCM = @bitMNCM, 
  Priority=@Priority,
  SampleSelectionType_id=@SampleSelectionType_id,
  DontSampleUnit=@DontSampleUnit,
  CAHPSType_id=@CAHPSType_id,
  bitLowVolumeUnit = @IsLowVolumeUnit
WHERE SampleUnit_id=@SampleUnit_id

GO
