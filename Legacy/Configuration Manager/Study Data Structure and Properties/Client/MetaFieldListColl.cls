VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MetaFieldListColl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private colList As Collection

Private Sub Class_Initialize()
    Set colList = New Collection
End Sub

Friend Sub Load(aStudyID As Long)
    Dim objDB As MetaFieldListDB
    
    Set objDB = New MetaFieldListDB
    
    With objDB
        .Fetch aStudyID
        SetState .GetState
    End With
    
    Set objDB = Nothing
End Sub

Public Function Item(ByVal Index As Variant) As MetaFieldList
Attribute Item.VB_UserMemId = 0
    Set Item = colList.Item(Index)
End Function

Public Function Count() As Long
    Count = colList.Count
End Function

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    Set NewEnum = colList.[_NewEnum]
End Function

Private Sub SetState(ByVal Buffer As String)
    Dim objBuffer As Buffer
    Dim lngIndex As Long
    Dim objMetaFieldList As MetaFieldList
    
    Set objBuffer = New Buffer
    objBuffer.SetState Buffer
    With objBuffer
        For lngIndex = 1 To objBuffer.Count
            Set objMetaFieldList = New MetaFieldList
            objMetaFieldList.SetState objBuffer.Item(lngIndex)
            colList.Add Item:=objMetaFieldList
        Next
    End With
End Sub

Public Function ListItem(aFldID As Long) As MetaFieldList
    Dim iterField As MetaFieldList
    
    Set ListItem = Nothing
    
    For Each iterField In colList
        If iterField.ID = aFldID Then
            Set ListItem = iterField
            Exit For
        End If
    Next
End Function
