/*
	ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	S59 ATL-928 Implement Hold on Sampling Tool

	Implement a warning / block on Sampling Tool which prevents sampling from taking place if there is a HOLD record for the selected channel.

	Tim Butler

	Adding QUALPRO_Param for ODS connection string

*/

USE QP_PROD

DECLARE @param_id int
DECLARE @strparam_nm varchar(75)
DECLARE @strparam_type char(1)
DECLARE @strparam_grp varchar(20)
DECLARE @strparam_value varchar(255)
DECLARE @numparam_value int
DECLARE @dataparam_value datetime
DECLARE @comments varchar(255)




begin tran

SET @strparam_grp = 'ConnectionStrings'
SET @strparam_nm = 'ODSConnection'


DELETE
FROM QUALPRO_PARAMS 
WHERE STRPARAM_GRP = @strparam_grp
AND STRPARAM_NM = @strparam_nm

commit tran

select *
from dbo.QUALPRO_PARAMS
where STRPARAM_GRP = @strparam_grp
and STRPARAM_NM = @strparam_nm 