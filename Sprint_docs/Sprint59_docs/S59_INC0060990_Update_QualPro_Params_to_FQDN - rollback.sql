/*

S59_INC0060990_Update_QualPro_Params_to_FQDN - rollback.sql

Chris Burkholder

9/30/2016

Trying to address INC0060990 by following John Dorn's advice to use FQDN rather than CName/short name:

PIQUALAPP02
A device attached to the system is not functioning 

*/

--select * from qualpro_params where strparam_value like '\\%'

USE [QP_Prod]
GO

declare @old nvarchar(100), @new nvarchar(100)

select @old = '\\Argus'
select @new = '\\Argus.nationalresearch.com'

update qpp set strparam_value = replace(strparam_value, @new, @old)
--select strparam_value, replace(strparam_value, @new, @old), len(replace(strparam_value, @new, @old))
from qualpro_params qpp
where strparam_value like @old+'%'

select @old = '\\popsfil01'
select @new = '\\popsfil01.nationalresearch.com'

update qpp set strparam_value = replace(strparam_value, @new, @old)
--select strparam_value, replace(strparam_value, @new, @old), len(replace(strparam_value, @new, @old))
from qualpro_params qpp
where strparam_value like @old+'%'

select @old = '\\neptune'
select @new = '\\oma0pfil01.nationalresearch.com'

update qpp set strparam_value = replace(strparam_value, @new, @old)
--select strparam_value, replace(strparam_value, @new, @old), len(replace(strparam_value, @new, @old))
from qualpro_params qpp
where strparam_value like @old+'%'

select @old = '\\NRC45'
select @new = '\\NRC45.nationalresearch.com'

update qpp set strparam_value = replace(strparam_value, @new, @old)
--select strparam_value, replace(strparam_value, @new, @old), len(replace(strparam_value, @new, @old))
from qualpro_params qpp
where strparam_value like @old+'%'

select @old = '\\MHM0pFIL01'
select @new = '\\mhm0pfil01.nrccanada.com'

update qpp set strparam_value = replace(strparam_value, @new, @old)
--select strparam_value, replace(strparam_value, @new, @old), len(replace(strparam_value, @new, @old))
from qualpro_params qpp
where strparam_value like @old+'%'

select @old = '\\lnk0pfil01'
select @new = '\\oma0pfil01'

update qpp set strparam_value = replace(strparam_value, @new, @old)
--select strparam_value, replace(strparam_value, @new, @old), len(replace(strparam_value, @new, @old))
from qualpro_params qpp
where strparam_value like @old+'%'

GO