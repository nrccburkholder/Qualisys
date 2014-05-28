/*********************************************************************************************************  
QSL_VendorFileValidation  
Created by: Michael Beltz   
Purpose: Vendor File validation will check the results of an individual vendor file to make sure all  
   frequencies and null counts are within the specified range.  
  
History Log:  
Created on: 7/16/09  
Modified: 8/9/2012 DBG -- added MailingStepMethod #9 to "IF @MailingStepMethod_ID IN (2,4,9)" to accomodate Letter-Web Mailing Step Method
*********************************************************************************************************/
CREATE PROCEDURE [dbo].[QSL_VendorFileValidation] (
      @VendorFile_ID INT = 0
      ,@inDebug INT = 0
      )
AS
BEGIN
      /*  
QSL_VendorFileValidation 65, 1  
select * from VendorFile_Messages where vendorfile_Id = 6  
*/
      IF @inDebug = 1
      BEGIN
            PRINT 'Start QSL_VendorFileValidation'
            PRINT '@VendorFile_ID = ' + cast(@VendorFile_ID AS VARCHAR(10))
      END

      DECLARE @MailingStepMethod_ID INT, @TotalRecords INT, @ThresholdPct INT, @strField_nm VARCHAR(50)
      DECLARE @NullCountMessageType_ID INT

      CREATE TABLE #ThresholdFields (strfield_nm VARCHAR(100), ThresholdPct INT)

      CREATE TABLE #Results (strfield_nm VARCHAR(50), counts INT, ThresholdPct INT)

      SELECT @MailingStepMethod_ID = ms.MailingStepMethod_ID
      FROM VendorFileCreationQueue VFC, MailingStep ms
      WHERE VFC.MailingStep_Id = ms.MailingStep_ID
            AND VFC.vendorFile_Id = @VendorFile_ID

      IF @indebug = 1
            PRINT '@MailingStepMethod_ID = ' + cast(@MailingStepMethod_ID AS VARCHAR(5))

      --set @MailingStepMethod_ID = 1  
      --delete old messages so we can create new ones as data might change.  
      IF @indebug = 1
            PRINT 'Delete old Messages'

      DELETE
      FROM VendorFile_messages
      WHERE vendorFile_ID = @VendorFile_ID

      --figure out mailing step type and insert tables and variables based on results.  
      IF @MailingStepMethod_ID IN (1,3)
      BEGIN
            INSERT INTO #ThresholdFields (strfield_nm, ThresholdPct)
            SELECT strField_nm, ThresholdPct
            FROM VendorFile_ValidationFields
            WHERE bitUseThreshold = 1
                  AND bitPhone = 1

            SELECT @TotalRecords = count(*)
            FROM VendorPhoneFile_Data
            WHERE vendorFile_Id = @VendorFile_ID

            SET @NullCountMessageType_ID = 3

            IF @indebug = 1
                  PRINT '@TotalRecords = ' + cast(@TotalRecords AS VARCHAR(10))
      END
      ELSE
            IF @MailingStepMethod_ID IN (2,4,9)
            BEGIN
                  INSERT INTO #ThresholdFields
                  SELECT strField_nm, ThresholdPct
                  FROM VendorFile_ValidationFields
                  WHERE bitUseThreshold = 1
                        AND bitWeb = 1

                  SELECT @TotalRecords = count(*)
                  FROM VendorWebFile_Data
                  WHERE vendorFile_Id = @VendorFile_ID

                  SET @NullCountMessageType_ID = 2

                  IF @indebug = 1
                        PRINT '@TotalRecords = ' + cast(@TotalRecords AS VARCHAR(10))
            END
            ELSE
            BEGIN
                  RETURN
            END

      IF @indebug = 1
            SELECT '#ThresholdFields' AS [#ThresholdFields], *
            FROM #ThresholdFields

      WHILE (SELECT count(*) FROM #ThresholdFields) > 0
      BEGIN
            SELECT TOP 1 @strField_nm = strField_nm, @ThresholdPct = ThresholdPct
            FROM #ThresholdFields

            IF @indebug = 1
            BEGIN
                  PRINT @strField_nm
                  PRINT @ThresholdPct
                  PRINT '((@ThresholdPct * 1.0) / 100) = ' + cast(((@ThresholdPct * 1.0) / 100) AS VARCHAR(50))
            END

            IF (  SELECT ((occurrences * 1.0) / @TotalRecords)
                        FROM VendorFile_nullCounts
                        WHERE VendorFile_Id = @VendorFile_ID
                              AND strfield_nm = @strField_nm
                        ) > ((@ThresholdPct * 1.0) / 100)
            BEGIN
                  IF @indebug = 1
                        PRINT @strField_nm + 'Field is found in error.  Create Message'

                  INSERT INTO VendorFile_Messages (vendorFile_ID, VendorFile_messageType_ID, message)
                  SELECT @VendorFile_ID AS VendorFile_ID
                        ,@NullCountMessageType_ID AS VendorFile_messageType_ID
                        ,@strField_nm + ' Field exceeds Null count Threshold.  Please check data file details.' AS Message
            END

            DELETE #ThresholdFields
            WHERE strField_nm = @strField_nm
                  AND ThresholdPct = @ThresholdPct
      END

      --now to check for special validation rules.  
      --Phone only checks  
      --Overall Rule: If Phone if HCAHPS Survey must have at least 1 HCAHPSSamp Record in the file  
      IF @MailingStepMethod_ID IN (1,3)
      BEGIN
            --if HCAHPS  
            DECLARE @Survey_ID INT

            SELECT @Survey_ID = ss.Survey_ID
            FROM VendorFileCreationQueue VFC
                  ,SampleSet ss
            WHERE VFC.SampleSet_Id = ss.SampleSet_ID
                  AND VFC.VendorFile_ID = @VendorFile_ID

            IF (  SELECT surveyType_ID
                        FROM Survey_Def
                        WHERE survey_ID = @Survey_ID
                        ) = 2
            BEGIN
                  IF (  SELECT max(HCAHPSSamp)
                              FROM VendorPhoneFile_data
                              WHERE Vendorfile_ID = @VendorFile_ID
                              ) <= 0
                  BEGIN
                        INSERT INTO VendorFile_Messages (vendorFile_ID, VendorFile_messageType_ID, message)
                        SELECT @VendorFile_ID AS VendorFile_ID
                              ,3 AS VendorFile_messageType_ID
                              ,'HCAHPS Phone Survey does not have any HCAHPSSamp respondents.' AS Message
                  END
            END

            --Overall Rule: if any phone numbers are not a length of 10  
            IF EXISTS (
                        SELECT 'x'
                        FROM VendorFile_Freqs
                        WHERE vendorFile_ID = @VendorFile_ID
                              AND strField_nm = 'Length of Phone Number'
                              AND strValue <> 10
                        )
            BEGIN
                  INSERT INTO VendorFile_Messages (vendorFile_ID, VendorFile_messageType_ID, message)
                  SELECT @VendorFile_ID AS VendorFile_ID
                        ,3 AS VendorFile_messageType_ID
                        ,'There are some phone numbers that are not a length of Ten digits.' AS Message
            END
      END --phone only validation rules  

      --Overall Rule: vendor_ID has been selected for given mail step(s)  
      IF EXISTS (
                  SELECT 'x'
                  FROM VendorFileCreationQueue VFC, MailingStep ms
                  WHERE VFC.MailingStep_ID = ms.MailingStep_ID
                        AND VFC.vendorFile_ID = @VendorFile_ID
                        AND ms.Vendor_ID IS NULL
                  )
      BEGIN
            INSERT INTO VendorFile_Messages (vendorFile_ID, VendorFile_messageType_ID, message)
            SELECT @VendorFile_ID AS VendorFile_ID
                  ,3 AS VendorFile_messageType_ID
                  ,'No Vendor File selected.  Please Select a vendor for mailing Step' AS Message
      END
END


