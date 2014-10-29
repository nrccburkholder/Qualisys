VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Headers"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Collection" ,"Header"
Attribute VB_Ext_KEY = "Member0" ,"Header"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
    
    'local variable to hold collection
    Private mobjHeaders As Collection

Friend Sub Clear()
    
    Dim lngCnt As Long
    
    For lngCnt = 1 To Count
        Remove 1
    Next lngCnt
    
End Sub

Friend Function Add(ByVal strHeaderID As String, ByVal strHeaderName As String) As Header
    
    'Create a new object
    Dim strKey As String
    Dim objNewMember As Header
    
    'Set the properties passed into the method
    Set objNewMember = New Header
    With objNewMember
        .HeaderID = strHeaderID
        .HeaderName = strHeaderName
    End With
    strKey = "H-" & strHeaderID
    
    'Add this object to the collection
    mobjHeaders.Add objNewMember, strKey
    
    'return the object created
    Set Add = objNewMember
    Set objNewMember = Nothing
    
End Function

Public Property Get Item(vntIndexKey As Variant) As Header
Attribute Item.VB_UserMemId = 0
    'used when referencing an element in the collection
    'vntIndexKey contains either the Index or Key to the collection,
    'this is why it is declared as a Variant
    'Syntax: Set foo = x.Item(xyz) or Set foo = x.Item(5)
  Set Item = mobjHeaders(vntIndexKey)
End Property



Public Property Get Count() As Long
    'used when retrieving the number of elements in the
    'collection. Syntax: Debug.Print x.Count
    Count = mobjHeaders.Count
End Property


Public Sub Remove(vntIndexKey As Variant)
    'used when removing an element from the collection
    'vntIndexKey contains either the Index or Key, which is why
    'it is declared as a Variant
    'Syntax: x.Remove(xyz)


    mobjHeaders.Remove vntIndexKey
End Sub


Public Property Get NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    'this property allows you to enumerate
    'this collection with the For...Each syntax
    Set NewEnum = mobjHeaders.[_NewEnum]
End Property


Private Sub Class_Initialize()
    'creates the collection when this class is created
    Set mobjHeaders = New Collection
End Sub


Private Sub Class_Terminate()
    'destroys collection when this class is terminated
    Set mobjHeaders = Nothing
End Sub

