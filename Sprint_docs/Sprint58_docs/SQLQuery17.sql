/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [DataFileState_id]
      ,[DataFile_id]
      ,[State_id]
      ,[datOccurred]
      ,[StateParameter]
      ,[StateDescription]
      ,[Member_id]
  FROM [QP_Load].[dbo].[DataFileState]
  where datafile_id = 3410


  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [DataFileState_id]
      ,[DataFile_id]
      ,[State_id]
      ,[datOccurred]
      ,[StateParameter]
      ,[StateDescription]
      ,[Member_id]
  FROM [QP_Load].[dbo].[DataFileState_History]
  where datafile_id = 3410


  DELETE FROM [QP_Load].[dbo].[DataFileState_History]
  where datafile_id = 3410
  and state_id = 14


  update [QP_Load].[dbo].[DataFileState]
	SET State_id = 14,
		StateParameter = '',
		StateDescription = 'DRGApplied',
		Member_id = 164662
  where datafile_id = 3410

  DELETE FROM [QP_Load].[dbo].[DataFileState_History]
  where datafile_id = 3410
  and state_id = 25