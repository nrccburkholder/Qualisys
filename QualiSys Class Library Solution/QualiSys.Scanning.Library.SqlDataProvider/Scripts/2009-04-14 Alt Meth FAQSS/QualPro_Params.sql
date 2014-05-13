DECLARE @strParam_Nm varchar(50)
DECLARE @strParam_Type char(1)
DECLARE @strParam_Grp varchar(20)
DECLARE @strParam_Value varchar(255)
DECLARE @numParam_Value int
DECLARE @datParam_Value datetime
DECLARE @Comments varchar(255)

-- QSIFAQSSCommentDataFileFolder
SET @strParam_Nm = 'QSIFAQSSCommentDataFileFolder'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN '\\FAQSSTest\Production\FAQSS\Dynamic\CmntData'
        WHEN 'Tiger' THEN '\\FAQSSTest\Production\FAQSS\Dynamic\CmntData'
        ELSE '\\Argus\Production\FAQSS\Dynamic\CmntData'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the location to place the comment data files'
IF EXISTS(SELECT * FROM QualPro_Params WHERE strParam_Nm = @strParam_Nm)
    UPDATE QualPro_Params
    SET strParam_Type = @strParam_Type, strParam_Grp = @strParam_Grp, 
        strParam_Value = @strParam_Value, numParam_Value = @numParam_Value, 
        datParam_Value = @datParam_Value, Comments = @Comments
    WHERE strParam_Nm = @strParam_Nm
ELSE
    INSERT INTO QualPro_Params (strParam_Nm, strParam_Type, strParam_Grp, 
                                strParam_Value, numParam_Value, datParam_Value, Comments)
    VALUES (@strParam_Nm, @strParam_Type, @strParam_Grp, @strParam_Value, @numParam_Value, 
            @datParam_Value, @Comments)

-- QSIFAQSSDefinitionFileFolder
SET @strParam_Nm = 'QSIFAQSSDefinitionFileFolder'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN '\\FAQSSTest\Production\FAQSS\Dynamic\Litho'
        WHEN 'Tiger' THEN '\\FAQSSTest\Production\FAQSS\Dynamic\Litho'
        ELSE '\\Argus\Production\FAQSS\Dynamic\Litho'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the location to place the comment definition files'
IF EXISTS(SELECT * FROM QualPro_Params WHERE strParam_Nm = @strParam_Nm)
    UPDATE QualPro_Params
    SET strParam_Type = @strParam_Type, strParam_Grp = @strParam_Grp, 
        strParam_Value = @strParam_Value, numParam_Value = @numParam_Value, 
        datParam_Value = @datParam_Value, Comments = @Comments
    WHERE strParam_Nm = @strParam_Nm
ELSE
    INSERT INTO QualPro_Params (strParam_Nm, strParam_Type, strParam_Grp, 
                                strParam_Value, numParam_Value, datParam_Value, Comments)
    VALUES (@strParam_Nm, @strParam_Type, @strParam_Grp, @strParam_Value, @numParam_Value, 
            @datParam_Value, @Comments)

-- QSITransferTempFolderCleanDays
-- No longer used
SET @strParam_Nm = 'QSITransferTempFolderCleanDays'
DELETE FROM QualPro_Params WHERE strParam_Nm = @strParam_Nm
/*
SET @strParam_Nm = 'QSITransferTempFolderCleanDays'
SET @strParam_Type = 'N'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = NULL
SET @numParam_Value = 14
SET @datParam_Value = NULL
SET @Comments = 'Specifies how many days to wait before deleting folders from the QSITransferTempFolder'
IF EXISTS(SELECT * FROM QualPro_Params WHERE strParam_Nm = @strParam_Nm)
    UPDATE QualPro_Params
    SET strParam_Type = @strParam_Type, strParam_Grp = @strParam_Grp, 
        strParam_Value = @strParam_Value, numParam_Value = @numParam_Value, 
        datParam_Value = @datParam_Value, Comments = @Comments
    WHERE strParam_Nm = @strParam_Nm
ELSE
    INSERT INTO QualPro_Params (strParam_Nm, strParam_Type, strParam_Grp, 
                                strParam_Value, numParam_Value, datParam_Value, Comments)
    VALUES (@strParam_Nm, @strParam_Type, @strParam_Grp, @strParam_Value, @numParam_Value, 
            @datParam_Value, @Comments)
*/
