CREATE VIEW vExtractHistory
WITH SCHEMABINDING
AS
SELECT  [ExtractHistoryID]
      ,[ExtractFileID]
      ,[EntityTypeID]
      ,[PKey1]
      ,[PKey2]
      ,[IsMetaData]
      ,[IsDeleted]
      ,[Created]
      ,[Source]
  FROM [dbo].[ExtractHistory]


