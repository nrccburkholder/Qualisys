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
if not exists (select * from sys.tables st inner join sys.columns sc on st.object_id=sc.object_id where st.name='SurveyTypeQuestionMappings' and sc.name='isATA')
	ALTER TABLE SurveyTypeQuestionMappings add isATA bit

if not exists (select * from sys.tables st inner join sys.columns sc on st.object_id=sc.object_id where st.name='SurveyTypeQuestionMappings' and sc.name='isMeasure')
	ALTER TABLE SurveyTypeQuestionMappings add isMeasure bit
go
update SurveyTypeQuestionMappings set isATA=0, isMeasure=0

-- ACO
update stqm
set isATA=1
from SurveyTypeQuestionMappings stqm 
inner join subtype st on stqm.subtype_id=st.subtype_id
where stqm.surveytype_id = (select surveytype_id from surveytype where surveytype_dsc='ACOCAHPS')
and st.subtype_nm='ACO-8'
and stqm.qstncore in (50175,50218,50222,50223,50224,50225,50229,50230,50234,50235,50236,50238,50240,50241,50243,50245,50247,50248,50249,50250,50251,50252,50253,50255,50256,50699,50700,50725,51426)

update stqm
set isATA=1 
from SurveyTypeQuestionMappings stqm 
inner join subtype st on stqm.subtype_id=st.subtype_id
where stqm.surveytype_id = (select surveytype_id from surveytype where surveytype_dsc='ACOCAHPS')
and st.subtype_nm='ACO-12'
and stqm.qstncore in (50175,50218,50222,50223,50224,50225,50226,50229,50230,50234,50235,50236,50238,50240,50241,50243,50245,50247,50248,50249,50250,50251,50252,50253,50255,50256,50699,50700,50725,51426)

update stqm
set isMeasure=1 
from SurveyTypeQuestionMappings stqm 
where stqm.surveytype_id = (select surveytype_id from surveytype where surveytype_dsc='ACOCAHPS')
and stqm.qstncore in (50180,50182,50184,50186,50189,50190,50191,50193,50194,50196,50197,50201,50202,50203,50210,50211,50212,50213,50214,50215,50220,50221,50222,50223,50224,50225,50229,50230,50234,50235,50237,50239,50240,50249,50250,50251,50252)

-- PQRS
update SurveyTypeQuestionMappings  
set isATA=1
where qstncore in (50175,50218,50222,50223,50224,50225,50226,50229,50230,50234,50235,50236,50238,50240,50243,50245,50247,50249,50250,50251,50252,50253,50255,50256,50699,50700,50725)
and surveytype_id = (select surveytype_id from surveytype where surveytype_dsc='PQRS CAHPS')

update SurveyTypeQuestionMappings  
set isMeasure=1
where qstncore in (50182,50188,50190,50191,50195,50196,50197,50199,50201,50202,50203,50205,50207,50208,50210,50211,50212,50213,50214,50215,50216,50217,50220,50221,50222,50223,50224,50225,50227,50228,50229,50230,50234,50235,50237,50239,50240,50249,50250,50251,50252,53422,53424,53425,53427,53428,53429)
and surveytype_id = (select surveytype_id from surveytype where surveytype_dsc='PQRS CAHPS')

