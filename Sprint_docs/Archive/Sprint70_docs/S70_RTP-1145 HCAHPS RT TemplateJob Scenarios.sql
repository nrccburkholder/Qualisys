--SCENARIO 1
--Study with everything (all surveys + all sample units) [1, -1, -1, -1] -> [3543, -1, -1]
INSERT INTO [RTPhoenix].[TemplateJob]
           (--no master
		    [TemplateJobTypeID],[TemplateID],[TemplateSurveyID],[TemplateSampleUnitID]
		   ,[CAHPSSurveyTypeID],[CAHPSSurveySubtypeID],[RTSurveyTypeID],[RTSurveySubtypeID],[AsOfDate]
		   ,[TargetClientID],[TargetStudyID],[TargetSurveyID]
           ,[StudyName],[StudyDescription],[SurveyName],[SampleUnitName]
           ,[MedicareNumber]
           ,[LoggedBy],[LoggedAt]
           ,[CompletedNotes],[CompletedAt])
     VALUES
           (1, -1, -1, -1
		   ,2, 41, 27, 42, GetDate()
		   ,3543, -1, -1
           ,'HCRT-All','Everything Study Exported From RTPhoenix Template',null,null
           ,'X91111'
           ,SYSTEM_USER,GetDate()
           ,NULL,NULL)
---------------------------------------------
--SCENARIO 1B

--Study with nothing (no surveys nor sample units) [1, -1, 0, 0] -> [3543, -1, -1]
INSERT INTO [RTPhoenix].[TemplateJob] 
           (--no master
		    [TemplateJobTypeID],[TemplateID],[TemplateSurveyID],[TemplateSampleUnitID]
		   ,[CAHPSSurveyTypeID],[CAHPSSurveySubtypeID],[RTSurveyTypeID],[RTSurveySubtypeID],[AsOfDate]
		   ,[TargetClientID],[TargetStudyID],[TargetSurveyID]
           ,[StudyName],[StudyDescription],[SurveyName],[SampleUnitName]
           ,[MedicareNumber]
           ,[LoggedBy],[LoggedAt]
           ,[CompletedNotes],[CompletedAt])
     VALUES
           (1, -1, 0, 0
		   ,2, 41, 27, 42, GetDate()
		   ,3543, -1, -1
           ,'HCRT-Exist','Study Only Exported From RTPhoenix Template',null,null
           ,NULL
           ,SYSTEM_USER,GetDate()
           ,NULL,NULL)

---------------------------------------------
--SCENARIO 2

--Now pretending prior inserted study from scenario 1B is a preexisting study to which to add the HCAHPS template's HCAHPS survey 
--Add Prepopulated Survey and Specific Sample Unit from the template [2, -1, -1, -1] -> [3543, 5888, -1]
INSERT INTO [RTPhoenix].[TemplateJob] 
           (--no master
		    [TemplateJobTypeID],[TemplateID],[TemplateSurveyID],[TemplateSampleUnitID]
		   ,[CAHPSSurveyTypeID],[CAHPSSurveySubtypeID],[RTSurveyTypeID],[RTSurveySubtypeID],[AsOfDate]
		   ,[TargetClientID],[TargetStudyID],[TargetSurveyID]
           ,[StudyName],[StudyDescription],[SurveyName],[SampleUnitName]
           ,[MedicareNumber]
           ,[LoggedBy],[LoggedAt])
select top 1
	2 [TemplateJobTypeID], -1, -1, -1, -- tj.TemplateID, css.survey_id [TemplateSurveyID], su.sampleunit_id [TemplateSampleUnitID], 
    2, 41, 27, 42, GetDate(),
	tj.TargetClientID, tj.TargetStudyId, -1 [TargetSurveyID],
	tj.StudyName, tj.StudyDescription, null, su.STRSAMPLEUNIT_NM [SampleUnitName],
	NULL as [MedicareNumber], 
	tj.LoggedBy, tj.LoggedAt
from RTPhoenix.TemplateJob tj inner join
	RTPhoenix.ClientStudySurvey_viewTemplate css on css.TemplateID = tj.TemplateID inner join
	RTPhoenix.SAMPLEPLANTemplate sp on sp.SURVEY_ID = css.survey_id join 
	RTPhoenix.SAMPLEUNITTemplate su on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID
		and css.SurveyType_id = su.CAHPSType_id
where tj.TemplateSurveyID = 0 and 
	tj.TemplateSampleUnitID = 0 and 
	tj.TemplateJobTypeID = 1 and
	css.SurveyType_id = 2 and
	tj.CompletedAt is not null
order by tj.LoggedAt desc

Declare @SurveyTemplateJob_ID int = ident_current('RTPhoenix.TemplateJob')

--Add Prepopulated Survey and Specific Sample Unit from the template [3, -1, -1, -1] -> [3543, 5888, -1]
INSERT INTO [RTPhoenix].[TemplateJob]
           (--no master
		    [MasterTemplateJobID],
			[TemplateJobTypeID],[TemplateID],[TemplateSurveyID],[TemplateSampleUnitID]
		   ,[CAHPSSurveyTypeID],[CAHPSSurveySubtypeID],[RTSurveyTypeID],[RTSurveySubtypeID],[AsOfDate]
		   ,[TargetClientID],[TargetStudyID],[TargetSurveyID]
           ,[StudyName],[StudyDescription],[SurveyName],[SampleUnitName]
           ,[MedicareNumber]
           ,[LoggedBy],[LoggedAt])
select top 1
	@SurveyTemplateJob_ID as [MasterTemplateJobID],
	3 [TemplateJobTypeID], -1, -1, -1, -- tj.TemplateID, css.survey_id [TemplateSurveyID], su.sampleunit_id [TemplateSampleUnitID], 
    2, 41, 27, 42, GetDate(),
	tj.TargetClientID, tj.TargetStudyId, -1 [TargetSurveyID],
	tj.StudyName, tj.StudyDescription, css.strSurvey_nm [SurveyName], su.STRSAMPLEUNIT_NM [SampleUnitName],
	'T00001' as [MedicareNumber],
	tj.LoggedBy, tj.LoggedAt
from RTPhoenix.TemplateJob tj inner join
	RTPhoenix.ClientStudySurvey_viewTemplate css on css.TemplateID = tj.TemplateID inner join
	RTPhoenix.SAMPLEPLANTemplate sp on sp.SURVEY_ID = css.survey_id join 
	RTPhoenix.SAMPLEUNITTemplate su on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID
		and css.SurveyType_id = su.CAHPSType_id
where tj.TemplateSurveyID = 0 and 
	tj.TemplateSampleUnitID = 0 and 
	tj.TemplateJobTypeID = 1 and
	css.SurveyType_id = 2 and
	tj.CompletedAt is not null
order by tj.LoggedAt desc
---------------------------------------------
--SCENARIO 3
--Initial Production Beta Client to ADD NEW study from template with pre-populated Sample Unit(s)
--Add new study with everything, but send along sample unit request(s) in same batch, hook up mastertemplate_id
--So...[1, -1, -1, -1] -> [3543, -1, -1] then [3, -1, -1, -1] -> [3543, -1, -1]
INSERT INTO [RTPhoenix].[TemplateJob]
           ([TemplateJobTypeID],[TemplateID],[TemplateSurveyID],[TemplateSampleUnitID]
		   ,[CAHPSSurveyTypeID],[CAHPSSurveySubtypeID],[RTSurveyTypeID],[RTSurveySubtypeID],[AsOfDate]
		   ,[TargetClientID],[TargetStudyID],[TargetSurveyID]
           ,[StudyName],[StudyDescription],[SurveyName],[SampleUnitName]
           ,[MedicareNumber]
           ,[LoggedBy],[LoggedAt]
           ,[CompletedNotes],[CompletedAt])
     VALUES
           (1, -1, -1, -1
		   ,2, 41, 27, 42, GetDate()
		   ,3543, -1, -1
           ,'HCRT-New','Study w/Everything From RTPhoenix Template',null,null
           ,NULL
           ,SYSTEM_USER,GetDate()
           ,NULL,NULL)

Declare @StudyTemplateJob_ID int = ident_current('RTPhoenix.TemplateJob')

INSERT INTO [RTPhoenix].[TemplateJob]
           ([MasterTemplateJobID]
		   ,[TemplateJobTypeID],[TemplateID],[TemplateSurveyID],[TemplateSampleUnitID]
		   ,[CAHPSSurveyTypeID],[CAHPSSurveySubtypeID],[RTSurveyTypeID],[RTSurveySubtypeID],[AsOfDate]
		   ,[TargetClientID],[TargetStudyID],[TargetSurveyID]
           ,[StudyName],[StudyDescription],[SurveyName],[SampleUnitName]
           ,[MedicareNumber]
           ,[LoggedBy],[LoggedAt]
           ,[CompletedNotes],[CompletedAt])
     VALUES
           (@StudyTemplateJob_ID --hooked up to original Study request record
		   ,3, -1, -1, -1
		   ,2, 41, 27, 42, GetDate()
		   ,3543, -1, -1
           ,'HCRT-New','Study w/Everything From RTPhoenix Template','HCAHPS','HCAHPSRT'
           ,'T00001'
           ,SYSTEM_USER,GetDate()
           ,NULL,NULL)

INSERT INTO [RTPhoenix].[TemplateJob]
           ([MasterTemplateJobID]
		   ,[TemplateJobTypeID],[TemplateID],[TemplateSurveyID],[TemplateSampleUnitID]
		   ,[CAHPSSurveyTypeID],[CAHPSSurveySubtypeID],[RTSurveyTypeID],[RTSurveySubtypeID],[AsOfDate]
		   ,[TargetClientID],[TargetStudyID],[TargetSurveyID]
           ,[StudyName],[StudyDescription],[SurveyName],[SampleUnitName]
           ,[MedicareNumber]
           ,[LoggedBy],[LoggedAt]
           ,[CompletedNotes],[CompletedAt])
     VALUES
           (@StudyTemplateJob_ID --hooked up to original Study request record
		   ,3, -1, -1, -1
		   ,2, 41, 27, 42, GetDate()
		   ,3543, -1, -1
           ,'HCRT-New','Study w/Everything From RTPhoenix Template','HCAHPS','HCAHPSRT'
           ,'T00004'
           ,SYSTEM_USER,GetDate()
           ,NULL,NULL)

--select * from medicarelookup ml inner join sufacility suf on ml.medicarenumber = suf.medicarenumber
---------------------------------------------
--SCENARIO 4
--Add another CCN/Sample Unit to an existing RT HCAHPS survey with existing Sample Units
--Pretend SCENARIO 3 is an existing RT Study/Survey/SampleUnit and we are adding to it
--STEP 2 after SCENARIO 3
--So...[3, -1, 0, 0] -> [3543, 5887, 20708]
INSERT INTO [RTPhoenix].[TemplateJob]
           ([TemplateJobTypeID],[TemplateID],[TemplateSurveyID],[TemplateSampleUnitID]
		   ,[CAHPSSurveyTypeID],[CAHPSSurveySubtypeID],[RTSurveyTypeID],[RTSurveySubtypeID],[AsOfDate]
		   ,[TargetClientID],[TargetStudyID],[TargetSurveyID]
           ,[StudyName],[StudyDescription],[SurveyName],[SampleUnitName]
           ,[MedicareNumber]
           ,[LoggedBy],[LoggedAt])
select top 1 
	3 [TemplateJobTypeID], -1, 0, 0, -- tj.TemplateID, css.survey_id [TemplateSurveyID], su.sampleunit_id [TemplateSampleUnitID], 
    2, 41, 27, 42, GetDate(),
	tj.TargetClientID, tj.TargetStudyId, tj.TargetSurveyID,
	tj.StudyName, tj.StudyDescription, css.strSurvey_nm [SurveyName], su.STRSAMPLEUNIT_NM [SampleUnitName],
	'260141' as [MedicareNumber], 
	tj.LoggedBy, tj.LoggedAt
from RTPhoenix.TemplateJob tj inner join
	RTPhoenix.ClientStudySurvey_viewTemplate css on css.TemplateID = tj.TemplateID inner join
	RTPhoenix.SAMPLEPLANTemplate sp on sp.SURVEY_ID = css.survey_id join 
	RTPhoenix.SAMPLEUNITTemplate su on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID
		and css.SurveyType_id = su.CAHPSType_id
where 
	tj.TemplateSampleUnitID = -1 and 
	tj.TemplateJobTypeID = 2 and
	tj.SurveyName = css.strSurvey_nm and
	css.SurveyType_id = 2 and
	tj.CompletedAt is not null
order by tj.LoggedAt desc
---------------------------------------------
