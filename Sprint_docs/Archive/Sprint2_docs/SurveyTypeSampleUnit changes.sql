USE [QP_Prod]
GO

--exec QCL_SelectAllSurveyTypes

EXEC sp_RENAME 'surveytype.OptionType_id', 'CAHPSType_id', 'COLUMN'

delete from SurveyType where SurveyType_ID = 8
SET IDENTITY_INSERT SurveyType ON
/*
insert surveytype (  SurveyType_ID,	SurveyType_dsc,	OptionType_id,	SeedMailings,	SeedSurveyPercent,	SeedUnitField)
values (7,	'Canada',	NULL,	0,	NULL,	NULL)
*/
insert surveytype (  SurveyType_ID,	SurveyType_dsc,	CAHPSType_id,	SeedMailings,	SeedSurveyPercent,	SeedUnitField)
values (8,	'ICHCAHPS',	7,	1,	NULL,	NULL)
/*
insert surveytype (  SurveyType_ID,	SurveyType_dsc,	OptionType_id,	SeedMailings,	SeedSurveyPercent,	SeedUnitField)
values (9,	'MDPDPCAHPS',	8,	0,	NULL,	NULL)
*/
SET IDENTITY_INSERT SurveyType OFF
update SurveyType set CAHPSType_id = 2 where surveytype_id = 2
update SurveyType set CAHPSType_id = 3 where surveytype_id = 3
update SurveyType set CAHPSType_id = 4 where surveytype_id = 4
update SurveyType set CAHPSType_id = NULL where surveytype_id = 5
update SurveyType set CAHPSType_id = NULL where surveytype_id = 6
update SurveyType set CAHPSType_id = 10 where surveytype_id = 10
update SurveyType set CAHPSType_id = 8 where surveytype_id = 8
update SurveyType set CAHPSType_id = null where surveytype_id = 9

--sp_helptext QCL_SelectSampleUnit

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectSampleUnit]    Script Date: 6/17/2014 1:24:37 PM ******/
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
	 su.CAHPSType_id, su.SampleSelectionType_id, su.samplePlan_id, su.DontSampleUnit  
	FROM SampleUnit su, SamplePlan sp 
	WHERE su.SamplePlan_id = sp.SamplePlan_id  
	AND su.SampleUnit_id=@SampleUnitId

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	SET NOCOUNT OFF

END

GO


--sp_helptext QCL_SelectSampleUnitsByParentId

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectSampleUnitsByParentId]    Script Date: 6/17/2014 1:25:15 PM ******/
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
 su.CAHPSType_id, su.SampleSelectionType_id, su.samplePlan_id, su.DontSampleUnit
FROM SampleUnit su, SamplePlan sp 
WHERE su.SamplePlan_id = sp.SamplePlan_id
 AND su.ParentSampleUnit_id=@SampleUnitId

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO


--sp_helptext QCL_SelectSampleUnitsBySurveyId

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectSampleUnitsBySurveyId]    Script Date: 6/17/2014 1:26:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[QCL_SelectSampleUnitsBySurveyId]
@SurveyId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT su.SampleUnit_id, su.ParentSampleUnit_id, sp.Survey_id, 
 su.strSampleUnit_nm, su.intTargetReturn, su.priority, 
 su.SampleSelectionType_id, su.CriteriaStmt_id, su.numInitResponseRate,
 su.numResponseRate, su.Reporting_Hierarchy_id, su.SUFacility_id, 
 su.SUServices, su.bitSuppress, --su.bitHCAHPS, su.bitACOCAHPS, su.bitHHCAHPS, su.bitCHART, su.bitMNCM,
 su.CAHPSType_id, su.SampleSelectionType_id, su.samplePlan_id, su.DontSampleUnit
FROM SampleUnit su, SamplePlan sp
WHERE su.SamplePlan_id = sp.SamplePlan_id
AND sp.Survey_id = @SurveyId

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO


--sp_helptext QCL_InsertSampleUnit

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_InsertSampleUnit]    Script Date: 6/17/2014 1:26:32 PM ******/
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

GO


--sp_helptext QCL_UpdateSampleUnit

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_UpdateSampleUnit]    Script Date: 6/17/2014 1:26:44 PM ******/
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
@CAHPSType_id INT
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
  CAHPSType_id=@CAHPSType_id
WHERE SampleUnit_id=@SampleUnit_id

GO

--EXEC sp_helptext 'dbo.QCL_InsertSurveyType'

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_InsertSurveyType]    Script Date: 6/17/2014 4:18:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[QCL_InsertSurveyType]
    @SurveyType_dsc    VARCHAR(100),
    @CAHPSType_id     INT,
    @SeedMailings      BIT,
    @SeedSurveyPercent INT,
    @SeedUnitField     VARCHAR(42)
AS

SET NOCOUNT ON

INSERT INTO [dbo].SurveyType (SurveyType_dsc, CAHPSType_id, SeedMailings, SeedSurveyPercent, SeedUnitField)
VALUES (@SurveyType_dsc, @CAHPSType_id, @SeedMailings, @SeedSurveyPercent, @SeedUnitField)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF

GO


--EXEC sp_helptext 'dbo.QCL_SelectAllSurveyTypes'

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectAllSurveyTypes]    Script Date: 6/17/2014 4:18:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[QCL_SelectAllSurveyTypes]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT SurveyType_ID, SurveyType_dsc, CAHPSType_id, SeedMailings, SeedSurveyPercent, SeedUnitField
FROM [dbo].SurveyType

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO


--EXEC sp_helptext 'dbo.QCL_SelectSurveyType'

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectSurveyType]    Script Date: 6/17/2014 4:18:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[QCL_SelectSurveyType]
    @SurveyType_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT SurveyType_ID, SurveyType_dsc, CAHPSType_id, SeedMailings, SeedSurveyPercent, SeedUnitField
FROM [dbo].SurveyType
WHERE SurveyType_ID = @SurveyType_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO


--EXEC sp_helptext 'dbo.QCL_UpdateSurveyType'

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_UpdateSurveyType]    Script Date: 6/17/2014 4:18:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[QCL_UpdateSurveyType]
    @SurveyType_ID     INT,
    @SurveyType_dsc    VARCHAR(100),
    @CAHPSType_id      INT,
    @SeedMailings      BIT,
    @SeedSurveyPercent INT,
    @SeedUnitField     VARCHAR(42)
AS

SET NOCOUNT ON

UPDATE [dbo].SurveyType 
SET SurveyType_dsc = @SurveyType_dsc,
    CAHPSType_id = @CAHPSType_id,
    SeedMailings = @SeedMailings,
    SeedSurveyPercent = @SeedSurveyPercent,
    SeedUnitField = @SeedUnitField
WHERE SurveyType_ID = @SurveyType_ID

SET NOCOUNT OFF

GO

--new QCL_SelectCAHPSTypesBySurveyType

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectSurveyTypes]    Script Date: 6/18/2014 9:10:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE 
--ALTER
PROCEDURE [dbo].[QCL_SelectCAHPSTypesBySurveyType] 
@SurveyType  INT
AS
SELECT '0' as CAHPSType_id, 'None' as SurveyType_dsc
union
SELECT CAHPSType_id, SurveyType_dsc
FROM SurveyType (NOLOCK)
where surveyType_id = @SurveyType
and CAHPSType_id is not null

GO


