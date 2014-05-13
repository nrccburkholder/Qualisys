IF (ObjectProperty(Object_Id('dbo.DCL_ExportInsertExportSet'),
                   'IsProcedure') IS NOT NULL)
    DROP PROCEDURE dbo.DCL_ExportInsertExportSet
GO


--Modified 6/1/6 BGD No longer assign samplepops to exportsets.  
--   Added ExportSetTypeID
--Modified 10/15/06 Brian M
--   For column ReportDateField:
--       Save data from ClientStudySurvey.strSampleEncounterDateField for HCAHPS or Chart export;
--       Save data from ClientStudySurvey.strReportDateField for the other export types
CREATE PROCEDURE dbo.DCL_ExportInsertExportSet
        @Name VARCHAR(100),
        @SurveyId INT,
        @ExportSetTypeID INT,
        @EncounterStartDate DATETIME,
        @EncounterEndDate DATETIME,
        @CreatedEmployeeName VARCHAR(50),
        @SampleUnitID INT
AS

INSERT INTO ExportSet (
        ExportSetName,
        Survey_id,
        Study_id,
        EncounterStartDate, 
        EncounterEndDate,
        ReportDateField,
        UpdatedDate,
        CreatedEmployeeName,
        ExportSetTypeID,
        SampleUnit_id
       )
SELECT @Name,
       @SurveyId,
       Study_id,
       @EncounterStartDate, 
       @EncounterEndDate,
       CASE 
         WHEN @ExportSetTypeID IN (2, 3) THEN strSampleEncounterDateField
         ELSE strReportDateField
         END,
       GETDATE(),
       @CreatedEmployeeName,
       @ExportSetTypeID,
       @SampleUnitID
  FROM ClientStudySurvey
 WHERE Survey_id=@SurveyId

SELECT SCOPE_IDENTITY()

GO
