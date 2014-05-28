/*******************************************************************************
 *
 * Procedure Name:
 *           GHS_SelectProjects
 *
 * Description:
 *           Retrieve project list
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
CREATE PROCEDURE dbo.GHS_SelectProjects (
        @strClient_NM     varchar(128) = NULL,
        @StartDate        datetime = NULL,
        @EndDate          datetime = NULL
       )
AS
  DECLARE @Sql           varchar(8000),
          @StartDateStr  char(23),
          @EndDateStr    char(23),
          @TmpDate       datetime
  
  SET @strClient_NM = LTRIM(RTRIM(@strClient_NM))
  
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
           SELECT 0 AS Project_ID,
                  ''_All'' AS ProjectName
           UNION
           SELECT pj.Project_ID,
                  pj.ProjectName + '' ('' + CONVERT(varchar, pj.Project_ID) + '')'' AS ProjectName
             FROM GHS_MailMergeLog mm,
                  GHS_MailMergeProject pj'
  
  IF (@StartDate IS NULL) BEGIN
      SET @Sql = @Sql + '
            WHERE mm.DateRun >= DATEADD(yy, -2, GETDATE())'
  END
  ELSE BEGIN
      SET @Sql = @Sql + '
            WHERE mm.DateRun BETWEEN ''' + @StartDateStr + '''
                                 AND ''' + @EndDateStr + ''''
  END
  
  SET @Sql = @Sql + '
              AND pj.Project_ID = mm.Project_ID'

  IF (@strClient_NM IS NOT NULL AND @strClient_NM <> '') BEGIN
      SET @Sql = @Sql + '
              AND pj.strClient_NM = ''' + @strClient_NM + ''''
  END

  SET @Sql = @Sql + '
            ORDER BY ProjectName'

  -- PRINT @Sql
  EXEC(@Sql)
  
  RETURN -1


