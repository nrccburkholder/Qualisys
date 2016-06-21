/*
	S32 US21	PQRS Dispositions
				As a PQRS Vendor, we need to assign the correct final disposition to all records, so that we can process and report data correctly

	21.1	insert records into survey type dispositions table for PQRS
	21.2	insert PQRS dispostion data into the proper Catalyst tables

Dave Gilsdorf

QP_Prod:
insert into dbo.SurveyTypeDisposition 

NRC_Datamart:
insert into dbo.CahpsDisposition 
insert into dbo.CahpsDispositionMapping 
*/
go
use master
go
delete from qualisys.qp_prod.dbo.SurveyTypeDisposition where surveytype_id=14
go
use NRC_Datamart
go
delete from CahpsDisposition where cahpstypeid=8

delete from CahpsDispositionMapping where cahpstypeid=8
