/*
	RTP-3604 QLoader Skipped Recs Alpha-Numeric CPT.sql

	Chris Burkholder

	Update Functions

*/

use [qp_load]
go

--select CptCode from OasExcludedCptCode where CptCode = ''
declare @topBlock nvarchar(1000)
select @topBlock = Substring(strFunction_code,1,CharIndex('Public Sub', strFunction_code)-1) from Functions where strfunction_nm = 'OASEligibleSurg'

declare @function nvarchar(4000)
set @function = 'Public Sub InitOASESConnection()
    
    ''Open the database connection
    ''If mobjOASESConn Is Nothing Then
        Set mobjOASESConn = CreateObject("ADODB.connection")
        mobjOASESConn.Open mkstrQPLoadOASESConn
    ''End If

End Sub

Function OASEligibleSurg(strCPT4,strCPT4_2,strCPT4_3,strHCPCS,strHCPCS_2,strHCPCS_3)
    
    Dim strSQL
    Dim objServiceRS
    Set objServiceRS = Nothing
    
    Dim LOasEligibleSurg
    LOasEligibleSurg = "0"

if IsNumeric(strCPT4) Then
    strSQL = "select CptCode from OasExcludedCptCode where CptCode = ''" & strCPT4 & "''"
    Set objServiceRS = mobjOASESConn.Execute(strSQL)
    If (strCPT4 >= 10021 And strCPT4 <= 69990 and objServiceRS.EOF) Then
        LOASEligibleSurg = "1"
    End If
End If

If IsNumeric(strCPT4_2) Then
    strSQL = "select CptCode from OasExcludedCptCode where CptCode = ''" & strCPT4_2 & "''"
    Set objServiceRS = mobjOASESConn.Execute(strSQL)
    If (strCPT4_2 >= 10021 And strCPT4_2 <= 69990 and objServiceRS.EOF) Then
        LOASEligibleSurg = "1"
    End If
End If

If IsNumeric(strCPT4_3) Then
    strSQL = "select CptCode from OasExcludedCptCode where CptCode = ''" & strCPT4_3 & "''"
    Set objServiceRS = mobjOASESConn.Execute(strSQL)
    If (strCPT4_3 >= 10021 And strCPT4_3 <= 69990 And objServiceRS.EOF) Then
        LOASEligibleSurg = "1"
    End If
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
    If IsNumeric(strCPT4) Or IsNumeric(strCPT4_2) Or IsNumeric(strCPT4_3) Then
        objServiceRS.Close
        Set objServiceRS = Nothing
    End If
    OASEligibleSurg = LOASEligibleSurg

End Function'

update functions set strfunction_code = @TopBlock + @function where strfunction_nm = 'OASEligibleSurg'

GO