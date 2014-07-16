VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Relation"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Private udtProps As RelationProps

Friend Sub SetState(Buffer As String)
  
    Dim udtData As RelationData
    
    udtData.Buffer = Buffer
    LSet udtProps = udtData

End Sub

Public Property Get currentTableID() As Long
    
    currentTableID = udtProps.currentTableID

End Property

Public Property Get lookupFieldID() As Long
    
    lookupFieldID = udtProps.lookupFieldID

End Property

Public Property Get lookupTableID() As Long
    
    lookupTableID = udtProps.lookupTableID

End Property

Public Property Get masterFieldID() As Long
    
    masterFieldID = udtProps.masterFieldID

End Property

Public Property Get masterTableID() As Long
    
    masterTableID = udtProps.masterTableID

End Property
