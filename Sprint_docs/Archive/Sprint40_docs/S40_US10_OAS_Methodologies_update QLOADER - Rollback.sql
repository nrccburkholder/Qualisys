/*

S40_US10_OAS_Methodologies_update QLOADER - Rollback.sql

10 OAS: New Survey Type
As an Implementation Associate, I want a new survey type w/ appropriate settings for OAS CAHPS, so that I can set up surveys compliantly.
Survey type, no subtypes, DQ rules, monthly sample periods, 3 std methodologies, add survey type to catalyst database 


Chris Burkholder

*/
begin tran

DELETE --SELECT *
  FROM [QP_Load].[dbo].[Functions]
  where strfunction_nm = 'OAScahpsCPTCodesValid'

DELETE --select *
	from [QP_Load].[dbo].[FunctionGroup]
	where strFunctionGroup_dsc = 'OAS CAHPS'

--rollback tran	
commit tran
