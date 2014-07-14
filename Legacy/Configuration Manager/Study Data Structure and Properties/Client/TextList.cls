VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "TextList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private colList As Collection
Private colKeys As Collection

Private Sub Class_Initialize()
  
    Set colList = New Collection
    Set colKeys = New Collection

End Sub

Friend Sub Load(ListName As String)
  
    Dim objDB As StudyDataPROC.TextListDB
    
    Set objDB = CreateObject("StudyDataPROC.TextListDB")
    
    With objDB
        .Fetch ListName
        SetState .GetState
    End With
    Set objDB = Nothing

End Sub

Friend Sub LoadClientContacts(ClientID As Long)
  
    Dim objDB As TextListDB
    
    Set objDB = New TextListDB
    With objDB
        .FetchClientContacts ClientID
        SetState .GetState
    End With
    Set objDB = Nothing

End Sub

Public Function Item(ByVal Index As Variant) As String
Attribute Item.VB_UserMemId = 0
  
    Item = colList.Item(Index)

End Function

Public Function Key(ByVal Text As String) As String
  
    Key = colKeys.Item(Text)

End Function

Public Function Count() As Long
    
    Count = colList.Count
    
End Function

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    
    Set NewEnum = colList.[_NewEnum]
    
End Function

Private Sub SetState(ByVal Buffer As String)
  
    Dim objBuffer As Buffer
    Dim lngIndex As Long
    Dim udtProps As TextListProps
    Dim udtData As TextListData
    
    Set objBuffer = New Buffer
    objBuffer.SetState Buffer
    
    With objBuffer
        For lngIndex = 1 To objBuffer.Count
            udtData.Buffer = objBuffer.Item(lngIndex)
            LSet udtProps = udtData
            With udtProps
                colList.Add Trim(Format$(.Item)), Trim(Format$(.Key))
                colKeys.Add Trim(Format$(.Key)), Trim(Format$(.Item))
            End With
        Next
    End With

End Sub
