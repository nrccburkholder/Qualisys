VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MetaFieldColl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private colMetaFieldColl As Collection
Private colDeleted As Collection

Private fldChildEditing As Boolean

Public Sub ChildBeginEdit()
    Dim objMetaField As MetaField
    
    If fldChildEditing Then Err.Raise 445
    
    ' save object state
    For Each objMetaField In colMetaFieldColl
        objMetaField.ChildBeginEdit
    Next
    fldChildEditing = True
End Sub

Public Sub ChildCancelEdit()
    Dim objMetaField As MetaField
    Dim lngIndex As Long
    
    If Not fldChildEditing Then Err.Raise 445
    
    fldChildEditing = False
    For lngIndex = colDeleted.Count To 1 Step -1
        With colDeleted
            colMetaFieldColl.Add Item:=.Item(lngIndex)
            .Remove lngIndex
        End With
    Next
    
    For lngIndex = colMetaFieldColl.Count To 1 Step -1
      Set objMetaField = colMetaFieldColl.Item(lngIndex)
      With objMetaField
        .ChildCancelEdit
        If .IsNew Then _
            colMetaFieldColl.Remove lngIndex
      End With
    Next lngIndex
End Sub

Public Sub ChildApplyEdit(MetaTableID As Long)
    Dim objDB As MetaFieldCollDB
    
    If Not fldChildEditing Then Err.Raise 445
    
    Set objDB = New MetaFieldCollDB
    With objDB
        .SetState GetState
        .Save MetaTableID
        SetState .GetState
    End With
    Set objDB = Nothing
    
    fldChildEditing = False
End Sub

Friend Sub Load(MetaTableID As Long)
    Dim objDB As MetaFieldCollDB
    '  If fldChildEditing Then Err.Raise 445
    
    Set objDB = New MetaFieldCollDB
    With objDB
        .Fetch MetaTableID
        SetState .GetState
    End With
    
    Set objDB = Nothing
End Sub

Public Sub Remove(ByVal Index As Variant)
    Dim objMetaField As MetaField
    
    If Not fldChildEditing Then Err.Raise 445
    
    Set objMetaField = colMetaFieldColl.Item(Index)
    objMetaField.Delete
    colDeleted.Add Item:=objMetaField
    colMetaFieldColl.Remove Index
End Sub

Public Sub Delete()
    Dim objMetaField As MetaField
    Dim lngIndex As Long
    
    If Not fldChildEditing Then Err.Raise 445
    
    For lngIndex = colMetaFieldColl.Count To 1 Step -1
        Set objMetaField = colMetaFieldColl.Item(lngIndex)
        objMetaField.Delete
        colDeleted.Add Item:=objMetaField
        colMetaFieldColl.Remove lngIndex
    Next
End Sub

Private Sub Class_Initialize()
    Set colMetaFieldColl = New Collection
    Set colDeleted = New Collection
End Sub

Public Function Add() As MetaField
    Dim objMetaField As MetaField
    
    Set objMetaField = New MetaField
    objMetaField.SetAsChild
    Set objMetaField.Parent = Me
    If fldChildEditing Then objMetaField.ChildBeginEdit
    Set Add = objMetaField
End Function

Friend Sub AddChild(NewMetaField As MetaField)
    colMetaFieldColl.Add Item:=NewMetaField
End Sub

Public Function Item(ByVal Index As Variant) As MetaField
Attribute Item.VB_UserMemId = 0
    Set Item = colMetaFieldColl(Index)
End Function

Public Function Count() As Long
    Count = colMetaFieldColl.Count
End Function

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    Set NewEnum = colMetaFieldColl.[_NewEnum]
End Function

Private Sub SetState(ByVal Buffer As String)
    Dim lngIndex As Long
    Dim objMetaField As MetaField
    Dim objBuffer As Buffer

    Set colMetaFieldColl = New Collection
    Set colDeleted = New Collection
    
    Set objBuffer = New Buffer
    objBuffer.SetState Buffer
    
    For lngIndex = 1 To objBuffer.Count
        Set objMetaField = New MetaField
        With objMetaField
            .SetAsChild
            .SetState objBuffer.Item(lngIndex)
        End With
        colMetaFieldColl.Add Item:=objMetaField
    Next
End Sub

Private Function GetState() As String
    Dim objBuffer As Buffer
    Dim objMetaField As MetaField
    
    Set objBuffer = New Buffer
    Set objMetaField = New MetaField
    objBuffer.Initialize Len(objMetaField.GetState), 20
    
    For Each objMetaField In colDeleted
        objBuffer.Add objMetaField.GetState
    Next
    
    For Each objMetaField In colMetaFieldColl
        objBuffer.Add objMetaField.GetState
    Next
    
    GetState = objBuffer.GetState
    Set objBuffer = Nothing
End Function

Public Function ExistsItem(aFldID As Long) As Boolean
    Dim iterField As MetaField
    Dim found As Boolean
    
    found = False
    For Each iterField In colMetaFieldColl
        If iterField.ID = aFldID Then
            found = True
            Exit For
        End If
    Next
    
    ExistsItem = found
End Function

Public Function ListItem(aFieldID As Long) As MetaField
    Dim iterItem As MetaField
    
    Set ListItem = Nothing
    
    For Each iterItem In colMetaFieldColl
        If iterItem.ID = aFieldID Then
            Set ListItem = iterItem
            Exit For
        End If
    Next
End Function
