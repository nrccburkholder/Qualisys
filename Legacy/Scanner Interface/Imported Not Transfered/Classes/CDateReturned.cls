VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CDateReturned"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
    
    'local variable(s) to hold property value(s)
    Private mdtDateReturned As Date
    Private mlQuantity As Long
    Private msKey As String
Public Property Let Key(ByVal sData As String)
    
    msKey = sData
    
End Property


Public Property Get Key() As String
    
    Key = msKey
    
End Property



Public Property Let Quantity(ByVal lData As Long)
    
    mlQuantity = lData
    
End Property


Public Property Get Quantity() As Long
    
    Quantity = mlQuantity
    
End Property



Public Property Let DateReturned(ByVal dtData As Date)
    
    mdtDateReturned = dtData
    
End Property


Public Property Get DateReturned() As Date
    
    DateReturned = mdtDateReturned
    
End Property



