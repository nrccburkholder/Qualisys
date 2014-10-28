VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "QSHandEntryList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
    
    Private mstrTemplateID  As String
    
    Private mobjCodes       As Codes
    
Public Function GetList(ByVal intQstnCore As Integer, ByVal intBubbleID As Integer, ByVal intLineID As Integer) As Codes
    
    'Return the collection
    Set GetList = mobjCodes
    
End Function


Public Sub Initialize(ByVal strTemplateID As String)
    
    'Clear the existing collection
    Set mobjCodes = Nothing
    
    'Create a new collection
    Set mobjCodes = New Codes
    
    'Save the new template id
    mstrTemplateID = strTemplateID
    
    'Populate the collection
    
End Sub

Private Sub Class_Terminate()
    
    Set mobjCodes = Nothing
    
End Sub


