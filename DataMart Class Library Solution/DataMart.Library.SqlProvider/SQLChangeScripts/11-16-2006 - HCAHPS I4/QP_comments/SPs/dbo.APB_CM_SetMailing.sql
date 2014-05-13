SET ANSI_NULLS OFF
GO  

IF (ObjectProperty(Object_Id('dbo.APB_CM_SetMailing'),
                   'IsProcedure') IS NOT NULL)
    DROP PROCEDURE dbo.APB_CM_SetMailing
GO

/*******************************************************************************
 *
 * Procedure Name:
 *           APB_CM_SetMailing
 *
 * Description:
 *           Set mailing status to "Waiting" for the jobs waiting to send mail
 *
 * Parameters:
 *           N/A
 *
 * Return:
 *           0:     Success
 *           Other: Fail
 *
 * History:
 *           2.0.0  04/17/2006 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.APB_CM_SetMailing
AS
  SET NOCOUNT ON

  --------------------------------------------------------------------
  -- Constants
  --------------------------------------------------------------------
  DECLARE 
      @JOB_QUEUED                           int,
      @JOB_SCHEDULED                        int,
      @JOB_WAITING                          int,
      @JOB_PULLING_DATA                     int,
      @JOB_DOING_STATISTIC                  int,
      @JOB_OUTPUTTING_RESULT                int,
      @JOB_PROCESSED                        int,
      @JOB_GENERATING_PDF                   int,
      @JOB_PDF_GENERATED                    int,
      @JOB_ERR_PULL_DATA                    int,
      @JOB_ERR_DO_STATISTIC                 int,
      @JOB_ERR_OUTPUT_RESULT                int,
      @JOB_GEN_FAILED                       int,
      @JOB_GEN_TIMEOUT                      int,
      @JOB_AP_NOT_EXIST                     int,
      @JOB_TEMPLATE_UNASSIGNED              int,
      @JOB_TEMPLATE_NOT_EXIST               int,
      @JOB_OTHER_ERROR                      int,
      @JOB_CANCELLED                        int,
      @JOB_PENDING                          int,
      @MAIL_NOT_YET                         int,
      @MAIL_WAITING                         int,
      @MAIL_COMPLETED                       int,
      @MAIL_FAILED                          int


  SET @JOB_QUEUED                           = dbo.APB_CM_Constant('JOB_QUEUED')
  SET @JOB_SCHEDULED                        = dbo.APB_CM_Constant('JOB_SCHEDULED')
  SET @JOB_WAITING                          = dbo.APB_CM_Constant('JOB_WAITING')
  SET @JOB_PULLING_DATA                     = dbo.APB_CM_Constant('JOB_PULLING_DATA')
  SET @JOB_DOING_STATISTIC                  = dbo.APB_CM_Constant('JOB_DOING_STATISTIC')
  SET @JOB_OUTPUTTING_RESULT                = dbo.APB_CM_Constant('JOB_OUTPUTTING_RESULT')
  SET @JOB_PROCESSED                        = dbo.APB_CM_Constant('JOB_PROCESSED')
  SET @JOB_GENERATING_PDF                   = dbo.APB_CM_Constant('JOB_GENERATING_PDF')
  SET @JOB_PDF_GENERATED                    = dbo.APB_CM_Constant('JOB_PDF_GENERATED')
  SET @JOB_ERR_PULL_DATA                    = dbo.APB_CM_Constant('JOB_ERR_PULL_DATA')
  SET @JOB_ERR_DO_STATISTIC                 = dbo.APB_CM_Constant('JOB_ERR_DO_STATISTIC')
  SET @JOB_ERR_OUTPUT_RESULT                = dbo.APB_CM_Constant('JOB_ERR_OUTPUT_RESULT')
  SET @JOB_GEN_FAILED                       = dbo.APB_CM_Constant('JOB_GEN_FAILED')
  SET @JOB_GEN_TIMEOUT                      = dbo.APB_CM_Constant('JOB_GEN_TIMEOUT')
  SET @JOB_AP_NOT_EXIST                     = dbo.APB_CM_Constant('JOB_AP_NOT_EXIST')
  SET @JOB_TEMPLATE_UNASSIGNED              = dbo.APB_CM_Constant('JOB_TEMPLATE_UNASSIGNED')
  SET @JOB_TEMPLATE_NOT_EXIST               = dbo.APB_CM_Constant('JOB_TEMPLATE_NOT_EXIST')
  SET @JOB_OTHER_ERROR                      = dbo.APB_CM_Constant('JOB_OTHER_ERROR')
  SET @JOB_CANCELLED                        = dbo.APB_CM_Constant('JOB_CANCELLED')
  SET @JOB_PENDING                          = dbo.APB_CM_Constant('JOB_PENDING')
  SET @MAIL_NOT_YET                         = dbo.APB_CM_Constant('MAIL_NOT_YET')
  SET @MAIL_WAITING                         = dbo.APB_CM_Constant('MAIL_WAITING')
  SET @MAIL_COMPLETED                       = dbo.APB_CM_Constant('MAIL_COMPLETED')
  SET @MAIL_FAILED                          = dbo.APB_CM_Constant('MAIL_FAILED')


  --------------------------------------------------------------------
  -- Process Begin
  --------------------------------------------------------------------
  
  --
  -- Find out all the notified parties and the highest priority of their completed jobs
  --
  CREATE TABLE #Notify (
         Notify     varchar(60) NOT NULL PRIMARY KEY CLUSTERED,
         Priority   tinyint NOT NULL
  )
  
  INSERT INTO #Notify (
          Notify,
          Priority
         )
  SELECT Notify,
         MAX(Priority)
    FROM tbl_ApJobList
   WHERE Status IN (
                 @JOB_PDF_GENERATED,
                 @JOB_ERR_PULL_DATA,
                 @JOB_ERR_DO_STATISTIC,
                 @JOB_ERR_OUTPUT_RESULT,
                 @JOB_GEN_FAILED,
                 @JOB_GEN_TIMEOUT,
                 @JOB_AP_NOT_EXIST,
                 @JOB_TEMPLATE_UNASSIGNED,
                 @JOB_TEMPLATE_NOT_EXIST,
                 @JOB_OTHER_ERROR
                )
     AND Mailing = @MAIL_NOT_YET
   GROUP BY Notify

  --
  -- For each notified party, find if there is any unprocessed job which has
  -- equal or higher priority than the highest priority of their completed job.
  -- If so, don't send mail to this notified party
  --
  DELETE FROM nt
    FROM #Notify nt,
         tbl_ApJobList jl
   WHERE jl.Status IN (
                    @JOB_WAITING,
                    @JOB_PULLING_DATA,
                    @JOB_DOING_STATISTIC,
                    @JOB_OUTPUTTING_RESULT,
                    @JOB_PROCESSED
                   )
     AND jl.Notify = nt.Notify
     AND jl.Priority >= nt.Priority

    
  --
  -- For the rest of the notified parties, send mail
  --
  UPDATE jl
     SET Mailing = @MAIL_WAITING
    FROM #Notify nt,
         tbl_ApJobList jl
   WHERE jl.Status IN (
                 @JOB_PDF_GENERATED,
                 @JOB_ERR_PULL_DATA,
                 @JOB_ERR_DO_STATISTIC,
                 @JOB_ERR_OUTPUT_RESULT,
                 @JOB_GEN_FAILED,
                 @JOB_GEN_TIMEOUT,
                 @JOB_AP_NOT_EXIST,
                 @JOB_TEMPLATE_UNASSIGNED,
                 @JOB_TEMPLATE_NOT_EXIST,
                 @JOB_OTHER_ERROR
                )
     AND jl.Mailing = @MAIL_NOT_YET
     AND jl.Notify = nt.Notify

  RETURN 0

GO
