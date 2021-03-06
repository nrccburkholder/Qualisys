/****** Object:  StoredProcedure [dbo].[log_DbFileSize]    Script Date: 08/10/2006 16:47:10 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[log_DbFileSize]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[log_DbFileSize]
GO
/****** Object:  StoredProcedure [dbo].[log_DbFileSize]    Script Date: 08/10/2006 16:47:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[log_DbFileSize]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'






CREATE      PROCEDURE log_DbFileSize
--WITH ENCRYPTION 
AS 
BEGIN
SET NOCOUNT ON

-- Remove any logs for current day, do not want more than one log per day
-- Otherwise, regression will become weighed to days where resize was run
-- more than once
DELETE DbFileSizeLog WHERE StatusDate > CAST(CONVERT(varchar(20), GETDATE(), 101) AS datetime)

-- Temp work tables to store rows returned be dbcc functions
CREATE TABLE #FileDetails ( 
        FileId int , FileGroupId int , TotalExtents int , UsedExtents int , 
        Name nvarchar( 128 )  , FileName nvarchar( 500 ) , 
        TotalSize AS ( ( TotalExtents * 64.0 ) / 1024 ) , 
        UsedSize AS ( ( UsedExtents * 64.0 ) / 1024 ) 
)
CREATE TABLE #LogDetails (
       DatabaseName nvarchar( 128 ) , FileSize float , 
        Usage float , Status int
)

-- Get data file info: 
INSERT INTO #FileDetails ( 
        FileId , FileGroupId , TotalExtents , UsedExtents , Name , Filename 
) 
EXECUTE( ''dbcc showfilestats with tableresults'' ) 

-- Get log files info:
INSERT INTO #LogDetails (
       DatabaseName , FileSize ,  Usage , Status 
)
EXECUTE( ''dbcc sqlperf( logspace ) with tableresults'' )

INSERT INTO DbFileSizeLog(FileGroupName, FileId, Name, FileName, FileSizeMb, UsageSizeMb, PercentUsage)
SELECT FILEGROUP_NAME( FileGroupID )  AS FileGroupName , FileId , Name , FileName , 
       CAST(STR( TotalSize , 28 , 2 ) AS  decimal(18,2)) AS FileSizeMB , 
       CAST(STR( UsedSize , 28 , 2 ) AS decimal(18,2)) AS UsagetSizeMB , 
       CAST(STR( ( ( UsedExtents * 1. ) / TotalExtents ) * 100 , 5 , 2 ) AS decimal(18,2)) AS PercentUsage 
FROM #FileDetails 
UNION ALL
SELECT ''LOG'' , NULL , ''QMS_LOG'' , NULL ,
      CAST(STR( FileSize , 28 , 2 ) AS decimal(18,2)) AS FileSizeMB ,
      CAST(STR((FileSize * 1.) * (Usage / 100) , 28 , 2 ) AS decimal(18,2)) AS UsageSizeMB ,
      CAST(STR( Usage , 5 , 2 ) AS decimal(18,2)) AS PercentUsage
FROM #LogDetails
WHERE DatabaseName = DB_NAME()
ORDER BY FileGroupName , FileId

SET NOCOUNT OFF
END

' 
END
GO
