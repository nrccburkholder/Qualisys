/*

	S16 US8 Handle Phone Completes as phone completes rather than mail completes

	Tim Butler

*/

  update [NRC_Datamart].[dbo].[CahpsDispositionMapping]
	SET ReceiptTypeID = 17
  where CahpsTypeID = 5 and DispositionID = 19 

 update [NRC_Datamart].[dbo].[CahpsDispositionMapping]
	SET ReceiptTypeID = 12
  where CahpsTypeID = 5 and DispositionID = 20 



SELECT [CahpsTypeID]
      ,[DispositionID]
      ,[ReceiptTypeID]
      ,[Label]
      ,[CahpsDispositionID]
      ,[CahpsHierarchy]
      ,[IsDefaultDisposition]
  FROM [NRC_Datamart].[dbo].[CahpsDispositionMapping]
