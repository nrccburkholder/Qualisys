create procedure sp_phase2_extract_flg
as
select distinct ss.sampleset_id into #sampset
from sampleset ss, samplepop sp, questionform qf, sentmailing sm
where ss.extract_flg is null
and ss.sampleset_id = sp.sampleset_id
and sp.samplepop_id = qf.samplepop_id
and qf.sentmail_id = sm.sentmail_id
and datmailed is not null

update ss set ss.extract_flg = 0 
from sampleset ss, #sampset s
where ss.sampleset_id = s.sampleset_id

drop table #sampset


