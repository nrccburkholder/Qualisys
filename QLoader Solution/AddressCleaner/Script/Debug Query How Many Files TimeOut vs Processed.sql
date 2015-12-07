USE QP_Load
GO

DECLARE @FromDate DATETIME
SET @FromDate = '2015-12-07'

SELECT
	COUNT(*) As Total, 'Loaded & Cleaned' AS Status
FROM
	[dbo].[DataFileState_History] DFSH1
	INNER JOIN
	[dbo].[DataFileState_History] DFSH4 ON DFSH1.DataFile_id = DFSH4.DataFile_id AND DFSH4.State_Id = 4
WHERE
DFSH1.datOccurred > @FromDate AND DFSH1.State_Id = 1

UNION 

SELECT
	COUNT(*) As Total, 'Timed Out' As Status
FROM
	[dbo].[DataFileState_History] DFSH1
	INNER JOIN
	[dbo].[DataFileState] DFSH11 ON DFSH1.DataFile_id = DFSH11.DataFile_id AND DFSH11.State_Id = 11 AND DFSH11.StateParameter = 'Address Cleaning Exception: The operation has timed out'
WHERE
	DFSH1.datOccurred > @FromDate
AND DFSH1.State_Id = 1


UNION

SELECT
	COUNT(*) As Total, 'Abandoned for other reason' As Status
FROM
	[dbo].[DataFileState_History] DFSH1
	INNER JOIN
	[dbo].[DataFileState] DFSH11 ON DFSH1.DataFile_id = DFSH11.DataFile_id AND DFSH11.State_Id = 11 
	AND DFSH11.StateParameter <> 'Address Cleaning Exception: The operation has timed out'
WHERE
	DFSH1.datOccurred > @FromDate
AND DFSH1.State_Id = 1
