/*

S36 US18 ICD-10 - HH Importer - New OCS HH 10 Only Transform	As a Data Mgmt Associate, I want a new OCS HHCAHPS transform created that maps to ICD-10 fields, but not to ICD-9, so that I don't have to continue to add the ICD-9 fields to new studies

Task 1 - analysis: review DB structure and tables for transforms and determine which tables to populate
Task 2 - write queries to insert new transform

Tim Butler

ROLLBACK

*/

USE [QP_DataLoad]
GO

DECLARE @TransformId int
DECLARE @TransformTargetId int
DECLARE @TransformName varchar(100) = 'OCS HHCAHPS ICD10'
DECLARE @CreateUser varchar(64) = 'nrc\tbutler'

begin tran

SELECT @TransformId = TransformId
FROM Transform 
WHERE TransformName = @TransformName

DELETE tm
FROM  [TransformMapping] tm
INNER JOIN [TransformTarget] tt on tt.TransformTargetId = tm.TransformTargetId
INNER JOIN [TransformDefinition] td on td.TransformTargetId = tt.TransformTargetId
INNER JOIN [Transform] t on t.TransformId = td.TransformId

DELETE tt
FROM  [TransformTarget] tt
INNER JOIN [TransformDefinition] td on td.TransformTargetId = tt.TransformTargetId
INNER JOIN [Transform] t on t.TransformId = td.TransformId

DELETE td
FROM [TransformDefinition] td 
INNER JOIN [Transform] t on t.TransformId = td.TransformId


DELETE ti
FROM [TransformImports] ti
INNER JOIN [Transform] t on t.TransformId = ti.TransformId

DELETE Transform 
WHERE TransformName = @TransformName

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