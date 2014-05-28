CREATE procedure sp_phase2_extract_flg_inuse @sampleset int
as
declare @strsql varchar(1000)

set @strsql = 'update sampleset set extract_flg = 2 where sampleset_id = ' + convert(varchar,@sampleset)
exec(@strsql)

select study_id from survey_def sd, sampleset ss
where ss.sampleset_id = @sampleset
and ss.survey_id = sd.survey_id


