VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "StudyEmployeeDB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' SH 08-20-02 Removed MTS and ObjectContext.

Private udtProps As StudyEmployeeProps

Public Sub SaveChild(StudyID As Long)
  
    With udtProps
        If .IsDeleted Then
            DeleteObject StudyID, .EmployeeID
        ElseIf .IsDirty Or .IsNew Then
            .StudyID = StudyID
            Save
        End If
    End With

End Sub

Public Sub Save()
    
    'Dim sSQL As String
    'Dim rs As New ADODB.Recordset
        
    'On Error GoTo errhandler
    
    'If udtProps.IsNew Then
    '    sSQL = "SELECT * from Study_Employee where Study_id=" & udtProps.StudyID & " and Employee_id=" & udtProps.EmployeeID
    '    rs.Open sSQL, cn, adOpenForwardOnly
    '    If rs.BOF Or rs.EOF Then
    '        rs.Close
    '        sSQL = "SELECT * from Study_Employee"
    '        rs.Open sSQL, cn, adOpenKeyset, adLockPessimistic
    '        rs.AddNew
    '        rs("Study_id") = udtProps.StudyID
    '        rs("employee_id") = udtProps.EmployeeID
    '        rs.Update
    '    End If
    'Else
        'should never be here
    '    Err.Raise 445
    'End If
         
    'rs.Close
    'Set rs = Nothing
           
    Exit Sub
    
errhandler:
    'If Not rs Is Nothing Then
    '    If rs.State = adStateOpen Then rs.Close
    '    Set rs = Nothing
    'End If
    App.LogEvent "StudyEmployee Save - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError

End Sub

Public Sub DeleteObject(StudyID As Long, EmployeeID As Long)
    
    Dim sSQL As String
    
    On Error GoTo errhandler
    
    'sSQL = "DELETE FROM Study_Employee WHERE Study_id = " & StudyID & " and Employee_id=" & EmployeeID
    'cn.Execute sSQL
        
    Exit Sub
    
errhandler:
    App.LogEvent "StudyEmployee DeleteObject - " & _
                 Err.Description & "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError

End Sub

Public Sub Fetch(ByVal StudyID As Long, EmployeeID As Long)

    udtProps.StudyID = StudyID
    udtProps.EmployeeID = EmployeeID

End Sub

Public Property Get IsDeleted() As Boolean
  
    IsDeleted = udtProps.IsDeleted
    
End Property

Public Sub SetState(Buffer As String)
  
    Dim udtData As StudyEmployeeData
    
    udtData.Buffer = Buffer
    LSet udtProps = udtData

End Sub

Public Function GetState() As String
    
    Dim udtData As StudyEmployeeData
    
    LSet udtData = udtProps
    GetState = udtData.Buffer
        
End Function
