DECLARE @strParam_Nm varchar(50)
DECLARE @strParam_Type char(1)
DECLARE @strParam_Grp varchar(20)
DECLARE @strParam_Value varchar(255)
DECLARE @numParam_Value int
DECLARE @datParam_Value datetime
DECLARE @Comments varchar(255)

-- QSIServicesServerName
SET @strParam_Nm = 'QSIServicesServerName'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN 'Superman'
        WHEN 'Tiger' THEN 'Huskers'
        ELSE 'Argus'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the name of the server where the QSI Services are installed and running'
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

-- QSIVendorSampleSetFileInterval
-- No Longer Used
DELETE QualPro_Params
WHERE strParam_Nm = 'QSIVendorSampleSetFileInterval'
/*
SET @strParam_Nm = 'QSIVendorSampleSetFileInterval'
SET @strParam_Type = 'N'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = NULL
SET @numParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN 10000
        WHEN 'Tiger' THEN 60000
        ELSE 300000
    END
SET @datParam_Value = NULL
SET @Comments = 'Specifies how often the QSI Vendor SampleSet File Service checks for new SampleSets in milliseconds'
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

-- QSIVendorFileInterval
SET @strParam_Nm = 'QSIVendorFileInterval'
SET @strParam_Type = 'N'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = NULL
SET @numParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN 10000
        WHEN 'Tiger' THEN 300000
        ELSE 1800000
    END
SET @datParam_Value = NULL
SET @Comments = 'Specifies how often the QSI Vendor File Service checks for new SampleSets in milliseconds'
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

-- QSIVendorSampleSetFileOutboundFolder
-- No Longer Used
DELETE QualPro_Params
WHERE strParam_Nm = 'QSIVendorSampleSetFileOutboundFolder'
/*
SET @strParam_Nm = 'QSIVendorSampleSetFileOutboundFolder'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN '\\Superman\Production\SampleSetFiles\OutboundFiles'
        WHEN 'Tiger' THEN '\\Huskers\Production\SampleSetFiles\OutboundFiles'
        ELSE '\\Argus\Production\SampleSetFiles\OutboundFiles'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the location to create the SampleSet files.'
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

-- QSIVendorFileOutboundRootFolder
SET @strParam_Nm = 'QSIVendorFileOutboundRootFolder'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN '\\Superman\Production\SampleSetFiles\ftpUser'
        WHEN 'Tiger\Something' THEN '\\Huskers\Production\SampleSetFiles\ftpuser'
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

-- QSIVendorSampleSetFileArchiveFolder
-- No Longer Used
DELETE QualPro_Params
WHERE strParam_Nm = 'QSIVendorSampleSetFileArchiveFolder'
/*
SET @strParam_Nm = 'QSIVendorSampleSetFileArchiveFolder'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN '\\Superman\Production\SampleSetFiles\ArchivedFiles'
        WHEN 'Tiger' THEN '\\Huskers\Production\SampleSetFiles\ArchivedFiles'
        ELSE '\\Argus\Production\SampleSetFiles\ArchivedFiles'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the location to archive the SampleSet files after creation.'
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

-- QSIVendorFileArchiveFolder
SET @strParam_Nm = 'QSIVendorFileArchiveFolder'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN '\\Superman\Production\SampleSetFiles\ArchivedFiles'
        WHEN 'Tiger' THEN '\\Huskers\Production\SampleSetFiles\ArchivedFiles'
        ELSE '\\Argus\Production\SampleSetFiles\ArchivedFiles'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the location to archive the SampleSet files after creation.'
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

-- QSIVendorFileTelematchSFTPHost
SET @strParam_Nm = 'QSIVendorFileTelematchSFTPHost'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN 'ftp.nationalresearch.com'
        WHEN 'Tiger' THEN 'ftp.nationalresearch.com'
        ELSE 'ftp.telematch.com'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the host name of the telematch SFTP server.'
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

-- QSIVendorFileTelematchSFTPUser
SET @strParam_Nm = 'QSIVendorFileTelematchSFTPUser'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN 'TelematchTest'
        WHEN 'Tiger' THEN 'TelematchStage'
        ELSE 'nrc9371'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the username for the telematch SFTP server.'
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

-- QSIVendorFileTelematchSFTPPassword
SET @strParam_Nm = 'QSIVendorFileTelematchSFTPPassword'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN 'NRC2test'
        WHEN 'Tiger' THEN 'NRC2Stage'
        ELSE 'ohd0UxfH'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the password for the telematch SFTP server.'
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

-- QSIVendorFileTelematchSFTPFolder
SET @strParam_Nm = 'QSIVendorFileTelematchSFTPFolder'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN 'uploads/'
        WHEN 'Tiger' THEN 'uploads/'
        ELSE 'auto/'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the password for the telematch SFTP server.'
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

-- QSIVendorFileTelematchInboundFolder
SET @strParam_Nm = 'QSIVendorFileTelematchInboundFolder'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN '\\Superman\Production\SampleSetFiles\ftpUser\Telematch\uploads'
        WHEN 'Tiger\Something' THEN '\\Huskers\Production\SampleSetFiles\ftpUser\Telematch\uploads'
        ELSE '\\ftp\ftpuser\Telematch\uploads'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the location to pickup inbound telematch files'
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

-- QSIVendorFileInProcessFolder
SET @strParam_Nm = 'QSIVendorFileInProcessFolder'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN '\\Superman\Production\SampleSetFiles\InProcessFiles'
        WHEN 'Tiger' THEN '\\Huskers\Production\SampleSetFiles\InProcessFiles'
        ELSE '\\Argus\Production\SampleSetFiles\InProcessFiles'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the location to place the SampleSet files while converting from CSV to XLS.'
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

-- QSIVendorFileTelematchAgeInHoursEmail
SET @strParam_Nm = 'QSIVendorFileTelematchAgeInHoursEmail'
SET @strParam_Type = 'N'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = NULL
SET @numParam_Value = 2
SET @datParam_Value = NULL
SET @Comments = 'Specifies the age in hours for telematch files to be returned before sending an email'
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

-- QSIVoviciInterval
SET @strParam_Nm = 'QSIVoviciInterval'
SET @strParam_Type = 'N'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = NULL
SET @numParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN 300000
        WHEN 'Tiger' THEN 300000
        ELSE 300000
    END
SET @datParam_Value = NULL
SET @Comments = 'Specifies how often the QSI Vovici Service checks for new uploads and results in milliseconds'
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

-- QSIVoviciOutboundRunTimes
SET @strParam_Nm = 'QSIVoviciOutboundRunTimes'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN '8:00,8:30,9:00,9:30,10:00,10:30,11:00,11:30,12:00,12:30,13:00,13:30,14:00,14:30,15:00,15:30,16:00,16:30,17:00'
        WHEN 'Tiger' THEN '8:00,8:30,9:00,9:30,10:00,10:30,11:00,11:30,12:00,12:30,13:00,13:30,14:00,14:30,15:00,15:30,16:00,16:30,17:00'
        ELSE '19:30'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies at what times (Military) the service should run for outbound files. Comma seperate times.'
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

-- QSIVoviciInboundRunTimes
SET @strParam_Nm = 'QSIVoviciInboundRunTimes'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN '8:00,8:30,9:00,9:30,10:00,10:30,11:00,11:30,12:00,12:30,13:00,13:30,14:00,14:30,15:00,15:30,16:00,16:30,17:00'
        WHEN 'Tiger' THEN '8:00,8:30,9:00,9:30,10:00,10:30,11:00,11:30,12:00,12:30,13:00,13:30,14:00,14:30,15:00,15:30,16:00,16:30,17:00'
        ELSE '19:30'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies at what times (Military) the service should run for inbound files. Comma seperate times.'
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

-- QSIReportServerURL
SET @strParam_Nm = 'QSIReportServerURL'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN 'http://Ironman/ReportServer'
        WHEN 'Tiger' THEN 'http://RunningRebel/ReportServer'
        ELSE 'http://Iris/ReportServer'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the SQL Server Reporting Services server.'
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

-- QSIVendorFileValidationReportPath
SET @strParam_Nm = 'QSIVendorFileValidationReportPath'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN '/AlternativeMethodology/Vendor Outgoing File Validation'
        WHEN 'Tiger' THEN '/AlternativeMethodology/Vendor Outgoing File Validation'
        ELSE '/AlternativeMethodology/Vendor Outgoing File Validation'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the SQL Server Reporting Services server.'
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

-- QSINavigatorFontSizeStep
SET @strParam_Nm = 'QSINavigatorFontSizeStep'
SET @strParam_Type = 'N'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = NULL
SET @numParam_Value = 2
SET @datParam_Value = NULL
SET @Comments = 'Specifies how many points to increase or decrease the font size'
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

-- QSINavigatorFontSizeMin
SET @strParam_Nm = 'QSINavigatorFontSizeMin'
SET @strParam_Type = 'N'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = NULL
SET @numParam_Value = 8
SET @datParam_Value = NULL
SET @Comments = 'Specifies the minimum font size for the navigator'
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

-- QSINavigatorFontSizeMax
SET @strParam_Nm = 'QSINavigatorFontSizeMax'
SET @strParam_Type = 'N'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = NULL
SET @numParam_Value = 14
SET @datParam_Value = NULL
SET @Comments = 'Specifies the maximum font size for the navigator'
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

-- QSITransferDefaultDaysToDisplay
SET @strParam_Nm = 'QSITransferDefaultDaysToDisplay'
SET @strParam_Type = 'N'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = NULL
SET @numParam_Value = 7
SET @datParam_Value = NULL
SET @Comments = 'Specifies the default number of days to display in the Transfer Results navigator'
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

-- QSIVendorFileDefaultDaysToDisplay
SET @strParam_Nm = 'QSIVendorFileDefaultDaysToDisplay'
SET @strParam_Type = 'N'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = NULL
SET @numParam_Value = 7
SET @datParam_Value = NULL
SET @Comments = 'Specifies the default number of days to display in the Vendor File Validation navigator'
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

-- ServicesDownTimeStartHour
SET @strParam_Nm = 'ServicesDownTimeStartHour'
SET @strParam_Type = 'N'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = NULL
SET @numParam_Value = 7
SET @datParam_Value = NULL
SET @Comments = 'Specifies the hour (value: 0 - 23) of when the services are to stop processing'
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

-- ServicesDownTimeEndHour
SET @strParam_Nm = 'ServicesDownTimeEndHour'
SET @strParam_Type = 'N'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = NULL
SET @numParam_Value = 19
SET @datParam_Value = NULL
SET @Comments = 'Specifies the hour (value: 0 - 23) of when the services are to start processing'
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