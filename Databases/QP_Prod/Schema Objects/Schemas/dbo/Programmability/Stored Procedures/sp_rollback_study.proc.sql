/* This procedure will start everything off on the cascade triggering of stored procedures  
** It will then delete the remaining data and drop the data structure for the study  
*/  
CREATE procedure sp_rollback_study  
 @study_id int,  
 @cascade tinyint = 1  
as  
 declare @rc int  
 declare @sql varchar(2000)  
  
 if @cascade = 1  
 begin  
  exec @rc=dbo.sp_rollback_import @study_id, @cascade  
  if @@error <> 0 OR @rc <> 0  
   return -1  
 end  
  
 CREATE TABLE #delstudy (  
  survey_id int  
 )  
 INSERT INTO #delstudy (survey_id)  
 SELECT survey_id  
 FROM dbo.survey_def  
 WHERE study_id = @study_id  
 if @@error <> 0  
  return -1  
  
 BEGIN TRANSACTION  
  
/* This is the remaining sampling stuff that we need to delete */  
  
 print 'Deleting from dbo.Sampleunitsection'  
 DELETE dbo.SampleUnitSection  
 FROM dbo.SamplePlan sp, dbo.SampleUnit su, dbo.SampleUnitSection sus, #delstudy ds  
 WHERE sus.sampleunit_id = su.sampleunit_id  
 AND su.sampleplan_id = sp.sampleplan_id  
 AND sp.survey_id = ds.survey_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting from dbo.Sampleunit'  
 DELETE dbo.SampleUnit  
 FROM dbo.SamplePlan sp, dbo.SampleUnit su, #delstudy ds  
 WHERE su.sampleplan_id = sp.sampleplan_id  
 AND sp.survey_id = ds.survey_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting from dbo.ReportingHierarchy'  
 DELETE FROM dbo.ReportingHierarchy  
 WHERE study_id = @study_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting from dbo.Sampleplan'  
 DELETE dbo.SamplePlan  
 FROM #delstudy  
 WHERE #delstudy.survey_id = dbo.SamplePlan.survey_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
/* This is the SEL_ stuff that we will be deleting. */  
  
 print 'Deleting from dbo.Sel_Skip'  
 DELETE dbo.Sel_Skip  
 FROM #delstudy  
 WHERE #delstudy.survey_id = dbo.Sel_Skip.survey_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting from dbo.Sel_Logo'  
 DELETE dbo.Sel_Logo  
 FROM #delstudy  
 WHERE #delstudy.survey_id = dbo.Sel_Logo.survey_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting from dbo.Sel_PCL'  
 DELETE dbo.Sel_PCL  
 FROM #delstudy  
 WHERE #delstudy.survey_id = dbo.Sel_PCL.survey_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting from dbo.Sel_Cover'  
 DELETE dbo.Sel_Cover  
 FROM #delstudy  
 WHERE #delstudy.survey_id = dbo.Sel_Cover.survey_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting from dbo.CodeScls'  
 DELETE dbo.CodeScls  
 FROM #delstudy  
 WHERE #delstudy.survey_id = dbo.CodeScls.survey_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting from dbo.Sel_Scls'  
 DELETE dbo.Sel_Scls  
 FROM #delstudy  
 WHERE #delstudy.survey_id = dbo.Sel_Scls.survey_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting from dbo.CodeTxtbox'  
 DELETE dbo.CodeTxtBox  
 FROM #delstudy  
 WHERE #delstudy.survey_id = dbo.CodeTxtBox.survey_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
   
 print 'Deleting from dbo.Sel_Textbox'  
 DELETE dbo.Sel_Textbox  
 FROM #delstudy  
 WHERE #delstudy.survey_id = dbo.Sel_Textbox.survey_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting from dbo.CodeQstns'  
 DELETE dbo.CodeQstns  
 FROM #delstudy  
 WHERE #delstudy.survey_id = dbo.CodeQstns.survey_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
   
 print 'Deleting from dbo.Sel_Qstns'  
 DELETE dbo.Sel_Qstns  
 FROM #delstudy  
 WHERE #delstudy.survey_id = dbo.Sel_Qstns.survey_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
/* MailingMethodologies & Steps */  
 print 'Deleting study from dbo.mailingstep'  
 DELETE dbo.MailingStep  
 FROM #delstudy  
 WHERE #delstudy.survey_id = dbo.MailingStep.survey_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting study from MailingMethodology'  
 DELETE dbo.MailingMethodology  
 FROM #delstudy  
 WHERE #delstudy.survey_id = dbo.MailingMethodology.survey_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
/* Other survey related tables */  
 print 'Deleting study from Survey_Contact'  
 DELETE dbo.survey_contact  
 FROM #delstudy  
 WHERE #delstudy.survey_id = dbo.survey_contact.survey_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting study from surveylanguage'  
 DELETE dbo.surveylanguage  
 FROM #delstudy  
 WHERE #delstudy.survey_id = dbo.surveylanguage.survey_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
/* This is how we delete out the criterias */  
 print 'Deleting from CriteriaInList'  
 DELETE dbo.CriteriaInList  
 FROM dbo.CriteriaInList cil, dbo.CriteriaClause cc, dbo.CriteriaStmt cs  
 WHERE cs.CRITERIASTMT_ID = cc.CRITERIASTMT_ID  
 AND cc.CRITERIACLAUSE_ID = cil.CRITERIACLAUSE_ID  
 AND cs.study_id = @study_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting from CriteriaClause'  
 DELETE dbo.CriteriaClause  
 FROM dbo.CriteriaClause cc, dbo.CriteriaStmt cs  
 WHERE cs.CRITERIASTMT_ID = cc.CRITERIASTMT_ID  
 AND cs.study_id = @study_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting from BusinessRule'  
 DELETE dbo.BusinessRule  
 FROM dbo.BusinessRule br, dbo.CriteriaStmt cs  
 WHERE cs.CRITERIASTMT_ID = br.CRITERIASTMT_ID  
 AND cs.study_id = @study_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting from CriteriaStmt'  
 DELETE dbo.CriteriaStmt  
 WHERE study_id = @study_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
/* This is how we will drop the meta stuff & related info */  
 print 'Deleting study from householdrule'  
 DELETE dbo.HouseHoldRule  
 FROM dbo.HouseHoldRule hhr, dbo.MetaTable mt  
 WHERE hhr.table_id = mt.table_id  
 AND mt.study_id = @study_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
  
 print 'Deleting study from metalookup'  
 DELETE dbo.MetaLookup  
 FROM dbo.MetaLookup ml, dbo.MetaTable mt  
 WHERE ml.NUMMASTERTABLE_ID = mt.TABLE_ID  
 AND mt.study_id = @study_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 DELETE dbo.MetaLookup  
 FROM dbo.MetaLookup ml, dbo.MetaTable mt  
 WHERE ml.NUMLKUPTABLE_ID = mt.TABLE_ID  
 AND mt.study_id = @study_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting from survey_def'  
 DELETE FROM dbo.survey_def  
 WHERE study_id = @study_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting study from tagexception'  
 DELETE FROM dbo.TagException  
 WHERE study_id = @study_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting study from tagfield'  
 DELETE FROM dbo.TagField  
 WHERE study_id = @study_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting study from metastructure'  
 DELETE dbo.MetaStructure  
 FROM dbo.MetaStructure ms, dbo.MetaTable mt  
 WHERE ms.table_id = mt.table_id  
 AND mt.study_id = @study_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting study from metatable'  
 DELETE FROM dbo.MetaTable  
 WHERE study_id = @study_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
/* These are the other study related tables that we will need to delete from */  
 print 'Deleting from TOCL'  
 DELETE FROM dbo.TOCL  
 WHERE study_id = @study_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting from study_employee'  
 DELETE FROM dbo.study_employee  
 WHERE study_id = @study_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting from RecurringEncounter'  
 DELETE FROM dbo.RecurringEncounter  
 WHERE study_id = @study_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting from StudyReportType'  
 DELETE FROM dbo.StudyReportType  
 WHERE study_id = @study_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting from StudyComparison'  
 DELETE FROM dbo.StudyComparison  
 WHERE study_id = @study_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting from StudyDeliveryDate'  
 DELETE FROM dbo.StudyDeliveryDate  
 WHERE study_id = @study_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 print 'Deleting from AuditLog'  
 DELETE FROM dbo.AuditLog  
 WHERE study_id = @study_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
/* These are the final tables we need to delete from */  
 print 'Deleting from study'  
 DELETE FROM dbo.study  
 WHERE study_id = @study_id  
 if @@error <> 0  
 begin  
  ROLLBACK TRANSACTION  
  return -1  
 end  
  
 COMMIT TRANSACTION  
  
/* Drop all tables and views associated with this the study */  
 declare dropstruct cursor for  
  select case type  
    when 'U' then convert(char(11),'DROP TABLE ')  
    when 'V' then convert(char(11),'DROP VIEW  ')  
   end + user_name(uid) + '.' + name  
  from dbo.sysobjects  
  where type in ('U','V')  
  and uid = user_id('S' + convert(varchar(9),@study_id))  
 open dropstruct  
 fetch dropstruct into @sql  
 while @@fetch_status = 0  
 begin  
  execute (@sql)  
  fetch dropstruct into @sql  
 end  
 close dropstruct  
 deallocate dropstruct  
  
  
  /* Drop the user name and login */    
SELECT @sql='S'+LTRIM(STR(@Study_ID))  
IF (SELECT USER_ID(@sql)) IS NOT NULL  
EXEC SP_DropUser @sql  

/* Drop the Schema if it exists in SQL 2008 */ 
SELECT @sql='S'+LTRIM(STR(@Study_ID))  
IF (SELECT SCHEMA_ID(@sql)) IS NOT NULL  
begin
	Select @sql = 'Drop Schema S' + cast(@Study_ID as varchar(10))   
	EXEC (@sql)
end


