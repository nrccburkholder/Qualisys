/*
	RTP-xxxx add Serbian to Qualisys

	Chris Burkholder

*/
use qp_prod 
go
delete from languages where langid=35 and language = 'Serbian'

GO