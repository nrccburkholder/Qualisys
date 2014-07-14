VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "StudyDeliveryColl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private colStudyDeliverys As Collection
Private colDeleted As Collection

Private fldChildEditing As Boolean

Public Sub ChildBeginEdit()
  
    Dim objStudyDelivery As StudyDelivery
    
    If fldChildEditing Then Err.Raise 445
    
    ' save object state
    For Each objStudyDelivery In colStudyDeliverys
        objStudyDelivery.ChildBeginEdit
    Next
    
    fldChildEditing = True

End Sub

Public Sub ChildCancelEdit()
  
    Dim objStudyDelivery As StudyDelivery
    Dim lngIndex As Long
    
    If Not fldChildEditing Then Err.Raise 445
    
    fldChildEditing = False
    For lngIndex = colDeleted.Count To 1 Step -1
        With colDeleted
            colStudyDeliverys.Add Item:=.Item(lngIndex)
            .Remove lngIndex
        End With
    Next
    
    For lngIndex = colStudyDeliverys.Count To 1 Step -1
        Set objStudyDelivery = colStudyDeliverys.Item(lngIndex)
        With objStudyDelivery
            .ChildCancelEdit
            If .IsNew Then _
                colStudyDeliverys.Remove lngIndex
        End With
    Next lngIndex

End Sub

Public Sub ChildApplyEdit(StudyID As Long)
    
    Dim objDB As StudyDeliveryCollDB
    Dim objStudyDB As StudyDB
    Dim objStudyDelivery As StudyDelivery
    
    If Not fldChildEditing Then Err.Raise 445
    
    Set objDB = New StudyDeliveryCollDB
    With objDB
        .SetState GetState
        .Save StudyID
        SetState .GetState
    End With
    
    Set objDB = Nothing
  
    fldChildEditing = False

End Sub

Friend Sub Load(StudyID As Long)
  
    Dim objDB As StudyDeliveryCollDB
    If fldChildEditing Then Err.Raise 445
    
    Set objDB = New StudyDeliveryCollDB
    With objDB
        .Fetch StudyID
        SetState .GetState
    End With
    Set objDB = Nothing

End Sub

Public Sub Remove(ByVal Index As Variant)
  
    Dim objStudyDelivery As StudyDelivery
    
    If Not fldChildEditing Then Err.Raise 445
    
    Set objStudyDelivery = colStudyDeliverys.Item(Index)
    objStudyDelivery.Delete
    colDeleted.Add Item:=objStudyDelivery
    colStudyDeliverys.Remove Index

End Sub

Public Sub Delete()
  
    Dim objStudyDelivery As StudyDelivery
    Dim lngIndex As Long
    
    If Not fldChildEditing Then Err.Raise 445
    
    For lngIndex = colStudyDeliverys.Count To 1 Step -1
        Set objStudyDelivery = colStudyDeliverys.Item(lngIndex)
        objStudyDelivery.Delete
        colDeleted.Add Item:=objStudyDelivery
        colStudyDeliverys.Remove lngIndex
    Next

End Sub

Private Sub Class_Initialize()
  
    Set colStudyDeliverys = New Collection
    Set colDeleted = New Collection

End Sub

Public Function Add() As StudyDelivery
  
    Dim objStudyDelivery As StudyDelivery
    
    Set objStudyDelivery = New StudyDelivery
    objStudyDelivery.SetAsChild
    Set objStudyDelivery.Parent = Me
    If fldChildEditing Then objStudyDelivery.ChildBeginEdit
    Set Add = objStudyDelivery

End Function

Friend Sub AddChild(NewStudyDelivery As StudyDelivery)
  
    colStudyDeliverys.Add Item:=NewStudyDelivery

End Sub

Public Function Item(ByVal Index As Variant) As StudyDelivery
Attribute Item.VB_UserMemId = 0
  
    Set Item = colStudyDeliverys(Index)
    
End Function

Public Function Count() As Long
  
    Count = colStudyDeliverys.Count
  
End Function

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    
    Set NewEnum = colStudyDeliverys.[_NewEnum]
    
End Function

Private Sub SetState(ByVal Buffer As String)
  
    Dim lngIndex As Long
    Dim objStudyDelivery As StudyDelivery
    Dim objBuffer As Buffer
    
    Set colStudyDeliverys = New Collection
    Set colDeleted = New Collection
    
    Set objBuffer = New Buffer
    objBuffer.SetState Buffer
    
    For lngIndex = 1 To objBuffer.Count
        Set objStudyDelivery = New StudyDelivery
        With objStudyDelivery
            .SetAsChild
            .SetState objBuffer.Item(lngIndex)
        End With
        colStudyDeliverys.Add Item:=objStudyDelivery
    Next

End Sub

Private Function GetState() As String
  
    Dim objBuffer As Buffer
    Dim objStudyDelivery As StudyDelivery
    
    Set objBuffer = New Buffer
    Set objStudyDelivery = New StudyDelivery
    objBuffer.Initialize Len(objStudyDelivery.GetState), 20
    
    For Each objStudyDelivery In colDeleted
        objBuffer.Add objStudyDelivery.GetState
    Next
    
    For Each objStudyDelivery In colStudyDeliverys
        objBuffer.Add objStudyDelivery.GetState
    Next
    
    GetState = objBuffer.GetState
    Set objBuffer = Nothing

End Function
