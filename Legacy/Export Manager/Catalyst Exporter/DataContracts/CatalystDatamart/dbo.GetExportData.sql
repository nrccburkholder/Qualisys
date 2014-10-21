USE [NRC_DataMart]
GO
/****** Object:  StoredProcedure [dbo].[GetExportData]    Script Date: 12/05/2012 13:28:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Emily Douglas [Nebraska Global]
-- Create date: 8/28/2012
-- Description:	Used by Catalyst Export website to create export file based pm surveyid, studyid and a date range.
-- =============================================
ALTER PROCEDURE [dbo].[GetExportData] 
	@SurveyId int,
	@StudyId int, 
	@StartDate date,
	@EndDate date,
	@DateType int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
declare @ReportDate varchar(1000)
set @ReportDate = 
	(SELECT
	  CASE 
			WHEN st.CahpsTypeID = 0 THEN dt.Label
			WHEN st.CahpsTypeID = 1 THEN 'Discharge Date'
			WHEN st.CahpsTypeID IN (2,3) THEN 'Service Date'
			ELSE NULL
	  END [Cutoff Field]
	FROM Survey s WITH(NOLOCK)
	INNER JOIN SurveyType st WITH(NOLOCK) ON s.SurveyTypeID = st.SurveyTypeID
	LEFT JOIN DateType dt WITH(NOLOCK) ON s.ReportDateTypeID = dt.DateTypeID
	where s.SurveyId = @SurveyId)

Select 
sv.ClientId as CatalystClientId,
sv.Client_Id as QualisysClientId,
sv.StudyId as CatalystStudyId,
sv.Study_Id as QualisysStudyId,
sv.SurveyID as CatalystSurveyId,
sv.Survey_ID as QualisysSurveyId,
su.sampleunitid as CatalystSampleUnitId,
suKey.DataSourceKey as QualisysSampleUnitId,
sp.SamplePopulationId as CatalystSamplePopulationId,
spKey.DataSourceKey as QualisysSamplePopulationId,
sp.SampleSetID,
sp.DispositionID,
sp.CahpsDispositionID,
sp.IsCahpsDispositionComplete,
sp.FirstName,
sp.LastName,
sp.City,
sp.Province,
sp.PostalCode,
sp.IsMale,
case when IsMale = 1 then 'Male' else 'Female' END as Gender,
sp.Age,
sp.LanguageID,
sp.AdmitDate,
sp.DischargeDate,
sp.ServiceDate,
sp.ReportDate,
qf.ReturnDate AS SurveyReturnDate,
rb.OriginalQuestionCore AS QuestionNumber,
rb.ResponseValue AS ResponseValues,
ISNULL(sqLT.Value,rb.MasterQuestionCore) AS QuestionLabel,
case when rb.ResponseValue = -9 then 'Invalid Response (No Response)' when rb.ResponseValue = -8  then 'Invalid Response (Multiple Response)' when rb.ResponseValue > 999  then ' Invalid Response (Skip Pattern Response)'  else  ISNULL(siLT.Value,rb.ResponseValue) end AS ScaleLabel,
CASE WHEN sq.SectionName  = 'DoD' THEN 'Standard Question' ELSE ISNULL(sq.SectionName,SPACE(1)) END AS Section,
ISNULL(qsq.QuestionSet,SPACE(1)) AS Dimension,
case when rc.UnmaskedResponse is null then rc.MaskedResponse when rc.UnmaskedResponse = '' then rc.MaskedResponse else rc.UnmaskedResponse end as UnmaskedResponse,
rc.MaskedResponse,
dskQF.DataSourceKey AS LithoCode,
su.Name as UnitName,
DATEDIFF(day,qf.DatMailed,qf.ReturnDate) AS DaysFromCurrentMailing,
DATEDIFF(day,qf.DatFirstMailed,qf.ReturnDate) AS DaysFromFirstMailing,
qf.DatExpire as ExpirationDate,
qf.DatUndeliverable as UndeliverableDate,
sas.SampleDate as SampleDate,
cd.Label as CahpsDispLabel,
mpn.MedicareProviderNumber,
cast(case when sv.CahpsTypeID = 1 and su.IsCahps = 1 then 1 else 0 end as bit) as HCAHPS,
cast(case when sv.CahpsTypeID = 2 and su.IsCahps = 1 then 1 else 0 end as bit) as HHCAHPS,
case when sp.CahpsDispositionID = 1 then 'HCAHPS Reportable' else 'HCAHPS Non-Reportable' end as HCAHPSReportable,
case when  sv.CahpsTypeID  = 2 then sp.CahpsDispositionID else null end as HHCAHPSDisp
from 
	 dbo.SampleUnit su WITH (NOLOCK) 
	 INNER JOIN dbo.v_ClientstudySurvey sv WITH (NOLOCK) ON su.SurveyID = sv.SurveyID
	 INNER JOIN dbo.SelectedSample ss WITH (NOLOCK) ON su.SampleUnitID = ss.SampleUnitID	
	 INNER JOIN dbo.QuestionForm qf WITH (NOLOCK) ON ss.SamplePopulationID = qf.SamplePopulationID
	 LEFT JOIN dbo.SurveyQuestion sq  WITH (NOLOCK) ON sq.SurveyID = sv.SurveyID
	 left JOIN dbo.ResponseBubble rb WITH (NOLOCK) ON qf.QuestionFormID = rb.QuestionFormID and rb.SurveyQuestionID = sq.SurveyQuestionID
	 LEFT JOIN dbo.ScaleItem si WITH (NOLOCK) ON sq.SurveyQuestionID = si.SurveyQuestionID AND rb.ResponseValue = si.ResponseValue
	 LEFT JOIN dbo.LocalizedText sqLT WITH (NOLOCK) ON sq.SurveyQuestionID = sqLT.EntityID AND sqLT.EntityTypeID = 4 AND sqLT.LanguageID = 1
	 LEFT JOIN dbo.LocalizedText siLT WITH (NOLOCK) ON si.ScaleItemID = siLT.EntityID AND siLT.EntityTypeID = 5 AND siLT.LanguageID = 1
	 LEFT JOIN dbo.v_QuestionSetQuestion qsq WITH (NOLOCK) ON rb.MasterQuestionCore = qsq.MasterQuestionCore AND qsq.Category = 'Picker Dimensions' and qsq.InstrumentTypeAbbr not like '%_old' and qsq.ClientID is null
	 inner join dbo.SamplePopulation sp WITH(NOLOCK) on sp.SamplePopulationId = ss.SamplePopulationID	
	 inner join dbo.SampleSet sas WITH(NOLOCK) on sp.SampleSetId = sas.SampleSetID
	 left join dbo.Responsecomment rc WITH (NOLOCK) ON qf.QuestionFormID = rc.QuestionFormID and rc.SurveyQuestionID = sq.SurveyQuestionID
	 left join etl.DataSourceKey suKey with (nolock) on su.SampleUnitId = suKey.DataSourceKeyId and suKey.EntityTypeId = 6
	 left join etl.DataSourceKey spKey with (nolock) on sp.SamplePopulationId = spKey.DataSourceKeyId and spKey.EntityTypeId = 7
	 left JOIN etl.DataSourceKey dskQF WITH (NOLOCK) ON qf.QuestionFormID = dskQF.DataSourceKeyID and dskQF.EntityTypeId = 11
     left join CahpsDisposition cd WITH (NOLOCK) on cd.CahpsDispositionID = sp.CahpsDispositionID
	 left join (SELECT sump.[SampleUnitID]
      ,sump.[BenchmarkDate]
      ,sump.[MedicareProviderNumber]      
	  FROM [SampleUnitMedicareProviderNumber] sump 
	  where not exists (select * from [SampleUnitMedicareProviderNumber]  high where 
	  high.SampleUnitId = sump.SampleUnitId  and high.BenchmarkDate > sump.BenchmarkDate)) mpn on mpn.SampleUnitID = su.SampleUnitID
	WHERE qf.IsActive = 1 AND sv.StudyID = @StudyId AND sv.SurveyID = @SurveyId and (rb.responsebubbleid is not null or rc.responsecommentid is not null)
		AND case @DateType
				when 1 then qf.ReturnDate
				else case @ReportDate 
						when 'Discharge Date' then sp.DischargeDate 
						when 'Service Date' then sp.ServiceDate 
						else sp.ReportDate 
					 end
			end BETWEEN @StartDate AND @EndDate

END

