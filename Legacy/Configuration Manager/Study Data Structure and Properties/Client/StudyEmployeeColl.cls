VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "StudyEmployeeColl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private colStudyEmployees As Collection
Private colDeleted As Collection

Private fldChildEditing As Boolean

Public Sub ChildBeginEdit()
  
    Dim objStudyEmployee As StudyEmployee
    
    If fldChildEditing Then Err.Raise 445
    
    ' save object state
    For Each objStudyEmployee In colStudyEmployees
        objStudyEmployee.ChildBeginEdit
    Next
    fldChildEditing = True

End Sub

Public Sub ChildCancelEdit()
  
    Dim objStudyEmployee As StudyEmployee
    Dim lngIndex As Long
    
    If Not fldChildEditing Then Err.Raise 445
    
    fldChildEditing = False
    
    For lngIndex = colDeleted.Count To 1 Step -1
        With colDeleted
            colStudyEmployees.Add Item:=.Item(lngIndex)
            .Remove lngIndex
        End With
    Next
    
    For lngIndex = colStudyEmployees.Count To 1 Step -1
        Set objStudyEmployee = colStudyEmployees.Item(lngIndex)
        With objStudyEmployee
            .ChildCancelEdit
            If .IsNew Then _
                colStudyEmployees.Remove lngIndex
        End With
    Next lngIndex

End Sub

Public Sub ChildApplyEdit(StudyID As Long)
    
    Dim objDB As StudyEmployeeCollDB
    Dim objStudyDB As StudyDB
    Dim objStudyEmployee As StudyEmployee
    
    If Not fldChildEditing Then Err.Raise 445
    
    Set objDB = New StudyEmployeeCollDB
    With objDB
        .SetState GetState
        .Save StudyID
        SetState .GetState
    End With
    
    Set objDB = Nothing
  
    fldChildEditing = False
    
End Sub

Friend Sub Load(StudyID As Long)
  
    Dim objDB As StudyEmployeeCollDB
    
    If fldChildEditing Then Err.Raise 445
    
    Set objDB = New StudyEmployeeCollDB
    With objDB
        .Fetch StudyID
        SetState .GetState
    End With
    
    Set objDB = Nothing

End Sub

Public Sub Remove(ByVal Index As Variant)
  
    Dim objStudyEmployee As StudyEmployee
    
    If Not fldChildEditing Then Err.Raise 445
    
    Set objStudyEmployee = colStudyEmployees.Item(Index)
    objStudyEmployee.Delete
    colDeleted.Add Item:=objStudyEmployee
    colStudyEmployees.Remove Index

End Sub

Public Sub Delete()
  
    Dim objStudyEmployee As StudyEmployee
    Dim lngIndex As Long
    
    If Not fldChildEditing Then Err.Raise 445
    
    For lngIndex = colStudyEmployees.Count To 1 Step -1
        Set objStudyEmployee = colStudyEmployees.Item(lngIndex)
        objStudyEmployee.Delete
        colDeleted.Add Item:=objStudyEmployee
        colStudyEmployees.Remove lngIndex
    Next

End Sub

Private Sub Class_Initialize()
    
    Set colStudyEmployees = New Collection
    Set colDeleted = New Collection

End Sub

Public Function Add() As StudyEmployee
  
    Dim objStudyEmployee As StudyEmployee
    
    Set objStudyEmployee = New StudyEmployee
    objStudyEmployee.SetAsChild
    Set objStudyEmployee.Parent = Me
    If fldChildEditing Then objStudyEmployee.ChildBeginEdit
    Set Add = objStudyEmployee

End Function

Friend Sub AddChild(NewStudyEmployee As StudyEmployee)
    
    colStudyEmployees.Add Item:=NewStudyEmployee

End Sub

Public Function Item(ByVal Index As Variant) As StudyEmployee
Attribute Item.VB_UserMemId = 0
  
    Set Item = colStudyEmployees(Index)
    
End Function

Public Function Count() As Long
    
    Count = colStudyEmployees.Count
    
End Function

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    
    Set NewEnum = colStudyEmployees.[_NewEnum]
    
End Function

Private Sub SetState(ByVal Buffer As String)
  
    Dim lngIndex As Long
    Dim objStudyEmployee As StudyEmployee
    Dim objBuffer As Buffer
    
    Set colStudyEmployees = New Collection
    Set colDeleted = New Collection
    
    Set objBuffer = New Buffer
    objBuffer.SetState Buffer
    
    For lngIndex = 1 To objBuffer.Count
        Set objStudyEmployee = New StudyEmployee
        With objStudyEmployee
            .SetAsChild
            .SetState objBuffer.Item(lngIndex)
        End With
        colStudyEmployees.Add Item:=objStudyEmployee
    Next
End Sub

Private Function GetState() As String
  
    Dim objBuffer As Buffer
    Dim objStudyEmployee As StudyEmployee
    
    Set objBuffer = New Buffer
    Set objStudyEmployee = New StudyEmployee
    objBuffer.Initialize Len(objStudyEmployee.GetState), 20
    
    For Each objStudyEmployee In colDeleted
        objBuffer.Add objStudyEmployee.GetState
    Next
    
    For Each objStudyEmployee In colStudyEmployees
        objBuffer.Add objStudyEmployee.GetState
    Next
    
    GetState = objBuffer.GetState
    Set objBuffer = Nothing

End Function

Public Function ExistsItem(anEmployeeID As Long) As Boolean

    Dim iterField As StudyEmployee
    Dim found As Boolean
    
    found = False
    For Each iterField In colStudyEmployees
        If iterField.EmployeeID = anEmployeeID Then
            found = True
            Exit For
        End If
    Next
    
    ExistsItem = found

End Function
