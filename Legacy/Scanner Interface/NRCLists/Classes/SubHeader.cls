VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "SubHeader"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Member0" ,"Codes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
    
    'local variable(s) to hold property value(s)
    Private mstrSubHeaderID     As String   'local copy
    Private mstrSubHeaderName   As String   'local copy
    Private mstrKey             As String   'local copy

    Private mobjCodes           As Codes    'local copy


Friend Property Let Key(ByVal strData As String)
    
    mstrKey = strData
    
End Property


Friend Property Get Key() As String
    
    Key = mstrKey
    
End Property



Public Property Get Codes() As Codes
    
    Set Codes = mobjCodes
    
End Property



Friend Property Let SubHeaderName(ByVal strData As String)
    
    mstrSubHeaderName = strData
    
End Property


Public Property Get SubHeaderName() As String
    
    SubHeaderName = mstrSubHeaderName
    
End Property



Friend Property Let SubHeaderID(ByVal strData As String)
    
    mstrSubHeaderID = strData
    
End Property


Public Property Get SubHeaderID() As String
    
    SubHeaderID = mstrSubHeaderID
    
End Property



Private Sub Class_Initialize()
    
    Set mobjCodes = New Codes
    
End Sub


Private Sub Class_Terminate()
    
    Set mobjCodes = Nothing
    
End Sub


