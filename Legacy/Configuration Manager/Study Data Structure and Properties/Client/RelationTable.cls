VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "RelationTable"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mvarID As Long

Public Property Let ID(ByVal vData As Long)
    
    mvarID = vData

End Property

Public Property Get ID() As Long
    
    ID = mvarID

End Property




