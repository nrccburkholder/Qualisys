/*
	    RTP-2395 Sampling - re-survey exclusion rule.sql

		Chris Burkholder

		5/30/2017

		INSERT to QUALPRO_PARAMS
		INSERT to SAMPLINGEXCLUSIONTYPES
		ADD COLUMN to SURVEY_DEF, Survey_DefTemplate
		ALTER QCL_SelectSurvey
		ALTER QCL_SelectSurveysByStudyId
		ALTER QCL_SelectSurveysBySurveyTypeMailOnly
		ALTER QCL_UpdateSurvey
		ALTER QCL_InsertSurvey

		ALTER QCL_SelectClientGroupsClientsStudysAndSurveysByUser
		ALTER QCL_SelectClientsStudiesAndSurveysByUser
		ALTER QCL_SampleSetResurveyExclusion_StaticPlus

		select t.name,c.name,* from sys.columns c inner join sys.tables t on c.object_id = t.object_id where c.name like '%resurvey%'
		select * from qualpro_params where strparam_nm like '%resurvey%'
		select * from surveytype
*/

use qp_prod
go

if not exists (select 1 from QualPro_params where strparam_nm = 'SurveyRule: ResurveyLocationProvider - Connect')
insert into qualpro_params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
values('SurveyRule: ResurveyLocationProvider - Connect','S','SurveyRules','1',NULL,NULL,'Resurvey by Location/Provider for Connect')

go

if not exists (select 1 from SamplingExclusionTypes where SamplingExclusionType_nm in ('ResurveyProvider','ResurveyLocation'))
insert into SamplingExclusionTypes 
	(SamplingExclusionType_nm,SamplingExclusionType_Desc)
values
	('ResurveyProvider','Respondent has been sent a survey for this provider in the last predefined time frame.'),
	('ResurveyLocation','Respondent has been sent a survey for this location in the last predefined time frame.')

go

if not exists(select * from sys.columns where name = 'LocationProviderResurveyDays'
			and object_id = object_id('dbo.survey_def'))
	alter table dbo.survey_def add LocationProviderResurveyDays int

if not exists(select * from sys.columns where name = 'LocationProviderResurveyDays'
			and object_id = object_id('rtphoenix.survey_defTemplate'))
	alter table rtphoenix.survey_defTemplate add LocationProviderResurveyDays int

GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
	   Contract, Active, ContractedLanguages, UseUSPSAddrChangeService, IsHandout, IsPointInTime,
	   LocationProviderResurveyDays
FROM Survey_Def 
WHERE Survey_id = @SurveyId 

          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
SET NOCOUNT OFF


GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
       sd.ContractedLanguages, sd.UseUSPSAddrChangeService, sd.IsHandout, sd.IsPointInTime,
	   sd.LocationProviderResurveyDays
FROM Survey_Def sd, SamplePlan sp
WHERE sd.Study_id = @StudyId
  AND sd.survey_id = sp.survey_id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
       sd.ContractedLanguages, sd.UseUSPSAddrChangeService, sd.IsHandout, IsPointInTime,
	   sd.LocationProviderResurveyDays
FROM Client cl, Study st, Survey_Def sd, SamplePlan sp, MailingMethodology ma, MailingStep ms, MailingStepMethod mm
WHERE cl.Client_id = st.Client_id
  AND st.Study_id = sd.Study_id
  AND sd.survey_id = sp.survey_id
  AND sd.Survey_id = ma.Survey_id
  AND ma.bitActiveMethodology = 1
  AND ma.Survey_id = ms.Survey_id
  AND ma.Methodology_id = ms.Methodology_id
  AND ms.MailingStepMethod_id = mm.MailingStepMethod_id
  and ms.bitSendSurvey = 1
  AND mm.IsNonMailGeneration = 0
  AND sd.SurveyType_id = @SurveyType_id
  AND cl.Active = 1
  AND st.Active = 1
  AND sd.Active = 1

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
	@IsPointInTime              BIT,
	@LocationProviderResurveyDays INT
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
	IsPointInTime = @IsPointInTime,
	LocationProviderResurveyDays = @LocationProviderResurveyDays
WHERE Survey_id = @Survey_id



GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
	@IsPointInTime             BIT,
	@LocationProviderResurveyDays INT
AS

INSERT INTO Survey_Def (Study_id, strSurvey_Nm, strSurvey_Dsc, intResponse_Recalc_Period,         
                        intResurvey_Period, datSurvey_Start_Dt, datSurvey_End_Dt, SamplingAlgorithmID, 
                        bitEnforceSkip, strCutoffResponse_Cd, CutoffTable_id, CutoffField_id, 
                        SampleEncounterTable_id, SampleEncounterField_id, strClientFacingName, 
                        SurveyType_id, SurveyTypeDef_id, ReSurveyMethod_id, bitDynamic, 
                        strHouseholdingType, Contract, Active, ContractedLanguages, UseUSPSAddrChangeService,
						IsHandout, IsPointInTime, LocationProviderResurveyDays) 
VALUES (@Study_id, @strSurvey_Nm, @strSurvey_Dsc, @intResponse_Recalc_Period, @intResurvey_Period,  
        @datSurvey_Start_Dt, @datSurvey_End_Dt, @SamplingAlgorithm, @bitEnforceSkip, @strCutoffResponse_Cd, 
        @CutoffTable_id, @CutoffField_id, @SampleEncounterTable_id, @SampleEncounterField_id, 
        @strClientFacingName, @SurveyType_id, @SurveyTypeDef_id, @ReSurveyMethod_id, 
        CASE WHEN @SamplingAlgorithm = 2 THEN 1 ELSE 0 END, @HouseHoldingType, @Contract, @Active, 
        @ContractedLanguages, @UseUSPSAddrChangeService, @IsHandout, @IsPointInTime,
		@LocationProviderResurveyDays)

SELECT SCOPE_IDENTITY()

go

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [dbo].[QCL_SelectClientGroupsClientsStudysAndSurveysByUser]    Script Date: 6/1/2017 9:15:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
    DateCreated DATETIME,
	AllowAutoSample BIT
)

--Populate the Client Group temp table
INSERT INTO #ClientGroups (ClientGroup_id, ClientGroup_nm, ClientGroupReporting_nm, Active, DateCreated, AllowAutoSample)
VALUES (-1, 'Unassigned', 'Unassigned', 1, '01/01/2010',0)

INSERT INTO #ClientGroups (ClientGroup_id, 
ClientGroup_nm, ClientGroupReporting_nm, Active, DateCreated, AllowAutoSample)
SELECT ClientGroup_id, ClientGroup_nm, ClientGroupReporting_nm, Active, DateCreated, AllowAutoSample
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
    SELECT ClientGroup_id, ClientGroup_nm, ClientGroupReporting_nm, Active, DateCreated,AllowAutoSample
    FROM #ClientGroups
END
ELSE
BEGIN
    SELECT cg.ClientGroup_id, cg.ClientGroup_nm, cg.ClientGroupReporting_nm, cg.Active, cg.DateCreated, cg.AllowAutoSample
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
  
--Fourth recordset.  List of surveys they have rights to  
SELECT sd.Survey_id, sd.strSurvey_nm, sd.strSurvey_dsc, sd.Study_id, sd.strCutoffResponse_cd,
       sd.CutoffTable_id, sd.CutoffField_id, sd.SampleEncounterTable_ID,
       sd.SampleEncounterField_ID, sd.bitValidated_flg, sd.datValidated,  
       sd.bitFormGenRelease, ISNULL(sp.SamplePlan_id,0) SamplePlan_id,  
       sd.INTRESPONSE_RECALC_PERIOD, sd.intResurvey_Period, sd.datSurvey_Start_dt,  
       sd.datSurvey_End_dt, sd.SamplingAlgorithmID, sd.bitEnforceSkip, sd.strClientFacingName,  
       sd.SurveyType_id, sd.SurveyTypeDef_id, sd.ReSurveyMethod_id, sd.strHouseholdingType,
	   sd.Contract, sd.Active, sd.ContractedLanguages, sd.UseUSPSAddrChangeService,
	   sd.IsHandout, sd.IsPointInTime, sd.LocationProviderResurveyDays
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

go
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [dbo].[QCL_SelectClientsStudiesAndSurveysByUser]      Script Date: 6/1/2017 9:15:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	   s.IsHandout, s.IsPointInTime, s.LocationProviderResurveyDays
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

go
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [dbo].[QCL_SampleSetResurveyExclusion_StaticPlus]    Script Date: 6/1/2017 9:15:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Business Purpose:
This procedure is used to support the Qualisys Class Library.  It determines
which records should be DQ'd because of resurvey exclusion

Created:  02/28/2006 by DC

Modified:
03/01/2006 BY Brian Dohmen  Incorporated Calendar Month as a resurvey method.
10/05/2007 Steve Spicka - Modified Calendar Month resurvey exclusion.
       Only HCAHPS unit encounters cause exclusion.
       Picker only units can may not be excluded.
       Temporary HCAHPS solution until sampling can be re-written
10/14/2009 Michael Beltz - added survey_ID var so we can check for the actual
       resurvey month variable instead of hard coding to 1
12/08/2009 Michael Beltz - Added not exists check to vw_Billians_NursingHomeAssistedLiving
    to make sure we do not household nursing or assisted living homes.

12/10/2009 by MWB
  Added inserts into SamplingExclusion_Log to log all occurances of
  exclusions for all Static Plus Samples

5/10/2011 DRM
  Added code to replace 9999999 with '12/31/4000' for ISNULL on date fields

08/30/2013 Lee Kohrs
  Removed the following snippet to improve performance
  -- and not exists ( select ''x'' from dbo.vw_Billians_NursingHomeAssistedLiving v
  --   where isnull(v.Street_Address, '''') = isnull(p.addr, '''') and
  --     isnull(v.mail_Address, '''') = isnull(p.addr2, '''') and
  --     isnull(v.city, '''') = isnull(p.city, '''') and
  --     isnull(v.state, '''') = isnull(p.st, '''') and
  --     isnull(substring(v.street_zip,1,5), '''') = isnull(p.zip5, '''')
  Added the following to delete records matching the vw_Billians_NursingHomeAssistedLiving view
    DELETE #Distinct
    FROM   #Distinct d
       INNER JOIN vw_Billians_NursingHomeAssistedLiving v
               ON d.POPULATIONAddr = v.Street_Address
                  AND d.POPULATIONaddr2 = v.mail_Address
                  AND d.POPULATIONcity = v.city
                  AND d.POPULATIONst = v.state
                  AND d.POPULATIONzip5 = LEFT(v.street_zip, 5)

11/25/2013 Dave Hansen - CanadaQualisysUpgrade - DFCT0010966 - conditioned delete/update statements using
													vw_Billians_NursingHomeAssistedLiving to be run in country=US only

02/26/2016 Dave Gilsdorf - added D_HH index on #Distinct 

03/28/2017 Chris Burkholder - ATL-1419 added logic to handle the Resurvey Exclusion Type of Returns Only

06/01/2017 Chris Burkholder - RTP-2395 sampling re-survey exclusion rule, add location/provider days

*/
ALTER PROCEDURE [dbo].[QCL_SampleSetResurveyExclusion_StaticPlus]
  @Study_id                      INT,
  @Survey_ID                     INT,
  @ReSurveyMethod_id             INT,
  @ReSurvey_Excl_Period          INT,
  @SamplingAlgorithmID           INT,
  @strHouseholdField_CreateTable VARCHAR(8000),/* List of fields and type that are used for HouseHolding criteria */
  @strHouseholdField_Select      VARCHAR(8000),/* List of fields that are used for HouseHolding criteria */
  @strHousehold_Join             VARCHAR(8000),
  @HouseHoldingType              CHAR(1),
  @Sampleset_ID                  INT = 0,
  @indebug                       INT = 0
AS
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @minDate        DATETIME,
          @maxDate        DATETIME,
          @sql            VARCHAR(max),
          @ResurveyMonths INT
  DECLARE @surveyType_ID INT

  SET @ResurveyMonths = 1

  IF @indebug = 1
    PRINT 'Start QCL_SampleSetResurveyExclusion_StaticPlus'

  SELECT @ResurveyMonths = INTRESURVEY_PERIOD
  FROM   dbo.SURVEY_DEF
  WHERE  SURVEY_ID = @Survey_ID
         AND ReSurveyMethod_id = 2

  SELECT @surveyType_ID = surveyType_ID
  FROM   dbo.survey_Def
  WHERE  survey_ID = @survey_ID

  SELECT @minDate = MIN(EncDate),
         @maxDate = MAX(EncDate)
  FROM   #SampleUnit_Universe

  SELECT @minDate = dbo.FirstDayOfMonth(DATEADD(MONTH, ((@ResurveyMonths - 1) * -1), dbo.FirstDayOfMonth(@minDate)))

  SELECT @maxDate = DATEADD(SECOND, -1, DATEADD(MONTH, 1, dbo.FirstDayOfMonth(@maxDate)))

  IF @ReSurveyMethod_id = 1  --Resurvey Days
    BEGIN
      IF EXISTS (SELECT *
                 FROM   tempdb.dbo.sysobjects o
                 WHERE  o.xtype IN ('U')
                        AND o.id = OBJECT_ID(N'tempdb..#Remove_Pops'))
        DROP TABLE #Remove_Pops;

	  IF EXISTS (SELECT *
				FROM   tempdb.dbo.sysobjects o
				WHERE  o.xtype IN ('U')
					AND o.id = OBJECT_ID(N'tempdb..#Remove_PopsProvider'))
		DROP TABLE #Remove_PopsProvider;

	  IF EXISTS (SELECT *
				FROM   tempdb.dbo.sysobjects o
				WHERE  o.xtype IN ('U')
					AND o.id = OBJECT_ID(N'tempdb..#Remove_PopsLocation'))
		DROP TABLE #Remove_PopsLocation;

	  --ATL-1419 ResurveyExclusionType ReturnsOnly -> only resurvey exclude those with a return for Returns Only subtype
		CREATE TABLE #Remove_Pops(Pop_id int)
		CREATE TABLE #Remove_PopsProvider(Pop_id int)
		CREATE TABLE #Remove_PopsLocation(Pop_id int)
		
		if exists(select st.subtype_nm from dbo.surveysubtype sst inner join 
				dbo.subtype st on st.Subtype_id = sst.Subtype_id 
				where survey_id = @survey_ID and
					st.subtype_nm = 'Returns Only')
			INSERT INTO #Remove_Pops (Pop_id)
			SELECT DISTINCT
					sp.Pop_id
			FROM   dbo.SamplePop sp
					INNER JOIN dbo.SampleSet ss ON sp.SampleSet_id = ss.SampleSet_id
					INNER JOIN dbo.QUESTIONFORM qf on sp.SAMPLEPOP_ID = qf.SAMPLEPOP_ID --ATL-1419
			WHERE  Study_id = @Study_id
					AND (DATEDIFF(day, ss.datLastMailed, GETDATE()) < @Resurvey_Excl_Period
						OR ss.datLastMailed IS NULL)
					AND (qf.DATRETURNED is not null) --ATL-1419
		else
			INSERT INTO #Remove_Pops (Pop_id)
			SELECT DISTINCT
					sp.Pop_id
			FROM   dbo.SamplePop sp
					 INNER JOIN dbo.SampleSet ss ON sp.SampleSet_id = ss.SampleSet_id
			WHERE  Study_id = @Study_id
					 AND (DATEDIFF(day, ss.datLastMailed, GETDATE()) < @Resurvey_Excl_Period
						   OR ss.datLastMailed IS NULL)

		--ATL-1419 END ResurveyExclusionType ReturnsOnly -> only resurvey exclude those with a return for Returns Only subtype

		--RTP-2395 ResurveyExclusion for RT: ResurveyType='P' -> use (Provider) DrNPI (on Encounter table)
		--	                               ResurveyType='L' -> use LocationBK (on Encounter table)
		--         Length of Time: LocationProviderSurveyDays (on Survey_Def table)
		--         Also Join To: SelectedSample

		DECLARE @LocationProviderResurveyDays int
		SELECT @LocationProviderResurveyDays = LocationProviderResurveyDays from Survey_DEF where survey_id = @survey_id

		if @LocationProviderResurveyDays > 0 
			and dbo.SurveyProperty('ResurveyLocationProvider',@surveytype_id,null) = 1
		BEGIN
			IF EXISTS(select 1 from sys.columns c inner join sys.tables t on c.object_id = t.object_id inner join sys.schemas s on t.schema_id = s.schema_id 
				where t.name = 'ENCOUNTER' and c.name = 'ResurveyType' and s.name = 'S' + convert(nvarchar, @study_id))
			BEGIN
				--if any Resurvey Type other than 'P' or 'L' then bail out
				Declare @countResurveyTypeOther int = 0
				Declare @sqlResurveyTypeOther nvarchar(200) = 'select @count = count(*) from s' + convert(nvarchar, @study_id) + '.encounter where ResurveyType not in (''P'',''L'') or ResurveyType is null'
				exec sp_executesql @sqlResurveyTypeOther, N'@count int out', @countResurveyTypeOther out
				if @countResurveyTypeOther > 0
				BEGIN
					declare @ResurveyTypeOtherError varchar(100) = 'ResurveyType column is present on s' + convert(nvarchar, @study_id) + '.encounter but contains values other than ''P'' or ''L''.'
					RAISERROR(@ResurveyTypeOtherError, 16, 1)
					RETURN --exit now
				END

				--if any Resurvey Type of Provider, then DrNPI must be present
				Declare @countResurveyTypeProvider int = 0
				Declare @sqlResurveyTypeProvider nvarchar(200) = 'select @count = count(*) from s' + convert(nvarchar, @study_id) + '.encounter where ResurveyType =''P'''
				exec sp_executesql @sqlResurveyTypeProvider, N'@count int out', @countResurveyTypeProvider out

				if @countResurveyTypeProvider > 0 
				IF NOT EXISTS(select 1 from sys.columns c inner join sys.tables t on c.object_id = t.object_id inner join sys.schemas s on t.schema_id = s.schema_id 
					where t.name = 'ENCOUNTER' and c.name = 'DrNPI' and s.name = 'S' + convert(nvarchar, @study_id))
					BEGIN
						declare @drNPIError varchar(100) = 'DrNPI column not present on s' + convert(nvarchar, @study_id) + '.encounter.'
						RAISERROR(@drNPIError, 16, 1)
						RETURN --exit now
					END
					ELSE --INSERT INTO #Remove_PopsProvider based on DrNPI/Provider
					BEGIN
						select @sql =
						N'INSERT INTO #Remove_PopsProvider (Pop_id)
						SELECT DISTINCT								
								eToday.Pop_id
						FROM   (select suu.Pop_id, suu.Enc_id, e.drNPI
								from #SampleUnit_Universe suu inner join 
									s' + convert(nvarchar, @study_id) +
									N'.encounter e on suu.enc_id = e.enc_id) eToday
								 INNER JOIN 
								(select e.enc_id, e.pop_id, e.drNPI
								from s' + convert(nvarchar, @study_id) + N'.encounter e inner join
								 dbo.SelectedSample ss ON e.enc_id = ss.enc_id
								WHERE  DATEDIFF(day, ss.SampleEncounterDate, GETDATE()) < ' + Convert(nvarchar,@LocationProviderResurveyDays) + N') eHistory
								 ON eToday.pop_id = eHistory.pop_id 
								 and eToday.drNPI = eHistory.drNPI 
								 and eToday.enc_id <> eHistory.enc_id'
						
						exec (@sql)
					END

				--if any Resurvey Type of Location, then LocationBK must be present
				Declare @countResurveyTypeLocation int = 0
				Declare @sqlResurveyTypeLocation nvarchar(200) = 'select @count = count(*) from s' + convert(nvarchar, @study_id) + '.encounter where ResurveyType =''L'''
				exec sp_executesql @sqlResurveyTypeLocation, N'@count int out', @countResurveyTypeLocation out

				if @countResurveyTypeLocation > 0 
					IF NOT EXISTS(select 1 from sys.columns c inner join sys.tables t on c.object_id = t.object_id inner join sys.schemas s on t.schema_id = s.schema_id 
						where t.name = 'ENCOUNTER' and c.name = 'LocationBK' and s.name = 'S' + convert(nvarchar, @study_id))
					BEGIN
						declare @locationBKError varchar(100) = 'LocationBK column not present on s' + convert(nvarchar, @study_id) + '.encounter.'
						RAISERROR(@locationBKError, 16, 1)
						RETURN --exit now
					END
					ELSE --INSERT INTO #Remove_PopsLocation based on LocationBK/NonProvider
					BEGIN
						select @sql =
						N'INSERT INTO #Remove_PopsLocation (Pop_id)
						SELECT DISTINCT								
								eToday.Pop_id
						FROM   (select suu.Pop_id, suu.Enc_id, e.LocationBK
								from #SampleUnit_Universe suu inner join 
									s' + convert(nvarchar, @study_id) +
									N'.encounter e on suu.enc_id = e.enc_id) eToday
								 INNER JOIN 
								(select e.enc_id, e.pop_id, e.LocationBK
								from s' + convert(nvarchar, @study_id) + N'.encounter e inner join
								 dbo.SelectedSample ss ON e.enc_id = ss.enc_id
								WHERE  DATEDIFF(day, ss.SampleEncounterDate, GETDATE()) < ' + Convert(nvarchar,@LocationProviderResurveyDays) + N') eHistory
								 ON eToday.pop_id = eHistory.pop_id 
								 and eToday.LocationBK = eHistory.LocationBK 
								 and eToday.enc_id <> eHistory.enc_id'
						
						exec (@sql)
					END

			END -- IF...where t.name = 'ENCOUNTER' and c.name = 'ResurveyType' and s.name = 's' + convert(nvarchar, @study_id)) 
			ELSE
			BEGIN
				declare @resurveyTypeError varchar(100) = 'ResurveyType column not present on s' + convert(nvarchar, @study_id) + '.encounter.'
				RAISERROR(@resurveyTypeError, 16, 1)
				RETURN --exit now
			END
		END --IF @LocationProviderResurveyDays > 0 
		--RTP-2395 END

      --Removed Rule value of 1 means it is resurvey exclusion.  This is not a bit field.
      UPDATE #SampleUnit_Universe
      SET    Removed_Rule = 1
      FROM   #SampleUnit_Universe U
             INNER JOIN (select pop_id from #Remove_Pops UNION 
						 select pop_id from #Remove_PopsProvider UNION 
						 select pop_id from #Remove_PopsLocation) MM ON U.Pop_id = MM.Pop_id
      WHERE  isnull(Removed_Rule, 0) = 0

      INSERT INTO dbo.Sampling_ExclusionLog
                  (Survey_ID, Sampleset_ID, Sampleunit_ID,
                   Pop_ID, Enc_ID, SamplingExclusionType_ID,
                   DQ_BusRule_ID)
      SELECT @survey_ID AS Survey_ID, @Sampleset_ID AS Sampleset_ID, Sampleunit_ID,
             U.Pop_ID, U.Enc_ID, 1 AS SamplingExclusionType_ID,
             NULL AS DQ_BusRule_ID
      FROM   #SampleUnit_Universe U
	         INNER JOIN #Remove_Pops MM ON U.Pop_id = MM.Pop_id

      INSERT INTO dbo.Sampling_ExclusionLog
                  (Survey_ID, Sampleset_ID, Sampleunit_ID,
                   Pop_ID, Enc_ID, SamplingExclusionType_ID,
                   DQ_BusRule_ID)
      SELECT @survey_ID AS Survey_ID, @Sampleset_ID AS Sampleset_ID, Sampleunit_ID,
             U.Pop_ID, U.Enc_ID, 11 AS SamplingExclusionType_ID,
             NULL AS DQ_BusRule_ID
      FROM   #SampleUnit_Universe U
	         INNER JOIN #Remove_PopsProvider MM ON U.Pop_id = MM.Pop_id

      INSERT INTO dbo.Sampling_ExclusionLog
                  (Survey_ID, Sampleset_ID, Sampleunit_ID,
                   Pop_ID, Enc_ID, SamplingExclusionType_ID,
                   DQ_BusRule_ID)
      SELECT @survey_ID AS Survey_ID, @Sampleset_ID AS Sampleset_ID, Sampleunit_ID,
             U.Pop_ID, U.Enc_ID, 12 AS SamplingExclusionType_ID,
             NULL AS DQ_BusRule_ID
      FROM   #SampleUnit_Universe U
	         INNER JOIN #Remove_PopsLocation MM ON U.Pop_id = MM.Pop_id

      IF EXISTS (SELECT *
                 FROM   tempdb.dbo.sysobjects o
                 WHERE  o.xtype IN ('U')
                        AND o.id = OBJECT_ID(N'tempdb..#Remove_Pops'))
        DROP TABLE #Remove_Pops

	  IF EXISTS (SELECT *
				FROM   tempdb.dbo.sysobjects o
				WHERE  o.xtype IN ('U')
					AND o.id = OBJECT_ID(N'tempdb..#Remove_PopsProvider'))
		DROP TABLE #Remove_PopsProvider;

	  IF EXISTS (SELECT *
				FROM   tempdb.dbo.sysobjects o
				WHERE  o.xtype IN ('U')
					AND o.id = OBJECT_ID(N'tempdb..#Remove_PopsLocation'))
		DROP TABLE #Remove_PopsLocation;

    END  --if @ReSurveyMethod_id = 1
  ELSE IF @ReSurveyMethod_id = 2  --Calendar month
    BEGIN
      UPDATE #SampleUnit_Universe
      SET    ReSurveyDate = dbo.FirstDayOfMonth(EncDate)

      IF EXISTS (SELECT *
                 FROM   tempdb.dbo.sysobjects o
                 WHERE  o.xtype IN ('U')
                        AND o.id = OBJECT_ID(N'tempdb..#ReSurvey'))
        DROP TABLE #ReSurvey;

      CREATE TABLE #ReSurvey (pop_ID       INT,
							  enc_ID	   INT,
	                          CCN          VARCHAR(20),
                              ReSurveyDate DATETIME)

  	  DECLARE @IntResurvey_Period int
	  select @IntResurvey_Period = INTRESURVEY_PERIOD from survey_def where survey_id = @survey_id

      --if HCAHPS / OAS
      IF dbo.SurveyProperty('DoesResurveyByCCN', @surveyType_ID, null) = 1 -- in (2, 16)
        BEGIN
          --Get the distinct months of the reportdate for each pop_id
          INSERT INTO #ReSurvey (pop_ID, enc_ID, CCN, ReSurveyDate)
		  SELECT DISTINCT 
				 a.Pop_id,
				 a.Enc_id,
				 a.CCN,
				 dbo.FirstDayOfMonth(sampleEncounterDate) ReSurveyDate
          FROM   (
                 --Get all the reportdates for all the eligible records for sample
                 SELECT t.Pop_id,
						t.Enc_id,
             sampleEncounterDate,
						suf.MedicareNumber as CCN
                  FROM  dbo.SelectedSample ss
                        INNER JOIN dbo.SampleUnit su ON ss.sampleunit_id = su.sampleunit_Id
                        INNER JOIN #SampleUnit_Universe t ON t.Pop_id = ss.Pop_id
						INNER JOIN SUFacility suf on su.SUFacility_ID = suf.SUFacility_ID
                  WHERE su.CAHPSType_id = @surveyType_ID
                        AND ss.Study_id = @Study_id
                        AND sampleEncounterDate BETWEEN @minDate AND @maxDate) a

          CREATE INDEX tmpIndex
            ON #ReSurvey (Pop_id)

          UPDATE u
          SET    Removed_Rule = 1
          FROM   #SampleUnit_Universe U
                 INNER JOIN SampleUnit su 
					ON u.sampleunit_id=su.sampleunit_id 
					AND su.CAHPSType_id = @surveyType_ID 
                 INNER JOIN SUFacility suf ON su.SUFacility_ID = suf.SUFacility_ID
                 INNER JOIN #ReSurvey MM 
					ON U.Pop_id = MM.Pop_id 
					AND mm.resurveydate >= dateadd(month, ((@IntResurvey_Period - 1) * -1), u.ReSurveyDate)
					AND suf.MedicareNumber=mm.CCN
          WHERE  isnull(Removed_Rule, 0) = 0

        END  --dbo.SurveyProperty('DoesResurveyByCCN', @surveyType_ID, null) = 1 -- in (2, 16/HCAHPS, OAS CAHPS)
      ELSE
	  IF dbo.SurveyProperty('DoesResurvey', @surveyType_ID, null) = 1 -- in (3,12/HHCAHPS,CIHI)
        BEGIN
          --Get the distinct months of the reportdate for each pop_id
          INSERT INTO #ReSurvey (pop_ID, Enc_id, ReSurveyDate)
          SELECT DISTINCT 
				 a.Pop_id,
				 a.Enc_id,
				 --a.CCN,
                 dbo.FirstDayOfMonth(a.sampleEncounterDate) ReSurveyDate
          FROM   (
                 --Get all the reportdates for all the eligible records for sample
                 SELECT t.Pop_id,
						t.Enc_id,
                        sampleEncounterDate
                  FROM   dbo.SelectedSample ss
                        INNER JOIN dbo.SampleUnit su ON ss.sampleunit_id = su.sampleunit_Id
                        INNER JOIN #SampleUnit_Universe t ON t.Pop_id = ss.Pop_id
						--INNER JOIN SUFacility suf on su.SUFacility_ID = suf.SUFacility_ID
                  WHERE  su.CAHPSType_id = @surveyType_ID
                         AND ss.Study_id = @Study_id
                         AND sampleEncounterDate BETWEEN @minDate AND @maxDate) a

          CREATE INDEX tmpIndex
            ON #ReSurvey (Pop_id)

          UPDATE u
          SET    Removed_Rule = 1
          FROM   #SampleUnit_Universe U
                 --INNER JOIN SUFacility suf ON su.SUFacility_ID = suf.SUFacility_ID
				 INNER JOIN #ReSurvey MM 
					ON U.Pop_id = MM.Pop_id
					AND mm.resurveydate >= dateadd(month, ((@IntResurvey_Period - 1) * -1), u.ReSurveyDate)
					--AND suf.MedicareNumber=mm.CCN
          WHERE isnull(Removed_Rule, 0) = 0

        END  -- dbo.SurveyProperty('DoesResurvey', @surveyType_ID, null) = 1) -- in (3,12)

		--Assign the encounters just marked as removed to other sampleunit/encounter pairs for that encounter
        UPDATE u
        SET    Removed_Rule = 1
        FROM   #SampleUnit_Universe U
                INNER JOIN #SampleUnit_Universe U2 on U.enc_id = U2.enc_id and U2.Removed_Rule = 1
		WHERE  isnull(u.Removed_Rule, 0) = 0

		--use removed rule = 1 to determine all rows to insert in the exclusion log
        INSERT INTO dbo.Sampling_ExclusionLog
                    (Survey_ID,
                    Sampleset_ID,
                    Sampleunit_ID,
                    Pop_ID,
                    Enc_ID,
                    SamplingExclusionType_ID,
                    DQ_BusRule_ID)
        SELECT @survey_ID AS Survey_ID,
                @Sampleset_ID AS Sampleset_ID,
                U.Sampleunit_ID,
                U.Pop_ID,
                U.Enc_ID,
                1 AS SamplingExclusionType_ID,
                NULL AS DQ_BusRule_ID
        FROM   #SampleUnit_Universe U
        WHERE  isnull(Removed_Rule, 0) = 1 --was set to 1 in the UPDATES just prior and further back

        IF EXISTS (SELECT *
                    FROM   tempdb.dbo.sysobjects o
                    WHERE  o.xtype IN ('U')
                        AND o.id = OBJECT_ID(N'tempdb..#ReSurvey'))
        DROP TABLE #ReSurvey;
    END  -- @ReSurveyMethod_id = 2

  --If Static Plus
  IF @SamplingAlgorithmID = 3
    BEGIN
      --Now to remove everyone in the household if anyone in the household is removed
      UPDATE #SampleUnit_Universe
      SET    HouseHold_id = id_Num
      WHERE  HouseHold_id IS NULL

      CREATE INDEX tmpIndex2
        ON #SampleUnit_Universe (HouseHold_id)

      UPDATE t
      SET    t.Removed_Rule = 1
      FROM   #SampleUnit_Universe t,
             (SELECT HouseHold_id
              FROM   #SampleUnit_Universe
              WHERE  Removed_Rule = 1
              GROUP  BY HouseHold_id) a
      WHERE  a.HouseHold_id = t.HouseHold_id

      UPDATE #SampleUnit_Universe
      SET    HouseHold_id = NULL
      WHERE  HouseHold_id = id_Num
    END

  --Now to expand to people not in this sample
  IF @HouseHoldingType = 'A'
     AND @ReSurveyMethod_id = 2   --Calendar month
    BEGIN
      -- all those REPLACE() and the SUBSTRING() change something like this:
      --  X.POPULATIONAddr, X.POPULATIONCity, X.POPULATIONST, X.POPULATIONZIP5, X.POPULATIONAddr2
      -- to this:
      -- ISNULL(Addr,9999999),ISNULL(City,9999999),ISNULL(ST,9999999),ISNULL(ZIP5,9999999),ISNULL(Addr2,9999999)

      SELECT @sql = 'CREATE TABLE #Distinct (a INT IDENTITY(-1,-1), ' + @strHouseHoldField_CreateTable + ', pop_id int, CCN varchar(20))
		  INSERT INTO #Distinct (' + @strHouseHoldField_Select + ', pop_id, CCN)
		  SELECT DISTINCT ' + SUBSTRING(REPLACE(REPLACE(REPLACE(@strHouseHoldField_Select, 'POPULATION', '')
			  , 'x.', ',9999999),ISNULL(p.')
			  , ', ,', ',')
			  , 12, 2000)
			  + ',9999999), p.pop_id, suf.MedicareNumber as CCN
		  FROM dbo.SelectedSample ss
		       INNER JOIN dbo.SampleUnit su ON ss.sampleunit_id=su.sampleunit_Id
			   INNER JOIN dbo.SUFacility suf on su.SUFacility_id = suf.SUFacility_id
		       INNER JOIN S' + LTRIM(STR(@Study_id)) + '.Population p ON ss.Pop_id=p.Pop_id
		  WHERE ss.Study_id=' + LTRIM(STR(@Study_id)) + '
		  AND sampleEncounterDate BETWEEN ''' + CONVERT(VARCHAR, @minDate) + ''' AND ''' + CONVERT(VARCHAR, @maxDate) + '''
		  and su.bitHCAHPS = 1

		CREATE NONCLUSTERED INDEX D_HH ON #Distinct ('+REPLACE(@strHouseHoldField_Select, 'X.', '')+', CCN)
										
		--11/25/2013 Dave Hansen - CanadaQualisysUpgrade - DFCT0010966 - conditioned delete/update statements using
		--													vw_Billians_NursingHomeAssistedLiving to be run in country=US only
		declare @country nvarchar(255)
		declare @environment nvarchar(255)
		exec dbo.sp_getcountryenvironment @ocountry=@country output, @oenvironment=@environment output
		IF @country=''US''
			DELETE #Distinct
			FROM   #Distinct d
			   INNER JOIN vw_Billians_NursingHomeAssistedLiving v
					   ON d.POPULATIONAddr = v.Street_Address
						  AND d.POPULATIONaddr2 = v.mail_Address
						  AND d.POPULATIONcity = v.city
						  AND d.POPULATIONst = v.state
						  AND d.POPULATIONzip5 = LEFT(v.street_zip, 5)

		  --select *
		  --into dbo.mb_Sampling_HHdistinct_' + CAST(@Sampleset_ID AS VARCHAR(10)) + '
		  --from #Distinct

		  UPDATE x
		  SET x.Removed_Rule=7
		  FROM #SampleUnit_Universe x, sampleunit su, SUFacility suf, #Distinct y
		  WHERE x.sampleunit_id = su.sampleunit_id 
		  and su.SUFacility_id = suf.SUFacility_id
		  and ' + REPLACE(REPLACE(@strHouseHold_Join, 'x.', 'ISNULL(X.'), '=', ',9999999)=') + '
		  and suf.MedicareNumber = y.CCN 
		  and isnull(x.removed_rule, 0) = 0

		  insert into dbo.Sampling_ExclusionLog (Survey_ID,Sampleset_ID,Sampleunit_ID,Pop_ID,Enc_ID,SamplingExclusionType_ID,DQ_BusRule_ID)
		  Select distinct ' + cast(@survey_ID AS VARCHAR(10)) + ' as Survey_ID, '
							+ cast(@Sampleset_ID AS VARCHAR(10)) + ' as Sampleset_ID, x.Sampleunit_ID, x.Pop_ID, x.Enc_ID, 7 as SamplingExclusionType_ID, Null as DQ_BusRule_ID
		  FROM #SampleUnit_Universe x, sampleunit su, SUFacility suf, #Distinct y
		  WHERE x.sampleunit_id = su.sampleunit_id 
		  and su.SUFacility_id = suf.SUFacility_id
		  and ' + REPLACE(REPLACE(@strHouseHold_Join, 'x.', 'ISNULL(X.'), '=', ',9999999)=') + '
		  and suf.MedicareNumber = y.CCN 
		  and x.removed_rule = 7

		--11/25/2013 Dave Hansen - CanadaQualisysUpgrade - DFCT0010966 - conditioned delete/update statements using
		--													vw_Billians_NursingHomeAssistedLiving to be run in country=US only
		IF @country=''US''
		  UPDATE x
		  SET x.Removed_Rule= -7
		  FROM #SampleUnit_Universe x, S' + LTRIM(STR(@Study_id)) + '.Population p
		  WHERE x.pop_ID = p.pop_ID
		  and x.removed_rule in (0, 7)
		  and exists     ( select ''x''
			 from dbo.vw_Billians_NursingHomeAssistedLiving v
			WHERE  isnull(p.addr, '''') = v.Street_Address
			   AND isnull(p.addr2, '''') = v.mail_Address
			   AND isnull(p.city, '''') = v.city
			   AND isnull(p.st, '''') = v.state
			   AND isnull(p.zip5, '''') = LEFT(v.street_zip, 5)
			 )

		  DROP TABLE #Distinct'

      SELECT @sql = replace(@sql, 'DOB,9999999', 'DOB,''12/31/4000''')

      SELECT @sql = replace(@sql, 'Date,9999999', 'Date,''12/31/4000''')

      IF @indebug = 1
        PRINT @sql

      EXEC (@sql)
    END
  ELSE IF @HouseHoldingType = 'A'
     AND @ReSurveyMethod_id = 1  -- resurvey days
    BEGIN
      SELECT @sql = 'CREATE TABLE #Distinct (a INT IDENTITY(-1,-1), ' + @strHouseHoldField_CreateTable + ')
		  INSERT INTO #Distinct (' + @strHouseHoldField_Select + ')
		  SELECT DISTINCT ' + SUBSTRING(REPLACE(REPLACE(REPLACE(@strHouseHoldField_Select, 'POPULATION', '')
					  , 'x.', ',9999999),ISNULL(')
					  , ', ,', ',')
					  , 12, 2000)
					  + ',9999999)
		  FROM dbo.SelectedSample ss
		       INNER JOIN dbo.SampleSet sset ON ss.SampleSet_id=sset.SampleSet_id
			   INNER JOIN S' + LTRIM(STR(@Study_id)) + '.Population p ON ss.Pop_id=p.Pop_id
		  WHERE ss.Study_id=' + LTRIM(STR(@Study_id)) + '
		  AND sset.datSampleCreate_dt>''' + CONVERT(VARCHAR, DATEADD(DAY, -@ReSurvey_Excl_Period, GETDATE())) + '''

		  CREATE NONCLUSTERED INDEX D_HH ON #Distinct ('+REPLACE(@strHouseHoldField_Select, 'X.', '')+')

		--11/25/2013 Dave Hansen - CanadaQualisysUpgrade - DFCT0010966 - conditioned delete/update statements using
		--													vw_Billians_NursingHomeAssistedLiving to be run in country=US only
		declare @country nvarchar(255)
		declare @environment nvarchar(255)
		exec dbo.sp_getcountryenvironment @ocountry=@country output, @oenvironment=@environment output
		IF @country=''US''
			DELETE #Distinct
			FROM   #Distinct d
			   INNER JOIN vw_Billians_NursingHomeAssistedLiving v
					   ON d.POPULATIONAddr = v.Street_Address
						  AND d.POPULATIONaddr2 = v.mail_Address
						  AND d.POPULATIONcity = v.city
						  AND d.POPULATIONst = v.state
						  AND d.POPULATIONzip5 = LEFT(v.street_zip, 5)

		  --select *
		  --into mb_Sampling_HHdistinct_' + CAST(@Sampleset_ID AS VARCHAR(10)) + '
		  --from #distinct

		  UPDATE x
		  SET x.Removed_Rule=7
		  FROM #SampleUnit_Universe x, #Distinct y
		  WHERE ' + REPLACE(REPLACE(@strHouseHold_Join, 'x.', 'ISNULL(X.'), '=', ',9999999)=') + '
		  and isnull(x.removed_rule, 0) = 0

		  insert into dbo.Sampling_ExclusionLog (Survey_ID,Sampleset_ID,Sampleunit_ID,Pop_ID,Enc_ID,SamplingExclusionType_ID,DQ_BusRule_ID)
		  Select distinct ' + cast(@survey_ID AS VARCHAR(10)) + ' as Survey_ID, '
							+ cast(@Sampleset_ID AS VARCHAR(10)) + ' as Sampleset_ID, x.Sampleunit_ID, x.Pop_ID, x.Enc_ID, 7 as SamplingExclusionType_ID, Null as DQ_BusRule_ID
		  FROM #SampleUnit_Universe x, #Distinct y
		  WHERE ' + REPLACE(REPLACE(@strHouseHold_Join, 'x.', 'ISNULL(X.'), '=', ',9999999)=') + '
		  and x.removed_rule = 7

		--11/25/2013 Dave Hansen - CanadaQualisysUpgrade - DFCT0010966 - conditioned delete/update statements using
		--													vw_Billians_NursingHomeAssistedLiving to be run in country=US only
		IF @country=''US''
		  UPDATE x
		  SET x.Removed_Rule= -7
		  FROM #SampleUnit_Universe x, S' + LTRIM(STR(@Study_id)) + '.Population p
		  WHERE x.pop_ID = p.pop_ID
		  and x.removed_rule = 7  /*** EXPERIMENT - DMP - 07/12/16 prevents enc samp 2x ***/
		  and exists     ( select ''x''
			from dbo.vw_Billians_NursingHomeAssistedLiving v
			WHERE  isnull(p.addr, '''') = v.Street_Address
			   AND isnull(p.addr2, '''') = v.mail_Address
			   AND isnull(p.city, '''') = v.city
			   AND isnull(p.st, '''') = v.state
			   AND isnull(p.zip5, '''') = LEFT(v.street_zip, 5)
			 )

		  DROP TABLE #Distinct'

      SELECT @sql = replace(@sql, 'DOB,9999999', 'DOB,''12/31/4000''')

      SELECT @sql = replace(@sql, 'Date,9999999', 'Date,''12/31/4000''')

      IF @indebug = 1
        PRINT @sql

      EXEC (@sql)
    END

  IF @indebug = 1
    PRINT 'End QCL_SampleSetResurveyExclusion_StaticPlus'
--test code should not be in production unless there is a specific sampling error
--insert into mb_sampling_samplesql
--select @sql as SQL


go
