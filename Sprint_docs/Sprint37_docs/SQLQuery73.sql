
USE [NRC_DataMart_ETL]
GO



CREATE TABLE #SamplePopTemp(
	[ExtractFileID] [int] NOT NULL,
	[SAMPLESET_ID] [int] NULL,
	[STUDY_ID] [int] NULL,
	[SAMPLEPOP_ID] [int] NULL,
	[POP_ID] [int] NULL,
	[ENC_ID] [int] NULL,
	[firstName] [nvarchar](100) NULL,
	[lastName] [nvarchar](100) NULL,
	[city] [nvarchar](100) NULL,
	[province] [nchar](2) NULL,
	[postalCode] [nvarchar](20) NULL,
	[language] [nchar](2) NULL,
	[age] [int] NULL,
	[isMale] [bit] NULL,
	[admitDate] [datetime] NULL,
	[serviceDate] [datetime] NULL,
	[dischargeDate] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_SamplePopTemp_IsDeleted]  DEFAULT ((0)),
	[drNPI] [nvarchar](100) NULL,
	[clinicNPI] [nvarchar](100) NULL,
	[SupplementalQuestionCount] [int] NULL,
	[NumberOfMailAttempts] [int] NULL,
	[NumberOfPhoneAttempts] [int] NULL
) 


INSERT INTO #SamplePopTemp
           ([ExtractFileID]
           ,[SAMPLESET_ID]
           ,[STUDY_ID]
           ,[SAMPLEPOP_ID]
           ,[POP_ID]
           ,[ENC_ID]
           ,[firstName]
           ,[lastName]
           ,[city]
           ,[province]
           ,[postalCode]
           ,[language]
           ,[age]
           ,[isMale]
           ,[admitDate]
           ,[serviceDate]
           ,[dischargeDate]
           ,[IsDeleted]
           ,[drNPI]
           ,[clinicNPI]
           ,[SupplementalQuestionCount]
           ,[NumberOfMailAttempts]
           ,[NumberOfPhoneAttempts])
     VALUES
           (1
           ,NULL
           ,NULL
           ,118014524
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,0
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL)



select smg.SAMPLEPOP_ID , sm.SENTMAIL_ID, sm.DATUNDELIVERABLE,  ms.INTSEQUENCE, qf.datReturned, dlog.Disposition_id, min(std.Hierarchy) hierarchy, stmg.MethodologyType
	INTO #Mailings
	FROM #SamplePopTemp spt
	left join QP_Prod.[dbo].[SCHEDULEDMAILING] smg on smg.SAMPLEPOP_ID = spt.SAMPLEPOP_ID
	left join QP_Prod.[dbo].[SENTMAILING] sm on sm.SCHEDULEDMAILING_ID = smg.SCHEDULEDMAILING_ID
	left join QP_Prod.[dbo].[MAILINGSTEP] ms on ms.MAILINGSTEP_ID = smg.MAILINGSTEP_ID
	left join QP_Prod.[dbo].[MAILINGMETHODOLOGY] mmg on mmg.METHODOLOGY_ID = ms.METHODOLOGY_ID and mmg.SURVEY_ID = ms.SURVEY_ID
	left join QP_Prod.[dbo].[StandardMethodology] stmg on stmg.StandardMethodologyID = mmg.StandardMethodologyID
	left join QP_Prod.dbo.QUESTIONFORM qf With (NOLOCK) on qf.SAMPLEPOP_ID = smg.SAMPLEPOP_ID and qf.SENTMAIL_ID = sm.SENTMAIL_ID
	left join QP_Prod.[dbo].SURVEY_DEF sd on sd.survey_id = qf.survey_id
	left join QP_Prod.[dbo].SurveyType st on st.SurveyType_id = sd.surveytype_id
	left join QP_Prod.[dbo].[DispositionLog] dlog on dlog.SamplePop_id = smg.SAMPLEPOP_ID and dlog.SentMail_id = sm.SENTMAIL_ID
	left join QP_Prod.[dbo].[Disposition] d on d.Disposition_id = dlog.Disposition_id
	left join QP_Prod.dbo.SurveyTypeDispositions std on std.Disposition_ID = d.Disposition_id and std.SurveyType_ID = st.SurveyType_ID
	where smg.OVERRIDEITEM_ID is null
	--and stmg.MethodologyType = 'Mail Only'
	group by smg.SAMPLEPOP_ID , sm.SENTMAIL_ID, sm.DATUNDELIVERABLE,  ms.INTSEQUENCE, qf.datReturned, dlog.Disposition_id, stmg.MethodologyType


	select *
	from #Mailings


 update spt
	SET NumberOfMailAttempts = 
		CASE 
			WHEN (m1.Disposition_id NOT IN (15)) THEN m1.INTSEQUENCE
			ELSE (SELECT MAX(INTSEQUENCE) FROM #Mailings m WHERE m.SAMPLEPOP_ID = spt.SAMPLEPOP_ID)
		END
	FROM #SamplePopTemp spt
	left join #Mailings m1 on m1.SAMPLEPOP_ID = spt.SAMPLEPOP_ID  
	and m1.hierarchy = (SELECT min(hierarchy) FROM #Mailings m WHERE m.SAMPLEPOP_ID = spt.SAMPLEPOP_ID) where m1.MethodologyType = 'Mail Only'


	--SELECT dlog.SamplePop_id, count(dlog.SamplePop_id) phoneAttempts
	--FROM QP_Prod.[dbo].[DispositionLog] dlog 
	--inner join #samplepoptemp spt on spt.SamplePop_id = dlog.SamplePop_id
	--WHERE dlog.LoggedBy = 'QSI Transfer Results Service'
	--GROUP by dlog.SamplePop_id

	update spt
	SET NumberOfPhoneAttempts = d.phoneAttempts
	FROM #SamplePopTemp spt
	inner join (SELECT dlog.SamplePop_id, count(dlog.SamplePop_id) phoneAttempts
			    FROM QP_Prod.[dbo].[DispositionLog] dlog 
				WHERE dlog.LoggedBy = 'QSI Transfer Results Service'
				GROUP by dlog.SamplePop_id) d on d.SamplePop_id = spt.SAMPLEPOP_ID


	--SELECT 
	--	CASE 
	--		WHEN (m1.Disposition_id NOT IN (15)) THEN m1.INTSEQUENCE
	--		ELSE (SELECT MAX(INTSEQUENCE) FROM #Mailings m WHERE m.SAMPLEPOP_ID = spt.SAMPLEPOP_ID)
	--	END
	--FROM #SamplePopTemp spt
	--left join #Mailings m1 on m1.SAMPLEPOP_ID = spt.SAMPLEPOP_ID  
	--and m1.hierarchy = (SELECT min(hierarchy) FROM #Mailings m WHERE m.SAMPLEPOP_ID = spt.SAMPLEPOP_ID) 

	drop table #Mailings


	select *
	from #samplePopTemp

	drop table #SamplePopTemp