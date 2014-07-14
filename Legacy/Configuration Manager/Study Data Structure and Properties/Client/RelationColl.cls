VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "RelationColl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mCol As Collection

'Public Function Add(masterTableID As Long, _
'                    masterFieldID As Long, _
'                    lookupTableID As Long, _
'                    lookupFieldID As Long, _
'                    currentTableID As Long, _
'                    Optional sKey As String) As Relation
'
'    'create a new object
'    Dim objNewMember As Relation
'    Set objNewMember = New Relation
'
'    objNewMember.masterTableID = masterTableID
'    objNewMember.masterFieldID = masterFieldID
'    objNewMember.lookupTableID = lookupTableID
'    objNewMember.lookupFieldID = lookupFieldID
'    objNewMember.currentTableID = currentTableID
'
'
'    If Len(sKey) = 0 Then
'        mCol.Add objNewMember
'    Else
'        mCol.Add objNewMember, sKey
'    End If
'
'
'    'return the object created
'    Set Add = objNewMember
'    Set objNewMember = Nothing
'
'
'End Function

Public Property Get Item(vntIndexKey As Variant) As Relation
Attribute Item.VB_UserMemId = 0
  
    Set Item = mCol(vntIndexKey)

End Property

Public Property Get Count() As Long
    
    Count = mCol.Count

End Property

Public Sub Remove(vntIndexKey As Variant)

    mCol.Remove vntIndexKey

End Sub

Public Property Get NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    
    Set NewEnum = mCol.[_NewEnum]

End Property

Private Sub Class_Initialize()
    
    Set mCol = New Collection

End Sub

Private Sub Class_Terminate()
    
    Set mCol = Nothing

End Sub

'Public Function exist(masterTableID As Long, _
'                        masterFieldID As Long, _
'                        lookupTableID As Long, _
'                        lookupFieldID As Long) As Boolean
Public Function exist(objRelation As Relation) As Boolean

    Dim iter As Relation
    Dim found As Boolean
    
    found = False
    For Each iter In mCol
        If ((iter.masterTableID = objRelation.masterTableID) And _
            (iter.masterFieldID = objRelation.masterFieldID) And _
            (iter.lookupTableID = objRelation.lookupTableID) And _
            (iter.lookupFieldID = objRelation.lookupFieldID)) _
        Or _
           ((iter.masterTableID = objRelation.lookupTableID) And _
            (iter.masterFieldID = objRelation.lookupFieldID) And _
            (iter.lookupTableID = objRelation.masterTableID) And _
            (iter.lookupFieldID = objRelation.masterFieldID)) Then
                found = True
                Exit For
        End If
    Next
    
    exist = found

End Function

Friend Sub Load(aTableID As Long)
  
    Dim objDB As RelationCollDB
    
    Set objDB = New RelationCollDB
    With objDB
        .Fetch aTableID
        SetState .GetState
    End With
    Set objDB = Nothing

End Sub

Private Sub SetState(ByVal Buffer As String)
  
    Dim objBuffer As Buffer
    Dim lngIndex As Long
    Dim objRelation As Relation
    
    Set objBuffer = New Buffer
    objBuffer.SetState Buffer
    With objBuffer
        For lngIndex = 1 To objBuffer.Count
            Set objRelation = New Relation
            objRelation.SetState objBuffer.Item(lngIndex)
            If Not exist(objRelation) Then _
                mCol.Add Item:=objRelation
        Next
    End With

End Sub
