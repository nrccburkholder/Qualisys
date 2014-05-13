Option Explicit On 
Option Strict On

Imports System.Data.SqlClient
Imports NormsApplicationBusinessObjectsLibrary

Public Class CanadaNormSettingApproveCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As CanadaNormSettingApprove
        Get
            Return DirectCast(MyBase.List(index), CanadaNormSettingApprove)
        End Get
    End Property

    Public Function Add(ByVal value As CanadaNormSettingApprove) As Integer
        Return MyBase.List.Add(value)
    End Function

    Public Sub New(ByVal normID As Integer)
        Dim checkItem As CanadaNormSettingApprove.CheckItemType
        Dim modifierMemberID As Integer
        Dim modifierName As String
        Dim modifyDate As Date
        Dim approveStatus As CanadaNormSettingApprove.ApproveStatusType
        Dim approverMemberID As Integer
        Dim approverName As String = String.Empty
        Dim approveDate As Date

        Dim rdr As SqlDataReader = DataAccess.SelectCanadaNormApproveInfo(normID)
        Do While rdr.Read
            checkItem = CType(rdr("NormCheckItem_ID"), CanadaNormSettingApprove.CheckItemType)
            modifierMemberID = CInt(rdr("ModifierMember_ID"))
            modifierName = CStr(rdr("ModifierName"))
            modifyDate = CDate(rdr("ModifyDate"))
            approveStatus = CType(rdr("ApproveStatus"), CanadaNormSettingApprove.ApproveStatusType)
            If (Not IsDBNull(rdr("ApproverMember_ID"))) Then
                approverMemberID = CInt(rdr("ApproverMember_ID"))
            End If
            If (Not IsDBNull(rdr("ApproverName"))) Then
                approverName = CStr(rdr("ApproverName"))
            End If
            If (Not IsDBNull(rdr("ApproveDate"))) Then
                approveDate = CDate(rdr("ApproveDate"))
            End If

            If (approveStatus = CanadaNormSettingApprove.ApproveStatusType.Waiting) Then
                Me.Add(New CanadaNormSettingApprove(normID, _
                                                    checkItem, _
                                                    modifierMemberID, _
                                                    modifierName, _
                                                    modifyDate, _
                                                    approveStatus))
            Else
                Me.Add(New CanadaNormSettingApprove(normID, _
                                                    checkItem, _
                                                    modifierMemberID, _
                                                    modifierName, _
                                                    modifyDate, _
                                                    approveStatus, _
                                                    approverMemberID, _
                                                    approverName, _
                                                    approveDate))
            End If
        Loop
        If (Not rdr Is Nothing) Then rdr.Close()
    End Sub

    Public ReadOnly Property Approve(ByVal checkItem As CanadaNormSettingApprove.CheckItemType) As CanadaNormSettingApprove
        Get
            Dim app As CanadaNormSettingApprove
            For Each app In Me
                If (app.CheckItem = checkItem) Then Return app
            Next
            Return Nothing
        End Get
    End Property

End Class
