VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "StudyDataStructure"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Sub GO(aStudyID As Long, InEditMode As Boolean)

    Dim aForm As New frmStudyDataStruct
    
'    If G_Study Is Nothing Then
'        Set G_Study = New Study
'        G_Study.Load (aStudyID)
'    Else 'study already exists
'        If Not (G_Study.ID = aStudyID) Then _
'            G_Study.Load (aStudyID)
'    End If
        
    Set G_Study = New StudyDataClient.Study
    G_Study.Load (aStudyID)
    aForm.EditMode = InEditMode

    aForm.Show vbModal
    Set G_Study = Nothing

End Sub

Public Sub GenerateBigView(aStudyID As Long)
'
'    Dim aForm As New frmStudyDataStruct
'
''    If G_Study Is Nothing Then
''        Set G_Study = New Study
''        G_Study.Load (aStudyID)
''    Else 'study already exists
''        If Not (G_Study.ID = aStudyID) Then
''            Set G_Study = Nothing
''            Set G_Study = New Study
''            G_Study.Load (aStudyID)
''        End If
''    End If
'
'    Set G_Study = New Study
'    G_Study.Load (aStudyID)
'    aForm.Show vbModal
'    G_Study.GenerateBigView
'    Set G_Study = Nothing
'
End Sub
