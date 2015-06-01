/*
	S26.US11	ICHCAHPS submission file changes
		as an authorized ICHCAHPS vendor, we must remove records from the submission file that were sampled in error


	T11.5	create a 'CMS Removal' disposition and put it at the top of ICHCAHPS' hierarchy

Dave Gilsdorf

QP_Prod:
INSERT INTO dbo.Disposition
UPDATE/INSERT INTO SurveyTypeDispositions 
DELETE FROM ScheduledMailing (stage environment only)
INSERT INTO dbo.DispositionLog
*/
use qp_prod
go
/* create new disposition code -- double-check that the new code is '48' -- if not, update the catalyst script */
if not exists (select * from disposition where strDispositionLabel='CMS Removal')
	insert into disposition (strDispositionLabel,Action_id,strReportLabel,MustHaveResults) 
	values ('CMS Removal',0,'CMS Removal',0)
go

/* put the new code at the top of ICHCAHPS' heirarcy */
if not exists (select * from SurveyTypeDispositions where [desc]='CMS Removal' and SurveyType_id=8)
begin
	update SurveyTypeDispositions set Hierarchy=Hierarchy+1 where surveytype_id=8
	insert into SurveyTypeDispositions (Disposition_ID,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
	select Disposition_id, 999 as Value, 0 as Hierarchy, strDispositionLabel as [Desc],0 as ExportReportResponses,null as ReceiptType_ID,8 as SurveyType_ID
	from Disposition 
	where strDispositionLabel='CMS Removal'
end

/* stage only: remove the samplepops from scheduledmailing, etc. */
if exists (select * from qualpro_params where strParam_nm ='EnvName' and STRPARAM_VALUE='STAGING')
	delete 
	from SCHEDULEDMAILING 
	where SAMPLEPOP_ID in (113522103,113522648,113553841,113599743,113522106,113599732,113599729,113522108,113522192,113522078,113522147, 
	113522069,113522132,113522112,113522182,113522054,113522064,113522086,113522138,113522196,113522161,113522191,113522125,113522171,113522117,113522144,113542581, 
	113552334,113552633,113552444,113552402,113552448,113552368,113552319,113553594,113553580,113553527,113553533,113553576,113553615,113553623,113553857,113553850, 
	113553844,113553847,113553842,113553815,113599760,113599735,113599752,113599755,113599747,113599753,113599731,113599764,113599771,113599768,113599739,113599749, 
	113599761,113599746,113599766,113599740,113599767,113599736,113599757,113599745,113599751,113552562,113552598,113552328,113552483,113552636,113552670,113552573, 
	113552359,113552534,113542547) 
	and SENTMAIL_ID is null 


/* insert records in DispositionLog for the appropriate samplepops */
insert into dispositionlog (samplepop_id, Disposition_id,ReceiptType_id,datLogged,LoggedBy)
select sp.Samplepop_id, d.Disposition_id, 0 as receiptType_id, getdate() as datLogged, 'CMS Removal' as LoggedBy 
from samplepop sp, disposition d
where d.strDispositionLabel='CMS Removal'
and sp.SAMPLEPOP_ID in (113522103,113522648,113553841,113599743,113522106,113599732,113599729,113522108,113522192,113522078,113522147, 
113522069,113522132,113522112,113522182,113522054,113522064,113522086,113522138,113522196,113522161,113522191,113522125,113522171,113522117,113522144,113542581, 
113552334,113552633,113552444,113552402,113552448,113552368,113552319,113553594,113553580,113553527,113553533,113553576,113553615,113553623,113553857,113553850, 
113553844,113553847,113553842,113553815,113599760,113599735,113599752,113599755,113599747,113599753,113599731,113599764,113599771,113599768,113599739,113599749, 
113599761,113599746,113599766,113599740,113599767,113599736,113599757,113599745,113599751,113552562,113552598,113552328,113552483,113552636,113552670,113552573, 
113552359,113552534,113542547) 
