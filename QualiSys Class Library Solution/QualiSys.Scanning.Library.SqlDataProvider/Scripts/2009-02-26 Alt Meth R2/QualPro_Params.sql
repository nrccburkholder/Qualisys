DECLARE @strParam_Nm varchar(50)
DECLARE @strParam_Type char(1)
DECLARE @strParam_Grp varchar(20)
DECLARE @strParam_Value varchar(255)
DECLARE @numParam_Value int
DECLARE @datParam_Value datetime
DECLARE @Comments varchar(255)

-- QSIFileMoverInterval
SET @strParam_Nm = 'QSIFileMoverInterval'
SET @strParam_Type = 'N'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = NULL
SET @numParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN 300000
        WHEN 'Tiger\Something' THEN 300000
        ELSE 900000
    END
SET @datParam_Value = NULL
SET @Comments = 'Specifies how often the QSI File Mover Service checks for new files in milliseconds'
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

-- QSIFileMoverRootPath
SET @strParam_Nm = 'QSIFileMoverRootPath'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN '\\Superman\Production\TransferResults\ftpuser'
        WHEN 'Tiger\Something' THEN '\\Huskers\Production\TransferResults\ftpuser'
        ELSE '\\ftp\ftpuser'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the location to archive files after they are transferred'
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
