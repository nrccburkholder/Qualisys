CREATE proc [dbo].[cleanout_dl_tables_by_dataload]
	@dataload_id int
as

truncate table tmp_cleanout_dl_tables_by_dataload

insert into tmp_cleanout_dl_tables_by_dataload
select distinct lc.dl_lithocode_id 
from DL_LithoCodes lc inner join dl_surveydataload sdl
 on lc.SurveyDataLoad_ID = sdl.SurveyDataLoad_ID
where sdl.DataLoad_ID = @dataload_id

--begin tran

truncate table tmp_samplepops_cleanout_dl_tables_by_dataload

insert into tmp_samplepops_cleanout_dl_tables_by_dataload
select distinct dl.samplepop_id, sdl.survey_id
from sentmailing sm inner join scheduledmailing schm
 on sm.scheduledmailing_id = schm.SCHEDULEDMAILING_ID
inner join DL_LithoCodes lc
 on sm.STRLITHOCODE = lc.strLithoCode
inner join vendordispositionlog vdl 
 on lc.DL_LithoCode_ID = vdl.dl_lithocode_id
inner join vendordispositions vd
 on vdl.VendorDisposition_ID = vd.vendordisposition_id
inner join DispositionLog dl
 on vd.disposition_id = dl.disposition_id
 and schm.samplepop_id = dl.samplepop_id
 and vdl.DispositionDate = dl.datLogged
inner join dl_surveydataload sdl
 on lc.SurveyDataLoad_ID = sdl.SurveyDataLoad_ID
where sdl.DataLoad_ID = @dataload_id


delete dl from
sentmailing sm inner join scheduledmailing schm
 on sm.scheduledmailing_id = schm.SCHEDULEDMAILING_ID
inner join DL_LithoCodes lc
 on sm.STRLITHOCODE = lc.strLithoCode
inner join vendordispositionlog vdl 
 on lc.DL_LithoCode_ID = vdl.dl_lithocode_id
inner join vendordispositions vd
 on vdl.VendorDisposition_ID = vd.vendordisposition_id
inner join DispositionLog dl
 on vd.disposition_id = dl.disposition_id
 and schm.samplepop_id = dl.samplepop_id
 and vdl.DispositionDate = dl.datLogged
inner join dl_surveydataload sdl
 on lc.SurveyDataLoad_ID = sdl.SurveyDataLoad_ID
where sdl.DataLoad_ID = @dataload_id

--delete dl from
--sentmailing sm inner join scheduledmailing schm
-- on sm.scheduledmailing_id = schm.SCHEDULEDMAILING_ID
--inner join DL_LithoCodes lc
-- on sm.STRLITHOCODE = lc.strLithoCode
--inner join vendordispositionlog vdl 
-- on lc.DL_LithoCode_ID = vdl.dl_lithocode_id
--inner join vendordispositions vd
-- on vdl.VendorDisposition_ID = vd.vendordisposition_id
--inner join datamart.qp_comments.dbo.DispositionLog dl
-- on vd.disposition_id = dl.disposition_id
-- and schm.samplepop_id = dl.samplepop_id
-- and vdl.DispositionDate = dl.datLogged
--inner join dl_surveydataload sdl
-- on lc.SurveyDataLoad_ID = sdl.SurveyDataLoad_ID
--where sdl.DataLoad_ID = @dataload_id

--update dl
--set bitevaluated = 0
--from datamart.qp_comments.dbo.dispositionlog dl inner join tmp_samplepops_cleanout_dl_tables_by_dataload t
-- on dl.samplepop_id = t.samplepop_id

-- the following new proc contains that above commented out delete/update
exec datamart.qp_comments.dbo.cleanout_dispositionlog_by_dataload @dataload_id

delete vendordispositionlog where DL_LithoCode_ID in (select * from tmp_cleanout_dl_tables_by_dataload)
delete dl_dispositions where DL_LithoCode_ID in (select * from tmp_cleanout_dl_tables_by_dataload)
delete dl_questionresults where DL_LithoCode_ID in (select * from tmp_cleanout_dl_tables_by_dataload)
delete dl_comments where DL_LithoCode_ID in (select * from tmp_cleanout_dl_tables_by_dataload)
delete dl_handentry where DL_LithoCode_ID in (select * from tmp_cleanout_dl_tables_by_dataload)
delete dl_popmapping where DL_LithoCode_ID in (select * from tmp_cleanout_dl_tables_by_dataload)
delete dl_lithocodes where DL_LithoCode_ID in (select * from tmp_cleanout_dl_tables_by_dataload)

select distinct 'exec SP_Extract_HCAHPSDispositionBigTable_bysurveyid '+cast(survey_id as varchar)+', 1' as "Run on datamart" from tmp_samplepops_cleanout_dl_tables_by_dataload
--rollback tran


