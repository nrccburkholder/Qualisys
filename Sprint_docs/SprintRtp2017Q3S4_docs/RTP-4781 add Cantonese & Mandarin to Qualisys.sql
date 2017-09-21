/*
	RTP-4781 add Cantonese & Mandarin to Qualisys

	Dave Gilsdorf

*/
use qp_prod 
go
insert into languages (LangID, Language, Dictionary, WebLanguageLabel, QualiSysLanguage, ISO639) values (33, 'Cantonese', 'English.dct', 'Cantonese', 0, 'chi.can')
insert into languages (LangID, Language, Dictionary, WebLanguageLabel, QualiSysLanguage, ISO639) values (34, 'Mandarin', 'English.dct', 'Mandarin', 0, 'chi.man')

GO