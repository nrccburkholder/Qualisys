/*

	S14.2 US11.2 Add mailing methodology to sample set table in NRC datamart and assosiated stored procs.

*/

use [NRC_DataMart_ETL]
go
begin tran
go
if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'StandardMethodology' 
					   AND sc.NAME = 'StandardMethodologyID' )

	alter table [dbo].[SampleSetTemp] add StandardMethodologyID tinyint NOT NULL default(0)

go

commit tran
go