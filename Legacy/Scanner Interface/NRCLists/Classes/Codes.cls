VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Codes"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Collection" ,"Code"
Attribute VB_Ext_KEY = "Member0" ,"Code"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

    'local variable to hold collection
    Private mobjCodes As Collection
Friend Sub Clear()
    
    Dim lngCnt As Long
    
    For lngCnt = 1 To Count
        Remove 1
    Next lngCnt
    
End Sub


Friend Function Add(ByVal strCodeID As String, ByVal strCodeName As String, ByVal bolIsLocal As Boolean) As Code
    
    'Create a new object
    Dim objCode As Code
    
    'Set the properties passed into the method
    Set objCode = New Code
    With objCode
        .CodeID = strCodeID
        .CodeName = strCodeName
        .IsLocal = bolIsLocal
    End With
    
    'Add this object to the collection
    mobjCodes.Add objCode
    
    'Return the object created
    Set Add = objCode
    Set objCode = Nothing
    
End Function

Public Property Get Item(ByVal vntIndexKey As Variant) As Code
Attribute Item.VB_UserMemId = 0
    
    On Error Resume Next
    Set Item = mobjCodes(vntIndexKey)
    If Err.Number <> 0 Then
        Err.Clear
        Set Item = Nothing
    End If
    
End Property



Public Property Get Count() As Long
    
    Count = mobjCodes.Count
    
End Property


Friend Sub Remove(ByVal vntIndexKey As Variant)
    
    mobjCodes.Remove vntIndexKey
    
End Sub


Public Property Get NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    
    Set NewEnum = mobjCodes.[_NewEnum]
    
End Property


Private Sub Class_Initialize()
    
    'creates the collection when this class is created
    Set mobjCodes = New Collection
    
End Sub


Private Sub Class_Terminate()
    
    'destroys collection when this class is terminated
    Set mobjCodes = Nothing
    
End Sub

