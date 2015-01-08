/*

	S14.2 US11.2 Add mailing methodology to sample set table in NRC datamart and assosiated stored procs.


	Tim Butler

	alter table [dbo].[SampleSet]

*/

use [NRC_DataMart]
go
begin tran
go
if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'SampleSet' 
					   AND sc.NAME = 'StandardMethodologyID' )

	alter table [dbo].[SampleSet] add StandardMethodologyID int NULL 

go

commit tran
go

begin tran
go

DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'LOAD_TABLES'


if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = @schema_id 
					   AND st.NAME = 'SampleSet' 
					   AND sc.NAME = 'StandardMethodologyID' )

	alter table [LOAD_TABLES].[SampleSet] add StandardMethodologyID int NULL

go

commit tran
go

begin tran
go

DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'LOAD_TABLES'


if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = @schema_id 
					   AND st.NAME = 'SampleSetError' 
					   AND sc.NAME = 'StandardMethodologyID' )

	alter table [LOAD_TABLES].[SampleSetError] add StandardMethodologyID int NULL

go

commit tran
go

