/*

S36 US18 ICD-10 - HH Importer - New OCS HH 10 Only Transform	As a Data Mgmt Associate, I want a new OCS HHCAHPS transform created that maps to ICD-10 fields, but not to ICD-9, so that I don't have to continue to add the ICD-9 fields to new studies

Task 1 - analysis: review DB structure and tables for transforms and determine which tables to populate
Task 2 - write queries to insert new transform

Tim Butler

*/

USE [QP_DataLoad]
GO

DECLARE @TransformId int
DECLARE @TransformTargetId int
DECLARE @TransformName varchar(100) = 'OCS HHCAHPS ICD10'
DECLARE @CreateUser varchar(64) = 'nrc\tbutler'

begin tran

INSERT INTO [dbo].[Transform]
           ([TransformName]
           ,[CreateDate]
           ,[CreateUser]
           ,[UpdateDate]
           ,[UpdateUser])
     VALUES
           (@TransformName
           ,GETDATE()
           ,@CreateUser
           ,NULL
           ,NULL)

SET @TransformId = SCOPE_IDENTITY()



INSERT INTO [dbo].[TransformTarget]
           ([TargetName]
           ,[TargetTable]
           ,[CreateDate]
           ,[CreateUser]
           ,[UpdateDate]
           ,[UpdateUser])
     VALUES
           (@TransformName + ' Encounter'
           ,'Encounter_Load'
           ,GETDATE()
           ,@CreateUser
           ,NULL
           ,NULL)

SET @TransformTargetId = SCOPE_IDENTITY()

INSERT INTO [dbo].[TransformDefinition]
           ([TransformId]
           ,[TransformTargetId]
           ,[CreateDate]
           ,[CreateUser]
           ,[UpdateDate]
           ,[UpdateUser])
     VALUES
           (@TransformId
           ,@TransformTargetId
           ,GETDATE()
           ,@CreateUser
           ,NULL
           ,NULL)

INSERT INTO [QP_DataLoad].[dbo].[TransformMapping]
SELECT @TransformTargetId
      ,[SourceFieldName]
      ,[TargetFieldname]
      ,[Transform]
      ,[CreateDate]
      ,[CreateUser]
      ,[UpdateDate]
      ,[UpdateUser]
  FROM [QP_DataLoad].[dbo].[TransformMapping]
  WHERE TransformTargetId = 1
  and TargetFieldname not like 'ICD9%'



INSERT INTO [dbo].[TransformTarget]
           ([TargetName]
           ,[TargetTable]
           ,[CreateDate]
           ,[CreateUser]
           ,[UpdateDate]
           ,[UpdateUser])
     VALUES
           (@TransformName + ' Population'
           ,'Population_Load'
           ,GETDATE()
           ,@CreateUser
           ,NULL
           ,NULL)

SET @TransformTargetId = SCOPE_IDENTITY()

INSERT INTO [dbo].[TransformDefinition]
           ([TransformId]
           ,[TransformTargetId]
           ,[CreateDate]
           ,[CreateUser]
           ,[UpdateDate]
           ,[UpdateUser])
     VALUES
           (@TransformId
           ,@TransformTargetId
           ,GETDATE()
           ,@CreateUser
           ,NULL
           ,NULL)


INSERT INTO [QP_DataLoad].[dbo].[TransformMapping]
SELECT @TransformTargetId
      ,[SourceFieldName]
      ,[TargetFieldname]
      ,[Transform]
      ,[CreateDate]
      ,[CreateUser]
      ,[UpdateDate]
      ,[UpdateUser]
  FROM [QP_DataLoad].[dbo].[TransformMapping]
  WHERE TransformTargetId = 2
  and TargetFieldname not like 'ICD9%'



INSERT INTO [dbo].[TransformImports]
           ([TransformId]
           ,[TransformLibraryId]
           ,[CreateDate]
           ,[CreateUser]
           ,[UpdateDate]
           ,[UpdateUser])
     VALUES
           (@TransformId
           ,1
           ,GETDATE()
           ,@CreateUser
           ,NULL
           ,NULL)


INSERT INTO [dbo].[TransformImports]
           ([TransformId]
           ,[TransformLibraryId]
           ,[CreateDate]
           ,[CreateUser]
           ,[UpdateDate]
           ,[UpdateUser])
     VALUES
           (@TransformId
           ,2
           ,GETDATE()
           ,@CreateUser
           ,NULL
           ,NULL)



commit tran


SELECT *
  FROM [QP_DataLoad].[dbo].[Transform]

SELECT *
  FROM [QP_DataLoad].[dbo].[TransformTarget]

SELECT *
  FROM [QP_DataLoad].[dbo].[TransformDefinition]

SELECT *
  FROM [QP_DataLoad].[dbo].[TransformImports]

SELECT*
  FROM [QP_DataLoad].[dbo].[TransformMapping] tm
  inner join [QP_DataLoad].[dbo].[TransformTarget] tt on tm.TransformTargetId = tt.TransformTargetId
  inner join [QP_DataLoad].[dbo].[TransformDefinition] td on td.TransformTargetId = tt.TransformTargetId
  inner join [QP_DataLoad].[dbo].[Transform] t on t.TransformId = td.TransformId
  where t.TransformName = @TransformName


  GO