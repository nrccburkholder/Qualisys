/*
S50 ATL-278 CA Web Survey Migration - Rollback.sql

Chris Burkholder

INSERT INTO VENDORS
INSERT INTO DL_TRANSLATIONMODULES
INSERT/UPDATE QUALPRO_PARAMS

*/

--select * from Vendors
--select * from qualpro_params where strparam_grp = 'ScannerInterface'

USE QP_Prod
GO

DELETE from DL_TranslationModules where vendor_id = 7

DELETE from vendors where vendor_id = 7

delete from qualpro_params where strparam_nm = 'QSIVerint-US-VendorID'

delete from qualpro_params where strparam_nm = 'QSIVerint-CA-VendorID'

update qualpro_params set Comments = 'Specifies the VendorID to be used when referencing Vovici' 
--select * from qualpro_params
where strparam_nm = 'QSIVoviciVendorID'
and comments <> 'Specifies the VendorID to be used when referencing Vovici'

delete from qualpro_params where strparam_nm = 'VerintUserName-US'

delete from qualpro_params where strparam_nm = 'VerintPassword-US'

delete from qualpro_params where strparam_nm = 'VerintURL-US'

delete from qualpro_params where strparam_nm = 'VerintUserName-CA'

delete from qualpro_params where strparam_nm = 'VerintPassword-CA'

delete from qualpro_params where strparam_nm = 'VerintURL-CA'

GO