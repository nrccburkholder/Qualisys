/*
S56 ATL-715 Vovici Svc Resending Participants.sql

ATL-740 stop retrying after errors

Chris Burkholder

8/15/2016
*/


--select  strparam_grp, count(*) from qualpro_params group by strparam_grp

--select * from qualpro_params where strparam_grp = 'ScannerInterface'

insert into qualpro_params (strparam_nm, strparam_type, strparam_grp, strparam_value, comments)
values('QSIVerintExceptionsToIgnoreAndMarkSent', 'S', 'ScannerInterface','A Unique set of keys must be specified for each participant for Passcode surveys.|A participant with this email and user keys has already been added to the survey.','Certain Verint exception messages should be just used to mark sent')

GO