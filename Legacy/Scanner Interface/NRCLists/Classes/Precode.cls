VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Precode"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
    
    'local variable(s) to hold property value(s)
    Private mlngPreCodeGroup    As Long 'local copy
    Private mlngMaxPreCode      As Long 'local copy
    Private mstrKey             As String 'local copy
Public Property Let Key(ByVal strData As String)
    
    mstrKey = strData
    
End Property


Public Property Get Key() As String
    
    Key = mstrKey
    
End Property





Public Property Let MaxPreCode(ByVal lngData As Long)
    
    mlngMaxPreCode = lngData
    
End Property


Public Property Get MaxPreCode() As Long
    
    MaxPreCode = mlngMaxPreCode
    
End Property



Public Property Let PreCodeGroup(ByVal lngData As Long)
    
    mlngPreCodeGroup = lngData
    
End Property


Public Property Get PreCodeGroup() As Long
    
    PreCodeGroup = mlngPreCodeGroup
    
End Property



