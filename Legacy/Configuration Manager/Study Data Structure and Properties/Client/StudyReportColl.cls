VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "StudyReportColl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private colStudyReports As Collection
Private colDeleted As Collection

Private fldChildEditing As Boolean

Public Sub ChildBeginEdit()
  
    Dim objStudyReport As StudyReport
    
    If fldChildEditing Then Err.Raise 445
    
    ' save object state
    For Each objStudyReport In colStudyReports
        objStudyReport.ChildBeginEdit
    Next
    
    fldChildEditing = True

End Sub

Public Sub ChildCancelEdit()
  
    Dim objStudyReport As StudyReport
    Dim lngIndex As Long
    
    If Not fldChildEditing Then Err.Raise 445
    
    fldChildEditing = False
    
    For lngIndex = colDeleted.Count To 1 Step -1
        With colDeleted
            colStudyReports.Add Item:=.Item(lngIndex)
            .Remove lngIndex
        End With
    Next
    
    For lngIndex = colStudyReports.Count To 1 Step -1
        Set objStudyReport = colStudyReports.Item(lngIndex)
        With objStudyReport
            .ChildCancelEdit
            If .IsNew Then _
                colStudyReports.Remove lngIndex
        End With
    Next lngIndex

End Sub

Public Sub ChildApplyEdit(StudyID As Long)
    
    Dim objDB As StudyReportCollDB
    Dim objStudyDB As StudyDB
    Dim objStudyReport As StudyReport
    
    If Not fldChildEditing Then Err.Raise 445
    
    Set objDB = New StudyReportCollDB
    With objDB
        .SetState GetState
        .Save StudyID
        SetState .GetState
    End With
    Set objDB = Nothing
  
    fldChildEditing = False
    
End Sub

Friend Sub Load(StudyID As Long)
  
    Dim objDB As StudyReportCollDB
    If fldChildEditing Then Err.Raise 445
    
    Set objDB = New StudyReportCollDB
    With objDB
        .Fetch StudyID
        SetState .GetState
    End With
    Set objDB = Nothing

End Sub

Public Sub Remove(ByVal Index As Variant)
  
    Dim objStudyReport As StudyReport
    
    If Not fldChildEditing Then Err.Raise 445
    
    Set objStudyReport = colStudyReports.Item(Index)
    objStudyReport.Delete
    colDeleted.Add Item:=objStudyReport
    colStudyReports.Remove Index

End Sub

Public Sub Delete()
  
    Dim objStudyReport As StudyReport
    Dim lngIndex As Long
    
    If Not fldChildEditing Then Err.Raise 445
    
    For lngIndex = colStudyReports.Count To 1 Step -1
        Set objStudyReport = colStudyReports.Item(lngIndex)
        objStudyReport.Delete
        colDeleted.Add Item:=objStudyReport
        colStudyReports.Remove lngIndex
    Next

End Sub

Private Sub Class_Initialize()
  
    Set colStudyReports = New Collection
    Set colDeleted = New Collection

End Sub

Public Function Add() As StudyReport
  
    Dim objStudyReport As StudyReport
    
    Set objStudyReport = New StudyReport
    objStudyReport.SetAsChild
    Set objStudyReport.Parent = Me
    If fldChildEditing Then objStudyReport.ChildBeginEdit
    Set Add = objStudyReport

End Function

Friend Sub AddChild(NewStudyReport As StudyReport)
  
    colStudyReports.Add Item:=NewStudyReport

End Sub

Public Function Item(ByVal Index As Variant) As StudyReport
Attribute Item.VB_UserMemId = 0
  
    Set Item = colStudyReports(Index)
    
End Function

Public Function Count() As Long
    
    Count = colStudyReports.Count
    
End Function

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
  
    Set NewEnum = colStudyReports.[_NewEnum]
    
End Function

Private Sub SetState(ByVal Buffer As String)
  
    Dim lngIndex As Long
    Dim objStudyReport As StudyReport
    Dim objBuffer As Buffer
    
    Set colStudyReports = New Collection
    Set colDeleted = New Collection
    
    Set objBuffer = New Buffer
    objBuffer.SetState Buffer
    
    For lngIndex = 1 To objBuffer.Count
        Set objStudyReport = New StudyReport
        With objStudyReport
            .SetAsChild
            .SetState objBuffer.Item(lngIndex)
        End With
        colStudyReports.Add Item:=objStudyReport
    Next

End Sub

Private Function GetState() As String
  
    Dim objBuffer As Buffer
    Dim objStudyReport As StudyReport
    
    Set objBuffer = New Buffer
    Set objStudyReport = New StudyReport
    objBuffer.Initialize Len(objStudyReport.GetState), 20
    
    For Each objStudyReport In colDeleted
        objBuffer.Add objStudyReport.GetState
    Next
    
    For Each objStudyReport In colStudyReports
        objBuffer.Add objStudyReport.GetState
    Next
    
    GetState = objBuffer.GetState
    Set objBuffer = Nothing

End Function
