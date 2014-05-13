--DCL_InsertScheduledExport
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[DCL_InsertScheduledExport] 
@RunDate DATETIME,
@IncludeOnlyReturns BIT,
@IncludeOnlyDirects BIT,
@IncludeDispositionRecords BIT,
@FileType INT,
@FileNm varchar(100),
@UserName VARCHAR(42)
AS

INSERT INTO ExportSchedule (RunDate,ReturnsOnly,DirectsOnly,FileType,FileName,ScheduledBy,ScheduledDate,IncludeDispositionRecords)
SELECT @RunDate,@IncludeOnlyReturns,@IncludeOnlyDirects,@FileType,@FileNm,@UserName,GETDATE(),@IncludeDispositionRecords

SELECT SCOPE_IDENTITY()


--DCL_SelectScheduledExportsBySurvey
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[DCL_SelectScheduledExportsBySurvey]
@StartDate DATETIME, 
@EndDate DATETIME,
@SurveyID INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT @EndDate=DATEADD(Minute,-1,@EndDate+1)

CREATE TABLE #ES (ExportScheduleID INT)

INSERT INTO #ES (ExportScheduleID)
SELECT es.ExportScheduleID
FROM ExportSchedule es, ExportScheduleExportSet eses, ExportSet e
WHERE StartedDate IS NULL
AND RunDate BETWEEN @StartDate and @EndDate
AND es.ExportScheduleID=eses.ExportScheduleID
AND eses.ExportSetID=e.ExportSetID
AND e.Survey_id=@SurveyID
GROUP BY es.ExportScheduleID

SELECT es.ExportScheduleID,es.RunDate,es.ReturnsOnly,es.DirectsOnly,
 es.FileType,es.FileName, es.ScheduledBy,es.ScheduledDate,es.StartedDate, es.IncludeDispositionRecords
FROM ExportSchedule es, #ES t
WHERE es.ExportScheduleID=t.ExportScheduleID

SELECT eses.ExportScheduleId,es.ExportSetID,es.ExportSetName,es.Survey_id,es.SampleUnit_id,
  es.EncounterStartDate,es.EncounterEndDate,es.ReportDateField,es.UpdatedDate,
  es.CreatedEmployeeName,es.ExportSetTypeID
FROM ExportScheduleExportSet eses, ExportSet es, #ES t
WHERE eses.ExportScheduleID=t.ExportScheduleID
AND eses.ExportSetID=es.ExportSetID

DROP TABLE #ES

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



--DCL_SelectScheduledExportsByStudy
ALTER PROCEDURE [dbo].[DCL_SelectScheduledExportsByStudy]
@StartDate DATETIME, 
@EndDate DATETIME,
@StudyID INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT @EndDate=DATEADD(Minute,-1,@EndDate+1)

CREATE TABLE #ES (ExportScheduleID INT)

INSERT INTO #ES (ExportScheduleID)
SELECT es.ExportScheduleID
FROM ExportSchedule es, ExportScheduleExportSet eses, ExportSet e
WHERE StartedDate IS NULL
AND RunDate BETWEEN @StartDate and @EndDate
AND es.ExportScheduleID=eses.ExportScheduleID
AND eses.ExportSetID=e.ExportSetID
AND e.Study_id=@StudyID
GROUP BY es.ExportScheduleID

SELECT es.ExportScheduleID,es.RunDate,es.ReturnsOnly,es.DirectsOnly,
 es.FileType,es.FileName,es.ScheduledBy,es.ScheduledDate,es.StartedDate, es.IncludeDispositionRecords
FROM ExportSchedule es, #ES t
WHERE es.ExportScheduleID=t.ExportScheduleID

SELECT eses.ExportScheduleId,es.ExportSetID,es.ExportSetName,es.Survey_id,es.SampleUnit_id,
  es.EncounterStartDate,es.EncounterEndDate,es.ReportDateField,es.UpdatedDate,
  es.CreatedEmployeeName,es.ExportSetTypeID
FROM ExportScheduleExportSet eses, ExportSet es, #ES t
WHERE eses.ExportScheduleID=t.ExportScheduleID
AND eses.ExportSetID=es.ExportSetID

DROP TABLE #ES

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF



--DCL_SelectScheduledExportsByClient
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[DCL_SelectScheduledExportsByClient]
@StartDate DATETIME, 
@EndDate DATETIME,
@ClientID INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT @EndDate=DATEADD(Minute,-1,@EndDate+1)

CREATE TABLE #ES (ExportScheduleID INT)

INSERT INTO #ES (ExportScheduleID)
SELECT es.ExportScheduleID
FROM ExportSchedule es, ExportScheduleExportSet eses, ExportSet e, ClientStudySurvey css
WHERE StartedDate IS NULL
AND RunDate BETWEEN @StartDate and @EndDate
AND es.ExportScheduleID=eses.ExportScheduleID
AND eses.ExportSetID=e.ExportSetID
AND e.Study_id=css.Study_id
AND css.Client_id=@ClientID
GROUP BY es.ExportScheduleID

SELECT es.ExportScheduleID,es.RunDate,es.ReturnsOnly,es.DirectsOnly,
 es.FileType, es.FileName, es.ScheduledBy,es.ScheduledDate,es.StartedDate, es.IncludeDispositionRecords
FROM ExportSchedule es, #ES t
WHERE es.ExportScheduleID=t.ExportScheduleID

SELECT eses.ExportScheduleId,es.ExportSetID,es.ExportSetName,es.Survey_id,es.SampleUnit_id,
  es.EncounterStartDate,es.EncounterEndDate,es.ReportDateField,es.UpdatedDate,
  es.CreatedEmployeeName,es.ExportSetTypeID
FROM ExportScheduleExportSet eses, ExportSet es, #ES t
WHERE eses.ExportScheduleID=t.ExportScheduleID
AND eses.ExportSetID=es.ExportSetID

DROP TABLE #ES

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF



--DCL_SelectScheduledExports
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[DCL_SelectScheduledExports] 
@StartDate DATETIME, 
@EndDate DATETIME
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT @EndDate=DATEADD(Minute,-1,@EndDate+1)

CREATE TABLE #ES (ExportScheduleID INT)

INSERT INTO #ES (ExportScheduleID)
SELECT ExportScheduleID
FROM ExportSchedule
WHERE StartedDate IS NULL
AND RunDate BETWEEN @StartDate and @EndDate

SELECT es.ExportScheduleID,es.RunDate,es.ReturnsOnly,es.DirectsOnly,
 es.FileType,es.FileName,es.ScheduledBy,es.ScheduledDate,es.StartedDate, es.IncludeDispositionRecords
FROM ExportSchedule es, #ES t
WHERE es.ExportScheduleID=t.ExportScheduleID

SELECT eses.ExportScheduleId,es.ExportSetID,es.ExportSetName,es.Survey_id,es.SampleUnit_id,
  es.EncounterStartDate,es.EncounterEndDate,es.ReportDateField,es.UpdatedDate,
  es.CreatedEmployeeName,es.ExportSetTypeID
FROM ExportScheduleExportSet eses, ExportSet es, #ES t
WHERE eses.ExportScheduleID=t.ExportScheduleID
AND eses.ExportSetID=es.ExportSetID

DROP TABLE #ES

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF



--DCL_SelectScheduledExport
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[DCL_SelectScheduledExport]
@ScheduledExportId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT ExportScheduleID,RunDate,ReturnsOnly,DirectsOnly,FileType, FileName, ScheduledBy,ScheduledDate,StartedDate,IncludeDispositionRecords
FROM ExportSchedule
WHERE ExportScheduleID=@ScheduledExportId

SELECT eses.ExportScheduleId,es.ExportSetID,es.ExportSetName,es.Survey_id,es.SampleUnit_id,
  es.EncounterStartDate,es.EncounterEndDate,es.ReportDateField,es.UpdatedDate,
  es.CreatedEmployeeName,es.ExportSetTypeID
FROM ExportScheduleExportSet eses, ExportSet es
WHERE eses.ExportScheduleID=@ScheduledExportId
AND eses.ExportSetID=es.ExportSetID

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

