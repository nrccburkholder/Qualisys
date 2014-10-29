VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CDateReturneds"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Collection" ,"CDateReturned"
Attribute VB_Ext_KEY = "Member0" ,"CDateReturned"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
    
    'local variable to hold collection
    Private moReturns As Collection
Public Sub Clear()
    
    Dim lCnt As Long
    
    For lCnt = 1 To Count
        Remove 1
    Next lCnt
    
End Sub


Public Function Add(ByVal dtDateReturned As Date, _
                    ByVal lQuantity As Long) As CDateReturned
    
    Dim sKey    As String
    Dim oReturn As CDateReturned
    
    'create a new object
    Set oReturn = New CDateReturned
    
    'set the properties passed into the method
    sKey = "DR" & Format(dtDateReturned, "mmddyyyy")
    With oReturn
        .DateReturned = dtDateReturned
        .Quantity = lQuantity
        .Key = sKey
    End With
    
    'Add this object to the collection
    moReturns.Add oReturn, sKey
    
    'return the object created
    Set Add = oReturn
    Set oReturn = Nothing
    
End Function

Public Property Get Item(ByVal vIndexKey As Variant) As CDateReturned
Attribute Item.VB_UserMemId = 0
    
    On Error Resume Next
    Set Item = moReturns(vIndexKey)
    If Err.Number <> 0 Then
        Err.Clear
        Set Item = Nothing
    End If
    
End Property



Public Property Get Count() As Long
    
    Count = moReturns.Count
    
End Property


Public Sub Remove(ByVal vIndexKey As Variant)
    
    moReturns.Remove vIndexKey
    
End Sub


Public Property Get NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    
    Set NewEnum = moReturns.[_NewEnum]
    
End Property


Private Sub Class_Initialize()
    
    'creates the collection when this class is created
    Set moReturns = New Collection
    
End Sub


Private Sub Class_Terminate()
    
    'destroys collection when this class is terminated
    Set moReturns = Nothing
    
End Sub

