/*

S43 US13 ICH: New Methodologies 
As an authorized ICH-CAHPS vendor, we need to set up new methodologies for Spring 2016, so that we can field compliantly



Tim Butler

Task 2 - Create script using prior examples, plus Catalyst table & run same


*/


use nrc_datamart

begin tran

UPDATE ct	
	SET NumberCutoffDays = 88
  FROM dbo.CahpsType ct
  where Label = 'ICHCAHPS'

commit tran



select *
FROM dbo.CahpsType ct