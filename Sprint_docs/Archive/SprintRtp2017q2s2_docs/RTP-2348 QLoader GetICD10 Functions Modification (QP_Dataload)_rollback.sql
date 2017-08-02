USE [QP_DataLoad]

GO
  
DECLARE @Code VARCHAR(MAX) = '
Function _GetHomeHealthSurg(ByVal strSurg As String) As String
	If UCase(strSurg) = "Y" Or strSurg = "1" Then 
		Return "1" 
	ElseIf UCase(strSurg) = "N" Or strSurg = "2" Then 
		Return "2" 
	Else 
		Return "M"    ''value for missing
	End If  
End Function

Function _GetHomeHealthESRD(ByVal strESRD As String) As String
	If UCase(strESRD) = "Y" Then
		Return "1"
	ElseIf UCase(strESRD) = "N" Then
		Return "2" 
	Else
		Return "M" 
	End If  
End Function

Function _GetHomeHealthADLDef(ByVal intDefCnt As Integer) As String
	If intDefCnt >= 0 And intDefCnt <= 6 Then
		Return CStr(intDefCnt)
	Else
		Return "M"
	End If
End Function


Function _GetHomeHealthCatAge(ByVal intAge As Integer)  As String
	If IsNull(intAge) Then
		Return "M"    ''code for missing value
	ElseIf IsNumeric(intAge) Then
		If intAge = 9999 Or intAge < 18 Then
			Return "M"
		ElseIf intAge < 25 Then
			Return "01"
		ElseIf intAge < 30 Then
			Return "02"
		ElseIf intAge < 35 Then
			Return "03"
		ElseIf intAge < 40 Then
			Return "04"
		ElseIf intAge < 45 Then
			Return "05"
		ElseIf intAge < 50 Then
			Return "06"
		ElseIf intAge < 55 Then
			Return "07"
		ElseIf intAge < 60 Then
			Return "08"
		ElseIf intAge < 65 Then
			Return "09"
		ElseIf intAge < 70 Then
			Return "10"
		ElseIf intAge < 75 Then
			Return "11"
		ElseIf intAge < 80 Then
			Return "12"
		ElseIf intAge < 85 Then
			Return "13"
		ElseIf intAge < 90 Then
			Return "14"
		ElseIf intAge >= 90 Then
			Return "15"
		Else              
			Return "M"    ''code for missing value
		End If      
	Else          
		Return "M"    ''code for missing value
	End If  
End Function

Function _GetHomeHealthAdm(ByVal strAdmSrc As String) as String
	If UCase(strAdmSrc) = "Y" Or strAdmSrc = "1" Then
		Return "1"
	Else
		Return "M"    ''value for mising      
	End If  
End Function

Function _GetHomeHealthPayer(ByVal strPayer As String)  As String
	If UCase(strPayer) = "Y" Or strPayer = "1" Then
		Return "1"
	Else
		Return "M"    ''value for missing      
	End If  
End Function

Function _GetHomeHealthHMO(ByVal strHMO As String) As String
	If UCase(strHMO) = "Y" Or strHMO = "1" Then
		Return "1"
	ElseIf UCase(strHMO) = "N"  Or strHMO = "2" Then 
		Return "2"
	Else
		Return "M"    ''value for missing      
	End If  
End Function

Function _GetHomeHealthDual(ByVal strDual As String)  As String
	If UCase(strDual) = "Y" Or strDual = "1" Then          
		Return "1"
	ElseIf UCase(strDual) = "N" Or strDual = "2" Then      
		Return "2"
	ElseIf UCase(strDual) = "NA" Or strDual = "3" Then
		Return "3"
	Else
		Return "M"    ''value for missing      
	End If  
End Function

Function _GetHomeHealthPrimaryICD9(ByVal strValue As String)  As String     
	If Len(strValue) > 0 And strValue IsNot Nothing Then
		dim objRegExp as RegEx = new RegEx( "^(V\d{2}(\.\d{1,2})?|\d{3}(\.\d{1,2})?|E\d{3}(\.\d)?)$", RegexOptions.IgnoreCase)
	
		If objRegExp.IsMatch(strValue) = TRUE Then
			If InStr(strValue,Chr(46)) Then          
				strValue = Replace(strValue, Chr(46), "")      
			End If  
			If IsNumeric(Left(strValue,1)) Then
				Return Right("00000" & strValue, 5)
			Else
				If InStr(strValue,"E") Then
					Return nothing
				Else
					Return strValue
				End If
			End If
		Else
			Return Nothing
		End If

		objRegExp = nothing
	else
		Return nothing
	End If
End Function


Function _GetHomeHealthICD9(ByVal strValue As String)    As String   
	If Len(strValue) > 0 And strValue IsNot Nothing Then
		dim objRegExp as RegEx = new RegEx("^(V\d{2}(\.\d{1,2})?|\d{3}(\.\d{1,2})?|E\d{3}(\.\d)?)$",RegexOptions.IgnoreCase)
		
		If objRegExp.IsMatch(strValue) = TRUE Then
			If InStr(strValue,Chr(46)) Then          
				strValue = Replace(strValue, Chr(46), "")      
			End If  
			If IsNumeric(Left(strValue,1)) Then
				Return Right("00000" & strValue, 5)
			Else
				Return strValue
			End If
		Else
			Return nothing
		End If

		objRegExp = nothing
	else
		Return nothing
	End If
End Function


 Function _GetHomeHealthICD10(ByVal strValue As String) As String
        If Len(strValue) > 0 And strValue IsNot Nothing Then
            Dim objRegExp As Regex = New Regex("^[A-TV-Z][0-9][A-Z0-9](\.[A-Z0-9]{1,4})?$", RegexOptions.IgnoreCase)

            If objRegExp.IsMatch(strValue) = True Then
                Return strValue
            Else
                Return Nothing
            End If

            objRegExp = Nothing
        Else
            Return Nothing
        End If
    End Function


Function _GetHHADLAll(ByVal strADLValue  As String, ByVal strADLName  As String)  As String
    Select Case UCase(strADLName)
    	Case "BATH"
        	Select Case strADLValue
        		Case "0","1","2","3","4","5","6","M"
            		Return strADLValue
        		Case Else
            		Return "M"
        	End Select
    	Case "DRESSUP","DRESSLOW"
	        Select Case strADLValue
		        Case "0","1","2","3","M"
		            Return strADLValue
		        Case Else
		            Return "M"
	        End Select
	    Case "FEED","TRANSFER"
	        Select Case strADLValue
		        Case "0","1","2","3","4","5","M"
		            Return strADLValue
		        Case Else
		            Return "M"
	        End Select
	    Case "TOILET"
	        Select Case strADLValue
		        Case "0","1","2","3","4","M"
		            Return strADLValue
		        Case Else
		            Return "M"
	        End Select
	    Case Else
	        Return "Invalid ADL Name"
    End Select
End Function'

UPDATE [dbo].[TransformLibrary] SET [Code] = @Code WHERE TransformLibraryName = 'c_HHCAHPS_Functions'

GO