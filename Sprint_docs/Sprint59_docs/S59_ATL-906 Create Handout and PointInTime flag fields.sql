/*

S59_ATL-906 Create Handout and PointInTime flag fields.sql

Chris Burkholder

10/10/2016

Create Handout and PointInTime flag fields on the Survey definition table

select top 1 * from survey_def

EXEC sp_helptext 'dbo.QCL_InsertSurvey'
EXEC sp_helptext 'dbo.QCL_SelectClientGroupsClientsStudysAndSurveysByUser'
EXEC sp_helptext 'dbo.QCL_SelectClientsStudiesAndSurveysByUser'
EXEC sp_helptext 'dbo.QCL_SelectSurvey'
EXEC sp_helptext 'dbo.QCL_SelectSurveysByStudyId'
EXEC sp_helptext 'dbo.QCL_SelectSurveysBySurveyTypeMailOnly'
EXEC sp_helptext 'dbo.QCL_UpdateSurvey'

*/

Use [QP_Prod]
GO

ALTER TABLE Survey_Def
ADD IsHandout bit

GO

ALTER TABLE Survey_Def
ADD IsPointInTime bit

GO

UPDATE Survey_Def set IsHandout = 0, IsPointInTime = 0

GO

--select * from qualpro_params where strparam_grp = 'SurveyRules'

Insert into QualPro_Params (strparam_nm, strparam_type, strparam_grp, strparam_value, comments)
values ('SurveyRule: HandoutsPermitted - NRC/Picker','S','SurveyRules','1','Handouts are permitted for NRC/Picker')
Insert into QualPro_Params (strparam_nm, strparam_type, strparam_grp, strparam_value, comments)
values ('SurveyRule: HandoutsPermitted - Physician','S','SurveyRules','1','Handouts are permitted for Physician')
Insert into QualPro_Params (strparam_nm, strparam_type, strparam_grp, strparam_value, comments)
values ('SurveyRule: HandoutsPermitted - Employee','S','SurveyRules','1','Handouts are permitted for Employee')
Insert into QualPro_Params (strparam_nm, strparam_type, strparam_grp, strparam_value, comments)
values ('SurveyRule: HandoutsPermitted - NRC Canada','S','SurveyRules','1','Handouts are permitted for NRC Canada')
Insert into QualPro_Params (strparam_nm, strparam_type, strparam_grp, strparam_value, comments)
values ('SurveyRule: HandoutsPermitted - PostAcuteFam','S','SurveyRules','1','Handouts are permitted for PostAcuteFam')
Insert into QualPro_Params (strparam_nm, strparam_type, strparam_grp, strparam_value, comments)
values ('SurveyRule: HandoutsPermitted - PostAcuteRes','S','SurveyRules','1','Handouts are permitted for PostAcuteRes')

Insert into QualPro_Params (strparam_nm, strparam_type, strparam_grp, strparam_value, comments)
values ('SurveyRule: PointInTimeDisallowed - HCAHPS IP','S','SurveyRules','1','Point In Time is disallowed for HCAHPS IP')
Insert into QualPro_Params (strparam_nm, strparam_type, strparam_grp, strparam_value, comments)
values ('SurveyRule: PointInTimeDisallowed - Home Health CAHPS','S','SurveyRules','1','Point In Time is disallowed for Home Health CAHPS')
Insert into QualPro_Params (strparam_nm, strparam_type, strparam_grp, strparam_value, comments)
values ('SurveyRule: PointInTimeDisallowed - CGCAHPS','S','SurveyRules','1','Point In Time is disallowed for CGCAHPS')
Insert into QualPro_Params (strparam_nm, strparam_type, strparam_grp, strparam_value, comments)
values ('SurveyRule: PointInTimeDisallowed - Hospice CAHPS','S','SurveyRules','1','Point In Time is disallowed for Hospice CAHPS')
Insert into QualPro_Params (strparam_nm, strparam_type, strparam_grp, strparam_value, comments)
values ('SurveyRule: PointInTimeDisallowed - OAS CAHPS','S','SurveyRules','1','Point In Time is disallowed for OAS CAHPS')

--select * from surveytype

--select dbo.SurveyProperty('PointInTimeDisallowed',2,null) 'HCAHPS PIT NA', dbo.SurveyProperty('PointInTimeDisallowed',1,null) 'NRC/Picker PIT NA',dbo.SurveyProperty('HandoutsPermitted',2,null) 'HCAHPS PIT OK', dbo.SurveyProperty('HandoutsPermitted',1,null) 'NRC/Picker handout OK'

GO

ALTER PROCEDURE [dbo].[QCL_InsertSurvey]
    @Study_id                  INT,        
    @strSurvey_nm              VARCHAR(10),        
    @strSurvey_dsc             VARCHAR(40),        
    @intResponse_Recalc_Period INT,        
    @intResurvey_Period        INT,        
    @ReSurveyMethod_id         INT,  
    @datSurvey_Start_dt        DATETIME,        
    @datSurvey_End_dt          DATETIME,        
    @SamplingAlgorithm         INT,        
    @bitEnforceSkip            BIT,        
    @strCutoffResponse_cd      CHAR(1),        
    @CutoffTable_id            INT,        
    @CutoffField_id            INT,        
    @SampleEncounterTable_id   INT,  
    @SampleEncounterField_id   INT,  
    @strClientFacingName       VARCHAR(42),        
    @SurveyType_id             INT,        
    @SurveyTypeDef_id          INT,        
    @HouseHoldingType          CHAR(1),
    @Contract                  VARCHAR(9) = NULL,
    @Active                    BIT, 
    @ContractedLanguages       VARCHAR(50),
    @UseUSPSAddrChangeService  BIT,
	@IsHandout                 BIT,
	@IsPointInTime             BIT
AS

INSERT INTO Survey_Def (Study_id, strSurvey_Nm, strSurvey_Dsc, intResponse_Recalc_Period,         
                        intResurvey_Period, datSurvey_Start_Dt, datSurvey_End_Dt, SamplingAlgorithmID, 
                        bitEnforceSkip, strCutoffResponse_Cd, CutoffTable_id, CutoffField_id, 
                        SampleEncounterTable_id, SampleEncounterField_id, strClientFacingName, 
                        SurveyType_id, SurveyTypeDef_id, ReSurveyMethod_id, bitDynamic, 
                        strHouseholdingType, Contract, Active, ContractedLanguages, UseUSPSAddrChangeService,
						IsHandout, IsPointInTime) 
VALUES (@Study_id, @strSurvey_Nm, @strSurvey_Dsc, @intResponse_Recalc_Period, @intResurvey_Period,  
        @datSurvey_Start_Dt, @datSurvey_End_Dt, @SamplingAlgorithm, @bitEnforceSkip, @strCutoffResponse_Cd, 
        @CutoffTable_id, @CutoffField_id, @SampleEncounterTable_id, @SampleEncounterField_id, 
        @strClientFacingName, @SurveyType_id, @SurveyTypeDef_id, @ReSurveyMethod_id, 
        CASE WHEN @SamplingAlgorithm = 2 THEN 1 ELSE 0 END, @HouseHoldingType, @Contract, @Active, 
        @ContractedLanguages, @UseUSPSAddrChangeService, @IsHandout, @IsPointInTime)

SELECT SCOPE_IDENTITY()

GO

ALTER PROCEDURE [dbo].[QCL_SelectClientGroupsClientsStudysAndSurveysByUser]    
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
    Active bit,
	bitAutoSample bit
)    

--Need a temp table to hold the client groups
CREATE TABLE #ClientGroups (
    ClientGroup_id INT,
    ClientGroup_nm VARCHAR(50),
    ClientGroupReporting_nm VARCHAR(100),
    Active BIT,
    DateCreated DATETIME
)

--Populate the Client Group temp table
INSERT INTO #ClientGroups (ClientGroup_id, ClientGroup_nm, ClientGroupReporting_nm, Active, DateCreated)
VALUES (-1, 'Unassigned', 'Unassigned', 1, '01/01/2010')

INSERT INTO #ClientGroups (ClientGroup_id, 
ClientGroup_nm, ClientGroupReporting_nm, Active, DateCreated)
SELECT ClientGroup_id, ClientGroup_nm, ClientGroupReporting_nm, Active, DateCreated
FROM ClientGroups
ORDER BY ClientGroup_nm

--Populate the temp table with the studies they have rights to.   
 
INSERT INTO #EmpStudy (Client_id, Study_id, strStudy_nm, strStudy_dsc, ADEmployee_id,
	                   datCreate_dt, bitCleanAddr, bitProperCase, Active, bitAutoSample)    
SELECT st.Client_id, st.Study_id, st.strStudy_nm, st.strStudy_dsc, st.ADEmployee_id,
	   st.datCreate_dt, st.bitCleanAddr, st.bitProperCase, st.Active, bitAutosample  
FROM Employee em, Study_Employee se, Study st    
WHERE em.strNTLogin_nm = @UserName    
  AND em.Employee_id = se.Employee_id    
  AND se.Study_id = st.Study_id  
  AND st.datArchived IS NULL    
    
CREATE INDEX tmpIndex ON #EmpStudy (Client_id)    

--First recordset.  List of client groups they have rights to or all client groups
IF @ShowAllClients = 1
BEGIN
    SELECT ClientGroup_id, ClientGroup_nm, ClientGroupReporting_nm, Active, DateCreated
    FROM #ClientGroups
END
ELSE
BEGIN
    SELECT cg.ClientGroup_id, cg.ClientGroup_nm, cg.ClientGroupReporting_nm, cg.Active, cg.DateCreated
    FROM #EmpStudy es, Client cl, #ClientGroups cg
    WHERE es.Client_id = cl.CLIENT_ID
      AND ISNULL(cl.ClientGroup_ID, -1) = cg.ClientGroup_id
    GROUP BY cg.ClientGroup_id, cg.ClientGroup_nm, cg.ClientGroupReporting_nm, cg.Active, cg.DateCreated
END

--Second recordset.  List of clients they have rights to or all clients 
   
IF @ShowAllClients = 1
BEGIN
	SELECT Client_id, strClient_nm, Active, ISNULL(ClientGroup_ID, -1) AS ClientGroup_ID
	FROM Client
	ORDER BY strClient_nm
END
ELSE
BEGIN
	SELECT cl.Client_id, cl.strClient_nm, cl.Active, cl.ClientGroup_ID
	FROM #EmpStudy es, Client cl
	WHERE es.Client_id = cl.Client_id
	GROUP BY cl.Client_id, cl.strClient_nm, cl.Active, cl.ClientGroup_ID
	ORDER BY cl.strClient_nm
END
    
--Third recordset.  List of studies they have rights to    
SELECT Client_id, Study_id, strStudy_nm, strStudy_dsc, ADEmployee_id,
	   datCreate_dt, bitCleanAddr, bitProperCase, Active, bitAutoSample
FROM #EmpStudy
ORDER BY strStudy_nm
  
--Forth recordset.  List of surveys they have rights to  
SELECT sd.Survey_id, sd.strSurvey_nm, sd.strSurvey_dsc, sd.Study_id, sd.strCutoffResponse_cd,
       sd.CutoffTable_id, sd.CutoffField_id, sd.SampleEncounterTable_ID,
       sd.SampleEncounterField_ID, sd.bitValidated_flg, sd.datValidated,  
       sd.bitFormGenRelease, ISNULL(sp.SamplePlan_id,0) SamplePlan_id,  
       sd.INTRESPONSE_RECALC_PERIOD, sd.intResurvey_Period, sd.datSurvey_Start_dt,  
       sd.datSurvey_End_dt, sd.SamplingAlgorithmID, sd.bitEnforceSkip, sd.strClientFacingName,  
       sd.SurveyType_id, sd.SurveyTypeDef_id, sd.ReSurveyMethod_id, sd.strHouseholdingType,
	   sd.Contract, sd.Active, sd.ContractedLanguages, sd.UseUSPSAddrChangeService,
	   sd.IsHandout, sd.IsPointInTime
  FROM #EmpStudy es  
       JOIN Survey_def sd  
         ON es.Study_id = sd.Study_id  
       LEFT JOIN SamplePlan sp  
         ON sd.Survey_id = sp.Survey_id  
ORDER BY sd.strSurvey_nm  

--Cleanup temp table    
DROP TABLE #EmpStudy
DROP TABLE #ClientGroups

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF




GO

ALTER PROCEDURE [dbo].[QCL_SelectClientsStudiesAndSurveysByUser]  
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
    Active bit,
	bitAutoSample bit
)  
  
--Populate the temp table with the studies they have rights to.  
INSERT INTO #EmpStudy (Client_id, Study_id, strStudy_nm, strStudy_dsc, ADEmployee_id,
	        datCreate_dt, bitCleanAddr, bitProperCase, Active, bitAutoSample)  
SELECT s.Client_id, s.Study_id, s.strStudy_nm, s.strStudy_dsc, s.ADEmployee_id,
	   s.datCreate_dt, s.bitCleanAddr, s.bitProperCase, s.Active, bitAutosample
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
	   datCreate_dt, bitCleanAddr, bitProperCase, Active, bitAutoSample     
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
	   s.Contract, s.Active, s.ContractedLanguages, s.UseUSPSAddrChangeService,
	   s.IsHandout, s.IsPointInTime
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

ALTER PROCEDURE [dbo].[QCL_SelectSurvey]
    @SurveyId INT      
AS      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
SET NOCOUNT ON        
      
DECLARE @intSamplePlan_id int

SELECT @intSamplePlan_id = SamplePlan_id     
FROM dbo.SamplePlan    
WHERE Survey_id = @Surveyid 
    
SELECT Survey_id, strSurvey_Nm, strSurvey_Dsc, Study_id, strCutoffResponse_Cd, CutoffTable_id, 
       CutoffField_id, SampleEncounterTable_id, SampleEncounterField_id, bitValidated_Flg,
       datValidated, bitFormGenRelease, @intSamplePlan_id as SamplePlan_id, intResponse_Recalc_Period,  
       intResurvey_Period, datSurvey_Start_Dt, datSurvey_End_Dt, SamplingAlgorithmID, bitEnforceSkip,
       strClientFacingName, SurveyType_id, SurveyTypeDef_id, ReSurveyMethod_id, strHouseholdingType,  
	   Contract, Active, ContractedLanguages, UseUSPSAddrChangeService, IsHandout, IsPointInTime
FROM Survey_Def 
WHERE Survey_id = @SurveyId 

          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
SET NOCOUNT OFF

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
       sd.ContractedLanguages, sd.UseUSPSAddrChangeService, sd.IsHandout, sd.IsPointInTime
FROM Survey_Def sd, SamplePlan sp
WHERE sd.Study_id = @StudyId
  AND sd.survey_id = sp.survey_id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

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
       sd.ContractedLanguages, sd.UseUSPSAddrChangeService, sd.IsHandout, IsPointInTime
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

ALTER PROCEDURE [dbo].[QCL_UpdateSurvey]    
    @Survey_id                 INT,    
    @strSurvey_Nm              VARCHAR(10),    
    @strSurvey_Dsc             VARCHAR(40),    
    @intResponse_Recalc_Period INT,    
    @intResurvey_Period        INT,    
    @ReSurveyMethod_id         INT,    
    @datSurvey_Start_Dt        DATETIME,    
    @datSurvey_End_Dt          DATETIME,    
    @SamplingAlgorithm         INT,    
    @bitEnforceSkip            BIT,    
    @strCutoffResponse_Cd      CHAR(1),    
    @CutoffTable_id            INT,    
    @CutoffField_id            INT,  
    @SampleEncounterTable_id   INT,  
    @SampleEncounterField_id   INT,  
    @strClientFacingName       VARCHAR(42),    
    @SurveyType_id             INT,    
    @SurveyTypeDef_id          INT,  
    @HouseHoldingType          CHAR(1),  
    @IsValidated               BIT,  
    @datValidated              DATETIME,  
    @IsFormGenReleased         BIT,
    @Contract                  VARCHAR(9) = NULL,
    @Active                    BIT, 
    @ContractedLanguages       VARCHAR(50),
    @UseUSPSAddrChangeService   BIT,
	@IsHandout                  BIT,
	@IsPointInTime              BIT
AS
    
UPDATE Survey_Def    
SET strSurvey_Nm = @strSurvey_Nm,  
    strSurvey_Dsc = @strSurvey_Dsc,     
    intResponse_Recalc_Period = @intResponse_Recalc_Period,  
    intResurvey_Period = @intResurvey_Period,     
    datSurvey_Start_Dt = @datSurvey_Start_Dt,  
    datSurvey_End_Dt = @datSurvey_End_Dt,     
    SamplingAlgorithmID = @SamplingAlgorithm,  
    bitEnforceSkip = @bitEnforceSkip,     
    strCutoffResponse_Cd = @strCutoffResponse_Cd,  
    CutoffTable_id = @CutoffTable_id,     
    CutoffField_id = @CutoffField_id,  
    SampleEncounterTable_id = @SampleEncounterTable_id,  
    SampleEncounterField_id = @SampleEncounterField_id,  
    strClientFacingName = @strClientFacingName,     
    SurveyType_id = @SurveyType_id,  
    SurveyTypeDef_id = @SurveyTypeDef_id,    
    ReSurveyMethod_id = @ReSurveyMethod_id,  
    bitDynamic = CASE WHEN @SamplingAlgorithm = 2 THEN 1 ELSE 0 END,  
    strHouseholdingType = @HouseHoldingType,  
    bitValidated_Flg = @IsValidated,  
    datValidated = @datValidated,  
    bitFormGenRelease = @IsFormGenReleased,
    Contract = @Contract,
    Active = @Active, 
    ContractedLanguages = @ContractedLanguages,
    UseUSPSAddrChangeService = @UseUSPSAddrChangeService,
	IsHandout = @IsHandout,
	IsPointInTime = @IsPointInTime 
WHERE Survey_id = @Survey_id


GO

