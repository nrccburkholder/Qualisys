CREATE procedure sp_phase2_extract_flg_redo @sampleset int
as
declare @strsql varchar(1000)

set @strsql = 'update sampleset set extract_flg = 0 where sampleset_id = ' + convert(varchar,@sampleset)
exec(@strsql)


