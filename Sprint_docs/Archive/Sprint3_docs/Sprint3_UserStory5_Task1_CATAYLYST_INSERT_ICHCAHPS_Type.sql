USE [NRC_Datamart]

/****** Script for SelectTopNRows command from SSMS  ******/

--S3_5.1_CATAYLYST_INSERT_ICHCAHPS_Type

SELECT [CahpsTypeID]
      ,[Label]
      ,[NumberCutoffDays]
  FROM [NRC_Datamart].[dbo].[CahpsType]


INSERT INTO [dbo].[CahpsType]
           ([CahpsTypeID]
           ,[Label]
           ,[NumberCutoffDays])
     VALUES
           (5
           ,'ICHCAHPS'
           ,84)

SELECT [CahpsTypeID]
      ,[Label]
      ,[NumberCutoffDays]
  FROM [NRC_Datamart].[dbo].[CahpsType]

