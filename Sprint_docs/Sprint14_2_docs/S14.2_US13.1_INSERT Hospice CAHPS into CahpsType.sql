/*
	S14.2 US13 Add Hospice CAHPS type to NRC_Datamart

	Tim Butler

	INSERT INTO [dbo].[CahpsType]

*/
USE [NRC_Datamart]
GO

INSERT INTO [dbo].[CahpsType]
           ([CahpsTypeID]
           ,[Label]
           ,[NumberCutoffDays])
     VALUES
           (6
           ,'Hospice CAHPS'
           ,84)
GO

