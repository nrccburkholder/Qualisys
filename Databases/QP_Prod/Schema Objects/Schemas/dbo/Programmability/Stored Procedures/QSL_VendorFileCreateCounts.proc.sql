/*********************************************************************************************************
QSL_VendorFileCreateCounts
Created by: Michael Beltz 
Purpose:    This proc is used to Validate a phone/web/IVR vendor file for both null counts and Frequencies
                  simular to the QLoader validation reports.

History Log:
Created on: 07/07/09
Modified: 8/9/2012 DBG -- added MailingStepMethod #9 to "IF @MailingStepMethod_ID IN (2,4,9)" to accomodate Letter-Web Mailing Step Method
*********************************************************************************************************/
CREATE PROCEDURE [dbo].[QSL_VendorFileCreateCounts] (
      @VendorFile_ID INT
      ,@inDebug BIT = 0
      )
AS
BEGIN
      DECLARE @strField_nm VARCHAR(42), @Field_Id INT, @SQL VARCHAR(8000)
      DECLARE @GroupByLowLimit INT, @bitPhone BIT, @bitWeb BIT, @MailingStepMethod_ID INT

      IF @inDebug = 1
            PRINT 'Start QSL_VendorFileCreateCounts'

      /*
--Debug Code
Declare @VendorFile_ID int , @SampleSet_ID int, @MailingStep_ID int , @inDebug bit 
set @VendorFile_ID  = 6
set @inDebug = 1
--(@VendorFile_ID int = 0, @SampleSet_ID int = 0, @MailingStep_ID int = 0, @inDebug bit = 0)
--exec QSL_VendorFileCreateCounts 7,  1
*/
      IF @VendorFile_ID = 0
      BEGIN
            RAISERROR ('No Parameters Selected.',-- Message text.
                        16,-- Severity.
                        1 -- State.
                        )
            RETURN
      END

      IF @inDebug = 1
            PRINT 'VendorFile_ID = ' + cast(@VendorFile_ID AS VARCHAR(10))

      DECLARE @DataTableName VARCHAR(100)

      CREATE TABLE #NULL (Field_ID INT, strField_nm VARCHAR(100))

      CREATE TABLE #Freqs (Field_ID INT, strField_nm VARCHAR(100), GroupByLowLimit INT)

      --get MailingStepmethod so we know if this is phone or web. 
      SELECT @MailingStepMethod_ID = ms.MailingStepMethod_ID
      FROM VendorFileCreationQueue VFC, MailingStep ms
      WHERE VFC.MailingStep_Id = ms.MailingStep_ID
            AND VFC.vendorFile_Id = @VendorFile_ID

      IF @inDebug = 1
            PRINT 'First Delete old NullCount and Freq data'

      DELETE
      FROM VendorFile_NULLCounts
      WHERE vendorfile_ID = @VendorFile_ID

      DELETE
      FROM VendorFile_Freqs
      WHERE vendorfile_ID = @VendorFile_ID

      IF @inDebug = 1
      BEGIN
            PRINT 'Get Null Fields to Check'
            PRINT '@MailingStepMethod_ID = ' + cast(@MailingStepMethod_ID AS VARCHAR(100))
      END

      IF @MailingStepMethod_ID IN (1,3)
      BEGIN
            --First to work on the NULL counts        
            INSERT INTO #NULL
            SELECT Field_ID, strField_nm
            FROM VendorFile_validationfields
            WHERE bitNullCount = 1
                  AND bitphone = 1

            SET @DataTableName = 'VendorPhoneFile_Data'
      END
      ELSE
            IF @MailingStepMethod_ID IN (2,4,9)
            BEGIN
                  --First to work on the NULL counts        
                  INSERT INTO #NULL
                  SELECT Field_ID, strField_nm
                  FROM VendorFile_validationfields
                  WHERE bitNullCount = 1
                        AND bitweb = 1

                  SET @DataTableName = 'VendorWebFile_Data'
            END
            ELSE
            BEGIN
                  RETURN
            END

      IF @inDebug = 1
            SELECT '#null' AS [#null], *
            FROM #null

      --Now to loop thru the fields        
      SELECT TOP 1 @strField_nm = strField_nm, @Field_id = isnull(Field_id, 0)
      FROM #NULL
      ORDER BY Field_id

      WHILE @@ROWCOUNT > 0
      BEGIN
            SET @sql = 'INSERT INTO VendorFile_NULLCounts (VendorFile_ID,Field_id,strField_nm,Occurrences)        
                        SELECT ' + cast(@VendorFile_ID AS VARCHAR(10)) + ' as VendorFile_ID, ' + cast(@Field_id AS VARCHAR(10)) + ' as Field_ID, ' + '''' + @strField_nm + ''' as strField_nm, Count(*) 
                        FROM  ' + @DataTableName + '       
                        WHERE VendorFile_ID = ' + cast(@VendorFile_ID AS VARCHAR(10)) + ' AND ' + @strField_nm + ' IS NULL
                        Group by ' + @strField_nm

            IF @inDebug = 1
                  PRINT @SQL

            EXEC (@sql)

            DELETE #NULL
            WHERE strField_nm = @strField_nm
                  AND isnull(Field_id, 0) = @Field_id

            SELECT TOP 1 @strField_nm = strField_nm, @Field_id = isnull(Field_id, 0)
            FROM #NULL
            ORDER BY 1
      END

      --Now on to the Freq counts        
      IF @MailingStepMethod_ID IN (1,3)
      BEGIN
            --First to work on the NULL counts        
            INSERT INTO #Freqs
            SELECT isnull(Field_ID, 0) Field_ID
                  ,strField_nm
                  ,GroupByLowLimit
            FROM VendorFile_validationfields
            WHERE bitFreqLimit = 1
                  AND bitphone = 1
      END
      ELSE
            IF @MailingStepMethod_ID IN (2,4,9)
            BEGIN
                  --First to work on the NULL counts        
                  INSERT INTO #Freqs
                  SELECT isnull(Field_ID, 0) Field_ID
                        ,strField_nm
                        ,GroupByLowLimit
                  FROM VendorFile_validationfields
                  WHERE bitFreqLimit = 1
                        AND bitweb = 1
            END
            ELSE
            BEGIN
                  RETURN
            END

      IF @inDebug = 1
            SELECT '#Freqs' AS [#Freqs], *
            FROM #Freqs

      --Now to loop thru the fields        
      SELECT TOP 1 @strField_nm = strField_nm
            ,@Field_id = isnull(Field_id, 0)
            ,@GroupByLowLimit = GroupByLowLimit
      FROM #Freqs
      ORDER BY 1

      WHILE @@ROWCOUNT > 0
      BEGIN
            IF @inDebug = 1
            BEGIN
                  PRINT '@strField_nm = ' + cast(@strField_nm AS VARCHAR(100))
                  PRINT '@Field_id = ' + cast(@Field_id AS VARCHAR(100))
                  PRINT '@GroupByLowLimit = ' + cast(@GroupByLowLimit AS VARCHAR(100))
            END

            SET @sql = 'INSERT INTO VendorFile_Freqs (VendorFile_ID,Field_id,strField_nm,strValue,Occurrences)        
                        SELECT ' + cast(@VendorFile_ID AS VARCHAR(10)) + ' as VendorFile_ID, ' + cast(@Field_id AS VARCHAR(10)) + ' as Field_ID, ' + '''' + @strField_nm + ''' as strField_nm,' + @strField_nm + ' as strValue ,COUNT(*)       
                        FROM ' + @DataTableName + '        
                        WHERE VendorFile_ID = ' + cast(@VendorFile_ID AS VARCHAR(10)) + '        
                        GROUP BY ' + @strField_nm + '        
                        HAVING COUNT(*)>=' + LTRIM(STR(@GroupByLowLimit))

            IF @inDebug = 1
                  PRINT @SQL

            EXEC (@sql)

            DELETE #Freqs
            WHERE strField_nm = @strField_nm
                  AND isnull(Field_id, 0) = @Field_id
                  AND GroupByLowLimit = @GroupByLowLimit

            SELECT TOP 1 @strField_nm = strField_nm
                  ,@Field_id = isnull(Field_id, 0)
                  ,@GroupByLowLimit = GroupByLowLimit
            FROM #Freqs
            ORDER BY 1
      END

      IF @MailingStepMethod_ID IN (1,3)
      BEGIN
            --special count for len(phone) fields
            INSERT INTO VendorFile_Freqs (VendorFile_ID, Field_id, strField_nm, strValue, Occurrences)
            SELECT @VendorFile_ID AS VendorFile_ID
                  ,NULL AS Field_ID
                  ,'Length of Phone Number' AS strField_nm
                  ,len(phone) AS strValue
                  ,COUNT(*)
            FROM VendorPhoneFile_Data
            WHERE VendorFile_ID = @VendorFile_ID
            GROUP BY len(phone)
      END
END


