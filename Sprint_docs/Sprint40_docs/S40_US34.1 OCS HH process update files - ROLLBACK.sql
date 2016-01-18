/*
S40_US34.1 OCS HH: process update files

user story 34:
As a company, we want to process update files received from OCS HHCAHPS clients so that we provide complete data to CMS on behalf of the clients.

Brendan Goble

Task 34.1 Add cutoff dates to QUALPRO_PARAMS.

ROLLBACK

*/
use QP_Prod
go

delete from dbo.QUALPRO_PARAMS
where STRPARAM_NM in ('HHCAHPSUpdateFileQ1Cutoff', 'HHCAHPSUpdateFileQ2Cutoff', 'HHCAHPSUpdateFileQ3Cutoff', 'HHCAHPSUpdateFileQ4Cutoff')

go