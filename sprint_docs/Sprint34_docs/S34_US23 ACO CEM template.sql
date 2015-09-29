/*
S34_US23 ACO CEM template.sql

As a compliance analyst I want the ACO submission file to be created in CEM using the newest version of submission file layout

23.1 - create a new template in CEM for ACO

Dave Gilsdorf

NRC_DataMart_Extracts:
insert into cem.ExportTemplate
insert into cem.ExportTemplateSection 
insert into cem.ExportTemplateDefaultResponse 
insert into cem.ExportTemplateColumn
insert into cem.ExportTemplateColumnResponse
insert into cem.DispositionProcess
insert into cem.DispositionClause
insert into cem.DispositionInList

*/
use NRC_DataMart_Extracts
go
if object_id('tempdb..#ACO') is not null
   drop table #ACO

declare @ETid int, @ETSid int
insert into cem.ExportTemplate (ExportTemplateName, SurveyTypeID, SurveySubTypeID, ValidDateColumnID, ValidStartDate, ValidEndDate, ExportTemplateVersionMajor, ExportTemplateVersionMinor, CreatedBy, CreatedOn, ClientID, DefaultNotificationID, DefaultNamingConvention, State, ReturnsOnly, SampleUnitCahpsTypeID, XMLSchemaDefinition, isOfficial, DefaultFileMakerType)
select 'ACO CAHPS' as ExportTemplateName
	, 10 as SurveyTypeID
	, null as SurveySubTypeID
	, 00 as ValidDateColumnID
	, '9/1/2015' as ValidStartDate
	, '12/31/2222' as ValidEndDate
	, 'ACO-12' as ExportTemplateVersionMajor
	, 1 as ExportTemplateVersionMinor
	, system_user as CreatedBy
	, getdate() as CreatedOn
	, null as ClientID
	, null as DefaultNotificationID
	, 'ACO12.NationalResearchCorp.submission{support.SUBNUM}.{support.SUBMN}{support.SUBDY}{support.SUBYR}' as DefaultNamingConvention
	, 1 as State
	, 0 as ReturnsOnly
	, 4 as SampleUnitCahpsTypeID
	, NULL as XMLSchemaDefinition
	, 1 as isOfficial
	, 2 as DefaultFileMakerType

set @ETid=SCOPE_IDENTITY()

insert into cem.ExportTemplateDefaultResponse (ExportTemplateID, RawValue, RecodeValue, ResponseLabel)
values (@ETid, -9,	'M ',	'MISSING')
	, (@ETid, -8,	'M ',	'MISSING')
	, (@ETid, -6,	'98',	'DON''T KNOW')
	, (@ETid, -5,	'99',	'REFUSED')
	, (@ETid, -4,	'M ',	'NOT APPLICABLE')
	, (@ETid, 10000,'0 ',	'(various)')
	, (@ETid, 10001,'1 ',	'(various)')
	, (@ETid, 10002,'2 ',	'(various)')
	, (@ETid, 10003,'3 ',	'(various)')
	, (@ETid, 10004,'4 ',	'(various)')
	, (@ETid, 10005,'5 ',	'(various)')
	, (@ETid, 10006,'6 ',	'(various)')
	, (@ETid, 10007,'7 ',	'(various)')
	, (@ETid, 10008,'8 ',	'(various)')
	, (@ETid, 10009,'9 ',	'(various)')
	, (@ETid, 10010,'10',	'(various)')
	, (@ETid, 10011,'11',	'(various)')
	, (@ETid, 10012,'12',	'(various)')
	, (@ETid, 10013,'13',	'(various)')
	, (@ETid, 10014,'14',	'(various)')

insert into cem.ExportTemplateSection (ExportTemplateSectionName,ExportTemplateID,DefaultNamingConvention)
select 'support' as ExportTemplateSectionName,
	@ETid as ExportTemplateID,
	NULL as DefaultNamingConvention
set @ETSid=SCOPE_IDENTITY()

insert into cem.ExportTemplateColumn (ExportTemplateSectionID, ExportTemplateColumnDescription, ColumnOrder,	DatasourceID,	ExportColumnName,	SourceColumnName,				SourceColumnType,	AggregateFunction,	DispositionProcessID,	FixedWidthLength,	ColumnSetKey,	FormatID,	MissingThresholdPercentage,	CheckFrequencies)
VALUES (@ETSid, 'The year in which the file is submitted.',												1,		0,				'SUBYR',			'00',							167,				null,				null,					2,					NULL,			NULL,		.95,						0)
	, (@ETSid, 'The month in which the file is submitted.',												2,		0,				'SUBMN',			'00',							167,				null,				null,					2,					NULL,			NULL,		.95,						0)
	, (@ETSid, 'The day in which the file is submitted.',												3,		0,				'SUBDY',			'00',							167,				null,				null,					2,					NULL,			NULL,		.95,						0)
	, (@ETSid, 'Number of the submission sent that day.',												4,		0,				'SUBNUM',			'1',							167,				null,				null,					2,					NULL,			NULL,		.95,						0)
	, (@ETSid, 'Field date.',																			5,		5,				'FIELDDATE',		'SampleDate',					61,					null,				null,					8,					NULL,			NULL,		.95,						0)

update et
set ValidDateColumnID=ExportTemplateColumnID
from cem.ExportTemplate ET, cem.ExportTemplateColumn etc
where et.ExportTemplateID=@ETid
and etc.ExportColumnName='FIELDDATE'
and etc.ExportTemplateSectionID=@ETSid

insert into cem.ExportTemplateSection (ExportTemplateSectionName,ExportTemplateID,DefaultNamingConvention)
select 'submission' as ExportTemplateSectionName,
	@ETid as ExportTemplateID,
	NULL as DefaultNamingConvention
set @ETSid=SCOPE_IDENTITY()

insert into cem.ExportTemplateColumn (ExportTemplateSectionID, ExportTemplateColumnDescription, ColumnOrder,	DatasourceID,	ExportColumnName,	SourceColumnName,				SourceColumnType,	AggregateFunction,	DispositionProcessID,	FixedWidthLength,	ColumnSetKey,	FormatID,	MissingThresholdPercentage,	CheckFrequencies)
VALUES (@ETSid, 'Unique Beneficiary Finder Number Assigned by CAHPS for ACOs Data Coordination Team',	1,		4,				'FINDER',			'ColumnName=''ACO_FinderNum''',	167,				null,				null,					8,					NULL,			NULL,		.95,						0)
, (@ETSid, 'Five character ACO identifier: begins with a letter (A or P), followed by 4 numbers',		2, 		4,				'ACO_ID',			'ColumnName=''ACO_ACOID''',		167,				null,				null,					5,					NULL,			NULL,		.95,						0)
, (@ETSid, 'Final Disposition Code',																	3,		3,             	'DISPOSITN',		'CahpsDispositionID',			56,					null,				null,					2,					NULL,			NULL,		.95,						0)
, (@ETSid, 'Survey Completion Mode',																	4,		1,             	'MODE',				'ReceiptTypeID',				56,					null,				null,					1,					NULL,			NULL,		.95,						0)
, (@ETSid, 'Survey Language',																			5,		3,             	'DISPO_LANG',		'LanguageID',					56,					null,				null,					1,					NULL,			NULL,		.95,						0)
, (@ETSid, 'Date survey was received or completed: YYYYMMDD',											6,		1,             	'RECEIVED',			'ReturnDate',					40,					null,				null,					8,					NULL,			NULL,		.95,						0)
, (@ETSid, 'Provider type: 1=Primary care, 2 = Specialist',												7,		4,             	'FOCALTYPE',		'ColumnName=''ACO_FocalType''',	167,				null,				null,					1,					NULL,			NULL,		.95,						0)
, (@ETSid, 'Type of provider (physician, PA, NP, etc)',													8,		4,             	'PRTITLE',			'ColumnName=''DrTitle''',		167,				null,				null,					35,					NULL,			NULL,		.95,						0)
, (@ETSid, 'Provider first name',																		9,		4,             	'PRFNAME',			'ColumnName=''DrFirstName''',	167,				null,				null,					30,					NULL,			NULL,		.95,						0)
, (@ETSid, 'Provider last name',																		10,		4,             	'PRLNAME',			'ColumnName=''DrLastName''',	167,				null,				null,					50,					NULL,			NULL,		.95,						0)
, (@ETSid, 'Which version of the survey was administered: 09 = ACO-9, 12 = ACO-12',						11,		3,             	'VERSION',			'CahpsDispositionID',			56,					null,				null,					2,					NULL,			NULL,		.95,						0)

declare @ETCid int
select @ETCid=ExportTemplateColumnID
from CEM.ExportTemplateColumn  etc
where etc.ExportTemplateSectionID=@ETSid
and ExportColumnName='DISPOSITN'

insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, RecodeValue, ResponseLabel)
values (@ETCid, 410, '10', 'Completed survey')
	, (@ETCid, 431, '31', 'Partially completed survey')
	, (@ETCid, 411, '11', 'Institutionalized')
	, (@ETCid, 420, '20', 'Deceased')
	, (@ETCid, 422, '22', 'Language barrier')
	, (@ETCid, 424, '24', 'Mentally or physically unable to respond')
	, (@ETCid, 432, '32', 'Refusal')
	, (@ETCid, 433, '33', 'Non-response when there is no indication of bad address or telephone number')
	, (@ETCid, 434, '34', 'Blank survey or Incomplete survey returned')
	, (@ETCid, 435, '35', 'Bad address and/or bad telephone number')
	, (@ETCid, 440, '40', 'Excluded from survey')

select @ETCid=ExportTemplateColumnID
from CEM.ExportTemplateColumn  etc
where etc.ExportTemplateSectionID=@ETSid
and ExportColumnName='MODE'

insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, RecodeValue, ResponseLabel)
values (@ETCid, 17, '1', 'Mail')
	, (@etcid, 999, '2', 'Inbound CATI')
	, (@etcid, 12, '3', 'Outbound CATI')
	, (@etcid, NULL, '8', 'Not applicable')

select @ETCid=ExportTemplateColumnID
from CEM.ExportTemplateColumn  etc
where etc.ExportTemplateSectionID=@ETSid
and ExportColumnName='DISPO_LANG'

insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, RecodeValue, ResponseLabel)
values(@etcid, 1, '1', 'English')
	, (@etcid, 19, '2', 'Spanish')
	, (@etcid, 990, '3', 'Cantonese')
	, (@etcid, 28, '4', 'Korean')
	, (@etcid, 991, '5', 'Mandarin')
	, (@etcid, 29, '6', 'Russian')
	, (@etcid, 30, '7', 'Vietnamese')
	, (@etcid, NULL, '8', 'Not applicable')
	, (@etcid, 14, '9', 'Portuguese')

select @ETCid=ExportTemplateColumnID
from CEM.ExportTemplateColumn  etc
where etc.ExportTemplateSectionID=@ETSid
and ExportColumnName='FOCALTYPE'

insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, RecodeValue, ResponseLabel)
values (@etcid, 1, '1', 'Primary care')
, (@etcid, 2, '2', 'Specialist')

select @ETCid=ExportTemplateColumnID
from CEM.ExportTemplateColumn  etc
where etc.ExportTemplateSectionID=@ETSid
and ExportColumnName='VERSION'

insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, RecodeValue, ResponseLabel)
values (@ETCid, 410, '12', 'ACO-12')
	, (@ETCid, 431, '12', 'ACO-12')
	, (@ETCid, 411, '12', 'ACO-12')
	, (@ETCid, 420, '12', 'ACO-12')
	, (@ETCid, 422, '12', 'ACO-12')
	, (@ETCid, 424, '12', 'ACO-12')
	, (@ETCid, 432, '12', 'ACO-12')
	, (@ETCid, 433, '12', 'ACO-12')
	, (@ETCid, 434, '12', 'ACO-12')
	, (@ETCid, 435, '12', 'ACO-12')
	, (@ETCid, 440, '88', 'beneficiary excluded from sample')

declare @DPid int, @DCid int
insert into cem.DispositionProcess (RecodeValue, DispositionActionID) values (' ',1)
set @DPid=SCOPE_IDENTITY()

select @ETCid=ExportTemplateColumnID
from CEM.ExportTemplateColumn  etc
where etc.ExportTemplateSectionID=@ETSid
and ExportColumnName='DISPOSITN'

insert into cem.DispositionClause (DispositionProcessID,DispositionPhraseKey,ExportTemplateColumnID,OperatorID)
values (@DPid, 1, @ETCid, 12)
set @DCid=SCOPE_IDENTITY()

insert into cem.DispositionInList (DispositionClauseID, ListValue) values (@DCid, '10'), (@DCid, '31'), (@DCid, '34')

create table #ACO (qstncore int, qstnlabel varchar(200), val int, responselabel varchar(200), intorder int, aco12 bit, aco9 bit, ExportTemplateColumnDescription varchar(10), ETCid int)
insert into #ACO (	qstncore,	qstnlabel,	val,	responselabel,	intOrder,	aco12,	aco9,	ExportTemplateColumnDescription)
values 
  (	50175,	'CG6-A: Saw provider',	1,	'Yes',	1,	1,	1,	'Q01')
, (	50175,	'CG6-A: Saw provider',	2,	'No',	1,	1,	1,	'Q01')
, (	50176,	'CG6-A: Usual provider',	1,	'Yes',	2,	1,	1,	'Q02')
, (	50176,	'CG6-A: Usual provider',	2,	'No',	2,	1,	1,	'Q02')
, (	50177,	'CG6-A: Length of time going to this provider',	1,	'Less than 6 months',	3,	1,	1,	'Q03')
, (	50177,	'CG6-A: Length of time going to this provider',	2,	'At least 6 months but less than 1 year',	3,	1,	1,	'Q03')
, (	50177,	'CG6-A: Length of time going to this provider',	3,	'At least 1 year but less than 3 years',	3,	1,	1,	'Q03')
, (	50177,	'CG6-A: Length of time going to this provider',	4,	'At least 3 years but less than 5 years',	3,	1,	1,	'Q03')
, (	50177,	'CG6-A: Length of time going to this provider',	5,	'5 years or more',	3,	1,	1,	'Q03')
, (	51426,	'CG6-A: Number of times visited this provider',	0,	'None',	4,	1,	1,	'Q04')
, (	51426,	'CG6-A: Number of times visited this provider',	1,	'1 time',	4,	1,	1,	'Q04')
, (	51426,	'CG6-A: Number of times visited this provider',	2,	'2',	4,	1,	1,	'Q04')
, (	51426,	'CG6-A: Number of times visited this provider',	3,	'3',	4,	1,	1,	'Q04')
, (	51426,	'CG6-A: Number of times visited this provider',	4,	'4',	4,	1,	1,	'Q04')
, (	51426,	'CG6-A: Number of times visited this provider',	5,	'5 to 9',	4,	1,	1,	'Q04')
, (	51426,	'CG6-A: Number of times visited this provider',	6,	'10 or more times',	4,	1,	1,	'Q04')
, (	53421,	'CG6-A Called office for urgent care',	1,	'Yes',	5,	1,	1,	'Q05')
, (	53421,	'CG6-A Called office for urgent care',	2,	'No',	5,	1,	1,	'Q05')
, (	53422,	'CG6-A: Got urgent care appt when needed',	1,	'Never',	6,	1,	1,	'Q06')
, (	53422,	'CG6-A: Got urgent care appt when needed',	2,	'Sometimes',	6,	1,	1,	'Q06')
, (	53422,	'CG6-A: Got urgent care appt when needed',	3,	'Usually',	6,	1,	1,	'Q06')
, (	53422,	'CG6-A: Got urgent care appt when needed',	4,	'Always',	6,	1,	1,	'Q06')
, (	50181,	'CG6-A: Made appts for routine care',	1,	'Yes',	7,	1,	1,	'Q07')
, (	50181,	'CG6-A: Made appts for routine care',	2,	'No',	7,	1,	1,	'Q07')
, (	50182,	'CG6-A: Got appt for check-up/routine care when needed',	1,	'Never',	8,	1,	1,	'Q08')
, (	50182,	'CG6-A: Got appt for check-up/routine care when needed',	2,	'Sometimes',	8,	1,	1,	'Q08')
, (	50182,	'CG6-A: Got appt for check-up/routine care when needed',	3,	'Usually',	8,	1,	1,	'Q08')
, (	50182,	'CG6-A: Got appt for check-up/routine care when needed',	4,	'Always',	8,	1,	1,	'Q08')
, (	53423,	'CG6-A: Called office with question during office hours',	1,	'Yes',	9,	1,	1,	'Q09')
, (	53423,	'CG6-A: Called office with question during office hours',	2,	'No',	9,	1,	1,	'Q09')
, (	53424,	'CG6-A: Got answer to medical questions same day',	1,	'Never',	10,	1,	1,	'Q10')
, (	53424,	'CG6-A: Got answer to medical questions same day',	2,	'Sometimes',	10,	1,	1,	'Q10')
, (	53424,	'CG6-A: Got answer to medical questions same day',	3,	'Usually',	10,	1,	1,	'Q10')
, (	53424,	'CG6-A: Got answer to medical questions same day',	4,	'Always',	10,	1,	1,	'Q10')
, (	50185,	'CG6-A: Called office with question after hours',	1,	'Yes',	11,	1,	1,	'Q11')
, (	50185,	'CG6-A: Called office with question after hours',	2,	'No',	11,	1,	1,	'Q11')
, (	53427,	'CG6-A: Got answer to medical questions after hours',	1,	'Never',	12,	1,	1,	'Q12')
, (	53427,	'CG6-A: Got answer to medical questions after hours',	2,	'Sometimes',	12,	1,	1,	'Q12')
, (	53427,	'CG6-A: Got answer to medical questions after hours',	3,	'Usually',	12,	1,	1,	'Q12')
, (	53427,	'CG6-A: Got answer to medical questions after hours',	4,	'Always',	12,	1,	1,	'Q12')
, (	50187,	'CG6-A: Got reminders from provider''s office between visits',	1,	'Yes',	13,	1,	0,	'Q13')
, (	50187,	'CG6-A: Got reminders from provider''s office between visits',	2,	'No',	13,	1,	0,	'Q13')
, (	50188,	'CG6-A: Received reminder appt',	1,	'Yes',	14,	1,	0,	'Q14')
, (	50188,	'CG6-A: Received reminder appt',	2,	'No',	14,	1,	0,	'Q14')
, (	53428,	'CG6-A: Saw provider within 15 minutes of appt time',	1,	'Never',	15,	1,	1,	'Q15')
, (	53428,	'CG6-A: Saw provider within 15 minutes of appt time',	2,	'Sometimes',	15,	1,	1,	'Q15')
, (	53428,	'CG6-A: Saw provider within 15 minutes of appt time',	3,	'Usually',	15,	1,	1,	'Q15')
, (	53428,	'CG6-A: Saw provider within 15 minutes of appt time',	4,	'Always',	15,	1,	1,	'Q15')
, (	50190,	'CG6-A: Provider explained things understandably',	1,	'Never',	16,	1,	1,	'Q16')
, (	50190,	'CG6-A: Provider explained things understandably',	2,	'Sometimes',	16,	1,	1,	'Q16')
, (	50190,	'CG6-A: Provider explained things understandably',	3,	'Usually',	16,	1,	1,	'Q16')
, (	50190,	'CG6-A: Provider explained things understandably',	4,	'Always',	16,	1,	1,	'Q16')
, (	50191,	'CG6-A: Provider listened carefully',	1,	'Never',	17,	1,	1,	'Q17')
, (	50191,	'CG6-A: Provider listened carefully',	2,	'Sometimes',	17,	1,	1,	'Q17')
, (	50191,	'CG6-A: Provider listened carefully',	3,	'Usually',	17,	1,	1,	'Q17')
, (	50191,	'CG6-A: Provider listened carefully',	4,	'Always',	17,	1,	1,	'Q17')
, (	50192,	'CG6-A: Talked with provider re: health question/concern',	1,	'Yes',	18,	1,	1,	'Q18')
, (	50192,	'CG6-A: Talked with provider re: health question/concern',	2,	'No',	18,	1,	1,	'Q18')
, (	53429,	'CG6-A: Easy to understand instructions about care',	1,	'Never',	19,	1,	1,	'Q19')
, (	53429,	'CG6-A: Easy to understand instructions about care',	2,	'Sometimes',	19,	1,	1,	'Q19')
, (	53429,	'CG6-A: Easy to understand instructions about care',	3,	'Usually',	19,	1,	1,	'Q19')
, (	53429,	'CG6-A: Easy to understand instructions about care',	4,	'Always',	19,	1,	1,	'Q19')
, (	53425,	'CG6-A: Provider knew important info about medical history',	1,	'Never',	20,	1,	1,	'Q20')
, (	53425,	'CG6-A: Provider knew important info about medical history',	2,	'Sometimes',	20,	1,	1,	'Q20')
, (	53425,	'CG6-A: Provider knew important info about medical history',	3,	'Usually',	20,	1,	1,	'Q20')
, (	53425,	'CG6-A: Provider knew important info about medical history',	4,	'Always',	20,	1,	1,	'Q20')
, (	50195,	'CG6-A: Provider knew medical history',	1,	'Never',	21,	1,	0,	'Q21')
, (	50195,	'CG6-A: Provider knew medical history',	2,	'Sometimes',	21,	1,	0,	'Q21')
, (	50195,	'CG6-A: Provider knew medical history',	3,	'Usually',	21,	1,	0,	'Q21')
, (	50195,	'CG6-A: Provider knew medical history',	4,	'Always',	21,	1,	0,	'Q21')
, (	50196,	'CG6-A: Provider showed respect for what patient said',	1,	'Never',	22,	1,	1,	'Q22')
, (	50196,	'CG6-A: Provider showed respect for what patient said',	2,	'Sometimes',	22,	1,	1,	'Q22')
, (	50196,	'CG6-A: Provider showed respect for what patient said',	3,	'Usually',	22,	1,	1,	'Q22')
, (	50196,	'CG6-A: Provider showed respect for what patient said',	4,	'Always',	22,	1,	1,	'Q22')
, (	50197,	'CG6-A: Provider spent enough time with patient',	1,	'Never',	23,	1,	1,	'Q23')
, (	50197,	'CG6-A: Provider spent enough time with patient',	2,	'Sometimes',	23,	1,	1,	'Q23')
, (	50197,	'CG6-A: Provider spent enough time with patient',	3,	'Usually',	23,	1,	1,	'Q23')
, (	50197,	'CG6-A: Provider spent enough time with patient',	4,	'Always',	23,	1,	1,	'Q23')
, (	50198,	'CG6-A: Provider ordered test',	1,	'Yes',	24,	1,	1,	'Q24')
, (	50198,	'CG6-A: Provider ordered test',	2,	'No',	24,	1,	1,	'Q24')
, (	50199,	'CG6-A: Office followed up with results',	1,	'Never',	25,	1,	1,	'Q25')
, (	50199,	'CG6-A: Office followed up with results',	2,	'Sometimes',	25,	1,	1,	'Q25')
, (	50199,	'CG6-A: Office followed up with results',	3,	'Usually',	25,	1,	1,	'Q25')
, (	50199,	'CG6-A: Office followed up with results',	4,	'Always',	25,	1,	1,	'Q25')
, (	50200,	'CG6-A: Provider discussed starting/stopping meds',	1,	'Yes',	26,	1,	1,	'Q26')
, (	50200,	'CG6-A: Provider discussed starting/stopping meds',	2,	'No',	26,	1,	1,	'Q26')
, (	50201,	'CG6-A: Provider discussed reasons to take meds',	1,	'Yes',	27,	1,	1,	'Q27')
, (	50201,	'CG6-A: Provider discussed reasons to take meds',	2,	'No',	27,	1,	1,	'Q27')
, (	50202,	'CG6-A: Provider discussed reasons not to take meds',	1,	'Yes',	28,	1,	1,	'Q28')
, (	50202,	'CG6-A: Provider discussed reasons not to take meds',	2,	'No',	28,	1,	1,	'Q28')
, (	50203,	'CG6-A: Provider asked about patient''s opinion of meds',	1,	'Yes',	29,	1,	1,	'Q29')
, (	50203,	'CG6-A: Provider asked about patient''s opinion of meds',	2,	'No',	29,	1,	1,	'Q29')
, (	50204,	'CG6-A: Started a prescription med',	1,	'Yes',	30,	1,	0,	'Q30')
, (	50204,	'CG6-A: Started a prescription med',	2,	'No',	30,	1,	0,	'Q30')
, (	50205,	'CG6-A: Easy to understand instructions about meds',	1,	'Never',	31,	1,	0,	'Q31')
, (	50205,	'CG6-A: Easy to understand instructions about meds',	2,	'Sometimes',	31,	1,	0,	'Q31')
, (	50205,	'CG6-A: Easy to understand instructions about meds',	3,	'Usually',	31,	1,	0,	'Q31')
, (	50205,	'CG6-A: Easy to understand instructions about meds',	4,	'Always',	31,	1,	0,	'Q31')
, (	50206,	'CG6-A: Provider gave written info about how to take meds',	1,	'Yes',	32,	1,	0,	'Q32')
, (	50206,	'CG6-A: Provider gave written info about how to take meds',	2,	'No',	32,	1,	0,	'Q32')
, (	50207,	'CG6-A: Written info about how to take meds understandable',	1,	'Yes',	33,	1,	0,	'Q33')
, (	50207,	'CG6-A: Written info about how to take meds understandable',	2,	'No',	33,	1,	0,	'Q33')
, (	50208,	'CG6-A: Provider suggested ways to remember to take meds',	1,	'Yes',	34,	1,	0,	'Q34')
, (	50208,	'CG6-A: Provider suggested ways to remember to take meds',	2,	'No',	34,	1,	0,	'Q34')
, (	50209,	'CG6-A: Provider dicussed surgery or procedure',	1,	'Yes',	35,	1,	1,	'Q35')
, (	50209,	'CG6-A: Provider dicussed surgery or procedure',	2,	'No',	35,	1,	1,	'Q35')
, (	50210,	'CG6-A: Provider discussed reasons to have surgery',	1,	'Yes',	36,	1,	1,	'Q36')
, (	50210,	'CG6-A: Provider discussed reasons to have surgery',	2,	'No',	36,	1,	1,	'Q36')
, (	50211,	'CG6-A: Provider discussed reasons not to have surgery',	1,	'Yes',	37,	1,	1,	'Q37')
, (	50211,	'CG6-A: Provider discussed reasons not to have surgery',	2,	'No',	37,	1,	1,	'Q37')
, (	50212,	'CG6-A: Provider asked about patient''s opinion of surgery',	1,	'Yes',	38,	1,	1,	'Q38')
, (	50212,	'CG6-A: Provider asked about patient''s opinion of surgery',	2,	'No',	38,	1,	1,	'Q38')
, (	50213,	'CG6-A: Provider discussed sharing health info w/family',	1,	'Yes',	39,	1,	1,	'Q39')
, (	50213,	'CG6-A: Provider discussed sharing health info w/family',	2,	'No',	39,	1,	1,	'Q39')
, (	50214,	'CG6-A: Provider respected wishes about sharing info w/family',	1,	'Yes',	40,	1,	1,	'Q40')
, (	50214,	'CG6-A: Provider respected wishes about sharing info w/family',	2,	'No',	40,	1,	1,	'Q40')
, (	50215,	'CG6-A: Rate Provider',	0,	'0    Worst provider possible',	41,	1,	1,	'Q41')
, (	50215,	'CG6-A: Rate Provider',	1,	'1',	41,	1,	1,	'Q41')
, (	50215,	'CG6-A: Rate Provider',	2,	'2',	41,	1,	1,	'Q41')
, (	50215,	'CG6-A: Rate Provider',	3,	'3',	41,	1,	1,	'Q41')
, (	50215,	'CG6-A: Rate Provider',	4,	'4',	41,	1,	1,	'Q41')
, (	50215,	'CG6-A: Rate Provider',	5,	'5',	41,	1,	1,	'Q41')
, (	50215,	'CG6-A: Rate Provider',	6,	'6',	41,	1,	1,	'Q41')
, (	50215,	'CG6-A: Rate Provider',	7,	'7',	41,	1,	1,	'Q41')
, (	50215,	'CG6-A: Rate Provider',	8,	'8',	41,	1,	1,	'Q41')
, (	50215,	'CG6-A: Rate Provider',	9,	'9',	41,	1,	1,	'Q41')
, (	50215,	'CG6-A: Rate Provider',	10,	'10 Best provider possible',	41,	1,	1,	'Q41')
, (	50216,	'CG6-A: Clerks/receptionists helpful',	1,	'Never',	42,	1,	1,	'Q42')
, (	50216,	'CG6-A: Clerks/receptionists helpful',	2,	'Sometimes',	42,	1,	1,	'Q42')
, (	50216,	'CG6-A: Clerks/receptionists helpful',	3,	'Usually',	42,	1,	1,	'Q42')
, (	50216,	'CG6-A: Clerks/receptionists helpful',	4,	'Always',	42,	1,	1,	'Q42')
, (	50217,	'CG6-A: Clerks/receptionists courtesy/respect',	1,	'Never',	43,	1,	1,	'Q43')
, (	50217,	'CG6-A: Clerks/receptionists courtesy/respect',	2,	'Sometimes',	43,	1,	1,	'Q43')
, (	50217,	'CG6-A: Clerks/receptionists courtesy/respect',	3,	'Usually',	43,	1,	1,	'Q43')
, (	50217,	'CG6-A: Clerks/receptionists courtesy/respect',	4,	'Always',	43,	1,	1,	'Q43')
, (	50218,	'CG6-A: Provider is specialist',	1,	'Yes',	44,	1,	1,	'Q44')
, (	50218,	'CG6-A: Provider is specialist',	2,	'No',	44,	1,	1,	'Q44')
, (	50219,	'CG6-A: Tried to make appt w/specialists',	1,	'Yes',	45,	1,	1,	'Q45')
, (	50219,	'CG6-A: Tried to make appt w/specialists',	2,	'No',	45,	1,	1,	'Q45')
, (	50220,	'CG6-A: Ease of making appt w/specialists',	1,	'Never',	46,	1,	1,	'Q46')
, (	50220,	'CG6-A: Ease of making appt w/specialists',	2,	'Sometimes',	46,	1,	1,	'Q46')
, (	50220,	'CG6-A: Ease of making appt w/specialists',	3,	'Usually',	46,	1,	1,	'Q46')
, (	50220,	'CG6-A: Ease of making appt w/specialists',	4,	'Always',	46,	1,	1,	'Q46')
, (	50221,	'CG6-A: Specialist knew medical history',	1,	'Never',	47,	1,	1,	'Q47')
, (	50221,	'CG6-A: Specialist knew medical history',	2,	'Sometimes',	47,	1,	1,	'Q47')
, (	50221,	'CG6-A: Specialist knew medical history',	3,	'Usually',	47,	1,	1,	'Q47')
, (	50221,	'CG6-A: Specialist knew medical history',	4,	'Always',	47,	1,	1,	'Q47')
, (	50222,	'CG6-A: Care team talked about things to prevent illness',	1,	'Yes',	48,	1,	1,	'Q48')
, (	50222,	'CG6-A: Care team talked about things to prevent illness',	2,	'No',	48,	1,	1,	'Q48')
, (	50223,	'CG6-A: Care team talked about healthy diet and eating habits',	1,	'Yes',	49,	1,	1,	'Q49')
, (	50223,	'CG6-A: Care team talked about healthy diet and eating habits',	2,	'No',	49,	1,	1,	'Q49')
, (	50224,	'CG6-A: Care team talked about exercise/physical activity',	1,	'Yes',	50,	1,	1,	'Q50')
, (	50224,	'CG6-A: Care team talked about exercise/physical activity',	2,	'No',	50,	1,	1,	'Q50')
, (	50225,	'CG6-A: Care team talked about specific goals for health',	1,	'Yes',	51,	1,	1,	'Q51')
, (	50225,	'CG6-A: Care team talked about specific goals for health',	2,	'No',	51,	1,	1,	'Q51')
, (	50226,	'CG6-A: Took prescription medicine',	1,	'Yes',	52,	1,	1,	'Q52')
, (	50226,	'CG6-A: Took prescription medicine',	2,	'No',	52,	1,	1,	'Q52')
, (	50227,	'CG6-A: Care team talked about all prescription meds',	1,	'Never',	53,	1,	0,	'Q53')
, (	50227,	'CG6-A: Care team talked about all prescription meds',	2,	'Sometimes',	53,	1,	0,	'Q53')
, (	50227,	'CG6-A: Care team talked about all prescription meds',	3,	'Usually',	53,	1,	0,	'Q53')
, (	50227,	'CG6-A: Care team talked about all prescription meds',	4,	'Always',	53,	1,	0,	'Q53')
, (	50228,	'CG6-A: Talked about cost of prescriptions',	1,	'Yes',	54,	1,	1,	'Q54')
, (	50228,	'CG6-A: Talked about cost of prescriptions',	2,	'No',	54,	1,	1,	'Q54')
, (	50229,	'CG6-A: Care team asked if felt sad, empty or depressed',	1,	'Yes',	55,	1,	1,	'Q55')
, (	50229,	'CG6-A: Care team asked if felt sad, empty or depressed',	2,	'No',	55,	1,	1,	'Q55')
, (	50230,	'CG6-A: Care team talked about things that worry/cause stress',	1,	'Yes',	56,	1,	1,	'Q56')
, (	50230,	'CG6-A: Care team talked about things that worry/cause stress',	2,	'No',	56,	1,	1,	'Q56')
, (	50234,	'CG6-A: Rate health',	1,	'Excellent',	57,	1,	1,	'Q57')
, (	50234,	'CG6-A: Rate health',	2,	'Very Good',	57,	1,	1,	'Q57')
, (	50234,	'CG6-A: Rate health',	3,	'Good',	57,	1,	1,	'Q57')
, (	50234,	'CG6-A: Rate health',	4,	'Fair',	57,	1,	1,	'Q57')
, (	50234,	'CG6-A: Rate health',	5,	'Poor',	57,	1,	1,	'Q57')
, (	50235,	'CG6-A: Rate mental/emotional health',	1,	'Excellent',	58,	1,	1,	'Q58')
, (	50235,	'CG6-A: Rate mental/emotional health',	2,	'Very Good',	58,	1,	1,	'Q58')
, (	50235,	'CG6-A: Rate mental/emotional health',	3,	'Good',	58,	1,	1,	'Q58')
, (	50235,	'CG6-A: Rate mental/emotional health',	4,	'Fair',	58,	1,	1,	'Q58')
, (	50235,	'CG6-A: Rate mental/emotional health',	5,	'Poor',	58,	1,	1,	'Q58')
, (	50236,	'CG6-A: Saw provider 3 or more times for same condition',	1,	'Yes',	59,	1,	1,	'Q59')
, (	50236,	'CG6-A: Saw provider 3 or more times for same condition',	2,	'No',	59,	1,	1,	'Q59')
, (	50237,	'CG6-A: Condition has lasted 3 months or more',	1,	'Yes',	60,	1,	1,	'Q60')
, (	50237,	'CG6-A: Condition has lasted 3 months or more',	2,	'No',	60,	1,	1,	'Q60')
, (	50238,	'CG6-A: Take prescription medicine',	1,	'Yes',	61,	1,	1,	'Q61')
, (	50238,	'CG6-A: Take prescription medicine',	2,	'No',	61,	1,	1,	'Q61')
, (	50239,	'CG6-A: Med for condition of 3 months or more',	1,	'Yes',	62,	1,	1,	'Q62')
, (	50239,	'CG6-A: Med for condition of 3 months or more',	2,	'No',	62,	1,	1,	'Q62')
, (	50240,	'CG6-A: Physical health interfered with social activities',	1,	'All of the time',	63,	1,	1,	'Q63')
, (	50240,	'CG6-A: Physical health interfered with social activities',	2,	'Most of the time',	63,	1,	1,	'Q63')
, (	50240,	'CG6-A: Physical health interfered with social activities',	3,	'Some of the time',	63,	1,	1,	'Q63')
, (	50240,	'CG6-A: Physical health interfered with social activities',	4,	'A little of the time',	63,	1,	1,	'Q63')
, (	50240,	'CG6-A: Physical health interfered with social activities',	5,	'None of the time',	63,	1,	1,	'Q63')
, (	50241,	'CG6-A: Age',	1,	'18 to 24',	64,	1,	1,	'Q64')
, (	50241,	'CG6-A: Age',	2,	'25 to 34',	64,	1,	1,	'Q64')
, (	50241,	'CG6-A: Age',	3,	'35 to 44',	64,	1,	1,	'Q64')
, (	50241,	'CG6-A: Age',	4,	'45 to 54',	64,	1,	1,	'Q64')
, (	50241,	'CG6-A: Age',	5,	'55 to 64',	64,	1,	1,	'Q64')
, (	50241,	'CG6-A: Age',	6,	'65 to 69',	64,	1,	1,	'Q64')
, (	50241,	'CG6-A: Age',	7,	'70 to 74',	64,	1,	1,	'Q64')
, (	50241,	'CG6-A: Age',	8,	'75 to 79',	64,	1,	1,	'Q64')
, (	50241,	'CG6-A: Age',	9,	'80 to 84',	64,	1,	1,	'Q64')
, (	50241,	'CG6-A: Age',	10,	'85 or older',	64,	1,	1,	'Q64')
, (	50699,	'CG6-A: Gender',	1,	'Male',	65,	1,	1,	'Q65')
, (	50699,	'CG6-A: Gender',	2,	'Female',	65,	1,	1,	'Q65')
, (	50243,	'CG6-A: Education level',	1,	'8th grade or less',	66,	1,	1,	'Q66')
, (	50243,	'CG6-A: Education level',	2,	'Some high school, but did not graduate',	66,	1,	1,	'Q66')
, (	50243,	'CG6-A: Education level',	3,	'High school graduate or GED',	66,	1,	1,	'Q66')
, (	50243,	'CG6-A: Education level',	4,	'Some college or 2-year degree',	66,	1,	1,	'Q66')
, (	50243,	'CG6-A: Education level',	5,	'4-year college graduate',	66,	1,	1,	'Q66')
, (	50243,	'CG6-A: Education level',	6,	'More than 4-year college degree',	66,	1,	1,	'Q66')
, (	50700,	'CG6-A: English fluency',	1,	'Very well',	67,	1,	1,	'Q67')
, (	50700,	'CG6-A: English fluency',	2,	'Well',	67,	1,	1,	'Q67')
, (	50700,	'CG6-A: English fluency',	3,	'Not well',	67,	1,	1,	'Q67')
, (	50700,	'CG6-A: English fluency',	4,	'Not at all',	67,	1,	1,	'Q67')
, (	50245,	'CG6-A: Speak another language at home',	1,	'Yes',	68,	1,	1,	'Q68')
, (	50245,	'CG6-A: Speak another language at home',	2,	'No',	68,	1,	1,	'Q68')
, (	50246,	'CG6-A: Language spoken at home',	1,	'Spanish',	69,	1,	1,	'Q69')
, (	50246,	'CG6-A: Language spoken at home',	2,	'Chinese',	69,	1,	1,	'Q69')
, (	50246,	'CG6-A: Language spoken at home',	3,	'Korean',	69,	1,	1,	'Q69')
, (	50246,	'CG6-A: Language spoken at home',	4,	'Russian',	69,	1,	1,	'Q69')
, (	50246,	'CG6-A: Language spoken at home',	5,	'Vietnamese',	69,	1,	1,	'Q69')
, (	50246,	'CG6-A: Language spoken at home',	6,	'Some other language',	69,	1,	1,	'Q69')
, (	50247,	'CG6-A: Deaf or hearing impaired',	1,	'Yes',	70,	1,	1,	'Q70')
, (	50247,	'CG6-A: Deaf or hearing impaired',	2,	'No',	70,	1,	1,	'Q70')
, (	50248,	'CG6-A: Blind or vision imparied',	1,	'Yes',	71,	1,	1,	'Q71')
, (	50248,	'CG6-A: Blind or vision imparied',	2,	'No',	71,	1,	1,	'Q71')
, (	50249,	'CG6-A: Difficulty concentrating/remembering/making decisions',	1,	'Yes',	72,	1,	1,	'Q72')
, (	50249,	'CG6-A: Difficulty concentrating/remembering/making decisions',	2,	'No',	72,	1,	1,	'Q72')
, (	50250,	'CG6-A: Difficulty walking or climbing stairs',	1,	'Yes',	73,	1,	1,	'Q73')
, (	50250,	'CG6-A: Difficulty walking or climbing stairs',	2,	'No',	73,	1,	1,	'Q73')
, (	50251,	'CG6-A: Difficulty dressing or bathing',	1,	'Yes',	74,	1,	1,	'Q74')
, (	50251,	'CG6-A: Difficulty dressing or bathing',	2,	'No',	74,	1,	1,	'Q74')
, (	50252,	'CG6-A: Difficulty doing errands alone',	1,	'Yes',	75,	1,	1,	'Q75')
, (	50252,	'CG6-A: Difficulty doing errands alone',	2,	'No',	75,	1,	1,	'Q75')
, (	50253,	'CG6-A: Of Hispanic/Latino origin/descent',	1,	'Yes, Hispanic, Latino, or Spanish',	76,	1,	1,	'Q76')
, (	50253,	'CG6-A: Of Hispanic/Latino origin/descent',	2,	'No, not Hispanic, Latino, or Spanish',	76,	1,	1,	'Q76')
, (	50254,	'CG6-A: Type of Hispanic/Latino origin',	1,	'Mexican, Mexican American, Chicano',	77,	1,	1,	'Q77')
, (	50254,	'CG6-A: Type of Hispanic/Latino origin',	2,	'Puerto Rican',	77,	1,	1,	'Q77')
, (	50254,	'CG6-A: Type of Hispanic/Latino origin',	3,	'Cuban',	77,	1,	1,	'Q77')
, (	50254,	'CG6-A: Type of Hispanic/Latino origin',	4,	'Another Hispanic, Latino, or Spanish origin',	77,	1,	1,	'Q77')
, (	50725,	'CG6-A: Race-White (phone)',	1,	'Yes',	78,	1,	1,	'Q78a')
, (	50725,	'CG6-A: Race-White (phone)',	2,	'No',	78,	1,	1,	'Q78a')
, (	50726,	'CG6-A: Race-Black or African American (phone)',	1,	'Yes',	79,	1,	1,	'Q78b')
, (	50726,	'CG6-A: Race-Black or African American (phone)',	2,	'No',	79,	1,	1,	'Q78b')
, (	50727,	'CG6-A: Race-American Indian or Alaskan Native (phone)',	1,	'Yes',	80,	1,	1,	'Q78c')
, (	50727,	'CG6-A: Race-American Indian or Alaskan Native (phone)',	2,	'No',	80,	1,	1,	'Q78c')
, (	50728,	'CG6-A: Race-Asian (phone)',	1,	'Yes',	81,	1,	1,	'Q78d')
, (	50728,	'CG6-A: Race-Asian (phone)',	2,	'No',	81,	1,	1,	'Q78d')
, (	50729,	'CG6-A: Race-Asian Indian (phone)',	1,	'Yes',	82,	1,	1,	'Q78d1')
, (	50729,	'CG6-A: Race-Asian Indian (phone)',	2,	'No',	82,	1,	1,	'Q78d1')
, (	50730,	'CG6-A: Race-Chinese (phone)',	1,	'Yes',	83,	1,	1,	'Q78d2')
, (	50730,	'CG6-A: Race-Chinese (phone)',	2,	'No',	83,	1,	1,	'Q78d2')
, (	50731,	'CG6-A: Race-Filipino (phone)',	1,	'Yes',	84,	1,	1,	'Q78d3')
, (	50731,	'CG6-A: Race-Filipino (phone)',	2,	'No',	84,	1,	1,	'Q78d3')
, (	50732,	'CG6-A: Race-Japanese (phone)',	1,	'Yes',	85,	1,	1,	'Q78d4')
, (	50732,	'CG6-A: Race-Japanese (phone)',	2,	'No',	85,	1,	1,	'Q78d4')
, (	50733,	'CG6-A: Race-Korean (phone)',	1,	'Yes',	86,	1,	1,	'Q78d5')
, (	50733,	'CG6-A: Race-Korean (phone)',	2,	'No',	86,	1,	1,	'Q78d5')
, (	50734,	'CG6-A: Race-Vietnamese (phone)',	1,	'Yes',	87,	1,	1,	'Q78d6')
, (	50734,	'CG6-A: Race-Vietnamese (phone)',	2,	'No',	87,	1,	1,	'Q78d6')
, (	50735,	'CG6-A: Race-Another Asian race (phone)',	1,	'Yes',	88,	1,	1,	'Q78d7')
, (	50735,	'CG6-A: Race-Another Asian race (phone)',	2,	'No',	88,	1,	1,	'Q78d7')
, (	50736,	'CG6-A: Race-Native Hawaiian or Pacific Islander (phone)',	1,	'Yes',	89,	1,	1,	'Q78e')
, (	50736,	'CG6-A: Race-Native Hawaiian or Pacific Islander (phone)',	2,	'No',	89,	1,	1,	'Q78e')
, (	50737,	'CG6-A: Race- Native Hawaiian (phone)',	1,	'Yes',	90,	1,	1,	'Q78e1')
, (	50737,	'CG6-A: Race- Native Hawaiian (phone)',	2,	'No',	90,	1,	1,	'Q78e1')
, (	50738,	'CG6-A: Race-Guamanian or Chamorro (phone)',	1,	'Yes',	91,	1,	1,	'Q78e2')
, (	50738,	'CG6-A: Race-Guamanian or Chamorro (phone)',	2,	'No',	91,	1,	1,	'Q78e2')
, (	50739,	'CG6-A: Race-Samoan? (phone)',	1,	'Yes',	92,	1,	1,	'Q78e3')
, (	50739,	'CG6-A: Race-Samoan? (phone)',	2,	'No',	92,	1,	1,	'Q78e3')
, (	50740,	'CG6-A: Race-Other Pacific Islander (phone)',	1,	'Yes',	93,	1,	1,	'Q78e4')
, (	50740,	'CG6-A: Race-Other Pacific Islander (phone)',	2,	'No',	93,	1,	1,	'Q78e4')
, (	50256,	'CG6-A: Had help completing survey',	1,	'Yes',	94,	1,	1,	'Q79')
, (	50256,	'CG6-A: Had help completing survey',	2,	'No',	94,	1,	1,	'Q79')
, (	50744,	'CG6-A: Type of help completing survey',	1,	'Read the questions to me',	95,	1,	1,	'Q80a')
, (	50744,	'CG6-A: Type of help completing survey',	2,	'Wrote down the answers I gave',	95,	1,	1,	'Q80b')
, (	50744,	'CG6-A: Type of help completing survey',	3,	'Answered the questions for me',	95,	1,	1,	'Q80c')
, (	50744,	'CG6-A: Type of help completing survey',	4,	'Translated the questions into my language',	95,	1,	1,	'Q80d')
, (	50744,	'CG6-A: Type of help completing survey',	5,	'Helped in some other way Please print:',	95,	1,	1,	'Q80e')
, (	50255,	'CG6-A: Race',	1,	'White',	96,	1,	1,	'Q78a-mail')
, (	50255,	'CG6-A: Race',	2,	'Black or African American',	96,	1,	1,	'Q78b-mail')
, (	50255,	'CG6-A: Race',	3,	'American Indian or Alaska Native',	96,	1,	1,	'Q78c-mail')
, (	50255,	'CG6-A: Race',	4,	'Asian Indian',	96,	1,	1,	'Q78d1-mail')
, (	50255,	'CG6-A: Race',	5,	'Chinese',	96,	1,	1,	'Q78d2-mail')
, (	50255,	'CG6-A: Race',	6,	'Filipino',	96,	1,	1,	'Q78d3-mail')
, (	50255,	'CG6-A: Race',	7,	'Japanese',	96,	1,	1,	'Q78d4-mail')
, (	50255,	'CG6-A: Race',	8,	'Korean',	96,	1,	1,	'Q78d5-mail')
, (	50255,	'CG6-A: Race',	9,	'Vietnamese',	96,	1,	1,	'Q78d6-mail')
, (	50255,	'CG6-A: Race',	10,	'Other Asian',	96,	1,	1,	'Q78d7-mail')
, (	50255,	'CG6-A: Race',	11,	'Native Hawaiian',	96,	1,	1,	'Q78e1-mail')
, (	50255,	'CG6-A: Race',	12,	'Guamanian or Chamorro',	96,	1,	1,	'Q78e2-mail')
, (	50255,	'CG6-A: Race',	13,	'Samoan',	96,	1,	1,	'Q78e3-mail')
, (	50255,	'CG6-A: Race',	14,	'Other Pacific Islander',	96,	1,	1,	'Q78e4-mail')


insert into cem.ExportTemplateColumn (ExportTemplateSectionID, ExportTemplateColumnDescription, ColumnOrder, DatasourceID, ExportColumnName, SourceColumnName, SourceColumnType, AggregateFunction, DispositionProcessID, FixedWidthLength, ColumnSetKey, FormatID, MissingThresholdPercentage, CheckFrequencies)
select distinct @ETSid
	, case qstncore when 50744 then 'Q80' when 50255 then 'Q78' else ExportTemplateColumnDescription end as ExportTemplateColumnDescription
	, intorder+11 as ColumnOrder
	, 2 as DataSourceID
	, case when qstncore in (50744,50255) then null else ExportTemplateColumnDescription end as ExportColumnName
	, 'MasterQuestionCore='+convert(varchar,qstncore) as SourceColumnName
	, 56 as SourceColumnType
	, NULL as AggregateFunction
	, @DPid as DispositionProcessID
	, case qstncore when 50744 then 10 when 50255 then 28 else 2 end as FixedWidthLength
	, null as ColumnSetKey
	, null as FormatID
	, .95 as MissingThresholdPercentage
	, 0 as CheckFrequencies
from #aco
order by 2

update aco
set ETCid=ExportTemplateColumnID
from #ACO aco
inner join cem.ExportTemplateColumn etc on aco.intOrder+11=etc.ColumnOrder and etc.ExportTemplateSectionID=@ETSid

-- move the mail-race question to the support section. The post proc file will have to move the mail-race responses into the phone-race fields for proper submission.
update CEM.ExportTemplateColumn
set ColumnOrder=6
	, ExportTemplateSectionID=(select ExportTemplateSectionID from cem.ExportTemplateSection where ExportTemplateSectionName='support' and ExportTemplateID=@ETid)
where ExportTemplateColumnDescription='Q78'

insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, ExportColumnName, RecodeValue, ResponseLabel)
select ETCid
	, val as RawValue
	, case when qstncore in (50744,50255) then ExportTemplateColumnDescription end as ExportColumnName
	, right(' ' + convert(varchar,val),2) as RecodeValue 
	, ResponseLabel
from #aco
order by intorder

go
create procedure CEM.ExportPostProcess00000004
@ExportQueueID int
as
begin
	--move mail-race to phone-race
	-- CG6-A: Race-White
	update eds
	set [submission.Q78a]=case ltrim(rtrim([support.Q78a-mail])) when '1' then '1' when '0' then '2' when '' then '2' end 
	from CEM.ExportDataset00000004 eds
	where [submission.mode]='1' 
	and eds.ExportQueueID=@ExportQueueID 

	-- CG6-A: Race-Black or African American
	update eds
	set [submission.Q78b]=case ltrim(rtrim([support.Q78b-mail])) when '2' then '1' when '0' then '2' when '' then '2' end 
	from CEM.ExportDataset00000004 eds
	where [submission.mode]='1' 
	and eds.ExportQueueID=@ExportQueueID 

	-- CG6-A: Race-American Indian or Alaska Native
	update eds
	set [submission.Q78c]=case ltrim(rtrim([support.Q78c-mail])) when '3' then '1' when '0' then '2' when '' then '2' end 
	from CEM.ExportDataset00000004 eds
	where [submission.mode]='1' 
	and eds.ExportQueueID=@ExportQueueID 

	-- CG6-A: Race-Asian
	update eds
	set [submission.Q78d]='M'
	from CEM.ExportDataset00000004 eds
	where [submission.mode]='1' 
	and eds.ExportQueueID=@ExportQueueID 

	-- CG6-A: Race-Asian Indian
	update eds
	set [submission.Q78d1]=case ltrim(rtrim([support.Q78d1-mail])) when '4' then '1' when '0' then '2' when '' then '2' end 
	from CEM.ExportDataset00000004 eds
	where [submission.mode]='1' 
	and eds.ExportQueueID=@ExportQueueID 

	-- CG6-A: Race-Chinese
	update eds
	set [submission.Q78d2]=case ltrim(rtrim([support.Q78d2-mail])) when '5' then '1' when '0' then '2' when '' then '2' end 
	from CEM.ExportDataset00000004 eds
	where [submission.mode]='1' 
	and eds.ExportQueueID=@ExportQueueID 

	-- CG6-A: Race-Filipino
	update eds
	set [submission.Q78d3]=case ltrim(rtrim([support.Q78d3-mail])) when '6' then '1' when '0' then '2' when '' then '2' end 
	from CEM.ExportDataset00000004 eds
	where [submission.mode]='1' 
	and eds.ExportQueueID=@ExportQueueID 

	-- CG6-A: Race-Japanese
	update eds
	set [submission.Q78d4]=case ltrim(rtrim([support.Q78d4-mail])) when '7' then '1' when '0' then '2' when '' then '2' end 
	from CEM.ExportDataset00000004 eds
	where [submission.mode]='1' 
	and eds.ExportQueueID=@ExportQueueID 

	-- CG6-A: Race-Korean
	update eds
	set [submission.Q78d5]=case ltrim(rtrim([support.Q78d5-mail])) when '8' then '1' when '0' then '2' when '' then '2' end 
	from CEM.ExportDataset00000004 eds
	where [submission.mode]='1' 
	and eds.ExportQueueID=@ExportQueueID 

	-- CG6-A: Race-Vietnamese
	update eds
	set [submission.Q78d6]=case ltrim(rtrim([support.Q78d6-mail])) when '9' then '1' when '0' then '2' when '' then '2' end 
	from CEM.ExportDataset00000004 eds
	where [submission.mode]='1' 
	and eds.ExportQueueID=@ExportQueueID 

	-- CG6-A: Race-Other Asian
	update eds
	set [submission.Q78d7]=case ltrim(rtrim([support.Q78d7-mail])) when '10' then '1' when '0' then '2' when '' then '2' end 
	from CEM.ExportDataset00000004 eds
	where [submission.mode]='1' 
	and eds.ExportQueueID=@ExportQueueID 

	-- CG6-A: Race-Native Hawaiian or Pacific Islander
	update eds
	set [submission.Q78e]='M'
	from CEM.ExportDataset00000004 eds
	where [submission.mode]='1' 
	and eds.ExportQueueID=@ExportQueueID 

	-- CG6-A: Race-Native Hawaiian
	update eds
	set [submission.Q78e1]=case ltrim(rtrim([support.Q78e1-mail])) when '11' then '1' when '0' then '2' when '' then '2' end 
	from CEM.ExportDataset00000004 eds
	where [submission.mode]='1' 
	and eds.ExportQueueID=@ExportQueueID 

	-- CG6-A: Race-Guamanian or Chamorro
	update eds
	set [submission.Q78e2]=case ltrim(rtrim([support.Q78e2-mail])) when '12' then '1' when '0' then '2' when '' then '2' end 
	from CEM.ExportDataset00000004 eds
	where [submission.mode]='1' 
	and eds.ExportQueueID=@ExportQueueID 

	-- CG6-A: Race-Samoan
	update eds
	set [submission.Q78e3]=case ltrim(rtrim([support.Q78e3-mail])) when '13' then '1' when '0' then '2' when '' then '2' end 
	from CEM.ExportDataset00000004 eds
	where [submission.mode]='1' 
	and eds.ExportQueueID=@ExportQueueID 

	-- CG6-A: Race-Other Pacific Islander
	update eds
	set [submission.Q78e4]=case ltrim(rtrim([support.Q78e4-mail])) when '14' then '1' when '0' then '2' when '' then '2' end 
	from CEM.ExportDataset00000004 eds
	where [submission.mode]='1' 
	and eds.ExportQueueID=@ExportQueueID 

	--skips and shit
	declare @QList table (Qnmbr varchar(10), Qlabel varchar(100), intOrder int, ACO12 bit, ACO9 bit)
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q01', 	1	, 1, 1, 'CG6-A: Saw provider')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q02', 	2	, 1, 1, 'CG6-A: Usual provider')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q03', 	3	, 1, 1, 'CG6-A: Length of time going to this provider')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q04', 	4	, 1, 1, 'CG6-A: Number of times visited this provider')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q05', 	5	, 1, 1, 'CG6-A Called office for urgent care')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q06', 	6	, 1, 1, 'CG6-A: Got urgent care appt when needed')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q07', 	7	, 1, 1, 'CG6-A: Made appts for routine care')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q08', 	8	, 1, 1, 'CG6-A: Got appt for check-up/routine care when needed')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q09', 	9	, 1, 1, 'CG6-A: Called office with question during office hours')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q10', 	10	, 1, 1, 'CG6-A: Got answer to medical questions same day')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q11', 	11	, 1, 1, 'CG6-A: Called office with question after hours')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q12', 	12	, 1, 1, 'CG6-A: Got answer to medical questions after hours')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q13', 	13	, 1, 0, 'CG6-A: Got reminders from provider''s office between visits')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q14', 	14	, 1, 0, 'CG6-A: Received reminder appt')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q15', 	15	, 1, 1, 'CG6-A: Saw provider within 15 minutes of appt time')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q16', 	16	, 1, 1, 'CG6-A: Provider explained things understandably')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q17', 	17	, 1, 1, 'CG6-A: Provider listened carefully')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q18', 	18	, 1, 1, 'CG6-A: Talked with provider re: health question/concern')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q19', 	19	, 1, 1, 'CG6-A: Easy to understand instructions about care')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q20', 	20	, 1, 1, 'CG6-A: Provider knew important info about medical history')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q21', 	21	, 1, 0, 'CG6-A: Provider knew medical history')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q22', 	22	, 1, 1, 'CG6-A: Provider showed respect for what patient said')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q23', 	23	, 1, 1, 'CG6-A: Provider spent enough time with patient')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q24', 	24	, 1, 1, 'CG6-A: Provider ordered test')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q25', 	25	, 1, 1, 'CG6-A: Office followed up with results')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q26', 	26	, 1, 1, 'CG6-A: Provider discussed starting/stopping meds')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q27', 	27	, 1, 1, 'CG6-A: Provider discussed reasons to take meds')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q28', 	28	, 1, 1, 'CG6-A: Provider discussed reasons not to take meds')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q29', 	29	, 1, 1, 'CG6-A: Provider asked about patient''s opinion of meds')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q30', 	30	, 1, 0, 'CG6-A: Started a prescription med')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q31', 	31	, 1, 0, 'CG6-A: Easy to understand instructions about meds')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q32', 	32	, 1, 0, 'CG6-A: Provider gave written info about how to take meds')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q33', 	33	, 1, 0, 'CG6-A: Written info about how to take meds understandable')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q34', 	34	, 1, 0, 'CG6-A: Provider suggested ways to remember to take meds')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q35', 	35	, 1, 1, 'CG6-A: Provider dicussed surgery or procedure')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q36', 	36	, 1, 1, 'CG6-A: Provider discussed reasons to have surgery')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q37', 	37	, 1, 1, 'CG6-A: Provider discussed reasons not to have surgery')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q38', 	38	, 1, 1, 'CG6-A: Provider asked about patient''s opinion of surgery')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q39', 	39	, 1, 1, 'CG6-A: Provider discussed sharing health info w/family')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q40', 	40	, 1, 1, 'CG6-A: Provider respected wishes about sharing info w/family')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q41', 	41	, 1, 1, 'CG6-A: Rate Provider')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q42', 	42	, 1, 1, 'CG6-A: Clerks/receptionists helpful')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q43', 	43	, 1, 1, 'CG6-A: Clerks/receptionists courtesy/respect')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q44', 	44	, 1, 1, 'CG6-A: Provider is specialist')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q45', 	45	, 1, 1, 'CG6-A: Tried to make appt w/specialists')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q46', 	46	, 1, 1, 'CG6-A: Ease of making appt w/specialists')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q47', 	47	, 1, 1, 'CG6-A: Specialist knew medical history')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q48', 	48	, 1, 1, 'CG6-A: Care team talked about things to prevent illness')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q49', 	49	, 1, 1, 'CG6-A: Care team talked about healthy diet and eating habits')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q50', 	50	, 1, 1, 'CG6-A: Care team talked about exercise/physical activity')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q51', 	51	, 1, 1, 'CG6-A: Care team talked about specific goals for health')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q52', 	52	, 1, 1, 'CG6-A: Took prescription medicine')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q53', 	53	, 1, 0, 'CG6-A: Care team talked about all prescription meds')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q54', 	54	, 1, 1, 'CG6-A: Talked about cost of prescriptions')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q55', 	55	, 1, 1, 'CG6-A: Care team asked if felt sad, empty or depressed')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q56', 	56	, 1, 1, 'CG6-A: Care team talked about things that worry/cause stress')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q57', 	57	, 1, 1, 'CG6-A: Rate health')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q58', 	58	, 1, 1, 'CG6-A: Rate mental/emotional health')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q59', 	59	, 1, 1, 'CG6-A: Saw provider 3 or more times for same condition')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q60', 	60	, 1, 1, 'CG6-A: Condition has lasted 3 months or more')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q61', 	61	, 1, 1, 'CG6-A: Take prescription medicine')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q62', 	62	, 1, 1, 'CG6-A: Med for condition of 3 months or more')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q63', 	63	, 1, 1, 'CG6-A: Physical health interfered with social activities')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q64', 	64	, 1, 1, 'CG6-A: Age')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q65', 	65	, 1, 1, 'CG6-A: Gender')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q66', 	66	, 1, 1, 'CG6-A: Education level')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q67', 	67	, 1, 1, 'CG6-A: English fluency')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q68', 	68	, 1, 1, 'CG6-A: Speak another language at home')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q69', 	69	, 1, 1, 'CG6-A: Language spoken at home')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q70', 	70	, 1, 1, 'CG6-A: Deaf or hearing impaired')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q71', 	71	, 1, 1, 'CG6-A: Blind or vision imparied')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q72', 	72	, 1, 1, 'CG6-A: Difficulty concentrating/remembering/making decisions')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q73', 	73	, 1, 1, 'CG6-A: Difficulty walking or climbing stairs')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q74', 	74	, 1, 1, 'CG6-A: Difficulty dressing or bathing')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q75', 	75	, 1, 1, 'CG6-A: Difficulty doing errands alone')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q76', 	76	, 1, 1, 'CG6-A: Of Hispanic/Latino origin/descent')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q77', 	77	, 1, 1, 'CG6-A: Type of Hispanic/Latino origin')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78a', 	78	, 1, 1, 'CG6-A: Race-White (phone)')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78b', 	79	, 1, 1, 'CG6-A: Race-Black or African American (phone)')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78c', 	80	, 1, 1, 'CG6-A: Race-American Indian or Alaskan Native (phone)')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78d', 	81	, 1, 1, 'CG6-A: Race-Asian (phone)')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78d1', 	82	, 1, 1, 'CG6-A: Race-Asian Indian (phone)')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78d2', 	83	, 1, 1, 'CG6-A: Race-Chinese (phone)')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78d3', 	84	, 1, 1, 'CG6-A: Race-Filipino (phone)')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78d4', 	85	, 1, 1, 'CG6-A: Race-Japanese (phone)')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78d5', 	86	, 1, 1, 'CG6-A: Race-Korean (phone)')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78d6', 	87	, 1, 1, 'CG6-A: Race-Vietnamese (phone)')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78d7', 	88	, 1, 1, 'CG6-A: Race-Another Asian race (phone)')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78e', 	89	, 1, 1, 'CG6-A: Race-Native Hawaiian or Pacific Islander (phone)')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78e1', 	90	, 1, 1, 'CG6-A: Race- Native Hawaiian (phone)')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78e2', 	91	, 1, 1, 'CG6-A: Race-Guamanian or Chamorro (phone)')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78e3', 	92	, 1, 1, 'CG6-A: Race-Samoan? (phone)')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78e4', 	93	, 1, 1, 'CG6-A: Race-Other Pacific Islander (phone)')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q79', 	94	, 1, 1, 'CG6-A: Had help completing survey')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q80a', 	95	, 1, 1, 'CG6-A: Type of help completing survey')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q80b', 	95	, 1, 1, 'CG6-A: Type of help completing survey')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q80c', 	95	, 1, 1, 'CG6-A: Type of help completing survey')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q80d', 	95	, 1, 1, 'CG6-A: Type of help completing survey')
	insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q80e', 	95	, 1, 1, 'CG6-A: Type of help completing survey')
	--insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78a-mail', 	96	, 1, 1, 'CG6-A: Race')
	--insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78b-mail', 	96	, 1, 1, 'CG6-A: Race')
	--insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78c-mail', 	96	, 1, 1, 'CG6-A: Race')
	--insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78d1-mail', 	96	, 1, 1, 'CG6-A: Race')
	--insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78d2-mail', 	96	, 1, 1, 'CG6-A: Race')
	--insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78d3-mail', 	96	, 1, 1, 'CG6-A: Race')
	--insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78d4-mail', 	96	, 1, 1, 'CG6-A: Race')
	--insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78d5-mail', 	96	, 1, 1, 'CG6-A: Race')
	--insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78d6-mail', 	96	, 1, 1, 'CG6-A: Race')
	--insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78d7-mail', 	96	, 1, 1, 'CG6-A: Race')
	--insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78e1-mail', 	96	, 1, 1, 'CG6-A: Race')
	--insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78e2-mail', 	96	, 1, 1, 'CG6-A: Race')
	--insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78e3-mail', 	96	, 1, 1, 'CG6-A: Race')
	--insert into @QList (QNmbr, intOrder, ACO12, ACO9, QLabel) values ('Q78e4-mail', 	96	, 1, 1, 'CG6-A: Race')

	declare @skips table (skip_id int identity(1,1), Gateway varchar(10), triggerresponses varchar(10), SkipTo varchar(10), flag tinyint)
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q01',	'2,98,99',	'Q44')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q04',	'0'      ,	'Q44')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q05',	'2,98,99',	'Q07')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q07',	'2,98,99',	'Q09')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q09',	'2,98,99',	'Q11')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q11',	'2,98,99',	'Q13')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q13',	'2,98,99',	'Q15')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q18',	'2,98,99',	'Q20')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q24',	'2,98,99',	'Q26')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q26',	'2,98,99',	'Q35')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q30',	'2,98,99',	'Q35')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q32',	'2,98,99',	'Q34')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q35',	'2,98,99',	'Q39')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q44',	'1'      ,	'Q48')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q45',	'2,98,99',	'Q48')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q52',	'2,98,99',	'Q55')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q59',	'2,98,99',	'Q61')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q61',	'2,98,99',	'Q63')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q68',	'2,98,99',	'Q70')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q76',	'2,98,99',	'Q78a')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q78d',	'2,98,99',	'Q78e')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q78e',	'2,98,99',	'Q79')
	insert into @skips (Gateway, TriggerResponses, SkipTo) values ('Q79',	'2,98,99',	'Q999')

	update @skips set flag=0
	update @skips set flag=1 where gateway in (select qnmbr from @QList where aco12=0)

	declare @sql varchar(max), @gateway varchar(10), @TR varchar(10)
	select top 1 @gateway=gateway, @tr=triggerresponses
	from @skips
	where flag=0
	order by gateway desc

	-- pattern:
	-- update CEM.ExportDataset00000004 set [skippedquestion]='88' where ltrim(rtrim([gatewayquestion])) in (triggerResponses) and ltrim(rtrim([skippedquestion])) = 'M'

	while @@rowcount>0
	begin
		set @sql = ''
		select @sql=@sql + 'update CEM.ExportDataset00000004 set [submission.'+ql.qnmbr+']=''88'' where ltrim(rtrim([submission.'+@gateway+'])) in ('''+replace(@TR,',',''',''')+''') and ltrim(rtrim([submission.'+ql.qnmbr+'])) = ''M'' and ExportQueueID='+convert(varchar,@ExportQueueID) + char(10)
		from @skips s
		inner join @QList ql on ql.qnmbr>s.gateway and ql.qnmbr<s.skipto
		where gateway=@gateway
		and ql.aco12=1

		print @SQL
		exec (@SQL)

		update @skips set flag=1 where gateway=@gateway
		select top 1 @gateway=gateway, @tr=triggerresponses
		from @skips
		where flag=0
		order by gateway desc
	end
end
go

-- copy ACO-12 to ACO-9
exec [CEM].[CopyExportTemplate] 4

declare @newTemplateID int
select @newTemplateID = max(exporttemplateid) from cem.ExportTemplate

update cem.exporttemplate 
set ExportTemplateVersionMajor='ACO-9', DefaultNamingConvention=replace(DefaultNamingConvention,'ACO12','ACO9')
where ExportTemplateID=@newTemplateID 

update cem.exporttemplatesection 
set DefaultNamingConvention=replace(DefaultNamingConvention,'ACO12','ACO9')  
where ExportTemplateID=@newTemplateID 

delete etcr
from cem.ExportTemplateColumnResponse etcr
inner join cem.ExportTemplateColumn etc on etcr.ExportTemplateColumnID=etc.ExportTemplateColumnID
inner join cem.ExportTemplateSection ets on etc.ExportTemplateSectionID=ets.ExportTemplateSectionID
where etc.ExportTemplateColumnDescription in (select ExportTemplateColumnDescription from #aco where aco9=0)
and ets.ExportTemplateID=@newTemplateID

delete etc
from cem.ExportTemplateColumn etc 
inner join cem.ExportTemplateSection ets on etc.ExportTemplateSectionID=ets.ExportTemplateSectionID
where etc.ExportTemplateColumnDescription in (select ExportTemplateColumnDescription from #aco where aco9=0)
and ets.ExportTemplateID=@newTemplateID

update etcr
set RecodeValue = '09', ResponseLabel = 'ACO-9'
from cem.ExportTemplateColumnResponse etcr
inner join cem.ExportTemplateColumn etc on etcr.ExportTemplateColumnID=etc.ExportTemplateColumnID
inner join cem.ExportTemplateSection ets on etc.ExportTemplateSectionID=ets.ExportTemplateSectionID
where ets.ExportTemplateID=@newTemplateID
and etc.ExportColumnName='VERSION'
and ResponseLabel = 'ACO-12'

-- alter post proc' where clauses from ACO12= to ACO9=
declare @sql nvarchar(max)
select @sql=definition
from sys.sql_modules
where object_name(object_id)='ExportPostProcess'+right(convert(varchar,@newTemplateID+100000000),8)

if exists(select * from sys.procedures where name = 'ExportPostProcess'+right(convert(varchar,@newTemplateID+100000000),8))
	set @SQL = replace(@SQL,'CREATE PROCEDURE','ALTER PROCEDURE')

set @SQL = replace(@SQL, 'ACO12=', 'ACO9=')

EXECUTE dbo.sp_executesql @SQL
go

-- copy ACO-12 to PQRS
exec [CEM].[CopyExportTemplate] 4

declare @newTemplateID int
select @newTemplateID = max(exporttemplateid) from cem.ExportTemplate

update cem.exporttemplate 
set ExportTemplateName='PQRS CAHPS', ExportTemplateVersionMajor='1.0', SurveyTypeID=13, DefaultNamingConvention=replace(DefaultNamingConvention,'ACO12','PQRS')  
where ExportTemplateID=@newTemplateID 

update cem.exporttemplatesection 
set DefaultNamingConvention=replace(DefaultNamingConvention,'ACO12','PQRS')  
where ExportTemplateID=@newTemplateID 

update etc
set SourceColumnName = replace(SourceColumnName, 'ACO_','PQRS_')
from  cem.ExportTemplateColumn etc 
inner join cem.ExportTemplateSection ets on etc.ExportTemplateSectionID=ets.ExportTemplateSectionID
where ets.ExportTemplateID=@newTemplateID
and etc.ExportColumnName in ('FIELDDATE','FINDER','FOCALTYPE')

update etc
set SourceColumnName = 'ColumnName=''PQRS_GroupID''', ExportColumnName='PQRS_ID'
from  cem.ExportTemplateColumn etc 
inner join cem.ExportTemplateSection ets on etc.ExportTemplateSectionID=ets.ExportTemplateSectionID
where ets.ExportTemplateID=@newTemplateID
and etc.ExportColumnName = 'ACO_ACOID'

--update etc
--set SourceColumnName = replace(SourceColumnName, 'Dr','PQRS_')
--from  cem.ExportTemplateColumn etc 
--inner join cem.ExportTemplateSection ets on etc.ExportTemplateSectionID=ets.ExportTemplateSectionID
--where ets.ExportTemplateID=@newTemplateID
--and etc.ExportColumnName in ('PRFNAME','PRLNAME')

delete etcr
from cem.ExportTemplateColumnResponse etcr
inner join cem.ExportTemplateColumn etc on etcr.ExportTemplateColumnID=etc.ExportTemplateColumnID
inner join cem.ExportTemplateSection ets on etc.ExportTemplateSectionID=ets.ExportTemplateSectionID
where etc.ExportColumnName = 'VERSION'
and ets.ExportTemplateID=@newTemplateID

declare @co int
select @co=columnorder 
from cem.ExportTemplateColumn etc 
inner join cem.ExportTemplateSection ets on etc.ExportTemplateSectionID=ets.ExportTemplateSectionID
where etc.ExportColumnName = 'VERSION'
and ets.ExportTemplateID=@newTemplateID

delete etc
from cem.ExportTemplateColumn etc 
inner join cem.ExportTemplateSection ets on etc.ExportTemplateSectionID=ets.ExportTemplateSectionID
where etc.ExportColumnName = 'VERSION'
and ets.ExportTemplateID=@newTemplateID

update etc
set ColumnOrder=ColumnOrder-1
from cem.ExportTemplateColumn etc 
inner join cem.ExportTemplateSection ets on etc.ExportTemplateSectionID=ets.ExportTemplateSectionID
where etc.columnOrder > @co
and ets.ExportTemplateID=@newTemplateID

update etcr
set RawValue=etcr.RecodeValue+800
from cem.ExportTemplateColumnResponse etcr
inner join cem.ExportTemplateColumn etc on etcr.ExportTemplateColumnID=etc.ExportTemplateColumnID
inner join cem.ExportTemplateSection ets on etc.ExportTemplateSectionID=ets.ExportTemplateSectionID
where ets.ExportTemplateID=@newTemplateID
and etc.ExportColumnName = 'DISPOSITN'
