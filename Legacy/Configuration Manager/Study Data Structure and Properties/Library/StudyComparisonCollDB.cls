VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "StudyComparisonCollDB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
' SH 08-20-02 Removed MTS and ObjectContext.
Option Explicit

Private objBuffer As Buffer

Private Sub Class_Initialize()
    Set objBuffer = New Buffer
End Sub

Public Sub Fetch(ByVal StudyID As Long)
    Dim sSQL As String
    Dim rs As New ADODB.Recordset
    Dim objDB As StudyComparisonDB
  
    On Error GoTo errhandler
  
    sSQL = "SELECT StudyComparison_ID FROM StudyComparison WHERE Study_id=" & StudyID
    Set rs = cn.Execute(sSQL)
  
    Set objDB = CreateObject("StudyDataPROC.StudyComparisonDB")
    
    Set objBuffer = Nothing
    Set objBuffer = New Buffer
    
    With objDB
        objBuffer.Initialize Len(.GetState), 20
        Do While Not rs.EOF
            .Fetch rs("StudyComparison_ID")
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
    App.LogEvent "StudyComparisonColl Fetch - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub

Public Sub Save(ByVal StudyID As Long)
    Dim objDB As StudyComparisonDB
    Dim objUpdatedStudyComparisons As Buffer
    Dim lngIndex As Long
    
    On Error GoTo errhandler
    
    Set objUpdatedStudyComparisons = New Buffer
    With objBuffer
        objUpdatedStudyComparisons.Initialize .Length, .Count
    End With
  
    Set objDB = CreateObject("StudyDataPROC.StudyComparisonDB")
    
    For lngIndex = 1 To objBuffer.Count
        With objDB
            .SetState objBuffer.Item(lngIndex)
            .SaveChild StudyID
            If Not .IsDeleted Then
                objUpdatedStudyComparisons.Add .GetState
            Else
                .GetState
            End If
        End With
    Next
    Set objDB = Nothing
    Set objBuffer = objUpdatedStudyComparisons
    
    Exit Sub
  
errhandler:
    App.LogEvent "StudyComparisonColl Save - " & Err.Description & _
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
