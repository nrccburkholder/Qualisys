/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [SentMail_id]
      ,[SamplePop_id]
      ,[Disposition_id]
      ,[ReceiptType_id]
      ,[datLogged]
      ,[LoggedBy]
      ,[DaysFromCurrent]
      ,[DaysFromFirst]
      ,[bitExtracted]
  FROM [QP_Prod].[dbo].[DispositionLog]
  where LoggedBy = 'DBA'
  order by datlogged desc


Select *
from [QP_Prod].[dbo].[DispositionLog]
where samplepop_ID in
(
100533897,
100533898,
100533899,
100533900,
100533901,
100533902,
100533903,
100533904,
100533905,
100533907,
100533908,
100533909,
100533910,
100533911,
100533912
) 


