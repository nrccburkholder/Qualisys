VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "GetEmpIdDll"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'-----------------------------------------------------------------
' Copyright © National Research Corporation
'
' Required References:
'       Microsoft ActiveX Data Objects 2.5 Library
'       QualiSysFunctions
'       OLE Automation
'
' Revisions:
'   Date        By      Description
'   04-10-2002  SH      Removed MTS objects from GetEmpIDMTS
'                       and called it GetEmpIDPROC.
'   09-27-2002  FG      Merged GetEmpIdPROC with GetEmpId.
'   09-28-2002  SH      Removed DBConnection.
'   09-29-2002  SH      Renamed QualProFunctions to
'                       QualiSysFunctions.
'   10-01-2002  SH      Recompiled with VB6.0 and moved DLL to
'                       \components\QualiSysDLLs\
'   05-05-2005  SH      Added Country ID when extracting the
'                       employee information.
'-----------------------------------------------------------------
Option Explicit

Dim lngUserEmpID        As Long
Dim strUserName         As String
Dim strUserLastName     As String
Dim strUserFirstName    As String
Dim strLoginName        As String
Dim strUserTitle        As String
Dim lngUserCountryID    As Long ' 05-05-2005 SH Added
Dim lngEnvCountryID     As Long ' 05-06-2005 SH Added
Dim cn As New ADODB.Connection

Event componentError(errNum As Integer, errSource As String, errDescription As String)

Public Property Get UserEmployeeID()
    UserEmployeeID = lngUserEmpID
End Property

Public Property Get UserFirstName()
    UserFirstName = strUserFirstName
End Property

Public Property Get UserLastName()
    UserLastName = strUserLastName
End Property

Public Property Get UserTitle()
    UserTitle = strUserTitle
End Property

Public Property Get UserLoginName()
    UserLoginName = strUserName
End Property

' *** 05-05-2005 SH Added
Public Property Get UserCountryID()
    UserCountryID = lngUserCountryID
End Property

Public Property Get EnvCountryID()
    EnvCountryID = lngEnvCountryID
End Property
' *** End of addition

Public Function RetrieveUserEmployeeID() As Boolean
    Dim pstrUserName    As String * 20
    Dim plngNameLen     As Long
    Dim strSql As String
    Dim rsEmployee As New ADODB.Recordset
    
    On Error GoTo errGetEmployee_Id
    
    ' The string being (pstrUserName)
    ' passed in to receive the results
    ' must be wide enough to receive the string
    ' being passed back by the function
    RetrieveUserEmployeeID = False
    
    ' *** 05-06-2005 SH Added
    ' Get the country ID for the environment from
    ' QualPro_Params
    Dim rs As New ADODB.Recordset
    Dim SQL As String

    SQL = "Select NumParam_Value From QualPro_Params " & _
          "Where strParam_nm = 'Country' " & _
          "And strParam_grp = 'Environment'"
    
    rs.Open SQL, cn, adOpenKeyset
    
    If Not rs.EOF And Not rs.BOF Then
        lngEnvCountryID = rs!NumParam_Value
    Else
        RetrieveUserEmployeeID = False
    End If
    
    rs.Close
    Set rs = Nothing
    ' *** End of addition
    
    ' The length of the string being
    ' passed in to receive the results
    ' must be determined and sent to function
    plngNameLen = Len(pstrUserName)
    
    ' Call the API function
    ' (it returns a zero if name not
    ' returned and non-zero value if
    ' it is returned
    If GetUserName(pstrUserName, plngNameLen) Then
        pstrUserName = StripNulls(pstrUserName)
        strUserName = pstrUserName
        
        strSql = "SELECT * FROM Employee WHERE " & _
                 "strNTLogin_nm = '" & pstrUserName & "'"
    
        rsEmployee.Open strSql, cn, adOpenKeyset
    
        If Not rsEmployee.EOF And Not rsEmployee.BOF Then
            lngUserEmpID = rsEmployee!employee_id
            strUserFirstName = rsEmployee!strEmployee_first_nm
            strUserLastName = rsEmployee!strEmployee_last_nm
            strUserTitle = rsEmployee!strEmployee_title
            strUserName = rsEmployee!strNTLogin_nm
            ' 05-05-2005 SH Added
            lngUserCountryID = rsEmployee!Country_id
            RetrieveUserEmployeeID = True
        End If
        
        rsEmployee.Close
        Set rsEmployee = Nothing
                
        'If objEmpId.fctGetEmployee_ID(pstrUserName) Then
        '    lngUserEmpID = objEmpId.UserEmployeeID
        '    strUserFirstName = objEmpId.UserFirstName
        '    strUserLastName = objEmpId.UserLastName
        '    strUserTitle = objEmpId.UserTitle
        '    strLoginName = objEmpId.UserLoginName
        '    RetrieveUserEmployeeID = True
        'End If
    End If
    
    Exit Function
    
errGetEmployee_Id:
    App.LogEvent Err.Description, vbLogEventTypeError
    RaiseEvent componentError(Err.Number, Err.Source, Err.Description)
End Function

Function StripNulls(ByRef pstrLoginName As String)
    Dim lngPos As Long
    
    lngPos = InStr(pstrLoginName, Chr(0))
    
    If lngPos > 0 Then
        StripNulls = Left$(pstrLoginName, lngPos - 1)
    End If
End Function

Private Sub Class_Initialize()
    ' 09-28-2002 SH
    ' Removed DBConnection.
    'Dim QualiSysConnect As New DBConnection.Connection
    Dim QualiSysConnect As New QualiSysFunctions.Library
    
    'Set the ADO connection
    cn.ConnectionString = QualiSysConnect.GetDBString
    cn.Open
    Set QualiSysConnect = Nothing
End Sub
