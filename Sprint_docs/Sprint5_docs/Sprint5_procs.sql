USE [QP_Prod]
GO



CREATE TABLE dbo.SubtypeCategory (
	SubtypeCategory_id int identity(1,1)
	,SubtypeCategory_nm varchar(50)
	,bitMultiSelect bit
)
ALTER TABLE SubtypeCategory ADD CONSTRAINT pk_SubtypeCategory PRIMARY KEY (SubtypeCategory_id)
go
INSERT INTO dbo.SubtypeCategory VALUES ('Subtype',1)
INSERT INTO dbo.SubtypeCategory VALUES ('Questionnaire Type',0)
go
CREATE TABLE dbo.Subtype (
	Subtype_id int identity(1,1)
	,Subtype_nm varchar(50)
	,SubtypeCategory_id int
	,bitRuleOverride bit
)
go
ALTER TABLE Subtype ADD CONSTRAINT pk_Subtype PRIMARY KEY (Subtype_id)
go
ALTER TABLE dbo.Subtype 
ADD CONSTRAINT fk_Subtype_SubtypeCategory
FOREIGN KEY (SubtypeCategory_id)
REFERENCES SubtypeCategory(SubtypeCategory_id)
go
CREATE TABLE dbo.SurveyTypeSubtype (
	SurveyTypeSubtype_id int identity(1,1)
	,SurveyType_id int
	,Subtype_id int
)
go
ALTER TABLE SurveyTypeSubtype ADD CONSTRAINT pk_SurveyTypeSubtype PRIMARY KEY (SurveyTypeSubtype_id)
go
ALTER TABLE dbo.SurveyTypeSubtype 
ADD CONSTRAINT fk_SurveyTypeSubtype_SurveyType
FOREIGN KEY (SurveyType_id)
REFERENCES SurveyType(SurveyType_id)
go
ALTER TABLE dbo.SurveyTypeSubtype 
ADD CONSTRAINT fk_SurveyTypeSubtype_Subtype
FOREIGN KEY (Subtype_id)
REFERENCES Subtype(Subtype_id)
go
CREATE TABLE dbo.SurveySubtype (
	SurveySubtype_id int identity(1,1)
	,Survey_id int
	,Subtype_id int
)
go
ALTER TABLE SurveySubtype ADD CONSTRAINT pk_SurveySubtype PRIMARY KEY (SurveySubtype_id)
go
ALTER TABLE dbo.SurveySubtype
ADD CONSTRAINT fk_SurveySubtype_Survey
FOREIGN KEY (Survey_id)
REFERENCES Survey_def(Survey_id)
go
ALTER TABLE dbo.SurveySubtype
ADD CONSTRAINT fk_SurveySubtype_Subtype
FOREIGN KEY (Subtype_id)
REFERENCES Subtype(Subtype_id)
go

begin
	INSERT INTO dbo.subtype VALUES ('MNCM',1,0)
	INSERT INTO dbo.subtype VALUES ('WCHQ',1,0)
	INSERT INTO dbo.subtype VALUES ('MIPEC',1,0)
	INSERT INTO dbo.subtype VALUES ('Visit Adult 2.0',2,0)
	INSERT INTO dbo.subtype VALUES ('12-month Adult 2.0',2,0)
	INSERT INTO dbo.subtype VALUES ('12-month Child 2.0',2,0)
	--INSERT INTO dbo.subtype VALUES ('12-month Adult 2.0 w/ PCMH',2,0) 
	--INSERT INTO dbo.subtype VALUES ('12-month Child 2.0 w/ PCMH',2,0) 
	--INSERT INTO dbo.subtype VALUES ('PCMH',1,0)

	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,1)
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,2)
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,3)
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,4)
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,5)
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,6)
	--INSERT INTO dbo.SurveyTypeSubtype VALUES (4,7)
	--INSERT INTO dbo.SurveyTypeSubtype VALUES (4,8)
	--INSERT INTO dbo.SurveyTypeSubtype VALUES (4,9)
end
go
INSERT INTO dbo.surveysubtype (survey_id, subtype_id)
select sd.survey_id, st.subtype_id
from dbo.survey_def sd
inner join dbo.surveysubtypes sst on sd.surveysubtype_id=sst.surveysubtype_id
inner join dbo.subtype st on sst.subtype_nm=st.subtype_nm

INSERT INTO dbo.surveysubtype (survey_id, subtype_id)
select sd.survey_id, st.subtype_id
from dbo.survey_def sd
inner join dbo.questionnairetypes qt on sd.questionnairetype_id=qt.questionnairetype_id
inner join dbo.subtype st on qt.description=st.subtype_nm
go
DROP TABLE dbo.surveysubtypes
DROP TABLE dbo.questionnairetypes 


GO

-- removed SurveySubType_ID and QuestionnaireType_ID from SURVEY_DEF
ALTER TABLE SURVEY_DEF
drop column SurveySubType_ID,
			QuestionnaireType_ID 

GO


/****** Object:  StoredProcedure [dbo].[QCL_SelectClientsStudiesAndSurveysByUser]    Script Date: 8/18/2014 8:40:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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
	   s.Contract, s.Active, s.ContractedLanguages
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


/****** Object:  StoredProcedure [dbo].[QCL_DeleteSurvey]    Script Date: 8/18/2014 8:38:23 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[QCL_DeleteSurvey]    
@SurveyID INT    
AS    
    
IF EXISTS (SELECT * FROM SampleSet WHERE Survey_id=@SurveyID)    
BEGIN    
    RAISERROR ('This survey has been sampled.', 16, 1)    
    RETURN    
END    
    
BEGIN TRANSACTION    
    
--  print 'Deleting from PCLGenLog'    
 DELETE PCLGenLog  
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting PCLGenLog.',16,1)    
   RETURN    
  END    
  
--  print 'Deleting from dbo.SampleUnitsection'    
 DELETE dbo.SampleUnitSection    
--  FROM dbo.SamplePlan sp, dbo.SampleUnit su, dbo.SampleUnitSection sus    
--  WHERE sus.SampleUnit_id=su.SampleUnit_id    
--  AND su.SamplePlan_id=sp.SamplePlan_id    
--  AND sp.Survey_id=@SurveyID    
 WHERE SelQstnsSurvey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting SampleUnitSection.',16,1)    
   RETURN    
  END    
    
--  print 'Deleting from dbo.PeriodDates'    
 DELETE pd    
 FROM dbo.PeriodDates pd, PeriodDef p    
 WHERE p.Survey_id=@SurveyID    
 AND p.PeriodDef_id=pd.PeriodDef_id    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting PeriodDates.',16,1)    
   RETURN    
  END    
    
--  print 'Deleting from dbo.PeriodDef'    
 DELETE dbo.PeriodDef     
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting PeriodDef.',16,1)    
   RETURN    
  END    
    
--  print 'Deleting from dbo.SampleUnitTreeIndex'    
 DELETE dbo.SurveyValidationResults    
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting SurveyValidationResults.',16,1)    
   RETURN    
  END    
    
--  print 'Deleting from dbo.SampleUnitTreeIndex'    
 DELETE dbo.Survey_SurveyTypeDef    
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting Survey_SurveyTypeDef.',16,1)    
   RETURN    
  END    
    
--  print 'Deleting from dbo.SampleUnitTreeIndex'    
 DELETE sut    
 FROM dbo.SampleUnitTreeIndex sut, dbo.SamplePlan sp, dbo.SampleUnit su    
 WHERE su.SamplePlan_id=sp.SamplePlan_id    
 AND sp.Survey_id=@SurveyID    
 AND su.SampleUnit_id=sut.SampleUnit_id    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting SampleUnit.',16,1)    
   RETURN    
  END    
   


--  print 'Deleting from dbo.SampleUnit'    
 DELETE dbo.SampleUnitService    
 FROM	dbo.SamplePlan sp, dbo.SampleUnit su, dbo.SampleUnitService sus    
 WHERE	su.SamplePlan_id=sp.SamplePlan_iD    
		AND su.sampleUnit_ID = sus.Sampleunit_ID
		AND sp.Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting SampleUnit.',16,1)    
   RETURN    
  END    

 
--  print 'Deleting from dbo.SampleUnit'    
 DELETE dbo.SampleUnit    
 FROM dbo.SamplePlan sp, dbo.SampleUnit su    
 WHERE su.SamplePlan_id=sp.SamplePlan_id    
 AND sp.Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting SampleUnit.',16,1)    
   RETURN    
  END    
    
--  print 'Deleting from dbo.CriteriaInList'    
 DELETE cil    
 FROM dbo.CriteriaInList cil, dbo.CriteriaClause cc, dbo.BusinessRule br    
 WHERE br.Survey_id=@SurveyID    
 AND br.CriteriaStmt_id=cc.CriteriaStmt_id    
 AND cc.CriteriaClause_id=cil.CriteriaClause_id    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting CriteriaInList.',16,1)    
   RETURN    
  END    
    
--  print 'Deleting from dbo.CriteriaClause'    
 DELETE cc    
 FROM dbo.CriteriaClause cc, dbo.BusinessRule br    
 WHERE br.Survey_id=@SurveyID    
 AND br.CriteriaStmt_id=cc.CriteriaStmt_id    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting CriteriaClause.',16,1)    
   RETURN    
  END    
    
--  print 'Deleting from dbo.CriteriaStmt'    
 DELETE cs    
 FROM dbo.CriteriaStmt cs, dbo.BusinessRule br    
 WHERE br.Survey_id=@SurveyID    
 AND br.CriteriaStmt_id=cs.CriteriaStmt_id    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting CriteriaStmt.',16,1)    
   RETURN    
  END    
    
--  print 'Deleting from dbo.CriteriaInList'    
 DELETE dbo.BusinessRule    
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting BusinessRule.',16,1)    
   RETURN    
  END    
    
--  print 'Deleting from dbo.ReportingHierarchy'    
 DELETE dbo.ReportingHierarchy    
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
 ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting ReportingHierarchy.',16,1)    
   RETURN    
  END    
    
--  print 'Deleting from dbo.SamplePlan'    
 DELETE dbo.SamplePlan    
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting SamplePlan.',16,1)    
   RETURN    
  END    
    
/* This is the SEL_ stuff that we will be deleting. */    
    
--  print 'Deleting from dbo.Sel_Skip'    
 DELETE dbo.Sel_Skip    
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting Sel_Skip.',16,1)    
   RETURN    
  END    
    
--  print 'Deleting from dbo.Sel_Logo'    
 DELETE dbo.Sel_Logo    
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting Sel_Logo.',16,1)    
   RETURN    
  END    
    
--  print 'Deleting from dbo.Sel_PCL'    
 DELETE dbo.Sel_PCL    
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting Sel_PCL.',16,1)    
   RETURN    
  END    
    
--  print 'Deleting from dbo.Sel_Cover'    
 DELETE dbo.Sel_Cover    
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting Sel_Cover.',16,1)    
   RETURN    
  END    
    
--  print 'Deleting from dbo.CodeScls'    
 DELETE dbo.CodeScls    
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting CodeScls.',16,1)    
   RETURN    
  END    
    
--  print 'Deleting from dbo.Sel_Scls'    
 DELETE dbo.Sel_Scls    
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting Sel_Scls.',16,1)    
   RETURN    
  END    
    
--  print 'Deleting from dbo.CodeTxtbox'    
 DELETE dbo.CodeTxtBox    
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting CodeTxtBox.',16,1)    
   RETURN    
  END    
     
--  print 'Deleting from dbo.Sel_Textbox'    
 DELETE dbo.Sel_Textbox    
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting Sel_TextBox.',16,1)    
   RETURN    
  END    
    
--  print 'Deleting from dbo.CodeQstns'    
 DELETE dbo.CodeQstns    
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting CodeQstns.',16,1)    
   RETURN    
  END    
     
--  print 'Deleting from dbo.Sel_Qstns'    
 DELETE dbo.Sel_Qstns    
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting Sel_Qstns.',16,1)    
   RETURN    
  END    
    
/* MailingMethodologies & Steps */    
--  print 'Deleting study from dbo.mailingstep'    
 DELETE dbo.MailingStep    
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting MailingStep.',16,1)    
   RETURN    
  END    
    
--  print 'Deleting study from MailingMethodology'    
 DELETE dbo.MailingMethodology    
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting MailingMethodology.',16,1)    
   RETURN    
  END    
    
/* Other survey related tables */    
--  print 'Deleting study from Survey_Contact'    
 DELETE dbo.Survey_contact    
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting Survey_Contact.',16,1)    
   RETURN    
  END    
    
--  print 'Deleting study from Surveylanguage'    
 DELETE dbo.Surveylanguage    
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting SurveyLanguage.',16,1)    
   RETURN    
  END    
    
--  print 'Deleting study from HouseHoldRule'    
 DELETE dbo.HouseHoldRule    
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting HouseHoldRule.',16,1)    
   RETURN    
  END 
  
-- Delete Sub-types from SurveySubType
DELETE FROM [dbo].[SurveySubtype]
      WHERE Survey_id=@SurveyID  
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting SubTypes.',16,1)    
   RETURN    
  END 

   
    
--  print 'Deleting from Survey_def'    
 DELETE FROM dbo.Survey_def    
 WHERE Survey_id=@SurveyID    
 IF @@ERROR <> 0    
  BEGIN    
   ROLLBACK TRANSACTION    
   RAISERROR ('Problem deleting Survey_def.',16,1)    
   RETURN    
  END    
    
COMMIT TRAN

GO


/****** Object:  StoredProcedure [dbo].[QCL_InsertSurvey]    Script Date: 8/18/2014 8:57:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
    @ContractedLanguages       VARCHAR(50)
AS

INSERT INTO Survey_Def (Study_id, strSurvey_Nm, strSurvey_Dsc, intResponse_Recalc_Period,         
                        intResurvey_Period, datSurvey_Start_Dt, datSurvey_End_Dt, SamplingAlgorithmID, 
                        bitEnforceSkip, strCutoffResponse_Cd, CutoffTable_id, CutoffField_id, 
                        SampleEncounterTable_id, SampleEncounterField_id, strClientFacingName, 
                        SurveyType_id, SurveyTypeDef_id, ReSurveyMethod_id, bitDynamic, 
                        strHouseholdingType, Contract, Active, ContractedLanguages) 
VALUES (@Study_id, @strSurvey_Nm, @strSurvey_Dsc, @intResponse_Recalc_Period, @intResurvey_Period,  
        @datSurvey_Start_Dt, @datSurvey_End_Dt, @SamplingAlgorithm, @bitEnforceSkip, @strCutoffResponse_Cd, 
        @CutoffTable_id, @CutoffField_id, @SampleEncounterTable_id, @SampleEncounterField_id, 
        @strClientFacingName, @SurveyType_id, @SurveyTypeDef_id, @ReSurveyMethod_id, 
        CASE WHEN @SamplingAlgorithm = 2 THEN 1 ELSE 0 END, @HouseHoldingType, @Contract, @Active, 
        @ContractedLanguages)

SELECT SCOPE_IDENTITY()


GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectSurvey]    Script Date: 8/18/2014 8:56:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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
	   Contract, Active, ContractedLanguages
FROM Survey_Def 
WHERE Survey_id = @SurveyId 

          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
SET NOCOUNT OFF

GO


/****** Object:  StoredProcedure [dbo].[QCL_SelectSurveysByStudyId]    Script Date: 8/18/2014 8:33:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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
       sd.ContractedLanguages
FROM Survey_Def sd, SamplePlan sp
WHERE sd.Study_id = @StudyId
  AND sd.survey_id = sp.survey_id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


GO


/****** Object:  StoredProcedure [dbo].[QCL_SelectSurveysBySurveyTypeMailOnly]    Script Date: 8/18/2014 8:37:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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



/****** Object:  StoredProcedure [dbo].[QCL_SelectSurveySubTypes]    Script Date: 8/18/2014 8:33:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[QCL_SelectSurveySubTypes]      
    @SurveyId INT,
	@SubtypeCategory_id INT     
AS      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
SET NOCOUNT ON        
      

SELECT sst.SurveySubtype_id, sst.Subtype_id, sst.Survey_id, st.Subtype_nm, st.SubtypeCategory_id, st.bitRuleOverride
FROM SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
WHERE sst.Survey_id = @SurveyId
and st.SubtypeCategory_id = @SubtypeCategory_id 

          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
SET NOCOUNT OFF

GO




/****** Object:  StoredProcedure [dbo].[QCL_UpdateSurvey]    Script Date: 8/18/2014 8:56:39 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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
    @ContractedLanguages       VARCHAR(50)
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
    ContractedLanguages = @ContractedLanguages
WHERE Survey_id = @Survey_id

GO


/****** Object:  StoredProcedure [dbo].[QCL_DeleteSurveyQuestionnaireSubType]    Script Date: 8/18/2014 8:32:25 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[QCL_DeleteSurveyQuestionnaireSubType]        
    @Survey_id                 INT,    
	@SubtypeCategory_id		   INT
AS

DELETE SurveySubtype
FROM SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
WHERE sst.Survey_id = @Survey_Id
and st.SubtypeCategory_id = @SubtypeCategory_id 


GO

/****** Object:  StoredProcedure [dbo].[QCL_DeleteSurveySubType]    Script Date: 8/18/2014 8:28:21 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[QCL_DeleteSurveySubType]        
    @Survey_id                 INT,    
    @SubType_id                INT,
	@SubtypeCategory_id		   INT
AS

DELETE SurveySubtype
FROM SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
WHERE sst.Survey_id = @Survey_Id
and sst.Subtype_id = @SubType_id
and st.SubtypeCategory_id = @SubtypeCategory_id 


GO

/****** Object:  StoredProcedure [dbo].[QCL_InsertSurveySubType]    Script Date: 8/18/2014 8:31:44 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[QCL_InsertSurveySubType]        
    @Survey_id                  INT,        
    @Subtype_id                 INT
AS

INSERT INTO SurveySubtype (Survey_id, [Subtype_id]) 
VALUES (@Survey_id, @Subtype_id)


GO


/****** Object:  StoredProcedure [dbo].[QCL_SelectSubTypes]    Script Date: 8/19/2014 10:55:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[QCL_SelectSubTypes] 
@surveytypeid int,
@subtypecategory int,
@surveyid int 
AS

SELECT distinct st.SubType_id, SurveyType_ID, SubType_NM, stc.SubtypeCategory_id, stc.SubtypeCategory_nm, stc.bitMultiSelect, st.bitRuleOverride, CASE WHEN sst.Subtype_id IS NULL THEN 0 ELSE 1 END bitSelected
FROM SurveyTypeSubType stst
inner join Subtype st on (st.Subtype_id = stst.Subtype_id)
inner join SubtypeCategory stc on (stc.SubtypeCategory_id = st.SubtypeCategory_id)
left join SurveySubtype sst on (sst.Subtype_id = st.Subtype_id and sst.Survey_id = @surveyid)
WHERE SurveyType_ID = @surveytypeid
and stc.SubtypeCategory_id = @subtypecategory


GO

/****** Object:  StoredProcedure [dbo].[QCL_UpdateSurveySubType]    Script Date: 8/19/2014 4:32:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[QCL_UpdateSurveySubType]    
    @Survey_id                 INT,    
    @SubType_id                INT,
	@SubtypeCategory_id		   INT
AS

DECLARE @SurveySubtype_id INT

SELECT @SurveySubtype_id = sst.SurveySubtype_id
FROM SurveySubtype sst
INNER JOIN Subtype st on st.Subtype_id = sst.Subtype_id
WHERE sst.Survey_id = @Survey_Id
and st.SubtypeCategory_id = @SubtypeCategory_id
    
IF @SurveySubtype_id is null
BEGIN

	EXEC QCL_InsertSurveySubType @Survey_id, @Subtype_id

END
ELSE
BEGIN

	UPDATE SurveySubtype    
		SET Subtype_id = @SubType_id
	WHERE SurveySubtype_id = @SurveySubtype_id

END
GO


/****** Object:  StoredProcedure [dbo].[QCL_SelectQuestionnaireTypes]    Script Date: 8/18/2014 8:58:16 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCL_SelectQuestionnaireType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[QCL_SelectQuestionnaireTypes]
GO




