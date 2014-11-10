/****
S12.US23 USPS Partial and Multiple match resolution

T23.2	Develop as per the design session 

Tim Butler

Adding a Receipt Type


****/

USE [QP_Prod]
GO
begin tran
go



INSERT INTO [dbo].[ReceiptType]
           ([ReceiptType_nm]
           ,[ReceiptType_dsc]
           ,[bitUIDisplay]
           ,[TranslationCode])
     VALUES
           ('USPS Address Change'
           ,'USPS Address Change'
           ,0
           ,NULL)
GO
commit tran

