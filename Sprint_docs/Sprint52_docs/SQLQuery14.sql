/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [QuestionID]
      ,[QuestionVersionID]
      ,[ResponseScaleID]
      ,[QuestionText]
      ,[QuestionReportText]
      ,[QuestionModule]
      ,[QuestionModeLimit]
      ,[QuestionPickerDimension]
      ,[QuestionCAHPSDimension]
      ,[QuestionStaffDimension]
      ,[QuestionIsOR]
      ,[QuestionIsWR]
      ,[QuestionIsComment]
      ,[QuestionIsMultiResponse]
      ,[SourceSystemID]
  FROM [odsdb].[dbo].[MQR_Question]
  where SourceSystemID = 2
  order by QuestionID
  --and questionid = 4

  /*
  DELETE FROM [odsdb].[dbo].[MQR_Question]
  where SourceSystemID = 2
  and questionid = 999
  */

  /*
  update q
	SET QuestionReportText = 'Health Since Left Facility' -- Health Since Left Facility
  FROM [odsdb].[dbo].[MQR_Question] q
  where questionid in (4)
  and SourceSystemID = 2

    update q
	SET QuestionReportText = 'Health Since Left Facility' -- Health Since Left Facility
  FROM [odsdb].[dbo].[MQR_Question] q
  where questionid in (117)
  and SourceSystemID = 2

    update q
	SET QuestionReportText = 'Medications Questions' -- Medications Questions
  FROM [odsdb].[dbo].[MQR_Question] q
  where questionid = 5
  and SourceSystemID = 2


update q
	SET QuestionReportText = 'A Test Question' 
  FROM [odsdb].[dbo].[MQR_Question] q
  where questionid = 999
  and SourceSystemID = 2


  */