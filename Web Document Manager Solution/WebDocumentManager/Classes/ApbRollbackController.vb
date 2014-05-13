Option Explicit On 
Option Strict On

Imports System.Data.SqlClient
Imports System.Text
Imports NRC.DataMart.WebDocumentManager.Library
Imports System.Threading

Public Class ApbRollbackController

#Region " Public Members"

    Public Enum RollbackStatus
        Rollbacking = 1
        Succeed = 2
        Failed = 3
    End Enum

#End Region

#Region " Private Members"

    'Filters
    Private mFilterMemberID As Integer
    Private mFilterPostDate As DateRange
    Private mFilterClientID As Integer
    Private mFilterReportDate As DateRange
    Private mFilterGroupIDs As ArrayList
    Private mFilterDocNameKeyword As String

    'Most important report data. Contain all the info of the reports, groups and doc copies
    Private mReports As ApbReportCollection

    'Group reports by group. Only used in "Select group (group by user group" view
    Private mGroupListItems As ApbGroupListItemCollection

    'Posting status variables
    Private mRollbackedCount As Integer
    Private mRollbackMessage As String
    Private mRollbackResult As RollbackStatus

#End Region

#Region " Public Properties"

    Public Property FilterMemberID() As Integer
        Get
            Return mFilterMemberID
        End Get
        Set(ByVal Value As Integer)
            mFilterMemberID = Value
        End Set
    End Property

    Public Property FilterPostDate() As DateRange
        Get
            Return mFilterPostDate
        End Get
        Set(ByVal Value As DateRange)
            mFilterPostDate = Value
        End Set
    End Property

    Public Property FilterClientID() As Integer
        Get
            Return mFilterClientID
        End Get
        Set(ByVal Value As Integer)
            mFilterClientID = Value
        End Set
    End Property

    Public Property FilterReportDate() As DateRange
        Get
            Return mFilterReportDate
        End Get
        Set(ByVal Value As DateRange)
            mFilterReportDate = Value
        End Set
    End Property

    Public Property FilterGroupIDs() As ArrayList
        Get
            Return mFilterGroupIDs
        End Get
        Set(ByVal Value As ArrayList)
            mFilterGroupIDs = Value
        End Set
    End Property

    Public Property FilterDocNameKeyword() As String
        Get
            Return mFilterDocNameKeyword
        End Get
        Set(ByVal Value As String)
            mFilterDocNameKeyword = Value.Trim
        End Set
    End Property

    Public ReadOnly Property Reports() As ApbReportCollection
        Get
            Return mReports
        End Get
    End Property

    Public ReadOnly Property GroupListItems() As ApbGroupListItemCollection
        Get
            Return mGroupListItems
        End Get
    End Property

    Public Property RollbackedCount() As Integer
        Get
            Return mRollbackedCount
        End Get
        Set(ByVal Value As Integer)
            mRollbackedCount = Value
        End Set
    End Property

    Public Property RollbackMessage() As String
        Get
            Return mRollbackMessage
        End Get
        Set(ByVal Value As String)
            mRollbackMessage = Value
        End Set
    End Property

    Public Property RollbackResult() As RollbackStatus
        Get
            Return mRollbackResult
        End Get
        Set(ByVal Value As RollbackStatus)
            mRollbackResult = Value
        End Set
    End Property

    Public ReadOnly Property SelectedDocumentCount() As Integer
        Get
            Dim report As ApbReport = Nothing
            Dim group As ApbGroup = Nothing
            Dim count As Integer = 0

            If (Reports Is Nothing) Then Return 0

            For Each report In Reports.Values
                For Each group In report.Groups.Values
                    If (group.DoRollback) Then
                        count += group.DocCopies.Count
                    End If
                Next
            Next
            Return count
        End Get
    End Property

#End Region

#Region " Public Methods"

    Public Function SelectMembers() As SqlDataReader
        Return DAL.SelectApbRollbackMemberList(CurrentUser.Member.MemberId)
    End Function

    Public Function SelectClients() As SqlDataReader
        If (Me.FilterPostDate Is Nothing) Then Return Nothing

        Return DAL.SelectApbRollbackClientList(Me.mFilterMemberID, _
                                               Me.FilterPostDate.DateBegin, _
                                               Me.FilterPostDate.DateEnd)
    End Function

    Public Function SelectGroups() As SqlDataReader
        If (Me.FilterPostDate Is Nothing OrElse _
            Me.FilterReportDate Is Nothing) Then Return Nothing

        Return DAL.SelectApbRollbackGroupList(Me.mFilterMemberID, _
                                              Me.FilterPostDate.DateBegin, _
                                              Me.FilterPostDate.DateEnd, _
                                              Me.FilterClientID, _
                                              Me.FilterReportDate.DateBegin, _
                                              Me.FilterReportDate.DateEnd)
    End Function

    Public Sub SelectDocuments()
        If (Me.FilterPostDate Is Nothing OrElse _
            Me.FilterReportDate Is Nothing) Then Return

        Dim report As ApbReport = Nothing
        Dim group As ApbGroup = Nothing
        Dim groupListItem As ApbGroupListItem
        Dim docCopy As ApbDocCopy

        Dim prevJobID As Integer = 0
        Dim prevGroupID As Integer

        Dim jobID As Integer
        Dim apID As String
        Dim documentID As Integer
        Dim dateRangeBegin As Date
        Dim dateRangeEnd As Date
        Dim documentName As String
        Dim groupID As Integer
        Dim orgUnitName As String
        Dim groupName As String
        Dim datePosted As Date
        Dim nodeID As Integer
        Dim documentNodeID As Integer

        Dim groupList() As StringBuilder = ConcateGroupLists()
        Dim rdr As SqlDataReader = DAL.SelectApbRollbackDocList( _
                                            Me.mFilterMemberID, _
                                            Me.mFilterPostDate.DateBegin, _
                                            Me.mFilterPostDate.DateEnd, _
                                            Me.mFilterClientID, _
                                            Me.mFilterReportDate.DateBegin, _
                                            Me.mFilterReportDate.DateEnd, _
                                            groupList, _
                                            Me.mFilterDocNameKeyword)

        'Query job and group list
        mReports = New ApbReportCollection
        mGroupListItems = New ApbGroupListItemCollection

        While rdr.Read
            'Read record
            jobID = CInt(rdr("Job_ID"))
            apID = CStr(rdr("AP_ID"))
            documentID = CInt(rdr("Document_ID"))
            documentName = CStr(rdr("strDocument_NM"))
            dateRangeBegin = CDate(rdr("ReportDateBegin"))
            dateRangeEnd = CDate(rdr("ReportDateEnd"))
            groupID = CInt(rdr("Group_ID"))
            orgUnitName = CStr(rdr("strOrgUnit_NM"))
            groupName = CStr(rdr("strGroup_nm"))
            datePosted = CDate(rdr("datPosted"))
            nodeID = CInt(rdr("Node_ID"))
            documentNodeID = CInt(rdr("DocumentNode_ID"))

            'New job ID?
            If (jobID <> prevJobID) Then
                prevJobID = jobID
                prevGroupID = 0
                report = New ApbReport
                Me.mReports.Add(jobID, report)
                With report
                    .JobID = jobID
                    .ApID = apID
                    .DocumentID = documentID
                    .DateRangeBegin = dateRangeBegin
                    .DateRangeEnd = dateRangeEnd
                    .DocumentName = documentName
                End With
            End If

            'New group ID?
            If (groupID <> prevGroupID) Then
                prevGroupID = groupID
                group = New ApbGroup(groupID, groupName)
                report.Groups.Add(groupID, group)
                group.DatePosted = datePosted

                'Add report to group list item
                groupListItem = Me.mGroupListItems.Item(groupID)
                If (groupListItem Is Nothing) Then
                    groupListItem = New ApbGroupListItem
                    mGroupListItems.Add(groupID, groupListItem)
                    With groupListItem
                        .GroupID = groupID
                        .GroupName = groupName
                    End With
                End If
                groupListItem.Reports.Add(jobID, report)
            End If

            'DocCopy
            docCopy = New ApbDocCopy
            docCopy.NodeID = nodeID
            docCopy.DocumentNodeID = documentNodeID
            group.DocCopies.Add(docCopy)

        End While
        rdr.Close()
    End Sub

    Public Sub Rollback()
        Dim report As ApbReport = Nothing
        Dim group As ApbGroup = Nothing
        Dim docCopy As ApbDocCopy = Nothing

        Try
            'Initalize
            mRollbackResult = RollbackStatus.Rollbacking
            mRollbackedCount = 0
            mRollbackMessage = ""


            For Each report In Me.mReports.Values
                For Each group In report.Groups.Values
                    If (group.DoRollback) Then

                        For Each docCopy In group.DocCopies
                            mRollbackMessage = "Rollbacking " + report.DocumentName + " (" & report.DocumentID & ") from group " + group.GroupName + " ..."
                            'Thread.Sleep(200)

                            'Rollback a document
                            RollbackDocument(report, group, docCopy)

                            mRollbackedCount += 1
                            mRollbackMessage = report.DocumentName + " (" & report.DocumentID & ") is rollbacked from group " + group.GroupName + "."

                        Next docCopy
                    End If
                Next group
            Next report
            mRollbackResult = RollbackStatus.Succeed

        Catch ex As Exception
            mRollbackResult = RollbackStatus.Failed
            mRollbackMessage = "Error happened when rollbacking " + report.DocumentName + " (" & report.DocumentID & ") from group " + group.GroupName + "." + vbCrLf _
                               + ex.Message

        Finally
            If (mRollbackResult <> RollbackStatus.Succeed AndAlso mRollbackResult <> RollbackStatus.Failed) Then
                mRollbackResult = RollbackStatus.Failed
            End If
        End Try

    End Sub

#End Region

#Region " Private Methods"

    Private Function ConcateGroupLists() As StringBuilder()
        Dim concateGroupList(9) As StringBuilder
        Dim i As Integer
        Dim groupID As Integer

        'Concatenate job list into 10 strings. each string is less than 8000 chars
        For i = 0 To concateGroupList.Length - 1
            concateGroupList(i) = New StringBuilder
        Next

        'No individual group selected
        If (Me.mFilterGroupIDs Is Nothing OrElse Me.mFilterGroupIDs.Count = 0) Then
            Return (concateGroupList)
        End If

        'Concate the individual groups into group list
        i = 0

        For Each groupID In Me.mFilterGroupIDs
            If (concateGroupList(i).Length >= 7990) Then i += 1
            concateGroupList(i).Append(groupID & ",")
        Next
        'remove the last ","
        concateGroupList(i).Remove(concateGroupList(i).Length - 1, 1)

        Return concateGroupList
    End Function

    Private Sub RollbackDocument(ByVal report As ApbReport, ByVal group As ApbGroup, ByVal docCopy As ApbDocCopy)
        Dim documentNodeID As Integer = docCopy.DocumentNodeID
        Dim memberID As Integer = CurrentUser.Member.MemberId
        Document.DeleteDocument(documentNodeID, memberID, False)
    End Sub

#End Region


End Class
