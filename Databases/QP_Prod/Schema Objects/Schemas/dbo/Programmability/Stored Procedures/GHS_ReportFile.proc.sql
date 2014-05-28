/*******************************************************************************
 *
 * Procedure Name:
 *           GHS_ReportFile
 *
 * Description:
 *           Retrieve job's file data
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
CREATE PROCEDURE dbo.GHS_ReportFile (
        @Job_ID       int
       )
AS  
  SELECT CASE
           WHEN FileType = 1 THEN 'SurveyPoint Data Source'
           WHEN FileType = 2 THEN 'Mail Merge Main Documents'
           WHEN FileType = 3 THEN 'Print Files Generated'
           WHEN FileType IN (4, 5, 6, 7, 8)
                             THEN 'Archived Files'
           END AS FileCategory,
         CASE
           WHEN FileType = 1 THEN SurveyDataDirectory + FileName
           WHEN FileType = 2 THEN MainDocDirectory + FileName
           WHEN FileType = 3 THEN OutputDirectory + FileName
           WHEN FileType IN (4, 5, 6, 7, 8)
                             THEN ArchiveDirectory + FileName
           END AS FilePath
    FROM GHS_MailMergeLog mm,
         GHS_MailMergeFileLog fi
   WHERE mm.Job_ID = @Job_ID
     AND fi.Job_ID = @Job_ID
   ORDER BY
         fi.FileType,
         fi.SeqNum

   
  RETURN -1


