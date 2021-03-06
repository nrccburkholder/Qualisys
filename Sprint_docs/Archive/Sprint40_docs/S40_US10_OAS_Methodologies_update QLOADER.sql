/*

S40_US10_OAS_Methodologies_update QLOADER.sql

10 OAS: New Survey Type
As an Implementation Associate, I want a new survey type w/ appropriate settings for OAS CAHPS, so that I can set up surveys compliantly.
Survey type, no subtypes, DQ rules, monthly sample periods, 3 std methodologies, add survey type to catalyst database 


Chris Burkholder

*/
begin tran

if not exists (select * from [QP_Load].[dbo].[FunctionGroup] where strFunctionGroup_dsc = 'OAS CAHPS')
insert into [QP_Load].[dbo].[FunctionGroup] (strFunctionGroup_dsc, intParentFunctionGroup_id)
values ('OAS CAHPS', 2)

declare @oasGroupId int 
select @oasGroupId = FunctionGroup_id from [QP_Load].[dbo].[FunctionGroup] where strFunctionGroup_dsc = 'OAS CAHPS'

if not exists (select * FROM [QP_Load].[dbo].[Functions]  where strfunction_nm = 'OAScahpsCPTCodesValid')
insert into [QP_Load].[dbo].[Functions] (strFunction_nm, strFunction_Sig, strFunction_dsc, 
strFunction_Code, 
bitVBS, Client_id, FunctionGroup_id)
values
('OAScahpsCPTCodesValid', 'OAScahpsCPTCodesValid(strCPT4,strCPT4_2,strCPT4_3)', 'Are CPT Codes Valid?', 
'Function OAScahpsCPTCodesValid(strCPT4,strCPT4_2,strCPT4_3)

If (strCPT4 >= "10021" And strCPT4 <= "69990" _
And strCPT4 <> "16020" And strCPT4 <> "16025" And strCPT4 <> "16030" And strCPT4 <> "29581" And strCPT4 <> "36600" And strCPT4 <> "36415" And strCPT4 <> "36416") _
Or (strCPT4_2 >= "10021" And strCPT4_2 <= "69990" _
And strCPT4_2 <> "16020" And strCPT4_2 <> "16025" And strCPT4_2 <> "16030" And strCPT4_2 <> "29581" And strCPT4_2 <> "36600" And strCPT4_2 <> "36415" And strCPT4_2 <> "36416") _
Or (strCPT4_3 >= "10021" And strCPT4_3 <= "69990" _
And strCPT4_3 <> "16020" And strCPT4_3 <> "16025" And strCPT4_3 <> "16030" And strCPT4_3 <> "29581" And strCPT4_3 <> "36600" And strCPT4_3 <> "36415" And strCPT4_3 <> "36416") Then
  OAScahpsCPTCodesValid = "1"
Else
    OAScahpsCPTCodesValid = "0"
End If
End Function',
0 ,0, @oasGroupId)

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [Function_id]
      ,[strFunction_nm]
      ,[strFunction_Sig]
      ,[strFunction_dsc]
      ,[strFunction_Code]
      ,[bitVBS]
      ,[Client_id]
      ,[FunctionGroup_id]
  FROM [QP_Load].[dbo].[Functions]
  where strfunction_nm like 'oas%'

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [FunctionGroup_id]
      ,[strFunctionGroup_dsc]
      ,[intParentFunctionGroup_id]
  FROM [QP_Load].[dbo].[FunctionGroup]
  where strFunctionGroup_dsc like '%cahps%'

--rollback tran	
commit tran
