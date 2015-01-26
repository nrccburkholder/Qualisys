

-- Alter survey_def to add sampling "cutoff" fields....Then populate the new columns based upon the existing cutoff data.
ALTER TABLE SURVEY_DEF ADD SampleEncounterTable_id INT CONSTRAINT FK_SampEncTable_id FOREIGN KEY REFERENCES MetaTable(Table_id), SampleEncounterField_id INT CONSTRAINT FK_SampEncField_id FOREIGN KEY REFERENCES MetaField (Field_id)
GO
UPDATE Survey_Def SET SampleEncounterTable_id = CutoffTable_id, SampleEncounterField_id = CutoffField_id WHERE strcutoffresponse_cd = '2'
