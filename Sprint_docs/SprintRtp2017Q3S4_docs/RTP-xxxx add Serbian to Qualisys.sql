/*
	RTP-xxxx add Serbian to Qualisys

	Chris Burkholder

*/
use qp_prod 
go
if not exists (select * from languages where langid=35 and language = 'Serbian')
	insert into languages (LangID, Language, Dictionary, WebLanguageLabel, QualiSysLanguage, ISO639) values (35, 'Serbian', 'English.dct', 'Serbian', 0, 'srp')

GO