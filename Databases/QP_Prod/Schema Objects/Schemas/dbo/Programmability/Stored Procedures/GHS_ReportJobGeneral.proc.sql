/*******************************************************************************
 *
 * Procedure Name:
 *           GHS_ReportJobGeneral
 *
 * Description:
 *           Retrieve job's general info
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
CREATE PROCEDURE dbo.GHS_ReportJobGeneral (
        @Job_ID       int
       )
AS
  SELECT mm.Job_ID,
         CASE 
           WHEN mm.ErrorCode = 0 AND mm.SaveMergedDoc = 0
             THEN ec.Status + ' (merged Word documents were not saved)'
           WHEN mm.ErrorCode = 0 AND mm.SaveMergedDoc = 1 AND mm.IsAllMergedDocSaved = 0
             THEN ec.Status + ' (one or more merged Word documents were not saved successfully)'
           ELSE ec.Status
           END AS Status,
         mm.Template_ID,
         mm.Project_ID,
         mm.TotalRecNum,
         mm.MergedRecNum,
         mm.TotalRecNum - mm.MergedRecNum AS ErrorRecNum,
         mm.DateRun,
         tm.strClient_NM,
         tm.Description,
         pc.strPaperConfig_NM,
         ISNULL(em.strEmployee_First_NM + ' ' + em.strEmployee_Last_NM, mm.strNTLogin_NM) Operator
    FROM GHS_MailMergeLog mm
         LEFT JOIN (
               SELECT ErrorCode,
                      CASE ErrorCode
                        WHEN 0 THEN Label
                        ELSE 'ERR-' + RIGHT('000' + CONVERT(varchar, ErrorCode), 3) + ' ' + Label
                        END AS Status
                 FROM GHS_MailMergeErrorCode 
              ) ec
           ON ec.ErrorCode = mm.ErrorCode
         LEFT JOIN GHS_MailMergeTemplate tm
           ON tm.Template_ID = mm.Template_ID
         LEFT JOIN PaperConfig pc
           ON pc.PaperConfig_ID = mm.PaperConfig_ID
         LEFT JOIN Employee em
           ON em.strNTLogin_NM = mm.strNTLogin_NM
   WHERE mm.Job_ID = @Job_ID
         
  RETURN -1


