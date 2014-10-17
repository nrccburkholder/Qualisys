VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ListTypes"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Collection" ,"ListType"
Attribute VB_Ext_KEY = "Member0" ,"ListType"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
    
    'local variable to hold collection
    Private mobjListTypes As Collection
Public Sub Clear()
    
    Dim lngCnt As Long
    
    For lngCnt = 1 To Count
        Remove 1
    Next lngCnt
    
End Sub


Public Function Add(ByVal lngStartColumn As Long, ByVal enuListType As enuListTypeConstants) As ListType
    
    'Create a new object
    Dim strKey      As String
    Dim objListType As ListType
    
    'Set the properties passed into the method
    strKey = "LT" & lngStartColumn
    Set objListType = New ListType
    With objListType
        .StartColumn = lngStartColumn
        .ListType = enuListType
        .Key = strKey
    End With
    
    'Add this object to the collection
    mobjListTypes.Add objListType, strKey
    
    'Return the object created
    Set Add = objListType
    Set objListType = Nothing
    
End Function

Public Property Get Item(ByVal vntIndexKey As Variant) As ListType
Attribute Item.VB_UserMemId = 0
    
    On Error Resume Next
    Set Item = mobjListTypes(vntIndexKey)
    If Err.Number <> 0 Then
        Err.Clear
        Set Item = Nothing
    End If
    
End Property



Public Property Get Count() As Long
    
    Count = mobjListTypes.Count
    
End Property


Public Sub Remove(ByVal vntIndexKey As Variant)
    
    mobjListTypes.Remove vntIndexKey
    
End Sub


Public Property Get NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    
    Set NewEnum = mobjListTypes.[_NewEnum]
    
End Property


Private Sub Class_Initialize()
    
    'creates the collection when this class is created
    Set mobjListTypes = New Collection
    
End Sub


Private Sub Class_Terminate()
    
    'destroys collection when this class is terminated
    Set mobjListTypes = Nothing
    
End Sub

