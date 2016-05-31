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