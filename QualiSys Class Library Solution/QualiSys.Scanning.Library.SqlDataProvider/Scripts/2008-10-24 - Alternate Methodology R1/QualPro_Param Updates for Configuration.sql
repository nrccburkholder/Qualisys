DECLARE @strParam_Nm varchar(50)
DECLARE @strParam_Type char(1)
DECLARE @strParam_Grp varchar(20)
DECLARE @strParam_Value varchar(255)
DECLARE @numParam_Value int
DECLARE @datParam_Value datetime
DECLARE @Comments varchar(255)

-- QSITransferArchiveFolder
SET @strParam_Nm = 'QSITransferArchiveFolder'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN '\\Superman\Production\TransferResults\ArchivedFiles'
        WHEN 'Tiger\Something' THEN '\\Huskers\Production\TransferResults\ArchivedFiles'
        ELSE '\\Argus\Production\TransferResults\ArchivedFiles'
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

-- QSITransferTempFolder
SET @strParam_Nm = 'QSITransferTempFolder'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN '\\Superman\Production\TransferResults\InProcessFiles'
        WHEN 'Tiger\Something' THEN '\\Huskers\Production\TransferResults\InProcessFiles'
        ELSE '\\Argus\Production\TransferResults\InProcessFiles'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the base location for temp files used while transferring a file'
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

-- QSIMaxConcurrentTransfers
SET @strParam_Nm = 'QSIMaxConcurrentTransfers'
SET @strParam_Type = 'N'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = NULL
SET @numParam_Value = 5
SET @datParam_Value = NULL
SET @Comments = 'Specifies how many files can be transferred at the same time'
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

-- QSIServicePauseInterval
SET @strParam_Nm = 'QSIServicePauseInterval'
SET @strParam_Type = 'N'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = NULL
SET @numParam_Value = 10000
SET @datParam_Value = NULL
SET @Comments = 'Specifies how long the Scanner Interface Service pauses waiting for the next available thread in milliseconds'
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

-- QSIServiceInterval
SET @strParam_Nm = 'QSIServiceInterval'
SET @strParam_Type = 'N'
SET @strParam_Grp = 'ScannerInterface'
SET @strParam_Value = NULL
SET @numParam_Value = 10000
SET @datParam_Value = NULL
SET @Comments = 'Specifies how often the Scanner Interface Service checks for new files in milliseconds'
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

-- EnvName
SET @strParam_Nm = 'EnvName'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'Environment'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN 'TESTING'
        WHEN 'Tiger\Something' THEN 'STAGING'
        ELSE 'PRODUCTION'
    END
SET @numParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN 2
        WHEN 'Tiger\Something' THEN 3
        ELSE 1
    END
SET @datParam_Value = NULL
SET @Comments = 'Specifies the environment name - Production (1), Testing (2), Staging (3)'
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

-- Country
SET @strParam_Nm = 'Country'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'Environment'
SET @strParam_Value = 'US'
SET @numParam_Value = 1
SET @datParam_Value = NULL
SET @Comments = 'Country this instalation of Qualisys is in.  US (1), Canada (2)'
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

-- QualisysConnection
SET @strParam_Nm = 'QualisysConnection'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ConnectionStrings'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN 'Data Source=Spiderman,5678;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Prod;'
        WHEN 'Tiger\Something' THEN 'Data Source=Tiger,5678;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Prod;'
        ELSE 'Data Source=NRC10;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Prod;'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the connection string for the QP_Prod database'
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

-- ScanConnection
SET @strParam_Nm = 'ScanConnection'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ConnectionStrings'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN 'Data Source=Spiderman,5678;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Scan;'
        WHEN 'Tiger\Something' THEN 'Data Source=Tiger,5678;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Scan;'
        ELSE 'Data Source=NRC10;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Scan;'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the connection string for the QP_Scan database'
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

-- QueueConnection
SET @strParam_Nm = 'QueueConnection'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ConnectionStrings'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN 'Data Source=Spiderman,5678;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Queue;'
        WHEN 'Tiger\Something' THEN 'Data Source=Tiger,5678;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Queue;'
        ELSE 'Data Source=NRC10;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Queue;'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the connection string for the QP_Queue database'
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

-- WorkflowConnection
SET @strParam_Nm = 'WorkflowConnection'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ConnectionStrings'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN 'Data Source=Spiderman,5678;UID=qpsa;PWD=qpsa;Initial Catalog=Workflow;'
        WHEN 'Tiger\Something' THEN 'Data Source=Tiger,5678;UID=qpsa;PWD=qpsa;Initial Catalog=Workflow;'
        ELSE 'Data Source=NRC10;UID=qpsa;PWD=qpsa;Initial Catalog=Workflow;'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the connection string for the Workflow database'
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

-- NrcAuthConnection
SET @strParam_Nm = 'NrcAuthConnection'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ConnectionStrings'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN 'Data Source=Batman,5678;UID=qpsa;PWD=qpsa;Initial Catalog=NRCAuth;'
        WHEN 'Tiger\Something' THEN 'Data Source=Jayhawk,5678;UID=qpsa;PWD=qpsa;Initial Catalog=NRCAuth;'
        ELSE 'Data Source=Mercury;UID=qpsa;PWD=qpsa;Initial Catalog=NRCAuth;'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the connection string for the NRCAuth database'
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

-- NotificationConnection
SET @strParam_Nm = 'NotificationConn'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ConnectionStrings'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN 'Data Source=Batman,5678;UID=qpsa;PWD=qpsa;Initial Catalog=NotificationService;'
        WHEN 'Tiger\Something' THEN 'Data Source=Jayhawk,5678;UID=qpsa;PWD=qpsa;Initial Catalog=NotificationService;'
        ELSE 'Data Source=Mercury;UID=qpsa;PWD=qpsa;Initial Catalog=NotificationService;'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the connection string for the NotificationService database'
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

-- DataMartConnection
SET @strParam_Nm = 'DataMartConnection'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ConnectionStrings'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN 'Data Source=Hulk,5678;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Comments;'
        WHEN 'Tiger\Something' THEN 'Data Source=Longhorn,5678;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Comments;'
        ELSE 'Data Source=Medusa;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Comments;'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the connection string for the QP_Comments database'
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

-- QLoaderConnection
SET @strParam_Nm = 'QLoaderConnection'
SET @strParam_Type = 'S'
SET @strParam_Grp = 'ConnectionStrings'
SET @strParam_Value = 
    CASE @@ServerName
        WHEN 'Spiderman' THEN 'Data Source=WonderWoman,5678;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Load;'
        WHEN 'Tiger\Something' THEN 'Data Source=Cyclone,5678;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Load;'
        ELSE 'Data Source=Mars;UID=qpsa;PWD=qpsa;Initial Catalog=QP_Load;'
    END
SET @numParam_Value = NULL
SET @datParam_Value = NULL
SET @Comments = 'Specifies the connection string for the QP_Load database'
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


