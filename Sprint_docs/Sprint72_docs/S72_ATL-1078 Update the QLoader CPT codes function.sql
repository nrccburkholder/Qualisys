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
    
    strSQL = "select CptCode from OasExcludedCptCode where CptCode = ''" & strCPT4 & "'' union 
			select CptCode from OasExcludedCptCode where CptCode = ''" & strCPT4_2 & "'' union 
			select CptCode from OasExcludedCptCode where CptCode = ''" & strCPT4_3 & "'' union 
			select CptCode from OasExcludedCptCode where CptCode = ''" & strHCPCS & "'' union 
			select CptCode from OasExcludedCptCode where CptCode = ''" & strHCPCS_2 & "'' union 
			select CptCode from OasExcludedCptCode where CptCode = ''" & strHCPCS_3 & "'' "

    Set objServiceRS = mobjConn.Execute(strSQL)
    
    ''Get the Service
    If objServiceRS.EOF Then
        OASEligibleSurg = "0"
    Else
        OASEligibleSurg = "1"
    End If
    
    ''Cleanup
    objServiceRS.Close
    Set objServiceRS = Nothing
    
End Function'

if not exists(select 1 from dbo.functions where strFunction_nm = 'OASEligibleSurg')
insert into dbo.functions(strFunction_nm,strFunction_Sig,strFunction_dsc,
strFunction_Code,bitVBS,Client_id,FunctionGroup_id)
Values('OASEligibleSurg','OASEligibleSurg(strCPT4,strCPT4_2,strCPT4_3,strHCPCS,strHCPCS_2,strHCPCS_3)','Are CPT and HCPCS Codes Valid?',
@function,0,0,23)

GO