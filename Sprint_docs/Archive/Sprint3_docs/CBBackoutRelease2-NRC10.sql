USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectSurveysByStudyId]    Script Date: 7/24/2014 10:10:21 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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
       sd.ContractedLanguages
FROM Survey_Def sd, SamplePlan sp
WHERE sd.Study_id = @StudyId
  AND sd.survey_id = sp.survey_id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectClientsAndStudiesByUser]    Script Date: 7/24/2014 10:10:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[QCL_SelectClientsAndStudiesByUser]    
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
    
--First recordset.  List of clients they have rights to or all clients    
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
    
--Cleanup temp table    
DROP TABLE #EmpStudy
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

GO

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectSurveysBySurveyTypeMailOnly]    Script Date: 7/24/2014 10:11:07 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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
       sd.ContractedLanguages
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

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectSampleUnit]    Script Date: 7/24/2014 10:11:21 AM ******/
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
	 su.SUServices, su.bitSuppress, su.bitHCAHPS, su.bitACOCAHPS, su.bitHHCAHPS, su.bitCHART, su.bitMNCM,
	 su.SampleSelectionType_id, su.samplePlan_id, su.DontSampleUnit  
	FROM SampleUnit su, SamplePlan sp 
	WHERE su.SamplePlan_id = sp.SamplePlan_id  
	AND su.SampleUnit_id=@SampleUnitId

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	SET NOCOUNT OFF

END



GO

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectSampleUnitsByParentId]    Script Date: 7/24/2014 10:11:45 AM ******/
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
 su.SUServices, su.bitSuppress, su.bitHCAHPS, su.bitHHCAHPS, su.bitCHART, su.bitMNCM, 
 su.SampleSelectionType_id, su.samplePlan_id, su.DontSampleUnit
FROM SampleUnit su, SamplePlan sp 
WHERE su.SamplePlan_id = sp.SamplePlan_id
 AND su.ParentSampleUnit_id=@SampleUnitId

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


GO

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectSampleUnitsBySurveyId]    Script Date: 7/24/2014 10:11:58 AM ******/
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
 su.SUServices, su.bitSuppress, su.bitHCAHPS, su.bitACOCAHPS, su.bitHHCAHPS, su.bitCHART, su.bitMNCM,
 su.SampleSelectionType_id, su.samplePlan_id, su.DontSampleUnit
FROM SampleUnit su, SamplePlan sp
WHERE su.SamplePlan_id = sp.SamplePlan_id
AND sp.Survey_id = @SurveyId

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF



GO

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_InsertSampleUnit]    Script Date: 7/24/2014 10:12:14 AM ******/
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



GO

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_UpdateSampleUnit]    Script Date: 7/24/2014 10:12:29 AM ******/
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



GO

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_InsertSurveyType]    Script Date: 7/24/2014 10:12:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[QCL_InsertSurveyType]
    @SurveyType_dsc    VARCHAR(100),
    @OptionType_id     INT,
    @SeedMailings      BIT,
    @SeedSurveyPercent INT,
    @SeedUnitField     VARCHAR(42)
AS

SET NOCOUNT ON

INSERT INTO [dbo].SurveyType (SurveyType_dsc, OptionType_id, SeedMailings, SeedSurveyPercent, SeedUnitField)
VALUES (@SurveyType_dsc, @OptionType_id, @SeedMailings, @SeedSurveyPercent, @SeedUnitField)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF

GO

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectAllSurveyTypes]    Script Date: 7/24/2014 10:13:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[QCL_SelectAllSurveyTypes]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT SurveyType_ID, SurveyType_dsc, OptionType_id, SeedMailings, SeedSurveyPercent, SeedUnitField
FROM [dbo].SurveyType

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectSurveyType]    Script Date: 7/24/2014 10:13:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[QCL_SelectSurveyType]
    @SurveyType_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT SurveyType_ID, SurveyType_dsc, OptionType_id, SeedMailings, SeedSurveyPercent, SeedUnitField
FROM [dbo].SurveyType
WHERE SurveyType_ID = @SurveyType_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_UpdateSurveyType]    Script Date: 7/24/2014 10:13:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[QCL_UpdateSurveyType]
    @SurveyType_ID     INT,
    @SurveyType_dsc    VARCHAR(100),
    @OptionType_id     INT,
    @SeedMailings      BIT,
    @SeedSurveyPercent INT,
    @SeedUnitField     VARCHAR(42)
AS

SET NOCOUNT ON

UPDATE [dbo].SurveyType 
SET SurveyType_dsc = @SurveyType_dsc,
    OptionType_id = @OptionType_id,
    SeedMailings = @SeedMailings,
    SeedSurveyPercent = @SeedSurveyPercent,
    SeedUnitField = @SeedUnitField
WHERE SurveyType_ID = @SurveyType_ID

SET NOCOUNT OFF

GO

USE [NRC_DataMart_ETL]
GO

/****** Object:  StoredProcedure [dbo].[csp_GetSampleUnitExtractData]    Script Date: 7/24/2014 10:14:17 AM ******/
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
	,Case When IsNull(sampleUnit.bitHCAHPS,0) = 0 And IsNull(SampleUnit.bitHHCAHPS,0) = 0 Then 0 Else 1 End  as [sampleUnit!1!isCahps]
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

USE [QP_Prod]
GO

/****** Object:  Table [dbo].[QUALPRO_PARAMS_History]    Script Date: 7/24/2014 10:15:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[QUALPRO_PARAMS_History](
	[jn_operation] [varchar](1) NULL,
	[jn_user] [varchar](100) NULL,
	[jn_datetime] [datetime] NULL,
	[jn_endtime] [datetime] NULL,
	[jn_notes] [varchar](240) NULL,
	[jn_SPID] [smallint] NULL,
	[PARAM_ID] [int] NOT NULL,
	[STRPARAM_NM] [varchar](50) NOT NULL,
	[STRPARAM_TYPE] [char](1) NOT NULL,
	[STRPARAM_GRP] [varchar](40) NOT NULL,
	[STRPARAM_VALUE] [varchar](255) NULL,
	[NUMPARAM_VALUE] [int] NULL,
	[DATPARAM_VALUE] [datetime] NULL,
	[COMMENTS] [varchar](255) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

