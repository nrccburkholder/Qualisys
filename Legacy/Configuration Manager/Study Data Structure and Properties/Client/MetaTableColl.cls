VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MetaTableColl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private colMetaTables As Collection
Private colDeleted As Collection

Private fldChildEditing As Boolean

Public Sub ChildBeginEdit()
    Dim objMetaTable As MetaTable
    
    If fldChildEditing Then Err.Raise 445
    
    ' save object state
    For Each objMetaTable In colMetaTables
        objMetaTable.ChildBeginEdit
    Next
    
    fldChildEditing = True
End Sub

Public Sub ChildCancelEdit()
    Dim objMetaTable As MetaTable
    Dim lngIndex As Long
    
    If Not fldChildEditing Then Err.Raise 445
    
    fldChildEditing = False
    For lngIndex = colDeleted.Count To 1 Step -1
        With colDeleted
            colMetaTables.Add Item:=.Item(lngIndex)
            .Remove lngIndex
        End With
    Next
    
    For lngIndex = colMetaTables.Count To 1 Step -1
        Set objMetaTable = colMetaTables.Item(lngIndex)
        With objMetaTable
            .ChildCancelEdit
            If .IsNew Then _
                colMetaTables.Remove lngIndex
        End With
    Next lngIndex
End Sub

Public Sub ChildApplyEdit(StudyID As Long)
    Dim objDB As MetaTableCollDB
    Dim objStudyDB As StudyDB
    Dim objMetaTable As MetaTable
    Dim lngIndex As Long
    Dim popid As Long
    Dim encid As Long
    Dim provid As Long
    
    If Not fldChildEditing Then Err.Raise 445
    If Not IsValid Then Err.Raise 445
    
    Set objDB = New MetaTableCollDB
    With objDB
        .SetState GetState
        .Save StudyID
        SetState .GetState
    End With
    Set objDB = Nothing
  
    'LOGIC:
    '  The SetState function builds the buffer with the
    '  regular collection elements first, and then with
    '  the deleted collection elements.  After saving,
    '  only the regular collection elements comeback,
    '  and in the same order they were sent.  So we can
    '  loop through the regular collection elements and
    '  save the grandchildren objects. The immediate
    '  children have been saved here.
    '
    popid = 0
    encid = 0
    provid = 0
 
    For lngIndex = colMetaTables.Count To 1 Step -1
        Set objMetaTable = colMetaTables.Item(lngIndex)
        objMetaTable.MetaFieldColl.ChildApplyEdit objMetaTable.ID
        objMetaTable.ResetValues
        
        If objMetaTable.IsPopulationTable Then _
            popid = objMetaTable.ID
        If objMetaTable.IsEncounterTable Then _
            encid = objMetaTable.ID
        If objMetaTable.IsProviderTable Then _
            provid = objMetaTable.ID
    Next
  
         
    If (popid > 0) Or (encid > 0) Or (provid > 0) Then
        Set objStudyDB = New StudyDB
        objStudyDB.SavePredefinedTables StudyID, popid, encid, provid
        Set objStudyDB = Nothing
    End If
  
    fldChildEditing = False
End Sub

Friend Sub Load(StudyID As Long)
    Dim objDB As MetaTableCollDB
    
    If fldChildEditing Then Err.Raise 445
    
    Set objDB = New MetaTableCollDB
    With objDB
        .Fetch StudyID
        SetState .GetState
    End With
    
    Set objDB = Nothing

End Sub

Public Sub Remove(ByVal Index As Variant)
  
    Dim objMetaTable As MetaTable
    
    If Not fldChildEditing Then Err.Raise 445
    
    Set objMetaTable = colMetaTables.Item(Index)
    objMetaTable.Delete
    colDeleted.Add Item:=objMetaTable
    colMetaTables.Remove Index

End Sub

Public Sub Delete()
  
    Dim objMetaTable As MetaTable
    Dim lngIndex As Long
    
    If Not fldChildEditing Then Err.Raise 445
    
    For lngIndex = colMetaTables.Count To 1 Step -1
        Set objMetaTable = colMetaTables.Item(lngIndex)
        objMetaTable.Delete
        colDeleted.Add Item:=objMetaTable
        colMetaTables.Remove lngIndex
    Next

End Sub

Private Sub Class_Initialize()
  
    Set colMetaTables = New Collection
    Set colDeleted = New Collection

End Sub

Private Function Add() As MetaTable
  
    Dim objMetaTable As MetaTable
    
    Set objMetaTable = New MetaTable
    objMetaTable.SetAsChild
    Set objMetaTable.Parent = Me
    
    If fldChildEditing Then objMetaTable.ChildBeginEdit
    Set Add = objMetaTable

End Function

Friend Sub AddChild(NewMetaTable As MetaTable)
  
    colMetaTables.Add Item:=NewMetaTable

End Sub

Public Function Item(ByVal Index As Variant) As MetaTable
Attribute Item.VB_UserMemId = 0
  
    Set Item = colMetaTables(Index)

End Function

Public Function Count() As Long
    
    Count = colMetaTables.Count
    
End Function

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    
    Set NewEnum = colMetaTables.[_NewEnum]
    
End Function

Private Sub SetState(ByVal Buffer As String)
  
    Dim lngIndex As Long
    Dim objMetaTable As MetaTable
    Dim objBuffer As Buffer
    
    If colMetaTables.Count = 0 Then
        ' load for the first time
        Set colMetaTables = New Collection
        Set colDeleted = New Collection
        
        Set objBuffer = New Buffer
        objBuffer.SetState Buffer
        
        For lngIndex = 1 To objBuffer.Count
            Set objMetaTable = New MetaTable
            With objMetaTable
                .SetAsChild
                .SetState objBuffer.Item(lngIndex)
            End With
            colMetaTables.Add Item:=objMetaTable
        Next
    Else
        ' refresh after save
        Set colDeleted = New Collection
        
        Set objBuffer = New Buffer
        objBuffer.SetState Buffer
        
        For lngIndex = 1 To objBuffer.Count
            Set objMetaTable = colMetaTables.Item(lngIndex)
            With objMetaTable
                .SetState objBuffer.Item(lngIndex)
            End With
        Next
    End If
        
End Sub

Private Function GetState() As String
  
    Dim objBuffer As Buffer
    Dim objMetaTable As MetaTable
    
    Set objBuffer = New Buffer
    Set objMetaTable = New MetaTable
    objBuffer.Initialize Len(objMetaTable.GetState), 20
    
    For Each objMetaTable In colMetaTables
        objBuffer.Add objMetaTable.GetState
    Next
    
    For Each objMetaTable In colDeleted
        objBuffer.Add objMetaTable.GetState
    Next
    
    GetState = objBuffer.GetState
    Set objBuffer = Nothing

End Function

Public Function AddEncounterTable() As MetaTable
    
    Dim objMetaTable As MetaTable
    
    Set objMetaTable = Add
    With objMetaTable
        .BeginEdit
        .name = ENCOUNTER_TABLE
        .Description = ""
        .UsesAddress = False
        .ApplyEdit
    End With
    
    Set AddEncounterTable = objMetaTable

End Function

Public Function AddProviderTable() As MetaTable
    
    Dim objMetaTable As MetaTable
    
    Set objMetaTable = Add
    With objMetaTable
        .BeginEdit
        .name = PROVIDER_TABLE
        .Description = ""
        .UsesAddress = False
        .ApplyEdit
    End With
    
    Set AddProviderTable = objMetaTable

End Function

Public Function AddPopulationTable() As MetaTable
    
    Dim objMetaTable As MetaTable
    
    Set objMetaTable = Add
    With objMetaTable
        .BeginEdit
        .name = POPULATION_TABLE
        .Description = ""
        .UsesAddress = False
        .ApplyEdit
    End With
    Set AddPopulationTable = objMetaTable

End Function

Public Function AddCustomTable() As MetaTable
    
    Set AddCustomTable = Add

End Function

Public Function IsValid() As Boolean

    ' Check to make sure that only one table
    ' has the usesAddress field selected.
    
    Dim objMetaTable As MetaTable
    Dim intCount As Integer
    
    intCount = 0
    
    For Each objMetaTable In colMetaTables
        If objMetaTable.UsesAddress Then
            intCount = intCount + 1
        End If
    Next
    
    If intCount > 1 Then
        IsValid = False
    Else
        IsValid = True
    End If

End Function

Public Function ListItem(aTableID As Long) As MetaTable
    
    Dim iterItem As MetaTable
    
    Set ListItem = Nothing
    
    For Each iterItem In colMetaTables
        If iterItem.ID = aTableID Then
            Set ListItem = iterItem
            Exit For
        End If
    Next
        
End Function

'TODO check if we need this function
Public Sub deleteTable(aTableName As String)
    
    Dim aTable As MetaTable
    Dim lngIndex As Long
    
    For lngIndex = colMetaTables.Count To 1 Step -1
        Set aTable = colMetaTables.Item(lngIndex)
        If Trim(aTable.name) = aTableName Then
            aTable.Delete
            colDeleted.Add aTable
            colMetaTables.Remove lngIndex
        End If
    Next lngIndex

End Sub
