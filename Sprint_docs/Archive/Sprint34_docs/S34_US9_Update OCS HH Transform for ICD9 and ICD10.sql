/*

S34 US9 Update Current OCS HHCAHPS Transform	As a Data Mgmt Associate, I want the current OCS HHCAHPS Transform mappings updated to map diagnoses fields to the new ICD10 fields, so that we collect data correctly for HH-CAHPS

Update ICD-9 fields to check if ICD-9s. Add ICD-10 fields mappings w/ check if ICD10s. Do not strip out dots. NULL if does not match ICD-10 pattern.

Tim Butler

Task 1 - update function list on QP_DataLoad 
Task 2 - map the 18 ICD-10 fields on QP_DataLoad 

TEST:		Ratchet (no existing tables)
STAGE:		Irish
PROD:		Minerva

*/

use QP_DataLoad

DECLARE @Code varchar(7000)

SET @Code = ' Function _GetHomeHealthSurg(ByVal strSurg As String) As String
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


Function _GetHomeHealthICD10(ByVal strValue As String)    As String   
	If Len(strValue) > 0 And strValue IsNot Nothing Then
		dim objRegExp as RegEx = new RegEx("^[A-TV-Z][0-9][A-Z0-9](\.[A-Z0-9]{1,4})?$",RegexOptions.IgnoreCase)
 
		If objRegExp.IsMatch(strValue) = TRUE Then
			Return strValue
		Else
			Return nothing
		End If

		objRegExp = nothing 
	ELSE
		Return nothing
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


begin tran

update [QP_DataLoad].[dbo].[TransformLibrary]
	SET Code = @Code,
		UpdateDate = GetDate(),
		UpdateUser = 'nrc\tbutler'
where TransformLibraryName = 'c_HHCAHPS_Functions'


SELECT [TransformLibraryId]
      ,[TransformLibraryName]
      ,[Code]
      ,[CreateDate]
      ,[CreateUser]
      ,[UpdateDate]
      ,[UpdateUser]
  FROM [QP_DataLoad].[dbo].[TransformLibrary]
  where TransformLibraryName = 'c_HHCAHPS_Functions'


commit tran

GO

begin tran

if not exists (SELECT * FROM [QP_DataLoad].[dbo].[TransformMapping] where TargetFieldname like 'ICD10%')
begin

	print 'creating ICD10 transforms from existing ICD9 transforms'

	insert into [QP_DataLoad].[dbo].[TransformMapping]
		SELECT[TransformTargetId]
			  ,[SourceFieldName]
			  ,REPLACE([TargetFieldname], 'ICD9', 'ICD10_1') [TargetFieldname]
			  ,'_GETHOMEHEALTHICD10(Records("R1").Fields("Primary Diagnosis ICD_A2"))' [Transform]
			  ,GetDate()
			  ,'nrc\tbutler'
			  ,[UpdateDate]
			  ,[UpdateUser]
		  FROM [QP_DataLoad].[dbo].[TransformMapping]
		 where TargetFieldname = 'ICD9'

	insert into [QP_DataLoad].[dbo].[TransformMapping]
		SELECT [TransformTargetId]
			  ,[SourceFieldName]
			  ,REPLACE([TargetFieldname], 'ICD9', 'ICD10') [TargetFieldname]
			  ,REPLACE([Transform], 'ICD9', 'ICD10') [Transform]
			  ,GETDATE()
			  ,'nrc\tbutler'
			  ,[UpdateDate]
			  ,[UpdateUser]
		  FROM [QP_DataLoad].[dbo].[TransformMapping]
		 where TargetFieldname like 'ICD9_%'

end
else print 'ICD10 transforms already exist'


SELECT *
FROM [QP_DataLoad].[dbo].[TransformMapping]
where TargetFieldname like 'ICD10%'

commit tran
