VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "StudyCreate"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Sub GO(anEmployeeID As Long)
    
    Dim aForm As New frmNewStudy
    Dim anObj As StudyEmployee
        
    If Not G_Study Is Nothing Then _
        Set G_Study = Nothing
    
    Set G_Study = New Study
    aForm.Component G_Study
    aForm.Show vbModal
    
    If G_Study.ID > 0 Then
        G_Study.BeginEdit
        Set anObj = G_Study.StudyEmployeeColl.Add
        anObj.BeginEdit
        anObj.employeeID = anEmployeeID
        anObj.ApplyEdit
        G_Study.ApplyEdit
    End If
    
End Sub

' 03-15-2006 SH Added for Config Manager .NET
' Passed client ID instead of letting user pick from the combo box
' since the client is already selected from the client tree.
Public Sub NewGO(ByVal employeeID As Long, ByVal clientID As Long)
    Dim newStudy As New frmNewStudy
    Dim obj As StudyEmployee
        
    If clientID = 0 Then Return
    
    If Not G_Study Is Nothing Then _
        Set G_Study = Nothing
    
    Set G_Study = New Study
    
    With newStudy
        .Component G_Study
        .mClientID = clientID
        .Show vbModal
    End With
        
    If G_Study.ID > 0 Then
        G_Study.BeginEdit
        Set obj = G_Study.StudyEmployeeColl.Add
        With obj
            .BeginEdit
            .employeeID = employeeID
            .ApplyEdit
        End With
        G_Study.ApplyEdit
    End If
End Sub
' End of addition

Public Property Get NewStudyID() As Long
    
    If Not G_Study Is Nothing Then
        NewStudyID = G_Study.ID
    Else
        NewStudyID = 0
    End If

End Property

Public Property Get NewStudyName() As String
    
    If Not G_Study Is Nothing Then
        NewStudyName = G_Study.name
    Else
        NewStudyName = ""
    End If

End Property
