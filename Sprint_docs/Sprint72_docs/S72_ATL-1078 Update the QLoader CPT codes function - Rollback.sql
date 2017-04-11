/*
	S72_ATL-1078 Update the QLoader CPT codes function - Rollback.sql

	Chris Burkholder

	4/11/2017

	DELETE FROM Functions
	INSERT INTO Functions

	select * from dbo.Functions where strFunction_nm = 'OAScahpsCPTCodesValid'
	select * from dbo.Functions where strFunction_nm = 'OASEligibleSurg'
*/

USE [QP_Load]
GO

delete dbo.Functions where strFunction_nm = 'OASEligibleSurg'

if not exists(select 1 from dbo.functions where strFunction_nm = 'OAScahpsCPTCodesValid')
insert into dbo.functions(strFunction_nm,strFunction_Sig,strFunction_dsc,strFunction_Code,bitVBS,Client_id,FunctionGroup_id)
Values('OAScahpsCPTCodesValid','OAScahpsCPTCodesValid(strCPT4,strCPT4_2,strCPT4_3)','Are CPT Codes Valid?',
N'Function OAScahpsCPTCodesValid(strCPT4,strCPT4_2,strCPT4_3)

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
End Function',0,0,23)

GO