/*

	ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	S44 US12 CG-CAHPS Completeness 
	As a CG-CAHPS vendor, we need to update completeness calculations for CG-CAHPS to match new guidelines, so that we can submit accurate data for state-level initiatives.

	Task 2 - Update SurveyTypeQuestionMappings table on QP_Prod

	T. Butler	
*/

USE QP_PROD
GO

DECLARE @Surveytype_id int
DECLARE @Subtype_id int


SELECT @Surveytype_id = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'CGCAHPS'



begin tran

--1
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '6-month Adult 2.0'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 


--2
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '6-month Adult 3.0'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 


--3
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '6-month Child 3.0'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 



--4
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '12-month Adult 2.0'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 



--5
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = 'Visit Adult 2.0'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 



--6
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '6-month Adult 2.0 w/ PCMH'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 



--7
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '12-month Adult 2.0 w/ PCMH'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 




--8
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '12-month Child 2.0 w/ PCMH'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 



--9
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '6-month Child 2.0'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 



--10
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '6-month Child 2.0 w/ PCMH'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 


--11
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '12-month Child 2.0'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 


-- re-populate SurveyTypeQuestionMappings with the old records we removed as part of this story
insert into dbo.SurveyTypeQuestionMappings
SELECT [SurveyType_id]
      ,[QstnCore]
      ,[intOrder]
      ,[bitFirstOnForm]
      ,[bitExpanded]
      ,[datEncounterStart_dt]
      ,[datEncounterEnd_dt]
      ,[SubType_ID]
      ,[isATA]
      ,[isMeasure]
  FROM [dbo].[SurveyTypeQuestionMappings_Old]
  where surveytype_id = 4
  and [Comment] = 'S44 US12'


commit tran



SELECT st.Subtype_nm, stqm.* 
FROM [dbo].[SurveyTypeQuestionMappings] stqm
inner join dbo.Subtype st on st.Subtype_id = stqm.SubType_ID
WHERE  SurveyType_id = 4
order by stqm.Subtype_id, intOrder

SELECT stqm.* 
FROM [dbo].[SurveyTypeQuestionMappings] stqm
WHERE  SurveyType_id = 4
order by stqm.Subtype_id, intOrder