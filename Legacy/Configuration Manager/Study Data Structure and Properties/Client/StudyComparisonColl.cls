VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "StudyComparisonColl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private colStudyComparisons As Collection
Private colDeleted As Collection

Private fldChildEditing As Boolean

Public Sub ChildBeginEdit()
  
    Dim objStudyComparison As StudyComparison
    
    If fldChildEditing Then Err.Raise 445
    
    ' save object state
    For Each objStudyComparison In colStudyComparisons
        objStudyComparison.ChildBeginEdit
    Next
    fldChildEditing = True

End Sub

Public Sub ChildCancelEdit()
  
    Dim objStudyComparison As StudyComparison
    Dim lngIndex As Long
    
    If Not fldChildEditing Then Err.Raise 445
    
    fldChildEditing = False
    For lngIndex = colDeleted.Count To 1 Step -1
        With colDeleted
            colStudyComparisons.Add Item:=.Item(lngIndex)
            .Remove lngIndex
        End With
    Next
    
    For lngIndex = colStudyComparisons.Count To 1 Step -1
        Set objStudyComparison = colStudyComparisons.Item(lngIndex)
        With objStudyComparison
            .ChildCancelEdit
            If .IsNew Then _
                colStudyComparisons.Remove lngIndex
        End With
    Next lngIndex

End Sub

Public Sub ChildApplyEdit(StudyID As Long)
    
    Dim objDB As StudyComparisonCollDB
    Dim objStudyDB As StudyDB
    Dim objStudyComparison As StudyComparison
    
    If Not fldChildEditing Then Err.Raise 445
    
    Set objDB = New StudyComparisonCollDB
    With objDB
        .SetState GetState
        .Save StudyID
        SetState .GetState
    End With
    Set objDB = Nothing
  
    fldChildEditing = False
    
End Sub

Friend Sub Load(StudyID As Long)
  
    Dim objDB As StudyComparisonCollDB
    If fldChildEditing Then Err.Raise 445
    
    Set objDB = New StudyComparisonCollDB
    With objDB
        .Fetch StudyID
        SetState .GetState
    End With
    Set objDB = Nothing

End Sub

Public Sub Remove(ByVal Index As Variant)
  
    Dim objStudyComparison As StudyComparison
    
    If Not fldChildEditing Then Err.Raise 445
    
    Set objStudyComparison = colStudyComparisons.Item(Index)
    objStudyComparison.Delete
    colDeleted.Add Item:=objStudyComparison
    colStudyComparisons.Remove Index

End Sub

Public Sub Delete()
  
    Dim objStudyComparison As StudyComparison
    Dim lngIndex As Long
    
    If Not fldChildEditing Then Err.Raise 445
    
    For lngIndex = colStudyComparisons.Count To 1 Step -1
        Set objStudyComparison = colStudyComparisons.Item(lngIndex)
        objStudyComparison.Delete
        colDeleted.Add Item:=objStudyComparison
        colStudyComparisons.Remove lngIndex
    Next

End Sub

Private Sub Class_Initialize()
  
    Set colStudyComparisons = New Collection
    Set colDeleted = New Collection

End Sub

Public Function Add() As StudyComparison
  
    Dim objStudyComparison As StudyComparison
    
    Set objStudyComparison = New StudyComparison
    objStudyComparison.SetAsChild
    Set objStudyComparison.Parent = Me
    If fldChildEditing Then objStudyComparison.ChildBeginEdit
    Set Add = objStudyComparison

End Function

Friend Sub AddChild(NewStudyComparison As StudyComparison)
  
    colStudyComparisons.Add Item:=NewStudyComparison

End Sub

Public Function Item(ByVal Index As Variant) As StudyComparison
Attribute Item.VB_UserMemId = 0
  
    Set Item = colStudyComparisons(Index)

End Function

Public Function Count() As Long
    
    Count = colStudyComparisons.Count
    
End Function

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    
    Set NewEnum = colStudyComparisons.[_NewEnum]
    
End Function

Private Sub SetState(ByVal Buffer As String)
  
    Dim lngIndex As Long
    Dim objStudyComparison As StudyComparison
    Dim objBuffer As Buffer
    
    Set colStudyComparisons = New Collection
    Set colDeleted = New Collection
    
    Set objBuffer = New Buffer
    objBuffer.SetState Buffer
    
    For lngIndex = 1 To objBuffer.Count
        Set objStudyComparison = New StudyComparison
        With objStudyComparison
            .SetAsChild
            .SetState objBuffer.Item(lngIndex)
        End With
        colStudyComparisons.Add Item:=objStudyComparison
    Next

End Sub

Private Function GetState() As String
  
    Dim objBuffer As Buffer
    Dim objStudyComparison As StudyComparison
    
    Set objBuffer = New Buffer
    Set objStudyComparison = New StudyComparison
    objBuffer.Initialize Len(objStudyComparison.GetState), 20
    
    For Each objStudyComparison In colDeleted
        objBuffer.Add objStudyComparison.GetState
    Next
    
    For Each objStudyComparison In colStudyComparisons
        objBuffer.Add objStudyComparison.GetState
    Next
    
    GetState = objBuffer.GetState
    Set objBuffer = Nothing

End Function
