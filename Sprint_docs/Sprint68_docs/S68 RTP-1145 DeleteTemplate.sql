/*
S68 RTP-1145 DeleteTemplate.sql

Chris Burkholder

1/26/2017

delete study_employeeTemplate

etc.

delete studyTemplate
delete clientTemplate

*/
USE [QP_Prod]
GO

begin tran

begin try

	  declare @TemplateLogEntryInfo int
	  declare @TemplateLogEntryWarning int
	  declare @TemplateLogEntryError int

	  select @TemplateLogEntryInfo = TemplateLogEntryType_ID 
	  from RTPhoenix.TemplateLogEntryType where TemplateLogEntryTypeName = 'INFORMATIONAL'

	  select @TemplateLogEntryWarning = TemplateLogEntryType_ID 
	  from RTPhoenix.TemplateLogEntryType where TemplateLogEntryTypeName = 'WARNING'

	  select @TemplateLogEntryError = TemplateLogEntryType_ID 
	  from RTPhoenix.TemplateLogEntryType where TemplateLogEntryTypeName = 'ERROR'

declare @user varchar(40) = SYSTEM_USER
declare @study_id int = 5852
declare @client_id int
select @client_id = client_id from RTPhoenix.studyTemplate where study_id = @study_id

declare @Template_ID int
select @Template_id = Template_id from RTPhoenix.Template where study_id = @study_id

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, @TemplateLogEntryInfo, 'Begin Template Delete for study_id '+convert(varchar,@study_id), @user, GetDate())

delete RTPhoenix.Study_EmployeeTemplate
  where Study_id = @study_id

delete RTPhoenix.CODETXTBOXTemplate
  FROM RTPhoenix.CODETXTBOXTemplate ct inner join
  RTPhoenix.[SURVEY_DEFTemplate] sd on ct.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.CODEQSTNSTemplate
  FROM RTPhoenix.CODEQSTNSTemplate cq inner join
  RTPhoenix.[SURVEY_DEFTemplate] sd on cq.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.CODESCLSTemplate
  FROM RTPhoenix.CODESCLSTemplate cs inner join
  RTPhoenix.[SURVEY_DEFTemplate] sd on cs.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.TAGFIELDTemplate
  FROM RTPhoenix.TAGFIELDTemplate tf inner join
  RTPhoenix.[METATABLETemplate] mt on tf.table_id = mt.table_id
  where tf.study_id = @study_id

delete RTPhoenix.ModeSectionMappingTemplate
  FROM [RTPhoenix].[ModeSectionMappingTemplate] msmt inner join
  RTPhoenix.[SURVEY_DEFTemplate] sd on msmt.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.SEL_COVERTemplate
  FROM RTPhoenix.SEL_COVERTemplate sc inner join
  RTPhoenix.[SURVEY_DEFTemplate] sd on sc.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.SEL_LOGOTemplate
  FROM RTPhoenix.SEL_LOGOTemplate sl inner join
  RTPhoenix.[SURVEY_DEFTemplate] sd on sl.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.SEL_PCLTemplate
  FROM RTPhoenix.SEL_PCLTemplate sp inner join
  RTPhoenix.[SURVEY_DEFTemplate] sd on sp.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.SEL_QSTNSTemplate
  FROM RTPhoenix.SEL_QSTNSTemplate sq inner join
  RTPhoenix.[SURVEY_DEFTemplate] sd on sq.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.SEL_SCLSTemplate
  FROM RTPhoenix.SEL_SCLSTemplate ss inner join
  RTPhoenix.[SURVEY_DEFTemplate] sd on ss.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.SEL_SKIPTemplate
  FROM RTPhoenix.SEL_SKIPTemplate ss inner join
  RTPhoenix.[SURVEY_DEFTemplate] sd on ss.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.SEL_TEXTBOXTemplate
  FROM RTPhoenix.SEL_TEXTBOXTemplate st inner join
  RTPhoenix.[SURVEY_DEFTemplate] sd on st.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.SUFacilityTemplate
  FROM RTPhoenix.SUFacilityTemplate suf inner join
  [RTPhoenix].[SAMPLEUNITTemplate] su on suf.SUFacility_id = su.SUFacility_id inner join
  [RTPhoenix].[SAMPLEPLANTemplate] sp on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID inner join
  [RTPhoenix].[SURVEY_DEFTemplate] sd on sp.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.MedicareLookupTemplate
  FROM RTPhoenix.MedicareLookupTemplate ml left join
  RTPhoenix.SUFacilityTemplate suf on ml.medicarenumber = suf.medicarenumber 
  where suf.medicarenumber is null --TODO: may want to put Template_ID on all tables...

delete RTPhoenix.CriteriaInlistTemplate
  FROM RTPhoenix.CriteriaInlistTemplate ci inner join
  RTPhoenix.[CRITERIACLAUSETemplate] cc on ci.CRITERIACLAUSE_ID = cc.CRITERIACLAUSE_ID inner join
  RTPhoenix.[CRITERIASTMTTemplate] cs on cc.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
  where Study_id = @study_id

delete RTPhoenix.CriteriaClauseTemplate
  FROM RTPhoenix.CriteriaClauseTemplate cc inner join
  RTPhoenix.[CRITERIASTMTTemplate] cs on cc.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
  where Study_id = @study_id

delete RTPhoenix.CriteriaStmtTemplate
  FROM RTPhoenix.CriteriaStmtTemplate
  where Study_id = @study_id

delete RTPhoenix.HouseHoldRuleTemplate
  FROM RTPhoenix.HouseHoldRuleTemplate hhr inner join
  RTPhoenix.[SURVEY_DEFTemplate] sd on hhr.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.BusinessRuleTemplate
  FROM RTPhoenix.BusinessRuleTemplate
  where Study_id = @study_id

delete RTPhoenix.PeriodDatesTemplate
  FROM RTPhoenix.PeriodDatesTemplate pdt inner join
  RTPhoenix.[PeriodDefTemplate] pdf on pdt.PeriodDef_id = pdf.PeriodDef_id inner join
  RTPhoenix.[SURVEY_DEFTemplate] sd on pdf.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.PeriodDefTemplate
  FROM RTPhoenix.PeriodDefTemplate pd inner join
  RTPhoenix.[SURVEY_DEFTemplate] sd on pd.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.SAMPLEUNITTREEINDEXTemplate
  FROM RTPhoenix.SAMPLEUNITTREEINDEXTemplate suti inner join
  RTPhoenix.[SAMPLEUNITTemplate] su on su.SAMPLEUNIT_ID = suti.SAMPLEUNIT_ID join
  RTPhoenix.[SAMPLEPLANTemplate] sp on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID inner join
  RTPhoenix.[SURVEY_DEFTemplate] sd on sp.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.SAMPLEUNITSERVICETemplate
  FROM RTPhoenix.SAMPLEUNITSERVICETemplate sus inner join
  RTPhoenix.[SAMPLEUNITTemplate] su on su.SAMPLEUNIT_ID = sus.SAMPLEUNIT_ID join
  RTPhoenix.[SAMPLEPLANTemplate] sp on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID inner join
  RTPhoenix.[SURVEY_DEFTemplate] sd on sp.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.SAMPLEUNITSECTIONTemplate
  FROM RTPhoenix.SAMPLEUNITSECTIONTemplate sus inner join
  RTPhoenix.[SAMPLEUNITTemplate] su on su.SAMPLEUNIT_ID = sus.SAMPLEUNIT_ID join
  RTPhoenix.[SAMPLEPLANTemplate] sp on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID inner join
  RTPhoenix.[SURVEY_DEFTemplate] sd on sp.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.SAMPLEUNITTemplate
  FROM RTPhoenix.SAMPLEUNITTemplate su inner join
  RTPhoenix.[SAMPLEPLANTemplate] sp on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID inner join
  RTPhoenix.[SURVEY_DEFTemplate] sd on sp.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.SAMPLEPLANTemplate
  FROM RTPhoenix.SAMPLEPLANTemplate sp inner join
  RTPhoenix.[SURVEY_DEFTemplate] sd on sp.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.mailingstepTemplate
  FROM RTPhoenix.mailingstepTemplate ms inner join
  RTPhoenix.[MAILINGMETHODOLOGYTemplate] mm on ms.METHODOLOGY_ID = mm.METHODOLOGY_ID join
  RTPhoenix.[SURVEY_DEFTemplate] sd on mm.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.mailingmethodologyTemplate
  FROM RTPhoenix.mailingmethodologyTemplate mm inner join
  RTPhoenix.[SURVEY_DEFTemplate] sd on mm.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.SurveySubtypeTemplate
  FROM RTPhoenix.SurveySubtypeTemplate sst inner join
  RTPhoenix.[SURVEY_DEFTemplate] sd on sst.Survey_id = sd.SURVEY_ID
  where Study_id = @study_id

delete RTPhoenix.SURVEY_DEFTemplate
  FROM RTPhoenix.SURVEY_DEFTemplate
  where Study_id = @study_id

delete RTPhoenix.METALOOKUPTemplate
  FROM RTPhoenix.METALOOKUPTemplate ml inner join
		RTPhoenix.METATABLETemplate mt on ml.NUMMASTERTABLE_ID = mt.TABLE_ID
		where Study_id = @Study_id

delete RTPhoenix.METASTRUCTURETemplate
  FROM RTPhoenix.METASTRUCTURETemplate ms inner join
		RTPhoenix.METATABLETemplate mt on ms.TABLE_ID = mt.TABLE_ID
		where Study_id = @Study_id

delete rtphoenix.METATABLETemplate
  FROM rtphoenix.METATABLETemplate
  where Study_id = @Study_id

delete rtphoenix.STUDYTemplate
  FROM rtphoenix.STUDYTemplate
  where Study_id = @study_id

if not exists (select 1 from rtphoenix.StudyTemplate where client_id = @client_id)
delete rtphoenix.CLIENTTemplate
  FROM rtphoenix.CLIENTTemplate
where client_id = @client_id

delete rtphoenix.DTSMappingQLTemplate 
  FROM rtphoenix.DTSMappingQLTemplate dtsm inner join 
  rtphoenix.PackageQLTemplate p on dtsm.Package_id = p.Package_id
  where study_id = @study_id

delete rtphoenix.SourceQLTemplate 
  FROM rtphoenix.SourceQLTemplate s inner join 
  rtphoenix.PackageQLTemplate p on s.Package_id = p.Package_id
  where study_id = @study_id

delete rtphoenix.DestinationQLTemplate 
  FROM rtphoenix.DestinationQLTemplate d inner join 
  rtphoenix.PackageQLTemplate p on d.Package_id = p.Package_id
  where study_id = @study_id

delete rtphoenix.PackageQLTemplate 
  where study_id = @study_id

delete RTPhoenix.Template
where study_id = @study_id

INSERT INTO [RTPhoenix].[TemplateLog]([TemplateLogEntryType_ID], [Template_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@TemplateLogEntryInfo, @Template_ID, 'Template Deleted for study_id '+convert(varchar,@study_id), @user, GetDate())

commit tran

end try
begin catch
	INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
		 SELECT @Template_ID, @TemplateLogEntryError, 'Delete Template did not succeed and was rolled back', SYSTEM_USER, GetDate()

	rollback tran
end catch

GO