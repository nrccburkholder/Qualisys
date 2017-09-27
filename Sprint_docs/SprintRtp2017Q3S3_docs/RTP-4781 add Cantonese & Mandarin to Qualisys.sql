/*
	RTP-4781 add Cantonese & Mandarin to Qualisys

	Dave Gilsdorf

*/
use qp_prod 
go
if not exists (select * from languages where langid=33 and language = 'Cantonese')
	insert into languages (LangID, Language, Dictionary, WebLanguageLabel, QualiSysLanguage, ISO639) values (33, 'Cantonese', 'English.dct', 'Cantonese', 0, 'yue')
if not exists (select * from languages where langid=34 and language = 'Mandarin')
	insert into languages (LangID, Language, Dictionary, WebLanguageLabel, QualiSysLanguage, ISO639) values (34, 'Mandarin', 'English.dct', 'Mandarin', 0, 'cmn')

GO