CREATE PROCEDURE QCL_DeleteSurvey    
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


