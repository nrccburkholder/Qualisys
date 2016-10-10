USE [odsdb]
GO

INSERT INTO [dbo].[MQR_Question]
           ([QuestionID]
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
           ,[SourceSystemID])
     VALUES
           (999
           ,0
           ,2
           ,'Did you know that this is only a test question?'
           ,'Test Question'
           ,null
           ,null
           ,null
           ,null
           ,null
           ,null
           ,null
           ,null
           ,1
           ,2)
GO


update  [dbo].[MQR_Question]
	SET QuestionText = 'Did you know this is just a test question?'
	, QuestionReportText = 'This is a test question'
where QuestionID = 999
and SourceSystemID = 2