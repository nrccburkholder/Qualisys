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
values (8,	'ICHCAHPS',	7,	1,	2,	NULL)
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


USE [NRC_DataMart_ETL]
GO
/****** Object:  StoredProcedure [dbo].[csp_GetSampleUnitExtractData]    Script Date: 6/30/2014 11:47:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[csp_GetSampleUnitExtractData] 
	@ExtractFileID int
AS
	SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 6 -- SampleUnit'
	
	--declare @ExtractFileID int
	--set @ExtractFileID = 1 -- SampleUnit

	select  distinct 1  as Tag
	,NULL  as Parent
	,sampleUnit.SAMPLEUNIT_ID as [sampleUnit!1!id]
	,sp.SURVEY_ID as [sampleUnit!1!surveyid]
	,sampleUnit.strSampleUnit_NM as  [sampleUnit!1!name]
	,Case When IsNull(sampleUnit.CAHPSType_id,0) = 0 Then 0 Else 1 End  as [sampleUnit!1!isCahps]
	,sampleUnit.bitSuppress as [sampleUnit!1!isSuppressedOnWeb]
	,sampleUnit.PARENTSAMPLEUNIT_ID as [sampleUnit!1!parentUnitID]
	,'false' as [sampleUnit!1!deleteEntity]
	  from QP_PROD.dbo.SAMPLEUNIT sampleUnit with (NOLOCK)
			inner join (select distinct PKey1 
                        from ExtractHistory  with (NOLOCK) 
                         where ExtractFileID = @ExtractFileID
	                     and EntityTypeID = @EntityTypeID
	                     and IsDeleted = 0 ) eh on sampleUnit.SAMPLEUNIT_ID = eh.PKey1
			inner join QP_Prod.dbo.SAMPLEPLAN sp with (NOLOCK) on sampleUnit.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID	 
	union all
	select distinct 1  as Tag
	,NULL  as Parent
	,sampleUnit.PKey1 as id
	,null as surveyid
	,null as name
	,null as isHcaphs
	,null as isSuppressedOnWeb
	,null as parentUnitID
	,'true' as deleteEntity
	  from ExtractHistory sampleUnit with (NOLOCK)
	 where sampleUnit.ExtractFileID = @ExtractFileID
	   and sampleUnit.EntityTypeID = @EntityTypeID
	   and sampleUnit.IsDeleted <> 0
	for XML EXPLICIT



GO

use [QP_Prod]

ALTER TABLE Qualpro_Params_History
ALTER COLUMN STRPARAM_NM varchar(75)


delete 
--update qualpro_params set strparam_grp = 'SurveyRules'
--select *
from qualpro_params where StrParam_GRP in 
(select 'SurveyRules' union select SurveyType_dsc from SurveyType)


insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsCAHPS - HCAHPS IP','S','SurveyRules','1','Rule to determine if this is a CAHPS survey type for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsCAHPS - Home Health CAHPS','S','SurveyRules','1','Rule to determine if this is a CAHPS survey type for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsCAHPS - CGCAHPS','S','SurveyRules','1','Rule to determine if this is a CAHPS survey type for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsCAHPS - ACOCAHPS','S','SurveyRules','1','Rule to determine if this is a CAHPS survey type for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsCAHPS - ICHCAHPS','S','SurveyRules','1','Rule to determine if this is a CAHPS survey type for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsMonthlyOnly - HCAHPS IP','S','SurveyRules','1','Rule to determine if survey type is Monthly only for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsMonthlyOnly - Home Health CAHPS','S','SurveyRules','1','Rule to determine if survey type is Monthly only for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: SamplingMethodDefault - Canada','S','SurveyRules','Specify Outgo','Rule to set default sampling method for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: SamplingMethodDefault - ACOCAHPS','S','SurveyRules','Census','Rule to set default sampling method for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: SamplingMethodDefault - ICHCAHPS','S','SurveyRules','Census','Rule to set default sampling method for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: SamplingMethodDefault','S','SurveyRules','Specify Targets','Rule to set default sampling method for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsSamplingMethodDisabled - ACOCAHPS','S','SurveyRules','1','Rule to determine if sampling method is enabled for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsSamplingMethodDisabled - ICHCAHPS','S','SurveyRules','1','Rule to determine if sampling method is enabled for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: SamplingAlgorithmDefault','S','SurveyRules','StaticPlus','Default sampling algorithm')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: SkipEnforcementRequired - HCAHPS IP','S','SurveyRules','1','Skip Enforcement is required and controls are not enabled in Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: SkipEnforcementRequired - Home Health CAHPS','S','SurveyRules','1','Skip Enforcement is required and controls are not enabled in Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: SkipEnforcementRequired - CGCAHPS','S','SurveyRules','1','Skip Enforcement is required and controls are not enabled in Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: SkipEnforcementRequired - ICHCAHPS','S','SurveyRules','1','Skip Enforcement is required and controls are not enabled in Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, NUMPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: RespRateRecalcDaysNumericDefault','N','SurveyRules',14,'Default Recalc Days in Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, NUMPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: RespRateRecalcDaysNumericDefault - Home Health CAHPS','N','SurveyRules',45,'HHCAHPS Default Recalc Days in Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: ResurveyMethodDefault','S','SurveyRules','NumberOfDays','Resurvey method default for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: ResurveyMethodDefault - HCAHPS IP','S','SurveyRules','CalendarMonths','HCAHPS Resurvey method default for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: ResurveyMethodDefault - Home Health CAHPS','S','Home Health CAHPS','CalendarMonths','HHCAHPS Resurvey method default for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, NUMPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: ResurveyExclusionPeriodsNumericDefault','N','SurveyRules',90,'Resurvey Exclusion Days default for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, NUMPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: ResurveyExclusionPeriodsNumericDefault - HCAHPS IP','N','SurveyRules',1,'HCAHPS Resurvey Exclusion Days default for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, NUMPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: ResurveyExclusionPeriodsNumericDefault - Home Health CAHPS','N','SurveyRules',6,'HHCAHPS Resurvey Exclusion Days default for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, NUMPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: ResurveyExclusionPeriodsNumericDefault - Physician','N','SurveyRules',365,'Physician Resurvey Exclusion Days default for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, NUMPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: ResurveyExclusionPeriodsNumericDefault - Employee','N','SurveyRules',365,'Employee Resurvey Exclusion Days default for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, NUMPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: ResurveyExclusionPeriodsNumericDefault - ACOCAHPS','N','SurveyRules',0,'ACOCAHPS Resurvey Exclusion Days default for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, NUMPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: ResurveyExclusionPeriodsNumericDefault - ICHCAHPS','N','SurveyRules',0,'ICHACOCAHPS Resurvey Exclusion Days default for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - ACOCAHPS','S','SurveyRules','1','ACOCAHPS Resurvey Exclusion Days disabled for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - ICHCAHPS','S','SurveyRules','1','ACOCAHPS Resurvey Exclusion Days disabled for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: HasReportability - HCAHPS IP','S','SurveyRules','1','HCAHPS has reportability for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: NotEditableIfSampled - HCAHPS IP','S','SurveyRules','1','HCAHPS not editable if sampled for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsResurveyMethodDisabled - CGCAHPS','S','SurveyRules','1','Resurvey Method is disabled for MNCM/CGCAHPS')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsResurveyMethodDisabled - NRC/Picker','S','SurveyRules','1','Resurvey Method is disabled for NRCPicker')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: MedicareIdTextMayBeBlank - CGCAHPS','S','SurveyRules','1','Medicare Id Text May Be Blank for CGCAHPS')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: MedicareIdTextMayBeBlank - ACOCAHPS','S','SurveyRules','1','Medicare Id Text May Be Blank for ACOCAHPS')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: CompliesWithSwitchToPropSamplingDate - HCAHPS IP','S','SurveyRules','1','Complies With Switch To Prop Sampling Date for HCAHPS IP')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: BypassInitRespRateNumericEnforcement - HCAHPS IP','S','SurveyRules','1','Bypass Init Resp Rate Numeric Enforcement for HCAHPS IP')


/*
EXEC sp_helptext 'dbo.Qualpro_params_jd'
EXEC sp_helptext 'dbo.QualPro_Params_ji'
EXEC sp_helptext 'dbo.QUALPRO_PARAMS_ju'

*/

--, SurveySubType_ID, QuestionnaireType_ID

GO
--EXEC sp_helptext 'dbo.QCL_SelectSurveysByStudyId'
ALTER PROCEDURE [dbo].[QCL_SelectSurveysByStudyId]
    @StudyId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT sd.Survey_id, sd.strSurvey_Nm, sd.strSurvey_Dsc, sd.Study_id, sd.strCutoffResponse_Cd, 
       sd.CutoffTable_id, sd.CutoffField_id, sd.SampleEncounterTable_id, sd.SampleEncounterField_id, 
       sd.bitValidated_Flg, sd.datValidated, sd.bitFormGenRelease, sp.SamplePlan_id, 
       sd.intResponse_Recalc_Period, sd.intResurvey_Period, sd.datSurvey_Start_Dt, sd.datSurvey_End_Dt,
       sd.SamplingAlgorithmID, sd.bitEnforceSkip, sd.strClientFacingName, sd.SurveyType_id,
       sd.SurveyTypeDef_id, sd.ReSurveyMethod_id, sd.strHouseholdingType, sd.Contract, sd.Active, 
       sd.ContractedLanguages, sd.SurveySubType_ID, sd.QuestionnaireType_ID
FROM Survey_Def sd, SamplePlan sp
WHERE sd.Study_id = @StudyId
  AND sd.survey_id = sp.survey_id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO
--EXEC sp_helptext 'dbo.QCL_SelectSurveysBySurveyTypeMailOnly'
ALTER PROCEDURE [dbo].[QCL_SelectSurveysBySurveyTypeMailOnly]
    @SurveyType_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT distinct sd.Survey_id, sd.strSurvey_Nm, sd.strSurvey_Dsc, sd.Study_id, sd.strCutoffResponse_Cd, 
       sd.CutoffTable_id, sd.CutoffField_id, sd.SampleEncounterTable_id, sd.SampleEncounterField_id, 
       sd.bitValidated_Flg, sd.datValidated, sd.bitFormGenRelease, sp.SamplePlan_id, 
       sd.intResponse_Recalc_Period, sd.intResurvey_Period, sd.datSurvey_Start_Dt, sd.datSurvey_End_Dt,
       sd.SamplingAlgorithmID, sd.bitEnforceSkip, sd.strClientFacingName, sd.SurveyType_id,
       sd.SurveyTypeDef_id, sd.ReSurveyMethod_id, sd.strHouseholdingType, sd.Contract, sd.Active, 
       sd.ContractedLanguages, sd.SurveySubType_ID, sd.QuestionnaireType_ID
FROM Client cl, Study st, Survey_Def sd, SamplePlan sp, MailingMethodology ma, MailingStep ms, MailingStepMethod mm
WHERE cl.Client_id = st.Client_id
  AND st.Study_id = sd.Study_id
  AND sd.survey_id = sp.survey_id
  AND sd.Survey_id = ma.Survey_id
  AND ma.bitActiveMethodology = 1
  AND ma.Survey_id = ms.Survey_id
  AND ma.Methodology_id = ms.Methodology_id
  AND ms.MailingStepMethod_id = mm.MailingStepMethod_id
  AND mm.IsNonMailGeneration = 0
  AND sd.SurveyType_id = @SurveyType_id
  AND cl.Active = 1
  AND st.Active = 1
  AND sd.Active = 1

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO
--sp_helptext QCL_SelectClientsStudiesAndSurveysByUser

ALTER  PROCEDURE [dbo].[QCL_SelectClientsStudiesAndSurveysByUser]  
    @UserName VARCHAR(42),  
    @ShowAllClients BIT = 0  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
  
--Need a temp table to hold the ids the user has rights to  
CREATE TABLE #EmpStudy (  
    Client_id INT,  
    Study_id INT,  
    strStudy_nm VARCHAR(10),  
    strStudy_dsc VARCHAR(255),
    ADEmployee_id int,
    datCreate_dt datetime,
    bitCleanAddr bit,
    bitProperCase bit,
    Active bit
)  
  
--Populate the temp table with the studies they have rights to.  
INSERT INTO #EmpStudy (Client_id, Study_id, strStudy_nm, strStudy_dsc, ADEmployee_id,
	        datCreate_dt, bitCleanAddr, bitProperCase, Active)  
SELECT s.Client_id, s.Study_id, s.strStudy_nm, s.strStudy_dsc, s.ADEmployee_id,
	   s.datCreate_dt, s.bitCleanAddr, s.bitProperCase, s.Active
FROM Employee e, Study_Employee se, Study s  
WHERE e.strNTLogin_nm = @UserName  
  AND e.Employee_id = se.Employee_id  
  AND se.Study_id = s.Study_id  
  AND s.datArchived IS NULL  
  
CREATE INDEX tmpIndex ON #EmpStudy (Client_id)  
  
--First recordset.  List of clients they have rights to.  
IF @ShowAllClients = 1  
BEGIN  
    SELECT c.Client_id, c.strClient_nm, c.Active, c.ClientGroup_ID  
    FROM Client c  
    ORDER BY c.strClient_nm  
END  
ELSE  
BEGIN  
    SELECT c.Client_id, c.strClient_nm, c.Active, c.ClientGroup_ID  
    FROM #EmpStudy t, Client c  
    WHERE t.Client_id = c.Client_id  
    GROUP BY c.Client_id, c.strClient_nm, c.Active, c.ClientGroup_ID
    ORDER BY c.strClient_nm  
END  
  
--Second recordset.  List of studies they have rights to  
SELECT Client_id, Study_id, strStudy_nm, strStudy_dsc, ADEmployee_id,
	   datCreate_dt, bitCleanAddr, bitProperCase, Active     
FROM #EmpStudy  
ORDER BY strStudy_nm  
  
--Third recordset.  List of surveys they have rights to  
SELECT s.Survey_id, s.strSurvey_nm, s.strSurvey_dsc, s.Study_id, s.strCutoffResponse_cd,
       s.CutoffTable_id, s.CutoffField_id, s.SampleEncounterTable_ID,
       s.SampleEncounterField_ID, s.bitValidated_flg, s.datValidated,  
       s.bitFormGenRelease, ISNULL(sp.SamplePlan_id,0) SamplePlan_id,  
       s.INTRESPONSE_RECALC_PERIOD, s.intResurvey_Period, s.datSurvey_Start_dt,  
       s.datSurvey_End_dt, s.SamplingAlgorithmID, s.bitEnforceSkip, s.strClientFacingName,  
       s.SurveyType_id, s.SurveyTypeDef_id, s.ReSurveyMethod_id, s.strHouseholdingType,
	   s.Contract, s.Active, s.ContractedLanguages, s.SurveySubType_ID, s.QuestionnaireType_ID
  FROM #EmpStudy t  
       JOIN Survey_def s  
         ON t.Study_id = s.Study_id  
       LEFT JOIN SamplePlan sp  
         ON s.Survey_id = sp.Survey_id  
ORDER BY s.strSurvey_nm  
  
--Cleanup temp table  
DROP TABLE #EmpStudy  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF

GO

use [QP_Prod]

--select * from METAFIELDGROUPDEF

if not exists(select fieldGroup_id from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'ICH CAHPS')
insert into metafieldgroupdef (STRFIELDGROUP_NM, strAddrCleanType, bitAddrCleanDefault) values
('ICH CAHPS', 'N', 0)

declare @FieldGroupId int
select @FieldGroupId = fieldGroup_id from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'ICH CAHPS'

--select * from metafield order by len(STRField_NM)
--update metafield set STRFIELD_NM = 'ICH_FacilityAdd2' where STRFIELD_NM = 'ICH_FacilityAddr2' 

if not exists(select 1 from metafield where strfield_nm= 'ICH_FacilityName')
insert into metafield (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ICH_FacilityName','ICH facility name from CMS',@FieldGroupId,'S',64,NULL,NULL,'ICHFcNm',0,0,NULL,NULL,0)

if not exists(select 1 from metafield where strfield_nm= 'ICH_FacilityAddr')
insert into metafield (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ICH_FacilityAddr','ICH facility address from CMS',@FieldGroupId,'S',64,NULL,NULL,'ICHFcAdd',0,0,NULL,NULL,0)

if not exists(select 1 from metafield where strfield_nm= 'ICH_FacilityAdd2')
insert into metafield (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ICH_FacilityAdd2','ICH facility secondary address from CMS',@FieldGroupId,'S',64,NULL,NULL,'ICHFcAd2',0,0,NULL,NULL,0)

if not exists(select 1 from metafield where strfield_nm= 'ICH_FacilityCity')
insert into metafield (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ICH_FacilityCity','ICH facility city from CMS',@FieldGroupId,'S',64,NULL,NULL,'ICHFcCit',0,0,NULL,NULL,0)

if not exists(select 1 from metafield where strfield_nm= 'ICH_FacilityST')
insert into metafield (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ICH_FacilityST','ICH facility state from CMS',@FieldGroupId,'S',2,NULL,NULL,'ICHFcST',0,0,NULL,NULL,0)

if not exists(select 1 from metafield where strfield_nm= 'ICH_FieldDate')
insert into metafield (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ICH_FieldDate','First day of month of survey administration',@FieldGroupId,'D',NULL,NULL,NULL,'ICHFldDt',0,0,NULL,NULL,0)

if not exists(select 1 from metafield where strfield_nm= 'ICH_SID')
insert into metafield (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ICH_SID','ICH samples patient ID from CMS',NULL,'S',8,NULL,NULL,'ICHSID',0,0,NULL,NULL,0)

if not exists(select 1 from metafield where strfield_nm= 'ICH_HE_Lang')
insert into metafield (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ICH_HE_Lang','ICH language speak hand entry',NULL,'S',42,NULL,NULL,'ICHLang',0,0,NULL,NULL,0)

if not exists(select 1 from metafield where strfield_nm= 'ICH_HE_WhoHelp')
insert into metafield (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ICH_HE_WhoHelp','ICH who helped hand entry',NULL,'S',99,NULL,NULL,'ICHWho',0,0,NULL,NULL,0)

if not exists(select 1 from metafield where strfield_nm= 'ICH_HE_HowHelp')
insert into metafield (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ICH_HE_HowHelp','ICH how helped hand entry',NULL,'S',99,NULL,NULL,'ICHHow',0,0,NULL,NULL,0)

use [QP_Prod] 

--select * from Disposition

SET IDENTITY_INSERT disposition ON

if not exists (select 1 from disposition where strDispositionLabel = 'Returned Survey - Eligibility Unknown')
insert into disposition (Disposition_id, strDispositionLabel, strReportLabel, Action_id, MustHaveResults)
values (32, 'Returned Survey - Eligibility Unknown','Unable to determine eligibility from screener questions on returned survey',0,1)

if not exists (select 1 from disposition where strDispositionLabel = 'Ineligible - Not Receiving Care')
insert into disposition (Disposition_id, strDispositionLabel, strReportLabel, Action_id, MustHaveResults)
values (33, 'Ineligible - Not Receiving Care','The patient is no longer receiving care',0,0)

if not exists (select 1 from disposition where strDispositionLabel = 'Ineligible - Not Receiving Care at Facility')
insert into disposition (Disposition_id, strDispositionLabel, strReportLabel, Action_id, MustHaveResults)
values (34, 'Ineligible - Not Receiving Care at Facility','The patient is not receiving care at the sampled facility',0,0)

if not exists (select 1 from disposition where strDispositionLabel = 'Proxy Return')
insert into disposition (Disposition_id, strDispositionLabel, strReportLabel, Action_id, MustHaveResults)
values (35, 'Proxy Return','The survey was completed by someone other than the intended recipient',0,1)

SET IDENTITY_INSERT disposition OFF

--select Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID from surveytypedispositions order by surveytype_id, hierarchy, disposition_id

declare @proxyId int
select @proxyId = disposition_id from disposition where strdispositionlabel = 'Proxy Return'

declare @eligibilityUnknownId int
select @eligibilityUnknownId = disposition_id from disposition where strdispositionlabel = 'Returned Survey - Eligibility Unknown'

declare @ineligibleNotCareId int
select @ineligibleNotCareId = disposition_id from disposition where strdispositionlabel = 'Ineligible - Not Receiving Care'

declare @ineligibleNotFacilityId int
select @ineligibleNotFacilityId = disposition_id from disposition where strdispositionlabel = 'Ineligible - Not Receiving Care at Facility'

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 3)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('150','Deceased',0,3,0,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = @proxyId)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('199','Survey completed by Proxy',0,@proxyId,1,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = @ineligibleNotCareId)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('140','Ineligible: Not Receiving Dialysis',1,@ineligibleNotCareId,1,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = @ineligibleNotFacilityId)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('190','Ineligible: No Longer Receiving Care at Sampled Facility',2,@ineligibleNotFacilityId,1,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 8)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('160','Ineligible: Does Not Meet Eligibility Criteria',3,8,1,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 24)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('160','Ineligible: Does Not Meet Eligibility Criteria',3,24,1,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = @eligibilityUnknownId)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('130','Completed Mail Questionnaire—Survey Eligibility Unknown',4,@eligibilityUnknownId,1,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 20)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('120','Completed Phone Interview',5,20,1,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 19)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('110','Completed Mail Questionnaire',5,19,1,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 11)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('210','Breakoff',7,11,1,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 2)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('220','Refusal',8,2,0,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 26)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('220','Refusal',8,26,0,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 10)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('170','Language Barrier',9,10,0,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 4)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('180','Mentally or Physically Incapacitated',10,4,0,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 14)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('240','Wrong, Disconnected, or No Telephone Number',11,14,0,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 16)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('240','Wrong, Disconnected, or No Telephone Number',11,16,0,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 5)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('230','Bad Address/Undeliverable Mail',12,5,0,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 12)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('250','No Response After Maximum Attempts',13,12,0,8)

if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = 8 and Disposition_ID = 25)
insert into SurveyTypeDispositions (Value, [Desc], Hierarchy, Disposition_ID, ExportReportResponses, SurveyType_ID)
values ('250','No Response After Maximum Attempts',13,25,0,8)
