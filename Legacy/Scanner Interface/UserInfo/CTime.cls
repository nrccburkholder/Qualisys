VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CTime"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
    
    'local variable(s) to hold property value(s)
    Private mdtStartTime    As Date
    Private mdtEndTime      As Date
    Private mnQtyAllowed    As Integer
Public Property Let QtyAllowed(ByVal nData As Integer)
    
    mnQtyAllowed = nData
    
End Property


Public Property Get QtyAllowed() As Integer
    
    QtyAllowed = mnQtyAllowed
    
End Property



Public Property Let EndTime(ByVal dtData As Date)
    
    mdtEndTime = dtData
    
End Property


Public Property Get EndTime() As Date
    
    EndTime = mdtEndTime
    
End Property



Public Property Let StartTime(ByVal dtData As Date)
    
    mdtStartTime = dtData
    
End Property


Public Property Get StartTime() As Date
    
    StartTime = mdtStartTime
    
End Property



