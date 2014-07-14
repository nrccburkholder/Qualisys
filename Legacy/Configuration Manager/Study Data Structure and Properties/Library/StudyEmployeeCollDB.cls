VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "StudyEmployeeCollDB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' SH 08-20-02 Removed MTS and ObjectContext.

Private objBuffer As Buffer

Private Sub Class_Initialize()

    Set objBuffer = New Buffer
    
End Sub

Public Sub Fetch(ByVal StudyID As Long)

    Dim sSQL As String
    Dim rs As New ADODB.Recordset
    Dim objDB As StudyEmployeeDB
  
    On Error GoTo errhandler
  
    sSQL = "SELECT Employee_ID FROM Study_Employee WHERE Study_id=" & StudyID
    
    
    Set rs = cn.Execute(sSQL)
   
    Set objDB = CreateObject("StudyDataPROC.StudyEmployeeDB")
    
    Set objBuffer = Nothing
    Set objBuffer = New Buffer
    With objDB
        objBuffer.Initialize Len(.GetState), 20
        Do While Not rs.EOF
            .Fetch StudyID, rs("Employee_ID")
            objBuffer.Add .GetState
            rs.MoveNext
        Loop
    End With
    Set objDB = Nothing
    rs.Close
    Set rs = Nothing
    
    Exit Sub
  
errhandler:
    If Not rs Is Nothing Then
        rs.Close
        Set rs = Nothing
    End If
    App.LogEvent "StudyEmployeeColl Fetch - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
    
End Sub

Public Sub Save(ByVal StudyID As Long)
  
    Dim objDB As StudyEmployeeDB
    Dim objUpdatedStudyEmployees As Buffer
    Dim lngIndex As Long
    
    On Error GoTo errhandler
    
    Set objUpdatedStudyEmployees = New Buffer
    With objBuffer
        objUpdatedStudyEmployees.Initialize .Length, .Count
    End With
   
    Set objDB = CreateObject("StudyDataPROC.StudyEmployeeDB")
    
    For lngIndex = 1 To objBuffer.Count
        With objDB
            .SetState objBuffer.Item(lngIndex)
            .SaveChild StudyID
            If Not .IsDeleted Then
                objUpdatedStudyEmployees.Add .GetState
            Else
                .GetState
            End If
        End With
    Next
    Set objDB = Nothing
    Set objBuffer = objUpdatedStudyEmployees
    
    Exit Sub
  
errhandler:
    App.LogEvent "StudyEmployeeColl Save - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError

End Sub

Public Sub SetState(ByVal Buffer As String)
    
    Set objBuffer = New Buffer
    objBuffer.SetState Buffer
    
End Sub

Public Function GetState() As String
    
    GetState = objBuffer.GetState
        
End Function
