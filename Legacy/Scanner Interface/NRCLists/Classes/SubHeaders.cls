VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "SubHeaders"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Collection" ,"SubHeader"
Attribute VB_Ext_KEY = "Member0" ,"SubHeader"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
    
    'local variable to hold collection
    Private mobjSubHeaders As Collection
Friend Sub Clear()
    
    Dim lngCnt As Long
    
    For lngCnt = 1 To Count
        Remove 1
    Next lngCnt
    
End Sub


Friend Function Add(ByVal strSubHeaderID As String, ByVal strSubHeaderName As String) As SubHeader
    
    'Create a new object
    Dim strKey As String
    Dim mobjSubHeader As SubHeader
    
    'Set the properties passed into the method
    Set mobjSubHeader = New SubHeader
    With mobjSubHeader
        .SubHeaderID = strSubHeaderID
        .SubHeaderName = strSubHeaderName
    End With
    strKey = "S" & strSubHeaderID
    
    'Add this object to the collection
    mobjSubHeaders.Add mobjSubHeader, strKey
    
    'return the object created
    Set Add = mobjSubHeader
    Set mobjSubHeader = Nothing
    
End Function

Public Property Get Item(ByVal vntIndexKey As Variant) As SubHeader
Attribute Item.VB_UserMemId = 0
    
    On Error Resume Next
    Set Item = mobjSubHeaders(vntIndexKey)
    If Err.Number <> 0 Then
        Err.Clear
        Set Item = Nothing
    End If
    
End Property



Public Property Get Count() As Long
    
    Count = mobjSubHeaders.Count
    
End Property


Friend Sub Remove(ByVal vntIndexKey As Variant)
    
    mobjSubHeaders.Remove vntIndexKey
    
End Sub


Public Property Get NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    
    Set NewEnum = mobjSubHeaders.[_NewEnum]
    
End Property


Private Sub Class_Initialize()
    
    'creates the collection when this class is created
    Set mobjSubHeaders = New Collection
    
End Sub


Private Sub Class_Terminate()
    
    'destroys collection when this class is terminated
    Set mobjSubHeaders = Nothing
    
End Sub

