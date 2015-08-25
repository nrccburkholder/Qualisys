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
if not exists (select * from qualisys.qp_prod.dbo.SurveyTypeDispositions where surveytype_id=14)
insert into qualisys.qp_prod.dbo.SurveyTypeDispositions 
(surveytype_id	,Value	,[Desc]	,Hierarchy	,ExportReportResponses	,Disposition_ID	)
values (14	,20	,'Deceased'										,1	,0	,3	)
	,  (14	,11	,'Institutionalized'							,2	,0	,24	)
	,  (14	,40	,'Excluded from survey'							,3	,0	,48	)
	,  (14	,10	,'Completed Survey'								,4	,1	,13	)
	,  (14	,34	,'Blank survey or incomplete survey returned'	,5	,0	,49	)
	,  (14	,31	,'Partially Completed Survey'					,6	,1	,11	)
	,  (14	,34	,'Blank survey or incomplete survey returned'	,7	,1	,25	)
	,  (14	,34	,'Blank survey or incomplete survey returned'	,7	,1	,26	)
	,  (14	,34	,'Blank survey or incomplete survey returned'	,7	,1	,27	)
	,  (14	,22	,'Language Barrier'								,8	,0	,10	)
	,  (14	,24	,'Mentally or physically unable to respond'		,9	,0	,4	)
	,  (14	,32	,'Refusal'										,10	,0	,2	)
	,  (14	,35	,'Bad address and/or bad phone number'			,11	,0	,5	)
	,  (14	,35	,'Bad address and/or bad phone number'			,11	,0	,16	)
	,  (14	,35	,'Bad address and/or bad phone number'			,11	,0	,14	)
	,  (14	,33	,'Non-response'									,12	,0	,12	)
go
use NRC_Datamart
go

if (select count(*) from dbo.Disposition where dispositionid in (3,24,48,13,49,11,25,26,27,10,4,2,5,16,14,12)) <> 16
	print 'there''s something wrong!'

if not exists (select * from dbo.CahpsType where cahpstypeid=8 and label='PQRS CAHPS')
	print 'there''s something wrong!'

if not exists (select * from CahpsDisposition where cahpstypeid=8 )
insert into dbo.CahpsDisposition (CahpsDispositionID,CahpsTypeID,Label,IsCahpsDispositionComplete,IsCahpsDispositionInComplete)
values (820, 8, 'Deceased'										, 0, 0)
	,  (811, 8, 'Institutionalized'								, 0, 0)
	,  (840, 8, 'Excluded from survey'							, 0, 0)
	,  (810, 8, 'Completed Survey'								, 1, 0)
	,  (834, 8, 'Blank survey or incomplete survey returned'	, 0, 0)
	,  (831, 8, 'Partially Completed Survey'					, 0, 1)
	,  (822, 8, 'Language Barrier'								, 0, 0)
	,  (824, 8, 'Mentally or physically unable to respond'		, 0, 0)
	,  (832, 8, 'Refusal'										, 0, 0)
	,  (835, 8, 'Bad address and/or bad phone number'			, 0, 0)
	,  (833, 8, 'Non-response'									, 0, 0)

if not exists (select * from CahpsDispositionMapping where cahpstypeid=8)
insert into dbo.CahpsDispositionMapping (CahpsTypeID, DispositionID, ReceiptTypeID, Label, CahpsDispositionID, CahpsHierarchy, IsDefaultDisposition)
values (8, 3	, -1,'Deceased'										,820,  1	,0)
	,  (8, 24	, -1,'Institutionalized'							,811,  2	,0)
	,  (8, 48	, -1,'Excluded from survey'							,840,  3	,0)
	,  (8, 13	, -1,'Completed Survey'								,810,  4	,0)
	,  (8, 49	, -1,'Blank survey or incomplete survey returned'	,834,  5	,0)
	,  (8, 11	, -1,'Partially Completed Survey'					,831,  6	,0)
	,  (8, 25	, -1,'Blank survey or incomplete survey returned'	,834,  7	,0)
	,  (8, 26	, -1,'Blank survey or incomplete survey returned'	,834,  7	,0)
	,  (8, 27	, -1,'Blank survey or incomplete survey returned'	,834,  7	,0)
	,  (8, 10	, -1,'Language Barrier'								,822,  8	,0)
	,  (8, 4	, -1,'Mentally or physically unable to respond'		,824,  9	,0)
	,  (8, 2	, -1,'Refusal'										,832,  10	,0)
	,  (8, 5	, -1,'Bad address and/or bad phone number'			,835,  11	,0)
	,  (8, 16	, -1,'Bad address and/or bad phone number'			,835,  11	,0)
	,  (8, 14	, -1,'Bad address and/or bad phone number'			,835,  11	,0)
	,  (8, 12	, -1,'Non-response'									,833,  12	,1)
