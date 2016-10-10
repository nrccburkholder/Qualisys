/****** Script for SelectTopNRows command from SSMS  ******/
SELECT distinct [SURVEY_ID]
      ,sd.[STUDY_ID]
      ,[STRSURVEY_NM]
      ,[STRSURVEY_DSC]
      ,[INTRESPONSE_RECALC_PERIOD]
      ,[INTRESURVEY_PERIOD]
      ,[BITREPEATINGENCOUNTERS_FLG]
      ,[BITPHYSASSIST_NAME_FLG]
      ,[BITMINOR_EXCEPT_FLG]
      ,[BITNEWBORN_FLG]
      ,[DATSURVEY_START_DT]
      ,[DATSURVEY_END_DT]
      ,[STRMAILFREQ]
      ,[INTSAMPLESINPERIOD]
      ,[STRXMITROUTE]
      ,[BITUSECOMMENTS]
      ,[STRCMNTCOPYTYPE]
      ,[STRCMNTSORT]
      ,[BITSENDCMNTOUT]
      ,[STRCMNTMAILFREQ]
      ,[STRCMNTCARRIER]
      ,[STROTHERINSTRUCTIONS]
      ,[STRCMNTTYPING_DBVER]
      ,[BITCMNTTYPING_ONDISK]
      ,[STRCMNT_CMNT]
      ,[BITVALIDATED_FLG]
      ,[DATVALIDATED]
      ,[BITFORMGENRELEASE]
      ,[BITLAYOUTVALID]
      ,[BITDYNAMIC]
      ,[STRCUTOFFRESPONSE_CD]
      ,[cutofftable_id]
      ,[cutofffield_id]
      ,[strHouseholdingType]
      ,[bitDoHousehold]
      ,[vcHouseholding]
      ,[intQuarter]
      ,[weighttype]
      ,[bitmultreturns]
      ,[Priority_Flg]
      ,[bitEnforceSkip]
      ,[strclientfacingName]
      ,[SurveyType_id]
      ,[AHANumber]
      ,[SurveyTypeDef_id]
      ,[ReSurveyMethod_id]
      ,[SamplingAlgorithmID]
      ,[SampleEncounterField_id]
      ,[SampleEncounterTable_id]
      ,[Contract]
      ,[bitPhoneTelematch]
      ,[Active]
      ,[PervasiveMapName]
      ,[ContractedLanguages]
      ,[UseUSPSAddrChangeService]
  FROM [dbo].[SURVEY_DEF] sd 
  inner join dbo.SELECTEDSAMPLE ss on ss.STUDY_ID = sd.STUDY_ID
 -- where survey_id = 16130
  

  SELECT distinct sd.[STUDY_ID]
  FROM [dbo].[SURVEY_DEF] sd 
  inner join dbo.surveytype st on st.SurveyType_ID = sd.SurveyType_id
  inner join dbo.SELECTEDSAMPLE ss on ss.STUDY_ID = sd.STUDY_ID
  where st.SurveyType_ID = 2


  select distinct SAMPLESET_ID
  from dbo.SELECTEDSAMPLE
  where STUDY_ID = 3558
  and SampleEncounterDate > '2016-01-01'
  and SAMPLESET_ID = 1218401


  select ss.*, sub.*, CASE WHEN CMSDataSubmissionSchedule_ID IS NULL THEN 2 ELSE 1 END 
  from dbo.SELECTEDSAMPLE ss
  left join [dbo].[CMSDataSubmissionSchedule] sub on sub.[month] = DATEPART(month,ss.SampleEncounterDate) and sub.[year] = DATEPART(year,ss.SampleEncounterDate) 
  where ss.STUDY_ID = 3558
  and sampleset_id in (1218401,1218399)


  select *
  from [dbo].[CMSDataSubmissionSchedule]