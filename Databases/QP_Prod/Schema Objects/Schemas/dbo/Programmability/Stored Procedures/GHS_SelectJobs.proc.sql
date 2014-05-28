/*******************************************************************************
 *
 * Procedure Name:
 *           GHS_SelectJobs
 *
 * Description:
 *           Retrieve job list
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
CREATE PROCEDURE dbo.GHS_SelectJobs (
        @strClient_NM     varchar(128) = NULL,
        @StartDate        datetime = NULL,
        @EndDate          datetime = NULL,
        @Project_ID       int = NULL,
        @strNTLogin_NM    varchar(32) = NULL
       )
AS
  DECLARE @Sql           varchar(8000),
          @StartDateStr  char(23),
          @EndDateStr    char(23),
          @TmpDate       datetime
  
  SET @strClient_NM = LTRIM(RTRIM(@strClient_NM))
  SET @strNTLogin_NM = LTRIM(RTRIM(@strNTLogin_NM))
  
  IF (@StartDate > @EndDate) BEGIN
      SET @TmpDate = @StartDate
      SET @StartDate = @EndDate
      SEt @EndDate = @TmpDate
  END
  IF (@StartDate IS NOT NULL) SET @StartDate = dbo.CM_BeginOfDay(@StartDate)
  IF (@StartDate IS NOT NULL AND @EndDate IS NULL) SET @EndDate = GETDATE()
  IF (@EndDate IS NOT NULL) SET @EndDate = dbo.CM_EndOfDay(@EndDate)

  SET @StartDateStr = CONVERT(varchar, @StartDate, 121)
  SET @EndDateStr = CONVERT(varchar, @EndDate, 121)
  
  SET @Sql = '
           SELECT mm.Job_ID,
                  ec.Label,
                  mm.Template_ID,
                  mm.Project_ID,
                  mm.Faqss_ID,
                  mm.MailStep,
                  mm.DateRun,
                  ISNULL(em.strEmployee_First_NM + '' '' + em.strEmployee_Last_NM, mm.strNTLogin_NM) AS OperatorName,
                  pj.ProjectName,
                  pj.strClient_NM
             FROM GHS_MailMergeLog mm
                  JOIN GHS_MailMergeProject pj
                    ON pj.Project_ID = mm.Project_ID
                  JOIN GHS_MailMergeErrorCode ec
                    ON ec.ErrorCode = mm.ErrorCode
                  LEFT JOIN Employee em
                    ON em.strNTLogin_NM = mm.strNTLogin_NM'
                    
  IF (@StartDate IS NULL) BEGIN
      SET @Sql = @Sql + '
            WHERE mm.DateRun >= DATEADD(yy, -2, GETDATE())'
  END
  ELSE BEGIN
      SET @Sql = @Sql + '
            WHERE mm.DateRun BETWEEN ''' + @StartDateStr + '''
                                 AND ''' + @EndDateStr + ''''
  END

  IF (@Project_ID IS NOT NULL AND @Project_ID > 0) BEGIN
      SET @Sql = @Sql + '
              AND mm.Project_ID = ' + CONVERT(varchar, @Project_ID)
  END

  IF (@strNTLogin_NM IS NOT NULL AND @strNTLogin_NM <> '') BEGIN
      SET @Sql = @Sql + '
              AND mm.strNTLogin_NM = ''' + @strNTLogin_NM + ''''
  END

  IF (@strClient_NM IS NOT NULL AND @strClient_NM <> '') BEGIN
      SET @Sql = @Sql + '
              AND pj.strClient_NM = ''' + @strClient_NM + ''''
  END

  SET @Sql = @Sql + '
            ORDER BY mm.Job_ID'

  PRINT @Sql
  EXEC(@Sql)
  
  RETURN -1


