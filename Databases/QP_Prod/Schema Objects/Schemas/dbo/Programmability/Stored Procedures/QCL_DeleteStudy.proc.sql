CREATE PROCEDURE [dbo].[QCL_DeleteStudy]
@StudyID INT
AS

IF EXISTS (SELECT * 
           FROM Survey_def 
           WHERE Study_id=@StudyID)

BEGIN
    RAISERROR ('Cannot delete the study while surveys exist.', 16, 1)  
    RETURN  
END

DECLARE @sql VARCHAR(8000)

-- IF EXISTS (SELECT * FROM SampleSet ss, Survey_def sd
-- WHERE sd.Study_id=@StudyID
-- AND sd.Survey_id=ss.Survey_id)
-- 
-- BEGIN
--     RAISERROR ('This study has been sampled.', 16, 1)  
--     RETURN  
-- END
-- 
-- DECLARE @SurveyID INT, @sql VARCHAR(8000)
-- 
-- BEGIN TRANSACTION
-- 
-- SELECT Survey_id
-- INTO #a
-- FROM Survey_Def
-- WHERE Study_id=@StudyID
-- 
-- SELECT TOP 1 @SurveyID=Survey_id FROM #a
-- WHILE @@ROWCOUNT>0
-- BEGIN
-- 
--   SELECT @sql='EXEC QCL_DeleteSurvey '+LTRIM(STR(@SurveyID))
--   EXEC (@sql)
-- 
--   IF @@ERROR<>0
--   BEGIN
-- 	RAISERROR ('Problem deleting the survey.',16,1)
-- 	ROLLBACK TRAN
-- 	RETURN
--   END
-- 
--   DELETE #a WHERE Survey_id=@SurveyID
-- 
--   SELECT TOP 1 @SurveyID=Survey_id FROM #a
-- 
-- END

BEGIN TRANSACTION

--  print 'Deleting from dbo.CriteriaInList'  
DELETE cil  
FROM dbo.CriteriaInList cil, dbo.CriteriaClause cc, dbo.BusinessRule br  
WHERE br.Study_id=@StudyID  
AND br.CriteriaStmt_id=cc.CriteriaStmt_id  
AND cc.CriteriaClause_id=cil.CriteriaClause_id  
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting CriteriaInList.',16,1)  
  RETURN  
 END  

DELETE cil  
FROM dbo.CriteriaInList cil, dbo.CriteriaClause cc, dbo.MetaTable mt  
WHERE mt.Study_id=@StudyID  
AND mt.Table_id=cc.Table_id  
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
WHERE br.Study_id=@StudyID  
AND br.CriteriaStmt_id=cc.CriteriaStmt_id  
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting CriteriaClause.',16,1)  
  RETURN  
 END  

DELETE cc  
FROM dbo.CriteriaClause cc, dbo.MetaTable mt
WHERE mt.Study_id=@StudyID  
AND mt.Table_id=cc.Table_id  
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting CriteriaClause.',16,1)  
  RETURN  
 END  

--  print 'Deleting from dbo.CriteriaStmt'  
DELETE cs  
FROM dbo.CriteriaStmt cs, dbo.BusinessRule br  
WHERE br.Study_id=@StudyID  
AND br.CriteriaStmt_id=cs.CriteriaStmt_id  
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting CriteriaStmt.',16,1)  
  RETURN  
 END  

DELETE dbo.CriteriaStmt
WHERE Study_id=@StudyID  
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting CriteriaStmt.',16,1)  
  RETURN  
 END  

--  print 'Deleting from dbo.BusinessRule'  
DELETE dbo.BusinessRule  
WHERE Study_id=@StudyID  
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting BusinessRule.',16,1)  
  RETURN  
 END  

/* This is how we will drop the meta stuff & related info */  
-- print 'Deleting study from metalookup'  
DELETE dbo.MetaLookup  
FROM dbo.MetaLookup ml, dbo.MetaTable mt  
WHERE ml.NumMasterTable_id=mt.Table_id  
AND mt.Study_id=@StudyID  
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting MetaLookup.',16,1)  
  RETURN  
 END  
  
DELETE dbo.MetaLookup  
FROM dbo.MetaLookup ml, dbo.MetaTable mt  
WHERE ml.NumLkupTable_id=mt.Table_id  
AND mt.Study_id=@StudyID  
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting MetaLookup.',16,1)  
  RETURN  
 END  
 
-- print 'Deleting study from tagexception'  
DELETE FROM dbo.TagException  
WHERE Study_id=@StudyID  
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting TagException.',16,1)  
  RETURN  
 END  
 
-- print 'Deleting study from tagfield'  
DELETE FROM dbo.TagField  
WHERE Study_id=@StudyID  
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting TagField.',16,1)  
  RETURN  
 END  
 
-- print 'Deleting study from metastructure'  
DELETE dbo.MetaStructure  
FROM dbo.MetaStructure ms, dbo.MetaTable mt  
WHERE ms.Table_id=mt.Table_id  
AND mt.Study_id=@StudyID  
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting MetaStructure.',16,1)  
  RETURN  
 END  

-- print 'Deleting study from metatable'  
DELETE FROM dbo.MetaTable  
WHERE Study_id=@StudyID  
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting MetaTable.',16,1)  
  RETURN  
 END  
 
/* These are the other study related tables that we will need to delete from */  
-- print 'Deleting from TOCL'  
DELETE FROM dbo.TOCL  
WHERE Study_id=@StudyID  
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting TOCL.',16,1)  
  RETURN  
 END  
 
-- print 'Deleting from Study_Employee'  
DELETE FROM dbo.Study_Employee  
WHERE Study_id=@StudyID  
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting Study_Employee.',16,1)  
  RETURN  
 END  
 
-- print 'Deleting from RecurringEncounter'  
DELETE FROM dbo.RecurringEncounter  
WHERE Study_id=@StudyID  
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting RecurringEncounter.',16,1)  
  RETURN  
 END  
 
-- print 'Deleting from StudyReportType'  
DELETE FROM dbo.StudyReportType  
WHERE Study_id=@StudyID  
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting StudyReportType.',16,1)  
  RETURN  
 END  
 
-- print 'Deleting from StudyComparison'  
DELETE FROM dbo.StudyComparison  
WHERE Study_id=@StudyID  
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting StudyComparison.',16,1)  
  RETURN  
 END 
 
-- print 'Deleting from StudyDeliveryDate'  
DELETE FROM dbo.StudyDeliveryDate  
WHERE Study_id=@StudyID  
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting StudyDeliveryDate.',16,1)  
  RETURN  
 END  
  
--  print 'Deleting from AuditLog'  
DELETE FROM dbo.AuditLog  
WHERE Study_id=@StudyID  
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting AuditLog.',16,1)  
  RETURN  
 END  
 
-- print 'Deleting from DataSetMember'  
DELETE dsm
FROM dbo.Data_Set ds, dbo.DataSetMember dsm
WHERE ds.Study_id=@StudyID  
AND ds.DataSet_id=dsm.DataSet_id
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting DataSetMember.',16,1)  
  RETURN  
 END  

-- print 'Deleting from Data_Set'  
DELETE dbo.Data_Set
WHERE Study_id=@StudyID  
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting Data_Set.',16,1)  
  RETURN  
 END  

/* These are the final tables we need to delete from */  
-- print 'Deleting from study'  
DELETE FROM dbo.Study  
WHERE Study_id=@StudyID  
IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RAISERROR ('Problem deleting Study.',16,1)  
  RETURN  
 END  
 
COMMIT TRANSACTION  
  
/* Drop all tables and views associated with this the study */  
SELECT @sql=''
SELECT @sql=@sql+'DROP '+CASE Table_Type WHEN 'Base Table' THEN 'Table' ELSE 'View' END+' '+Table_Schema+'.'+Table_Name+CHAR(10)
FROM Information_Schema.Tables
WHERE Table_Schema='S'+LTRIM(STR(@StudyID))
AND Table_Type IN ('Base Table','View')

EXEC (@sql)

--  declare dropstruct cursor for  
--   select case type  
--     when 'U' then convert(char(11),'DROP TABLE ')  
--     when 'V' then convert(char(11),'DROP VIEW  ')  
--    end + user_name(uid) + '.' + name  
--   from dbo.sysobjects  
--   where type in ('U','V')  
--   and uid=user_id('S' + convert(varchar(9),@StudyID))  
--  open dropstruct  
--  fetch dropstruct into @sql  
--  while @@fetch_status=0  
--  begin  
--   execute (@sql)  
--   fetch dropstruct into @sql  
--  end  
--  close dropstruct  
--  deallocate dropstruct  
  
/* Drop the user name and login */  
--  declare @loginnm varchar(32)  
--  set @loginnm='S' + convert(varchar(9),@StudyID)  
SELECT @sql='S'+LTRIM(STR(@StudyID))
IF (SELECT USER_ID(@sql)) IS NOT NULL
--  if exists (select name  
--    from dbo.sysusers  
--    where name=@loginnm)  
EXEC SP_DropUser @sql
/* if exists (select name  
   from master.dbo.syslogins  
   where name=@loginnm)  
  exec sp_droplogin @loginnm  
  
*/  

/* Drop the schema */  
IF (SELECT SCHEMA_ID(@sql)) IS NOT NULL
BEGIN
	SET @SQL = 'DROP SCHEMA ' + @SQL
	EXEC(@SQL)
END


