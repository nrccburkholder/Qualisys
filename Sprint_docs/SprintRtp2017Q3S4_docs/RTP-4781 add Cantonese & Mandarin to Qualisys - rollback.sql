/*
	RTP-4781 add Cantonese & Mandarin to Qualisys

	Dave Gilsdorf

*/
use qp_prod 
go
delete from languages where langid=33 and language = 'Cantonese'
delete from languages where langid=34 and language = 'Mandarin'

GO