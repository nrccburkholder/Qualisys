/*
S40_US34.1 OCS HH: process update files

user story 34:
As a company, we want to process update files received from OCS HHCAHPS clients so that we provide complete data to CMS on behalf of the clients.

Brendan Goble

Task 34.1 Add cutoff dates to Loading_PARAMS.

*/
use QP_DataLoad
go

if not exists (select * from dbo.Loading_PARAMS where STRPARAM_NM in ('Q1Cutoff', 'Q2Cutoff', 'Q3Cutoff', 'Q4Cutoff'))
begin
	INSERT INTO [dbo].[Loading_PARAMS]
			   ([PARAM_ID]
			   ,[STRPARAM_NM]
			   ,[STRPARAM_TYPE]
			   ,[STRPARAM_GRP]
			   ,[STRPARAM_VALUE]
			   ,[NUMPARAM_VALUE]
			   ,[DATPARAM_VALUE]
			   ,[COMMENTS])
		 VALUES
			   (3
			   ,'Q1Cutoff'
			   ,'D'
			   ,'Loading'
			   ,null
			   ,null
			   ,'2016-07-15'
			   ,'Cutoff date for processing HHCAHPS files in Quarter 1. Files will be processed up to and including this day. Only the month and day are significant, year will be set by the importer.'
			   ),
			   (4
			   ,'Q2Cutoff'
			   ,'D'
			   ,'Loading'
			   ,null
			   ,null
			   ,'2016-10-15'
			   ,'Cutoff date for processing HHCAHPS files in Quarter 2. Files will be processed up to and including this day. Only the month and day are significant, year will be set by the importer.'
			   ),
			   (5
			   ,'Q3Cutoff'
			   ,'D'
			   ,'Loading'
			   ,null
			   ,null
			   ,'2017-01-15'
			   ,'Cutoff date for processing HHCAHPS files in Quarter 3. Files will be processed up to and including this day. Only the month and day are significant, year will be set by the importer.'
			   ),
			   (6
			   ,'Q4Cutoff'
			   ,'D'
			   ,'Loading'
			   ,null
			   ,null
			   ,'2017-04-15'
			   ,'Cutoff date for processing HHCAHPS files in Quarter 4. Files will be processed up to and including this day. Only the month and day are significant, year will be set by the importer.'
			   )
end
go