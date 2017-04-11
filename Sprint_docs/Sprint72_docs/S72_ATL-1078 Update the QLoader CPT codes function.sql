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

declare @function nvarchar(max)
select @function = N'
''Define the QLoader connection string
Private Const mkstrQPLoadConn = "driver={SQL Server};server='++@QLoaderBox +N';UID=qpsa;PWD=qpsa;database=QP_Load"
Private mobjConn

InitConnection()

Public Sub InitConnection()
    
    ''Open the database connection
    ''If mobjConn Is Nothing Then
        Set mobjConn = CreateObject("ADODB.connection")
        mobjConn.Open mkstrQPLoadConn
    ''End If

End Sub

Function OASEligibleSurg(strCPT4,strCPT4_2,strCPT4_3,strHCPCS,strHCPCS_2,strHCPCS_3)
    
    Dim strSQL
    Dim objServiceRS
    
	Dim _OasEligibleSurg
	_OasEligibleSurg = "0"

    strSQL = "select CptCode from OasExcludedCptCode where CptCode = ''" & strCPT4 & "''"
    Set objServiceRS = mobjConn.Execute(strSQL)
    If (strCPT4 >= "10021" And strCPT4 <= "69990" and objServiceRS.EOF) Then
        _OASEligibleSurg = "1"
    End If

    strSQL = "select CptCode from OasExcludedCptCode where CptCode = ''" & strCPT4_2 & "''"
    Set objServiceRS = mobjConn.Execute(strSQL)
    If (strCPT4_2 >= "10021" And strCPT4_2 <= "69990" and objServiceRS.EOF) Then
        _OASEligibleSurg = "1"
    End If

    strSQL = "select CptCode from OasExcludedCptCode where CptCode = ''" & strCPT4_3 & "''"
    Set objServiceRS = mobjConn.Execute(strSQL)
    If (strCPT4_3 >= "10021" And strCPT4_3 <= "69990" And objServiceRS.EOF) Then
        _OASEligibleSurg = "1"
    End If
    
	if (strHCPCS = "G0104" Or strHCPCS = "GO105" Or strHCPCS = "GO121" Or strHCPCS = "G0260")
		_OASEligibleSurg = "1"
	End If

	if (strHCPCS_2 = "G0104" Or strHCPCS_2 = "GO105" Or strHCPCS_2 = "GO121" Or strHCPCS_2 = "G0260")
		_OASEligibleSurg = "1"
	End If

	if (strHCPCS_3 = "G0104" Or strHCPCS_3 = "GO105" Or strHCPCS_3 = "GO121" Or strHCPCS_3 = "G0260")
		_OASEligibleSurg = "1"
	End If

    ''Cleanup
    objServiceRS.Close
    Set objServiceRS = Nothing
    
	OASEligibleSurg = _OASEligibleSurg

End Function'

if not exists(select 1 from dbo.functions where strFunction_nm = 'OASEligibleSurg')
insert into dbo.functions(strFunction_nm,strFunction_Sig,strFunction_dsc,
strFunction_Code,bitVBS,Client_id,FunctionGroup_id)
Values('OASEligibleSurg','OASEligibleSurg(strCPT4,strCPT4_2,strCPT4_3,strHCPCS,strHCPCS_2,strHCPCS_3)','Are CPT and HCPCS Codes Valid?',
@function,0,0,23)

GO