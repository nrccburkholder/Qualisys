VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Precodes"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Collection" ,"Precode"
Attribute VB_Ext_KEY = "Member0" ,"Precode"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

    'local variable(s) to hold property value(s)
    Private mstrNoUseList       As String 'local copy
    Private mstrFormatString    As String 'local copy
    
    'local variable to hold collection
    Private mobjPrecodes As Collection
Public Property Let FormatString(ByVal strData As String)
    
    mstrFormatString = strData
    
End Property


Public Function GetList(ByVal lngPreCodeGroup As Long) As Codes
    
    Dim lngCnt      As Long
    Dim strPreCode  As String
    Dim objCodes    As Codes
    Dim objPreCode  As Precode
    
    'Get the precode object
    Set objPreCode = Item("G-" & lngPreCodeGroup)
    
    'Initialize the code collection
    Set objCodes = New Codes
    
    'Populate the code list
    If Not objPreCode Is Nothing Then
        For lngCnt = 1 To objPreCode.MaxPreCode
            'Build this code
            strPreCode = Format(lngCnt, mstrFormatString)
            
            'Determine if we are to add this particular code
            If InStr(mstrNoUseList, "," & strPreCode & ",") = 0 Then
                'Add the code to the collection
                objCodes.Add strCodeID:=strPreCode, strCodeName:=strPreCode, bolIsLocal:=True
            End If
        Next lngCnt
    End If
    
    'Add a blank entry to the list so the user can leave it blank if the respondent did not fill it in.
    strPreCode = ""
    objCodes.Add strCodeID:=strPreCode, strCodeName:=strPreCode, bolIsLocal:=True
    
    'Set return value and cleanup
    Set GetList = objCodes
    Set objCodes = Nothing
    Set objPreCode = Nothing
    
End Function

Public Property Let NoUseList(ByVal strData As String)
    
    mstrNoUseList = strData
    
End Property


Public Sub Clear()
    
    Dim lngCnt As Long
    
    For lngCnt = 1 To Count
        Remove 1
    Next lngCnt
    
End Sub


Public Function Add(ByVal lngPreCodeGroup As Long, ByVal lngMaxPreCode As Long) As Precode
    
    'create a new object
    Dim strKey As String
    Dim objPreCode As Precode
    
    'set the properties passed into the method
    Set objPreCode = New Precode
    With objPreCode
        .PreCodeGroup = lngPreCodeGroup
        .MaxPreCode = lngMaxPreCode
    End With
    strKey = "G-" & lngPreCodeGroup
    
    'Add this object to the collection
    mobjPrecodes.Add objPreCode, strKey
    
    'return the object created
    Set Add = objPreCode
    Set objPreCode = Nothing
    
End Function

Public Property Get Item(ByVal vntIndexKey As Variant) As Precode
Attribute Item.VB_UserMemId = 0
    
    On Error Resume Next
    Set Item = mobjPrecodes(vntIndexKey)
    If Err.Number <> 0 Then
        Err.Clear
        Set Item = Nothing
    End If
    
End Property



Public Property Get Count() As Long
    
    Count = mobjPrecodes.Count
    
End Property


Public Sub Remove(ByVal vntIndexKey As Variant)
    
    mobjPrecodes.Remove vntIndexKey
    
End Sub


Public Property Get NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    
    Set NewEnum = mobjPrecodes.[_NewEnum]
    
End Property


Private Sub Class_Initialize()
    
    'creates the collection when this class is created
    Set mobjPrecodes = New Collection
    
End Sub


Private Sub Class_Terminate()
    
    'destroys collection when this class is terminated
    Set mobjPrecodes = Nothing
    
End Sub

