/*
S50 ATL-278 CA Web Survey Migration.sql

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

set IDENTITY_INSERT vendors ON

insert into vendors (Vendor_ID,VendorCode,Vendor_nm,Phone,Addr1,Addr2,City,StateCode,Province,Zip5,Zip4,DateCreated,DateModified,bitAcceptFilesFromVendor,NoResponseChar,SkipResponseChar,MultiRespItemNotPickedChar,LocalFTPLoginName,VendorFileOutgoType_ID,DontKnowResponseChar,RefusedResponseChar)
VALUES (7,'VRNT CA','Verint Canada','','','','','','','','',GetDate(),null,1,'M','S','N',null,1,'D','R')

if exists(select * from qualpro_params where strparam_nm = 'Country' and strparam_value = 'US')
update Vendors set Vendor_nm = 'DO NOT USE' where vendor_id = 7 and Vendor_nm <> 'DO NOT USE'

set IDENTITY_INSERT vendors OFF

insert into DL_TranslationModules (Vendor_ID, ModuleName, WatchedFolderPath, FileType, Study_ID, Survey_ID, LithoLookupType_id)
select 7,	ModuleName,	Replace(WatchedFolderPath, 'Vovici','Verint-CA'), FileType,Study_ID,Survey_ID,LithoLookupType_id
from DL_TranslationModules 
where vendor_id = 3

select * from DL_TranslationModules where vendor_id = 7

select * from vendors where vendor_id = 7

GO

GO



if not exists(select 1 from qualpro_params where strparam_nm = 'QSIVerint-US-VendorID')
insert into qualpro_params (strparam_nm, strparam_type, strparam_grp, numparam_value, comments)
select 'QSIVerint-US-VendorID', StrParam_Type, StrParam_Grp, NumParam_value, 'Specifies the VendorID to be used when referencing Verint-US'
from qualpro_params where strparam_nm = 'QSIVoviciVendorID'

if not exists(select 1 from qualpro_params where strparam_nm = 'QSIVerint-CA-VendorID')
insert into qualpro_params (strparam_nm, strparam_type, strparam_grp, numparam_value, comments)
select 'QSIVerint-CA-VendorID', StrParam_Type, StrParam_Grp, 7, 'Specifies the VendorID to be used when referencing Verint-CANADA'
from qualpro_params where strparam_nm = 'QSIVoviciVendorID'

update qualpro_params set Comments = 'Deprecated: Vovici -> Verint US / CA' 
--select * from qualpro_params
where strparam_nm = 'QSIVoviciVendorID'
and comments <> 'Deprecated: Vovici -> Verint US / CA'

if not exists(select 1 from qualpro_params where strparam_nm = 'VerintUserName-US')
insert into QualPro_Params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('VerintUserName-US','S','ScannerInterface','nrcpickermdi','The Vovici/Verint User Name for the US')

if not exists(select 1 from qualpro_params where strparam_nm = 'VerintPassword-US')
insert into QualPro_Params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('VerintPassword-US','S','ScannerInterface','nrcpicker1234','The Vovici/Verint Password for the US')

if not exists(select 1 from qualpro_params where strparam_nm = 'VerintURL-US')
insert into QualPro_Params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('VerintURL-US','S','ScannerInterface','https://efm.nrcsurveyor.net/ws/projectdata.asmx','The Vovici/Verint URL for the US')

if not exists(select 1 from qualpro_params where strparam_nm = 'VerintUserName-CA')
insert into QualPro_Params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('VerintUserName-CA','S','ScannerInterface','NRCCService','The Vovici/Verint User Name for Canada')

if not exists(select 1 from qualpro_params where strparam_nm = 'VerintPassword-CA')
insert into QualPro_Params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('VerintPassword-CA','S','ScannerInterface','M00se&Squ1rr3L','The Vovici/Verint Password for Canada')

if not exists(select 1 from qualpro_params where strparam_nm = 'VerintURL-CA')
insert into QualPro_Params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
values ('VerintURL-CA','S','ScannerInterface','http://efm.nrcsurveyorcan.net/ws/projectdata.asmx','The Vovici/Verint URL for Canada')

select vendor_id, count(*) from MailingStep 
group by vendor_id

if exists(select * from qualpro_params where strparam_nm = 'Country' and strparam_value = 'CA')
select surveytype_id, count(*) from survey_def
where surveytype_id in (1,5,6)
group by surveytype_id 

select surveytype_id, count(*) from survey_def
where surveytype_id in (7,12)
group by surveytype_id 

GO