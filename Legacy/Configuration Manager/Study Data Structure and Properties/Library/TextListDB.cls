VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "TextListDB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' SH 08-20-02 Removed MTS and ObjectContext.

Private objBuffer As Buffer

Public Sub Fetch(ByVal ListName As String)
    
    Dim sSQL As String
    Dim rs As New ADODB.Recordset
    Dim udtProps As TextListProps
    Dim udtData As TextListData
        
    On Error GoTo errhandler
    
    '*SQL7.0*
    Select Case ListName
        Case "ClientList"
            sSQL = "SELECT QPC_id=client_id, description=strClient_nm  FROM Client order by strClient_nm"
        Case "EmployeeList"
            sSQL = "SELECT QPC_id=Employee_id, description=strEmployee_first_nm + ' ' + strEmployee_last_nm FROM Employee ORDER BY strEmployee_first_nm + ' ' + strEmployee_last_nm"
        Case "EmployeeExtList"
            sSQL = "SELECT QPC_id=Employee_id, description=strPhoneExt FROM Employee ORDER BY strEmployee_first_nm + ' ' + strEmployee_last_nm"
        Case "EmployeeEmailList"
            sSQL = "SELECT QPC_id=Employee_id, description=strEmail FROM Employee ORDER BY strEmployee_first_nm + ' ' + strEmployee_last_nm"
        Case "ComparisonTypeList"
             sSQL = "SELECT QPC_id=comparisonType_id, description=strComparisonType_cd FROM ComparisonType"
            'sSQL = "SELECT QPC_id=mktguideplantype_id, description=strmktguide_plantype from mktguide_plantype"
        Case "MSAList"
            sSQL = "SELECT QPC_id=MSA_id, description=MSA_desc FROM MSA"
        Case "StateList"
            sSQL = "SELECT QPC_id=State_id, description=state_nm FROM State ORDER BY State_nm"
        Case "ReportTypeList"
            sSQL = "SELECT QPC_id=ReportType_id, description=strReportType_cd FROM ReportType"
        'I added this case method, DW
        Case "MGPT"
            sSQL = "SELECT QPC_id=mktguideplantype_id, description=strmktguide_plantype from mktguide_plantype"
        Case Else
            Err.Raise vbObjectError + 1001, "TextList Name is invalid"
    End Select
    
    Set objBuffer = New Buffer
    objBuffer.Initialize Len(udtData), 50
        
    rs.Open sSQL, cn
    Do While Not rs.EOF
        With udtProps
            If Not IsNull(rs("description")) Then
                .Item = rs("description")
            Else
                .Item = ""
            End If
            '*SQL7.0*
            .Key = rs("QPC_id")
        End With
        LSet udtData = udtProps
        objBuffer.Add udtData.Buffer
        rs.MoveNext
    Loop
    rs.Close
    
    Set rs = Nothing
    
    Exit Sub

errhandler:
    If Not rs Is Nothing Then
        rs.Close
        Set rs = Nothing
    End If
    App.LogEvent "List Fetch - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
    
End Sub

Public Function GetState() As String
    
    On Error GoTo errhandler
    
    GetState = objBuffer.GetState
        
    Exit Function
    
errhandler:
    App.LogEvent Err.Number & ", " & Err.Source & ", " & Err.Description
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

Public Sub FetchClientContacts(ByVal ClientID As Long)
    
    Dim sSQL As String
    Dim rs As New ADODB.Recordset
    Dim udtProps As TextListProps
    Dim udtData As TextListData
  
    On Error GoTo errhandler
      
    
    '*SQL7.0*
    'sSQL = "SELECT QPC_id=contact_id, description=strContactFirst_nm + ' ' + strContactLast_nm  FROM client_contact WHERE Client_id = " & ClientID
    sSQL = "SELECT QPC_id=min(contact_id), description=strContactName FROM client_contact WHERE Client_id = " & ClientID & " group by strContactName"
    
    Set objBuffer = New Buffer
    objBuffer.Initialize Len(udtData), 50
    
    rs.Open sSQL, cn
    Do While Not rs.EOF
        With udtProps
            .Item = Trim(rs("Description"))
            '*SQL7.0*
            .Key = rs("QPC_id")
        End With
        LSet udtData = udtProps
        objBuffer.Add udtData.Buffer
        rs.MoveNext
    Loop
    
    rs.Close
    Set rs = Nothing
    
    Exit Sub

errhandler:
    If Not rs Is Nothing Then
        rs.Close
        Set rs = Nothing
    End If
    App.LogEvent "List FetchClientContacts - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
    
End Sub
