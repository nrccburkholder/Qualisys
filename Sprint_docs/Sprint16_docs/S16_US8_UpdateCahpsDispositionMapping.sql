/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [CahpsTypeID]
      ,[DispositionID]
      ,[ReceiptTypeID]
      ,[Label]
      ,[CahpsDispositionID]
      ,[CahpsHierarchy]
      ,[IsDefaultDisposition]
  FROM [NRC_Datamart].[dbo].[CahpsDispositionMapping]

 -- update [NRC_Datamart].[dbo].[CahpsDispositionMapping]
	--SET ReceiptTypeID = 17
 -- where CahpsTypeID = 5 and DispositionID = 19 

 --update [NRC_Datamart].[dbo].[CahpsDispositionMapping]
	--SET ReceiptTypeID = 12
 -- where CahpsTypeID = 5 and DispositionID = 20 

  select *
  from [NRC_Datamart].[dbo].CahpsType