/*
S40_US10_OAS_SurveyType_QualPro_Params - Rollback.sql

Chris Burkholder

1/8/2016

*/
--select * from surveytype

/* PROD
SurveyType_ID	SurveyType_dsc
1	NRC/Picker
2	HCAHPS IP
3	Home Health CAHPS
4	CGCAHPS
5	Physician
6	Employee
7	NRC Canada
8	ICHCAHPS
9	MDPDPCAHPS <- not in TEST
10	ACOCAHPS
11	Hospice CAHPS
12	CIHI CPES-IC
13	PQRS CAHPS
STAGE ADDITIONS
14	PostAcuteFam
15	PostAcuteRes
*/

--if not exists(
delete
--select * 
from surveytype where surveytype_id = 16--)

DBCC CHECKIDENT('surveytype', RESEED, 16)

delete
--select * 
from qualpro_params where strparam_nm like 'survey% OAS CAHPS%'

