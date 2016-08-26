/*
S56 ATL-715 Vovici Svc Resending Participants - Rollback.sql

ATL-740 stop retrying after errors

Chris Burkholder

8/15/2016
*/


--select  strparam_grp, count(*) from qualpro_params group by strparam_grp

--select * from qualpro_params where strparam_grp = 'ScannerInterface'

delete from qualpro_params where strparam_nm = 'QSIVerintExceptionsToIgnoreAndMarkSent'

