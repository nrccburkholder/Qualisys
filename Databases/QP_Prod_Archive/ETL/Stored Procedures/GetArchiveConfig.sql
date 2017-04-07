
CREATE PROCEDURE [ETL].[GetArchiveConfig]
AS
BEGIN
  SELECT CAST([MaxQueueSize] AS INT) AS [MaxQueueSize], CAST([ActiveMonths] AS INT) AS [ActiveMonths], CAST([NumToFind] AS INT) AS [NumToFind], CAST([NumToWork] AS INT) AS [NumToWork]
  FROM 
		(SELECT ConfigItem, ConfigValue
		FROM [ETL].[ArchiveConfig]
		WHERE Active = 1) AS SourceTable
		PIVOT
		(
		MAX(ConfigValue)
		FOR ConfigItem IN ([MaxQueueSize], [ActiveMonths], [NumToFind], [NumToWork])
		)  AS PivotTable;
END


