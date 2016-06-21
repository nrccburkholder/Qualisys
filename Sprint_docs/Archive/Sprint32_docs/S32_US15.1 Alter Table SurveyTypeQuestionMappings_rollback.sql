/*
	S32 US15	ACO Completeness
				As a Service Associate, I want survey validation question core checks updated to match current NRC templates, so that I can ensure surveys are correctly set up.


	15.1	modify survey type question mapping table to add ATA and measure question columns

Dave Gilsdorf

QP_Prod:
ALTER TABLE/UPDATE SurveyTypeQuestionMappings 
*/
go
use QP_Prod
go
if exists (select * from sys.tables st inner join sys.columns sc on st.object_id=sc.object_id where st.name='SurveyTypeQuestionMappings' and sc.name='isATA')
	ALTER TABLE SurveyTypeQuestionMappings drop column isATA

if not exists (select * from sys.tables st inner join sys.columns sc on st.object_id=sc.object_id where st.name='SurveyTypeQuestionMappings' and sc.name='isMeasure')
	ALTER TABLE SurveyTypeQuestionMappings drop column isMeasure
