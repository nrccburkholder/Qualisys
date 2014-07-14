VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "RelationTableColl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mCol As Collection

Public Function Add(ID As Long, Optional sKey As String) As RelationTable
    
    'create a new object
    Dim objNewMember As RelationTable
    
    Set objNewMember = New RelationTable

    'set the properties passed into the method
    objNewMember.ID = ID

    If Len(sKey) = 0 Then
        mCol.Add objNewMember
    Else
        mCol.Add objNewMember, sKey
    End If

    'return the object created
    Set Add = objNewMember
    Set objNewMember = Nothing

End Function

Public Property Get Item(vntIndexKey As Variant) As RelationTable
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

Public Function exist(aTableID As Long) As Boolean

    Dim iter As RelationTable
    Dim found As Boolean
    
    found = False
    For Each iter In mCol
        If iter.ID = aTableID Then
            found = True
            Exit For
        End If
    Next
    
    exist = found

End Function
