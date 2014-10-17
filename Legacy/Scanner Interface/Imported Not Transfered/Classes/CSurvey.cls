VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CSurvey"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
    
    'local variable(s) to hold property value(s)
    Private msClientName As String
    Private msSurveyName As String
    Private msSurveyID As String
    Private msKey As String
    Private moReturns As CDateReturneds

Public Property Get Returns() As CDateReturneds
    
    Set Returns = moReturns
    
End Property



Public Property Let Key(ByVal sData As String)
    
    msKey = sData
    
End Property


Public Property Get Key() As String
    
    Key = msKey
    
End Property



Public Property Get Quantity() As Long
    
    Dim lQuantity As Long
    Dim oReturn As CDateReturned
    
    For Each oReturn In moReturns
        lQuantity = lQuantity + oReturn.Quantity
    Next oReturn
    
    Set oReturn = Nothing
    Quantity = lQuantity
    
End Property



Public Property Let SurveyID(ByVal sData As String)
    
    msSurveyID = sData
    
End Property


Public Property Get SurveyID() As String
    
    SurveyID = msSurveyID
    
End Property



Public Property Let SurveyName(ByVal sData As String)
    
    msSurveyName = sData
    
End Property


Public Property Get SurveyName() As String
    
    SurveyName = msSurveyName
    
End Property



Public Property Let ClientName(ByVal sData As String)
    
    msClientName = sData
    
End Property


Public Property Get ClientName() As String
    
    ClientName = msClientName
    
End Property



Private Sub Class_Initialize()
    
    Set moReturns = New CDateReturneds
    
End Sub


Private Sub Class_Terminate()
    
    Set moReturns = Nothing
    
End Sub


