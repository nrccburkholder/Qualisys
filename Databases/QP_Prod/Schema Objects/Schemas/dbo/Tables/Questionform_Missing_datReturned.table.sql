﻿CREATE TABLE dbo.Questionform_Missing_datReturned 
	([QfMissingDatreturned_id] int identity(1,1)
	, [logDate] datetime
	, [host_name] nvarchar(256)
	, [program_name] nvarchar(256)
	, [login_name] nvarchar(256)
	, [isResetLitho] tinyint
	, [Notes] varchar(500)
	, [QUESTIONFORM_ID] int
	, [SENTMAIL_ID] int
	, [SAMPLEPOP_ID] int
	, [DATRETURNED] datetime
	, [SURVEY_ID] int
	, [UnusedReturn_id] int
	, [datUnusedReturn] datetime
	, [datResultsImported] datetime
	, [strSTRBatchNumber] varchar(8)
	, [intSTRLineNumber] int
	, [ReceiptType_id] int
	, [strScanBatch] varchar(100))