/*******************************************************************************
 *
 * Procedure Name:
 *           GHS_InsertLog
 *
 * Description:
 *           Save mail merge job info to log
 *
 * Parameters:
 *           {parameter}  {data type}
 *              {brief parameter description}
 *           ...
 *
 * Return:
 *           -1:     Succeed
 *           Others: Failed
 *
 * History:
 *           1.0  10/31/2005 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.GHS_InsertLog (
        @ErrorCode             smallint,
        @Template_ID           int,
        @Project_ID            int,
        @Faqss_ID              varchar(8),
        @MailStep              tinyint,
        @PaperConfig_ID        int,
        @PaperSize_ID          int,
        @SurveyDataDirectory   sysname,
        @MainDocDirectory      sysname,
        @OutputDirectory       sysname,
        @ArchiveDirectory      sysname,
        @TotalRecNum           int,
        @MergedRecNum          int,
        @SubJobNum             tinyint,
        @PrinterName           varchar(128),
        @SaveMergedDoc         bit,
        @IsAllMergedDocSaved   bit,
        @DateRun               datetime,
        @strNTLogin_NM         varchar(32)
       )
AS
  INSERT INTO GHS_MailMergeLog (
          ErrorCode,
          Template_ID,
          Project_ID,
          Faqss_ID,
          MailStep,
          PaperConfig_ID,
          PaperSize_ID,
          SurveyDataDirectory,
          MainDocDirectory,
          OutputDirectory,
          ArchiveDirectory,
          TotalRecNum,
          MergedRecNum,
          SubJobNum,
          PrinterName,
          SaveMergedDoc,
          IsAllMergedDocSaved,
          DateRun,
          strNTLogin_NM
         )
  VALUES (
          @ErrorCode,
          @Template_ID,
          @Project_ID,
          @Faqss_ID,
          @MailStep,
          @PaperConfig_ID,
          @PaperSize_ID,
          @SurveyDataDirectory,
          @MainDocDirectory,
          @OutputDirectory,
          @ArchiveDirectory,
          @TotalRecNum,
          @MergedRecNum,
          @SubJobNum,
          @PrinterName,
          @SaveMergedDoc,
          @IsAllMergedDocSaved,
          @DateRun,
          @strNTLogin_NM
         )

  SELECT SCOPE_IDENTITY() AS Job_ID
  
  RETURN -1


