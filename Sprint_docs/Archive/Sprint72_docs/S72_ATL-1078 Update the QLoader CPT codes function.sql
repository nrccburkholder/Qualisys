/*
	S72_ATL-1078 Update the QLoader CPT codes function.sql

	Chris Burkholder

	4/11/2017

	DELETE FROM Functions
	INSERT INTO Functions

	select * from dbo.Functions where strFunction_nm = 'OAScahpsCPTCodesValid'
	select * from dbo.Functions where strFunction_nm = 'OASEligibleSurg'
*/

USE [QP_Load]
GO

delete dbo.Functions where strFunction_nm = 'OAScahpsCPTCodesValid'

declare @QLoaderBox varchar(16)
Select @QLoaderBox = case strparam_value when 'Development' then 'd-QualLoadSql01' 
										when 'Testing' then 'tiQualSql01'
										when 'Staging' then 'siQualSql01'
										when 'Production' then 'Mars' end
	from Qualisys.QP_Prod.dbo.QualPro_Params where strparam_nm = 'EnvName'

declare @function nvarchar(4000)
select @function = N'''Define the QLoader connection string
Private Const mkstrQPLoadOASESConn = "driver={SQL Server};server='+@QLoaderBox+';UID=qpsa;PWD=qpsa;database=QP_Load"
Private mobjOASESConn

InitOASESConnection()

Public Sub InitOASESConnection()
    
    ''Open the database connection
    ''If mobjOASESConn Is Nothing Then
        Set mobjOASESConn = CreateObject("ADODB.connection")
        mobjOASESConn.Open mkstrQPLoadOASESConn
    ''End If

End Sub

Function OASEligibleSurg(strCPT4,strCPT4_2,strCPT4_3,strHCPCS,strHCPCS_2,strHCPCS_3)
    
    Dim strSQL
    Dim objServiceRS
    
    Dim LOasEligibleSurg
    LOasEligibleSurg = "0"

    strSQL = "select CptCode from OasExcludedCptCode where CptCode = ''" & strCPT4 & "''"
    Set objServiceRS = mobjOASESConn.Execute(strSQL)
    If (strCPT4 >= "10021" And strCPT4 <= "69990" and objServiceRS.EOF) Then
        LOASEligibleSurg = "1"
    End If

    strSQL = "select CptCode from OasExcludedCptCode where CptCode = ''" & strCPT4_2 & "''"
    Set objServiceRS = mobjOASESConn.Execute(strSQL)
    If (strCPT4_2 >= "10021" And strCPT4_2 <= "69990" and objServiceRS.EOF) Then
        LOASEligibleSurg = "1"
    End If

    strSQL = "select CptCode from OasExcludedCptCode where CptCode = ''" & strCPT4_3 & "''"
    Set objServiceRS = mobjOASESConn.Execute(strSQL)
    If (strCPT4_3 >= "10021" And strCPT4_3 <= "69990" And objServiceRS.EOF) Then
        LOASEligibleSurg = "1"
    End If
    
    If (strHCPCS = "G0104" Or strHCPCS = "G0105" Or strHCPCS = "G0121" Or strHCPCS = "G0260") Then
        LOASEligibleSurg = "1"
    End If

    If (strHCPCS_2 = "G0104" Or strHCPCS_2 = "G0105" Or strHCPCS_2 = "G0121" Or strHCPCS_2 = "G0260") Then
        LOASEligibleSurg = "1"
    End If

    If (strHCPCS_3 = "G0104" Or strHCPCS_3 = "G0105" Or strHCPCS_3 = "G0121" Or strHCPCS_3 = "G0260") Then
        LOASEligibleSurg = "1"
    End If

    If (strCPT4 = "" And strCPT4_2 = "" And strCPT4_3 = "" And strHCPCS = "" And strHCPCS_2 = "" And strHCPCS_3 = "") Then
        LOASEligibleSurg = "1"
    End If

    ''Cleanup
    objServiceRS.Close
    Set objServiceRS = Nothing
    
    OASEligibleSurg = LOASEligibleSurg

End Function'

if not exists(select 1 from dbo.functions where strFunction_nm = 'OASEligibleSurg')
insert into dbo.functions(strFunction_nm,strFunction_Sig,strFunction_dsc,
strFunction_Code,bitVBS,Client_id,FunctionGroup_id)
Values('OASEligibleSurg','OASEligibleSurg(strCPT4,strCPT4_2,strCPT4_3,strHCPCS,strHCPCS_2,strHCPCS_3)','Are CPT and HCPCS Codes Valid?',
@function,0,0,23)

GO