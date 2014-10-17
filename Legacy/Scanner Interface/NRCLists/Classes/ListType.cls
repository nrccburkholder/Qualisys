VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ListType"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Member0" ,"ListType"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
    
    'local variable(s) to hold property value(s)
    Private mlngStartColumn As Long                 'local copy
    Private menuListType    As enuListTypeConstants 'local copy
    Private mstrKey         As String               'local copy
    
    Public Enum enuListTypeConstants
        enuLTCHospital = 1
        enuLTCSystem = 2
        enuLTCPlan = 3
    End Enum

Public Property Let Key(ByVal strData As String)
    
    mstrKey = strData
    
End Property


Public Property Get Key() As String
    
    Key = mstrKey
    
End Property



Public Property Let ListType(ByVal enuData As enuListTypeConstants)
    
    menuListType = enuData
    
End Property


Public Property Get ListType() As enuListTypeConstants
    
    ListType = menuListType
    
End Property




Public Property Let StartColumn(ByVal lngData As Long)
    
    mlngStartColumn = lngData
    
End Property


Public Property Get StartColumn() As Long
    
    StartColumn = mlngStartColumn
    
End Property



