/*******************************************************************************
 *
 * Procedure Name:
 *           CM_SelectMemberInfo
 *
 * Description:
 *           Retrieve NRC Auth member info
 *
 * Parameters:
 *           @InputTable     sysname
 *              Input table name
 *           @OutputTable    sysname
 *              Output table name
 *
 * Return:
 *           0:     Success
 *           Other: Fail
 *
 * History:
 *           2.0.0  04/17/2006 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.CM_SelectMemberInfo (
        @InputTable     sysname,
        @OutputTable    sysname
       )
AS
  SET NOCOUNT ON
  
  -- Constants
  DECLARE @YES                             int

  SET @YES = 1

  -- Variables
  DECLARE @Server         sysname,
          @Sql            varchar(8000),
          @Member_ID      int

  CREATE TABLE #Member__________________2355345906237 (
           Member_ID      int NOT NULL PRIMARY KEY CLUSTERED
  )
  
  
  --
  -- Get NRCAuth server name
  --
  SELECT @Server=strParam_Value
    FROM Datamart_Params
   WHERE strParam_nm = 'NRCAuth Server'

  --
  -- Add columns to output table
  --
  SET @Sql = ''
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD Member_ID               int '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD OrgUnit_id              int '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD CreatorMember_id        int '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD datCreated              datetime '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD datLastLogin            datetime '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD datLocked               datetime '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD datRetired              datetime '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD datPasswordChanged      datetime '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD DaysTilPasswordExpires  int '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD MemberType_id           int '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD strHint                 varchar(250) '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD strHintAnswer           varchar(200) '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD strMember_nm            varchar(100) '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD strPassword             varchar(200) '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD SaltValue               varchar(50) '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD strFName                varchar(50) '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD strLName                varchar(50) '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD strTitle                varchar(50) '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD strPhone                varchar(30) '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD strCity                 varchar(50) '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD strState                varchar(50) '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD strFacility_nm          varchar(100) '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD strEmail                varchar(100) '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD Author                  int '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD datOccurred             datetime '
  SET @Sql = @Sql + 'ALTER TABLE ' + @OutputTable + ' ADD NTLogin_nm              varchar(42) '

  EXEC(@Sql)


  --
  -- Pull the members from input table
  --
  SET @Sql = '
       INSERT INTO #Member__________________2355345906237
       SELECT DISTINCT
              Member_ID
         FROM ' + @InputTable + '
        WHERE Member_ID IS NOT NULL
      '

  EXEC(@Sql)
  
  --
  -- Query member info
  --
  DECLARE curMember CURSOR LOCAL FOR
  SELECT Member_ID
    FROM #Member__________________2355345906237
  
  OPEN curMember
  FETCH curMember INTO @Member_ID
  
  WHILE @@FETCH_STATUS = 0 BEGIN
      SET @Sql = '
            INSERT INTO ' + @OutputTable + ' (
                    Member_ID,
                    OrgUnit_id,
                    CreatorMember_id,
                    datCreated,
                    datLastLogin,
                    datLocked,
                    datRetired,
                    datPasswordChanged,
                    DaysTilPasswordExpires,
                    MemberType_id,
                    strHint,
                    strHintAnswer,
                    strMember_nm,
                    strPassword,
                    SaltValue,
                    strFName,
                    strLName,
                    strTitle,
                    strPhone,
                    strCity,
                    strState,
                    strFacility_nm,
                    strEmail,
                    Author,
                    datOccurred,
                    NTLogin_nm
                   )
            EXEC ' + @Server + 'NRCAuth.dbo.Auth_SelectMemberInfo ' + CONVERT(varchar, @Member_ID)
      EXEC(@Sql)
      FETCH curMember INTO @Member_ID
  END
  
  CLOSE curMember
  DEALLOCATE curMember
  
  
  --
  -- Add PK
  -- Set default first and last name
  --
  SET @Sql = '
       ALTER TABLE ' + @OutputTable + ' ALTER COLUMN Member_ID int NOT NULL
       
       UPDATE ' + @OutputTable + '
          SET strFName = strMember_NM,
              strLName = ''''
        WHERE strFName IS NULL
          AND strLName IS NULL

       UPDATE ' + @OutputTable + '
          SET strFName = ISNULL(strFName, ''''),
              strLName = ISNULL(strLName, '''')
        WHERE strFName IS NULL
           OR strLName IS NULL
      '
  EXEC(@Sql)
  
  EXEC dbo.CM_CreatePK @OutputTable, 'Member_ID', @YES
  
  RETURN 0


