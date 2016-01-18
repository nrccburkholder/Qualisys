/*
S40_US34.1 OCS HH: process update files

user story 34:
As a company, we want to process update files received from OCS HHCAHPS clients so that we provide complete data to CMS on behalf of the clients.

Brendan Goble

Task 34.1 Add cutoff dates to QUALPRO_PARAMS.

*/
use QP_Prod
go

if not exists (select * from dbo.QUALPRO_PARAMS where STRPARAM_NM in ('HHCAHPSUpdateFileQ1Cutoff', 'HHCAHPSUpdateFileQ2Cutoff', 'HHCAHPSUpdateFileQ3Cutoff', 'HHCAHPSUpdateFileQ4Cutoff'))
begin
	INSERT INTO [dbo].[QUALPRO_PARAMS]
			   ([STRPARAM_NM]
			   ,[STRPARAM_TYPE]
			   ,[STRPARAM_GRP]
			   ,[STRPARAM_VALUE]
			   ,[NUMPARAM_VALUE]
			   ,[DATPARAM_VALUE]
			   ,[COMMENTS])
		 VALUES
			   ('HHCAHPSUpdateFileQ1Cutoff'
			   ,'D'
			   ,'HHCAHPSImporter'
			   ,null
			   ,null
			   ,'2016-07-15'
			   ,'Cutoff date for processing HHCAHPS update files in Quarter 1. Files will be processed up to and including this day. Only the month and day are significant, year will be set by the importer.'
			   ),
			   ('HHCAHPSUpdateFileQ2Cutoff'
			   ,'D'
			   ,'HHCAHPSImporter'
			   ,null
			   ,null
			   ,'2016-10-15'
			   ,'Cutoff date for processing HHCAHPS update files in Quarter 2. Files will be processed up to and including this day. Only the month and day are significant, year will be set by the importer.'
			   ),
			   ('HHCAHPSUpdateFileQ3Cutoff'
			   ,'D'
			   ,'HHCAHPSImporter'
			   ,null
			   ,null
			   ,'2017-01-15'
			   ,'Cutoff date for processing HHCAHPS update files in Quarter 3. Files will be processed up to and including this day. Only the month and day are significant, year will be set by the importer.'
			   ),
			   ('HHCAHPSUpdateFileQ4Cutoff'
			   ,'D'
			   ,'HHCAHPSImporter'
			   ,null
			   ,null
			   ,'2017-04-15'
			   ,'Cutoff date for processing HHCAHPS update files in Quarter 4. Files will be processed up to and including this day. Only the month and day are significant, year will be set by the importer.'
			   )
end
go