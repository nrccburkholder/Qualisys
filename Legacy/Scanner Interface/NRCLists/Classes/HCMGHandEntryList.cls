VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "HCMGHandEntryList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
    
    Private mstrTemplateID  As String
    
    Private mobjPrecodes    As Precodes
    
Public Function GetList(ByVal strBarcode As String) As Codes
    
    Dim lngPreCodeGroup As Long
    
    'Get the precode group from the barcode
    lngPreCodeGroup = Val(Trim(Mid(strBarcode, 5, 3)))
    
    'Return the code collection
    Set GetList = mobjPrecodes.GetList(lngPreCodeGroup:=lngPreCodeGroup)
    
End Function


Public Sub Initialize(ByVal strTemplateID As String)
    
    Dim lngTemplate     As Long
    Dim lngMaxLength    As Long
    Dim strNoUse        As String
    Dim strFormat       As String
    Dim objConn         As ADODB.Connection
    Dim objPrecodeCm    As ADODB.Command
    Dim objNoUseCm      As ADODB.Command
    Dim objTempRs       As ADODB.Recordset
    Dim bolIsAccess     As Boolean
    
    'Open the database connection
    ReadRegistry
    OpenDBConnection objConn:=objConn, strConnString:=gobjRegHCMGDBConnString.Value
    
    'Determine if we are using the access Database
    If InStr(UCase(objConn.ConnectionString), "{MICROSOFT ACCESS") > 0 Then
        bolIsAccess = True
    Else
        bolIsAccess = False
    End If
    
    'Setup the precode select command
    Set objPrecodeCm = New ADODB.Command
    With objPrecodeCm
        .CommandText = "sp_NRCList_GetHospPrecodes"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 30
        .ActiveConnection = objConn
        .Parameters.Append .CreateParameter("intHospGroup_Cd", adInteger, adParamInput)
        If Not bolIsAccess Then
            .Parameters.Append .CreateParameter("intMaxLength", adInteger, adParamOutput)
        End If
    End With 'objPrecodeCm
    
    'Setup the no use list select command
    Set objNoUseCm = New ADODB.Command
    With objNoUseCm
        .CommandText = "sp_NRCList_GetNoUseList"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 30
        .ActiveConnection = objConn
    End With 'objNoUseCm
    
    'Clear the existing collection
    Set mobjPrecodes = Nothing
    
    'Create a new collection
    Set mobjPrecodes = New Precodes
    
    'Save the new template id
    mstrTemplateID = strTemplateID
    lngTemplate = Val(Trim(Mid(strTemplateID, 2)))
    
    'Get the appropriate precode data from the database
    objPrecodeCm.Parameters("intHospGroup_Cd") = lngTemplate
    Set objTempRs = objPrecodeCm.Execute
    
    'Populate the precode data collection
    With objTempRs
        Do Until .EOF
            mobjPrecodes.Add lngPreCodeGroup:=!intPreCodeGroup_Cd, _
                             lngMaxPreCode:=!intMaxPreCode_Cd
            
            'Prep for next pass
            .MoveNext
        Loop
    End With 'objTempRs
    objTempRs.Close: Set objTempRs = Nothing
    
    'Get the MaxLength for the format string
    If Not bolIsAccess Then
        lngMaxLength = objPrecodeCm.Parameters("intMaxLength").Value
    Else
        lngMaxLength = 2
    End If
    strFormat = String(lngMaxLength, "0")
    mobjPrecodes.FormatString = strFormat
    
    'Get the No Use List from the database
    Set objTempRs = objNoUseCm.Execute
    
    'Build the no use list string
    strNoUse = ","
    With objTempRs
        Do Until .EOF
            strNoUse = strNoUse & Format(!int_cd, strFormat) & ","
            
            'Prep for next pass
            .MoveNext
        Loop
    End With 'objTempRs
    objTempRs.Close: Set objTempRs = Nothing
    mobjPrecodes.NoUseList = strNoUse
    
    'Cleanup
    Set objPrecodeCm = Nothing
    Set objNoUseCm = Nothing
    CloseDBConnection objConn:=objConn
    CloseRegistry
    
End Sub

Private Sub Class_Terminate()
    
    Set mobjPrecodes = Nothing
    
End Sub


