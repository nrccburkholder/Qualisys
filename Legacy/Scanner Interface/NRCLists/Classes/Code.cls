VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Code"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

    'local variable(s) to hold property value(s)
    Private mstrCodeID      As String 'local copy
    Private mstrCodeName    As String 'local copy
    Private mbolIsLocal     As Boolean 'local copy
Friend Property Let CodeID(ByVal strData As String)

    mstrCodeID = strData
    
End Property

Public Property Get IsLocal() As Boolean
    
    IsLocal = mbolIsLocal
    
End Property



Friend Property Let IsLocal(ByVal bolData As Boolean)

    mbolIsLocal = bolData
    
End Property

Public Property Get CodeName() As String
    
    CodeName = mstrCodeName
    
End Property



Friend Property Let CodeName(ByVal strData As String)

    mstrCodeName = strData
    
End Property

Public Property Get CodeID() As String
    
    CodeID = mstrCodeID
    
End Property



