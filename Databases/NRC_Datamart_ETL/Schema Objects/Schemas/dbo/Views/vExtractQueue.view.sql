CREATE VIEW vExtractQueue
WITH SCHEMABINDING
AS
SELECT  [ExtractQueueID]
      ,[EntityTypeID]
      ,[PKey1]
      ,[PKey2]
      ,[IsMetaData]
      ,[ExtractFileID]
      ,[IsDeleted]
      ,[Created]
      ,[Source]
  FROM [dbo].[ExtractQueue]


