VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Header"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Member0" ,"SubHeaders"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
    
    'local variable(s) to hold property value(s)
    Private mstrHeaderID    As String       'local copy
    Private mstrHeaderName  As String       'local copy
    Private mstrKey         As String       'local copy
    
    Private mobjSubHeaders  As SubHeaders   'local copy


Friend Property Let Key(ByVal strData As String)
    
    mstrKey = strData
    
End Property


Friend Property Get Key() As String
    
    Key = mstrKey
    
End Property



Public Property Get SubHeaders() As SubHeaders
    
    Set SubHeaders = mobjSubHeaders
    
End Property



Friend Property Let HeaderName(ByVal strData As String)
    
    mstrHeaderName = strData
    
End Property


Public Property Get HeaderName() As String
    
    HeaderName = mstrHeaderName
    
End Property



Friend Property Let HeaderID(ByVal strData As String)
    
    mstrHeaderID = strData
    
End Property


Public Property Get HeaderID() As String
    
    HeaderID = mstrHeaderID
    
End Property



Private Sub Class_Initialize()
    
    Set mobjSubHeaders = New SubHeaders
    
End Sub


Private Sub Class_Terminate()
    
    Set mobjSubHeaders = Nothing
    
End Sub


