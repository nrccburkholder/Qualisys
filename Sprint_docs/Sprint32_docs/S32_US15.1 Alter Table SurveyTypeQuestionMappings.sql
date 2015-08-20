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

update SurveyTypeQuestionMappings set isATA=0, isMeasure=0

update SurveyTypeQuestionMappings 
set isATA=1 
where SurveyType_id=10
and SubType_id=9
and qstncore in (50175,50218,50222,50223,50224,50225,50229,50230,50234,50235,50236,50238,50240,50241,50243,50245,50247,50248,50249,50250,50251,50252,50253,50255,50256,50699,50700,50725,51426)

update SurveyTypeQuestionMappings 
set isATA=1 
where SurveyType_id=10
and SubType_id=10
and qstncore in (50175,50218,50222,50223,50224,50225,50226,50229,50230,50234,50235,50236,50238,50240,50241,50243,50245,50247,50248,50249,50250,50251,50252,50253,50255,50256,50699,50700,50725,51426)

update SurveyTypeQuestionMappings 
set isMeasure=1 
where SurveyType_id=10
and qstncore in (50180,50182,50184,50186,50189,50190,50191,50193,50194,50196,50197,50201,50202,50203,50210,50211,50212,50213,50214,50215,50220,50221,50222,50223,50224,50225,50229,50230,50234,50235,50237,50239,50240,50249,50250,50251,50252)

