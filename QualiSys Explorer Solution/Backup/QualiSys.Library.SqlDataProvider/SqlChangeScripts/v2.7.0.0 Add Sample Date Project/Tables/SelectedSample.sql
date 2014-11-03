
-- Alter SelectedSample to add SampleEncounterDate field....Then populate the new column based upon the existing ReportDate data.
ALTER TABLE SELECTEDSAMPLE ADD SampleEncounterDate DATETIME
GO
UPDATE SelectedSample SET SampleEncounterDate = ReportDate
GO

--Fix old data that had newrecorddate saved as the reportdate and sampleencounter date.
--These are identified by looking for samplesets with no sample field defined.
update sm
	set reportdate=case when reportdate<>datsamplecreate_dt then null else reportdate end,
		sampleencounterdate=null
from sampleset ss, selectedsample sm
where ss.sampleset_id=sm.sampleset_id
	and intdaterange_table_id is null	
	and intdaterange_field_id is null
	and sm.sampleencounterdate >='01jan1900'
	
	
	