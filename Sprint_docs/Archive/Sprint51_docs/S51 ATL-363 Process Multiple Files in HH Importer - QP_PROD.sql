/*

Tim Butler

ATL-363 Process Multiple Files in HH Importer

ALTER PROCEDURE [dbo].[QCL_SelectStudy]
ALTER PROCEDURE [dbo].[QCL_SelectStudiesByClientId]
ALTER PROCEDURE [dbo].[QCL_UpdateStudy]
ALTER PROCEDURE [dbo].[QCL_InsertStudy]
 
ALTER PROCEDURE [dbo].[QCL_SelectClientGroupsClientsAndStudiesByUser]
ALTER PROCEDURE [dbo].[QCL_SelectClientGroupsClientsStudysAndSurveysByUser] 
ALTER PROCEDURE [dbo].[QCL_SelectClientsAndStudiesByUser] 
ALTER PROCEDURE [dbo].[QCL_SelectClientsStudiesAndSurveysByUser]     

*/
USE [QP_Prod]
GO


ALTER PROCEDURE [dbo].[QCL_SelectStudy]
@StudyId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

SELECT Study_id, strStudy_nm, strStudy_dsc, Client_id, ADEmployee_id,
	DATCREATE_DT, BITCLEANADDR, bitProperCase, Active, bitAutosample
FROM Study 
WHERE Study_id=@StudyId

SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF

GO


ALTER PROCEDURE [dbo].[QCL_SelectStudiesByClientId]
@ClientId INT  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
  
SELECT Study_id, strStudy_nm, strStudy_dsc, Client_id, ADEmployee_id,
	DATCREATE_DT, BITCLEANADDR, bitProperCase, Active, bitAutosample
FROM Study   
WHERE Client_id = @ClientId
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF


GO

ALTER PROCEDURE [dbo].[QCL_UpdateStudy]
@STUDY_ID int,
@STRSTUDY_NM char(10),
@STRSTUDY_DSC varchar(255),
@CLIENT_ID int,
@ADEMPLOYEE_ID int,
@DATCREATE_DT datetime,
@BITCLEANADDR bit,
@bitProperCase bit,
@Active bit,
@bitAutosample bit
AS

SET NOCOUNT ON

UPDATE [dbo].STUDY
SET STRSTUDY_NM = @STRSTUDY_NM,
	STRSTUDY_DSC = @STRSTUDY_DSC,
	CLIENT_ID = @CLIENT_ID,
	ADEMPLOYEE_ID = @ADEMPLOYEE_ID,
	DATCREATE_DT = @DATCREATE_DT,
	BITCLEANADDR = @BITCLEANADDR,
	bitProperCase = @bitProperCase,
	Active = @Active,
	bitAutosample = @bitAutosample
WHERE STUDY_ID = @STUDY_ID

SET NOCOUNT OFF


GO


ALTER PROCEDURE [dbo].[QCL_InsertStudy]  
@STRSTUDY_NM char(10),  
@STRSTUDY_DSC varchar(255),  
@CLIENT_ID int,  
@ADEMPLOYEE_ID int,  
@DATCREATE_DT datetime,  
@BITCLEANADDR bit,  
@bitProperCase bit,  
@Active bit,
@bitAutoSample bit 
AS  

BEGIN
	  
	DECLARE @StudyID int  
	DECLARE @SQL varchar(5000)  
	DECLARE @SchemaName varchar(10)  
	  
	SET NOCOUNT ON  
	  
	INSERT INTO [dbo].STUDY (STRSTUDY_NM, STRSTUDY_DSC, CLIENT_ID, ADEMPLOYEE_ID,  
	 DATCREATE_DT, DATCLOSE_DT, BITCLEANADDR, bitProperCase, INTPOPULATIONTABLEID,  
	 INTENCOUNTERTABLEID, INTPROVIDERTABLEID, BITSTUDYONGOING, BITCHECKPHON, BITMULTADDR, bitNCOA, Active, bitAutoSample)  
	VALUES (@STRSTUDY_NM, @STRSTUDY_DSC, @CLIENT_ID, @ADEMPLOYEE_ID,  
	 @DATCREATE_DT, @DATCREATE_DT, @BITCLEANADDR, @bitProperCase, -1, -1, -1, 1, 0, 0, 0, @Active,@bitAutoSample)  
	  
	SELECT @StudyID = SCOPE_IDENTITY()  
	  
	--Create Database Schema  
	SET @SchemaName = 'S' + cast(@StudyID as varchar)  
	SET @SQL = 'CREATE SCHEMA ' + @SchemaName  
	EXEC(@SQL)  
	  
	/*  
	--Create Universe Table  
	SET @SQL = 'IF OBJECT_ID(N''[' + @SchemaName + '].[Universe]'') IS NOT NULL   
	 DROP TABLE ''[' + @SchemaName + '].[Universe]''  
	GO  
	CREATE TABLE ''[' + @SchemaName + '].[Universe]''(  
	 [Pop_id] [int] NOT NULL,  
	 [DQRule_id] [int] NOT NULL,  
	 [numRandom] [numeric](18, 0) NULL,  
	 CONSTRAINT [PK_UNIVERSE] PRIMARY KEY CLUSTERED   
	(  
	 [Pop_id] ASC  
	)  
	) ON [PRIMARY]  
	GO'  
	      
	EXEC(@SQL)  
	  
	--Create PopFlags Table  
	SET @SQL = 'IF OBJECT_ID(N''[' + @SchemaName + '][.PopFlags]'') IS NOT NULL   
	 DROP TABLE ''[' + @SchemaName + '].[PopFlags]''  
	GO  
	CREATE TABLE ''[' + @SchemaName + '].[PopFlags]''(  
	 [Pop_id] [int] NOT NULL,  
	 [Adult] [char](1) NOT NULL,  
	 [Sex] [char](1) NOT NULL,  
	 [Doc] [char](1) NOT NULL,  
	 CONSTRAINT [PK_POPFLAGS] PRIMARY KEY CLUSTERED   
	(  
	 [Pop_id] ASC  
	)  
	) ON [PRIMARY]  
	GO'  
	  
	EXEC(@SQL)  
	  
	--Create UnitMembership Table  
	SET @SQL = 'IF OBJECT_ID(N''[' + @SchemaName + '][.UnitMembership]'') IS NOT NULL   
	 DROP TABLE ''[' + @SchemaName + '].[UnitMembership]''  
	GO  
	CREATE TABLE ''[' + @SchemaName + '].[UnitMembership]''(  
	 [Pop_id] [int] NOT NULL,  
	 [SampleUnit_id] [int] NOT NULL,  
	 [SelectType_cd] [char](1) NULL,  
	 CONSTRAINT [PK_UNITMEMBERSHIP] PRIMARY KEY CLUSTERED   
	(  
	 [Pop_id] ASC,  
	 [SampleUnit_id] ASC  
	)  
	) ON [PRIMARY]  
	GO'  
	  
	EXEC(@SQL)  
	  
	--Create UniKeys Table  
	SET @SQL = 'IF OBJECT_ID(N''[' + @SchemaName + '][.UniKeys]'') IS NOT NULL   
	 DROP TABLE ''[' + @SchemaName + '].[UniKeys]''  
	GO  
	CREATE TABLE ''[' + @SchemaName + '].[UniKeys]''(  
	 [SampleSet_id] [int] NOT NULL,  
	 [SampleUnit_id] [int] NOT NULL,  
	 [Pop_id] [int] NOT NULL,  
	 [Table_id] [int] NOT NULL,  
	 [KeyValue] [int] NOT NULL,  
	 CONSTRAINT [PK_UNIKEYS] PRIMARY KEY CLUSTERED   
	(  
	 [SampleSet_id] ASC,  
	 [SampleUnit_id] ASC,  
	 [Pop_id] ASC,  
	 [Table_id] ASC  
	)  
	) ON [PRIMARY]  
	GO'  
	  
	EXEC(@SQL)  
	  
	--Add additional indexes to UniKeys table  
	SET @SQL = 'CREATE NONCLUSTERED INDEX [IDX_Unikeys_KeyValue] ON [' + @SchemaName + '].[UniKeys]  
	(  
	 [KeyValue] ASC  
	)  
	GO  
	CREATE NONCLUSTERED INDEX [IDX_Unikeys_SampleSet_Table] ON [' + @SchemaName + '].[UniKeys]   
	(  
	 [SampleSet_id] ASC,  
	 [Table_id] ASC  
	)  
	GO'  
	  
	EXEC(@SQL)  
	*/  
	  
	DECLARE @TableID int = 0  
	--Add MetaData  
	EXEC dbo.SDS_SaveMetaTable 0, @TableID OUTPUT, @StudyID, 'POPULATION', '', 0  
	  
	DECLARE @isPII bit, @isAllowUS bit, @FieldID int, @ResultMsg varchar(100)  
	  
	--Add Key Field  
	SET @FieldID = 0  
	SET @isPII = 0  
	SET @isAllowUS = 1  
	SET @ResultMsg = ''  
	EXEC dbo.SDS_SaveMetaStructure 0, 1, 0, 0, 0, @isPII, @isAllowUS, @TableID, @FieldID, -1, -1, '', @ResultMsg  
	  
	--Add New Record Date Field  
	SET @FieldID = (SELECT field_id FROM MetaField WHERE INTSPECIALFIELD_CD = (SELECT numParam_Value FROM QualPro_Params WHERE strParam_Nm = 'FieldNewRecordDate'))   
	SET @isPII = (SELECT bitPII FROM MetaField WHERE Field_id = @FieldID)  
	IF @isPII = 0  
	 SET @isAllowUS = 1  
	ELSE  
	 SET @isAllowUS = 0  
	  
	SET @ResultMsg = ''  
	EXEC dbo.SDS_SaveMetaStructure 0, 0, 0, 0, 0, @isPII, @isAllowUS, @TableID, @FieldID, -1, -1, '', @ResultMsg  
	  
	--Add New Language Code Field  
	SET @FieldID = (SELECT field_id FROM MetaField WHERE INTSPECIALFIELD_CD = (SELECT numParam_Value FROM QualPro_Params WHERE strParam_Nm = 'FieldLanguageCode'))   
	SET @isPII = (SELECT bitPII FROM MetaField WHERE Field_id = @FieldID)  
	IF @isPII = 0  
	 SET @isAllowUS = 1  
	ELSE  
	 SET @isAllowUS = 0  
	  
	SET @ResultMsg = ''  
	EXEC dbo.SDS_SaveMetaStructure 0, 0, 0, 0, 0, @isPII, @isAllowUS, @TableID, @FieldID, -1, -1, '', @ResultMsg  
	  
	--Add New Age Field  
	SET @FieldID = (SELECT field_id FROM MetaField WHERE INTSPECIALFIELD_CD = (SELECT numParam_Value FROM QualPro_Params WHERE strParam_Nm = 'FieldAge'))   
	SET @isPII = (SELECT bitPII FROM MetaField WHERE Field_id = @FieldID)  
	IF @isPII = 0  
	 SET @isAllowUS = 1  
	ELSE  
	 SET @isAllowUS = 0  
	  
	SET @ResultMsg = ''  
	EXEC dbo.SDS_SaveMetaStructure 0, 0, 0, 0, 0, @isPII, @isAllowUS, @TableID, @FieldID, -1, -1, '', @ResultMsg  
	  
	--Add New Gender Field  
	SET @FieldID = (SELECT field_id FROM MetaField WHERE INTSPECIALFIELD_CD = (SELECT numParam_Value FROM QualPro_Params WHERE strParam_Nm = 'FieldGender'))   
	SET @isPII = (SELECT bitPII FROM MetaField WHERE Field_id = @FieldID)  
	IF @isPII = 0  
	 SET @isAllowUS = 1  
	ELSE  
	 SET @isAllowUS = 0  
	  
	SET @ResultMsg = ''  
	EXEC dbo.SDS_SaveMetaStructure 0, 0, 0, 0, 0, @isPII, @isAllowUS, @TableID, @FieldID, -1, -1, '', @ResultMsg  
	  

	-- DRM	07/23/2014	Added ClientLanguage as new default field.
	--Add New Client Language Field  
	SET @FieldID = (SELECT field_id FROM MetaField WHERE INTSPECIALFIELD_CD = (SELECT numParam_Value FROM QualPro_Params WHERE strParam_Nm = 'FieldClientLanguage'))   
	SET @isPII = (SELECT bitPII FROM MetaField WHERE Field_id = @FieldID)  
	IF @isPII = 0  
	 SET @isAllowUS = 1  
	ELSE  
	 SET @isAllowUS = 0  
	  
	SET @ResultMsg = ''  
	EXEC dbo.SDS_SaveMetaStructure 0, 0, 0, 0, 0, @isPII, @isAllowUS, @TableID, @FieldID, -1, -1, '', @ResultMsg  


	--Update Population Table ID in Study Table  
	UPDATE dbo.STUDY  
	SET INTPOPULATIONTABLEID = @TableID  
	WHERE STUDY_ID = @StudyID  
	  
	SELECT @StudyID  
	  
	SET NOCOUNT OFF  

END

GO

ALTER PROCEDURE [dbo].[QCL_SelectClientGroupsClientsAndStudiesByUser]    
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

INSERT INTO #ClientGroups (ClientGroup_id, ClientGroup_nm, ClientGroupReporting_nm, Active, DateCreated)
SELECT ClientGroup_id, ClientGroup_nm, ClientGroupReporting_nm, Active, DateCreated
FROM ClientGroups
ORDER BY ClientGroup_nm

--Populate the temp table with the studies they have rights to.    
INSERT INTO #EmpStudy (Client_id, Study_id, strStudy_nm, strStudy_dsc, ADEmployee_id,
	                   datCreate_dt, bitCleanAddr, bitProperCase, Active, bitAutoSample)    
SELECT st.Client_id, st.Study_id, st.strStudy_nm, st.strStudy_dsc, st.ADEmployee_id,
	   st.datCreate_dt, st.bitCleanAddr, st.bitProperCase, st.Active, st.bitAutosample  
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

--Cleanup temp table    
DROP TABLE #EmpStudy
DROP TABLE #ClientGroups

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


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

INSERT INTO #ClientGroups (ClientGroup_id, ClientGroup_nm, ClientGroupReporting_nm, Active, DateCreated)
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
	   sd.Contract, sd.Active, sd.ContractedLanguages, sd.UseUSPSAddrChangeService
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
	   datCreate_dt, bitCleanAddr, bitProperCase, Active, bitAutoSample
FROM #EmpStudy
ORDER BY strStudy_nm
    
--Cleanup temp table    
DROP TABLE #EmpStudy
    
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
	   s.Contract, s.Active, s.ContractedLanguages, s.UseUSPSAddrChangeService
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
