VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CSurveys"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Collection" ,"CSurvey"
Attribute VB_Ext_KEY = "Member0" ,"CSurvey"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
    
    'local variable to hold collection
    Private moSurveys As Collection
    
Public Property Get Quantity() As Long
    
    Dim lQuantity   As Long
    Dim oSurvey     As CSurvey
    
    For Each oSurvey In moSurveys
        lQuantity = lQuantity + oSurvey.Quantity
    Next oSurvey
    
    Set oSurvey = Nothing
    Quantity = lQuantity
    
End Property



Public Sub Clear()
    
    Dim lCnt As Long
    
    For lCnt = 1 To Count
        Remove 1
    Next lCnt
    
End Sub


Public Function Add(ByVal sClientName As String, _
                    ByVal sSurveyName As String, _
                    ByVal sSurveyID As String) As CSurvey
    
    Dim sKey As String
    Dim oSurvey As CSurvey
    
    'create a new object
    Set oSurvey = New CSurvey
    
    'set the properties passed into the method
    sKey = "SV" & sSurveyID
    With oSurvey
        .ClientName = sClientName
        .SurveyName = sSurveyName
        .SurveyID = sSurveyID
        .Key = sKey
    End With
    
    'Add this one to the collection
    moSurveys.Add oSurvey, sKey
    
    'return the object created
    Set Add = oSurvey
    Set oSurvey = Nothing
    
End Function

Public Property Get Item(ByVal vIndexKey As Variant) As CSurvey
Attribute Item.VB_UserMemId = 0
    
    On Error Resume Next
    Set Item = moSurveys(vIndexKey)
    If Err.Number <> 0 Then
        Err.Clear
        Set Item = Nothing
    End If
    
End Property



Public Property Get Count() As Long
    
    Count = moSurveys.Count
    
End Property


Public Sub Remove(ByVal vIndexKey As Variant)
    
    moSurveys.Remove vIndexKey
    
End Sub


Public Property Get NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    
    Set NewEnum = moSurveys.[_NewEnum]
    
End Property


Public Sub Sort()
    
    Dim bInserted As Boolean
    Dim oTempCol As Collection
    Dim oSurvey As CSurvey
    Dim oTemp As CSurvey
    
    Set oTempCol = New Collection
    
    For Each oSurvey In moSurveys
        bInserted = False
        
        For Each oTemp In oTempCol
            If oSurvey.Quantity > oTemp.Quantity Then
                bInserted = True
                oTempCol.Add oSurvey, oSurvey.Key, oTemp.Key
                Exit For
            ElseIf oSurvey.Quantity = oTemp.Quantity And _
                   UCase(oSurvey.ClientName) < UCase(oTemp.ClientName) Then
                bInserted = True
                oTempCol.Add oSurvey, oSurvey.Key, oTemp.Key
                Exit For
            ElseIf oSurvey.Quantity = oTemp.Quantity And _
                   UCase(oSurvey.ClientName) = UCase(oTemp.ClientName) And _
                   UCase(oSurvey.SurveyName) < UCase(oTemp.SurveyName) Then
                bInserted = True
                oTempCol.Add oSurvey, oSurvey.Key, oTemp.Key
                Exit For
            End If
        Next oTemp
        
        If Not bInserted Then
            oTempCol.Add oSurvey, oSurvey.Key
        End If
    Next oSurvey
    
    Clear
    
    For Each oTemp In oTempCol
        moSurveys.Add oTemp, oTemp.Key
    Next oTemp
    
    Set oTempCol = Nothing
    
End Sub

Private Sub Class_Initialize()
    
    'creates the collection when this class is created
    Set moSurveys = New Collection
    
End Sub


Private Sub Class_Terminate()
    
    'destroys collection when this class is terminated
    Set moSurveys = Nothing
    
End Sub

