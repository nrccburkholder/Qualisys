Option Explicit On 
Option Strict On

Imports System.Data.SqlClient
Imports System.Text
Imports System.Threading
Imports System.IO
Imports NRC.DataMart.WebDocumentManager.Library

Public Class ApbPostController

#Region " Public Events"

    Public Event DocumentExist(ByVal report As ApbReport, ByVal group As ApbGroup, ByVal docCopy As ApbDocCopy, ByVal nodeID As Integer)
    Public Event DocumentExistChecked(ByVal checkedCount As Integer)

#End Region

#Region " Public Members"

    Public Enum ComfirmResult
        Unknown = 0
        Cancel = 1
        Yes = 2
        YesToAll = 3
        No = 4
        NoToAll = 5
    End Enum

    Public Enum PostStatus
        Posting = 1
        Succeed = 2
        Failed = 3
    End Enum

#End Region

#Region " Private Members"

    'Filter for selecting postable report
    Private mNotify As String
    Private mJobGenerateDate As New DateRange(Date.Today, Date.Today)
    Private mClientID As Integer

    'Selected jobs
    Private mJobList() As Integer
    Private mJobListChanged As Boolean = False

    'Most important report data. Contain all the info of the reports, groups and doc copies
    Private mReports As ApbReportCollection

    'Group reports by group. Only used in "Select group (group by user group" view
    Private mGroupListItems As ApbGroupListItemCollection

    'Path collection used to check duplicate path
    Private mPaths As ApbPathCollection

    'User's answer to question of replacing existing 
    Private mReplaceConfirmResult As ComfirmResult

    'Posting status variables
    Private mPostedCount As Integer
    Private mPostMessage As String
    Private mPostResult As PostStatus


#End Region

#Region " Public Properties"

    Public Property Notify() As String
        Get
            Return mNotify
        End Get
        Set(ByVal Value As String)
            mNotify = Value
        End Set
    End Property

    Public Property ClientID() As Integer
        Get
            Return mClientID
        End Get
        Set(ByVal Value As Integer)
            mClientID = Value
        End Set
    End Property

    Public Property JobGenerateDate() As DateRange
        Get
            Return mJobGenerateDate
        End Get
        Set(ByVal Value As DateRange)
            mJobGenerateDate = Value
        End Set
    End Property

    Public Property JobList() As Integer()
        Get
            Return mJobList
        End Get
        Set(ByVal Value As Integer())
            mJobListChanged = False

            If (mJobList Is Nothing AndAlso _
                Value Is Nothing) Then
                Return
            ElseIf (mJobList Is Nothing AndAlso _
                Not Value Is Nothing) Then
                mJobListChanged = True

            ElseIf (Not mJobList Is Nothing AndAlso _
                            Value Is Nothing) Then
                mJobListChanged = True

            ElseIf (mJobList.Length <> Value.Length) Then
                mJobListChanged = True
            Else
                Array.Sort(Value)
                Dim i As Integer
                For i = 0 To Value.Length - 1
                    If (mJobList(i) <> Value(i)) Then
                        mJobListChanged = True
                        Exit For
                    End If
                Next
            End If

            If (mJobListChanged) Then
                mJobList = Value
            End If
        End Set
    End Property

    Public ReadOnly Property JobListChanged() As Boolean
        Get
            Return mJobListChanged
        End Get
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

    Public ReadOnly Property Paths() As ApbPathCollection
        Get
            Return mPaths
        End Get
    End Property

    Public ReadOnly Property SelectedDocumentCount() As Integer
        Get
            Dim report As ApbReport
            Dim group As ApbGroup
            Dim docCopy As ApbDocCopy
            Dim doPost As Boolean
            Dim count As Integer = 0

            For Each report In Reports.Values
                For Each group In report.Groups.Values
                    If (group.DoPost) Then
                        For Each docCopy In group.DocCopies
                            Select Case docCopy.DocumentExisting
                                Case ApbDocCopy.DocumentExistStatus.Unknown, _
                                     ApbDocCopy.DocumentExistStatus.NotExist
                                    doPost = True
                                Case ApbDocCopy.DocumentExistStatus.Exist
                                    doPost = docCopy.ReplaceExistingDocument
                            End Select
                            If (doPost) Then count += 1
                        Next
                    End If
                Next
            Next
            Return count
        End Get
    End Property

    Public Property ReplaceConfirmResult() As ComfirmResult
        Get
            Return mReplaceConfirmResult
        End Get
        Set(ByVal Value As ComfirmResult)
            mReplaceConfirmResult = Value
        End Set
    End Property

    Public ReadOnly Property PostResult() As PostStatus
        Get
            Return mPostResult
        End Get
    End Property

    Public ReadOnly Property PostedCount() As Integer
        Get
            Return mPostedCount
        End Get
    End Property

    Public ReadOnly Property PostMessage() As String
        Get
            Return mPostMessage
        End Get
    End Property

#End Region

#Region " Public Methods"

    Public Function PullNotifyList() As SqlDataReader
        Return DAL.SelectApbNotifyList(CurrentUser.OrgUnitsConcateString)
    End Function

    Public Function PullClientList() As SqlDataReader
        Return DAL.SelectApbClientList( _
                            CurrentUser.OrgUnitsConcateString, _
                            mJobGenerateDate.DateBegin, _
                            mJobGenerateDate.DateEnd, _
                            mNotify)
    End Function

    Public Function PullPostableApList() As SqlDataReader
        Dim orgUnitConcateString As String = CurrentUser.OrgUnitsConcateString
        Return DAL.SelectPostableApbList( _
                            orgUnitConcateString, _
                            mClientID, _
                            mJobGenerateDate.DateBegin, _
                            mJobGenerateDate.DateEnd, _
                            mNotify)
    End Function

    Public Sub PopulateReportGroupList(ByVal forceToRefresh As Boolean)
        If (Not forceToRefresh AndAlso mJobListChanged = False) Then Return

        Dim concateJobList() As StringBuilder = ConcateJobLists()
        Dim report As ApbReport = Nothing
        Dim group As ApbGroup = Nothing
        Dim docCopy As ApbDocCopy = Nothing
        Dim groupListItem As ApbGroupListItem

        Dim prevJobID As Integer = 0
        Dim prevGroupID As Integer
        Dim prevStartNodeID As Integer

        Dim jobID As Integer
        Dim apID As String
        Dim documentID As Integer
        Dim dateRangeBegin As Date
        Dim dateRangeEnd As Date
        Dim documentName As String
        Dim filePath As String
        Dim url As String
        Dim groupID As Integer
        Dim groupName As String
        Dim treeGroupID As Integer
        Dim startNodeID As Integer
        Dim startNodePath As String
        Dim subNodeLevelOrder As Integer
        Dim subNodeName As String

        'Query job and group list
        Dim rdr As SqlDataReader = DAL.SelectApbReportGroupList(concateJobList)
        mReports = New ApbReportCollection
        mGroupListItems = New ApbGroupListItemCollection

        While rdr.Read
            'Read record
            jobID = CInt(rdr("Job_ID"))
            apID = CStr(rdr("AP_ID"))
            documentID = CInt(rdr("Document_ID"))
            dateRangeBegin = CDate(rdr("DateRangeBegin"))
            dateRangeEnd = CDate(rdr("DateRangeEnd"))
            documentName = CStr(rdr("strDocument_NM"))
            filePath = CStr(rdr("Path"))
            url = CStr(rdr("Url"))
            groupID = CInt(rdr("AuthGroup_ID"))
            groupName = CStr(rdr("strGroup_nm"))
            treeGroupID = CInt(rdr("TreeGroup_ID"))
            startNodeID = CInt(rdr("StartNode_ID"))
            startNodePath = CStr(rdr("StartNodePath"))
            subNodeLevelOrder = CInt(rdr("NodeLevelOrder"))
            subNodeName = CStr(rdr("strNode_Nm"))

            'New job ID?
            If (jobID <> prevJobID) Then
                prevJobID = jobID
                prevGroupID = 0
                report = New ApbReport
                Me.mReports.Add(apID, report)
                With report
                    .JobID = jobID
                    .ApID = apID
                    .DocumentID = documentID
                    .DateRangeBegin = dateRangeBegin
                    .DateRangeEnd = dateRangeEnd
                    .DocumentName = documentName
                    .FilePath = filePath
                    .Url = url
                End With
            End If

            'New group ID?
            If (groupID <> prevGroupID) Then
                prevGroupID = groupID
                prevStartNodeID = 0
                group = New ApbGroup(groupID, groupName, treeGroupID)
                report.Groups.Add(groupID, group)

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
                groupListItem.Reports.Add(apID, report)
            End If

            'New start node ID?
            If (prevStartNodeID <> startNodeID) Then
                prevStartNodeID = startNodeID
                docCopy = New ApbDocCopy(startNodeID, report.DocumentName, startNodePath)
                group.DocCopies.Add(docCopy)
            End If

            'Has subnode?
            If (subNodeName <> "") Then
                docCopy.SubNodeNames.Add(subNodeName)
            End If

        End While
        rdr.Close()

        CreateSubPathName()
    End Sub

    Public Function IsFileExist(ByVal path As String) As Boolean
        Dim file As New FileInfo(path)
        Return file.Exists
    End Function

    Public Function DuplicatedPath() As Boolean
        Dim path As ApbPath
        Dim duplicateExist As Boolean = False
        Dim report As ApbReport
        Dim group As ApbGroup
        Dim docCopy As ApbDocCopy
        Dim destReport As ApbReport
        Dim destGroup As ApbGroup
        Dim pathKey As String

        mPaths = New ApbPathCollection
        For Each report In Reports.Values
            For Each group In report.Groups.Values
                If (group.DoPost) Then
                    For Each docCopy In group.DocCopies
                        'Look up the path object by key "<group ID>:<full path>"
                        '   If not exists, create a new one
                        '   If exists, means there are duplicate
                        pathKey = group.GroupID & ":" + docCopy.FullPath
                        path = mPaths.Item(pathKey)
                        If (path Is Nothing) Then
                            path = New ApbPath(group.GroupID, docCopy.FullPath)
                            mPaths.Add(pathKey, path)
                        Else
                            duplicateExist = True
                        End If

                        destReport = New ApbReport
                        path.Reports.Add(destReport)
                        With destReport
                            .ApID = report.ApID
                            .DateRangeBegin = report.DateRangeBegin
                            .DateRangeEnd = report.DateRangeEnd
                            .DocumentName = report.DocumentName
                            .JobID = report.JobID
                            .Url = report.Url
                        End With

                        With group
                            destGroup = New ApbGroup(.GroupID, .GroupName, .TreeGroupID)
                        End With
                        destReport.Groups.Add(group.GroupID, destGroup)
                        destGroup.DocCopies.Add(docCopy)
                    Next
                End If
            Next
        Next

        Return (duplicateExist)

    End Function

    Public Sub Refresh()
        Dim reportsBackup As ApbReportCollection = mReports
        PopulateReportGroupList(True)

        Dim bkReport As ApbReport
        Dim bkGroup As ApbGroup
        Dim newReport As ApbReport
        Dim newGroup As ApbGroup

        For Each bkReport In reportsBackup.Values
            newReport = Me.mReports(bkReport.ApID)
            If (Not newReport Is Nothing) Then
                For Each bkGroup In bkReport.Groups.Values
                    newGroup = newReport.Groups(bkGroup.GroupID)
                    If (Not newGroup Is Nothing) Then
                        newGroup.DoPost = bkGroup.DoPost
                    End If
                Next
            End If
        Next
    End Sub

    Public Sub RepostCheck()
        Dim report As ApbReport
        Dim group As ApbGroup
        Dim docCopy As ApbDocCopy
        Dim checkedCount As Integer = 0

        Dim testCount As Integer = 0

        'Initialize
        Me.ReplaceConfirmResult = ComfirmResult.Unknown

        For Each report In Reports.Values
            For Each group In report.Groups.Values
                For Each docCopy In group.DocCopies
                    docCopy.DocumentExisting = ApbDocCopy.DocumentExistStatus.Unknown
                    docCopy.ReplaceExistingDocument = False
                Next
            Next
        Next

        'Check
        mPaths = New ApbPathCollection
        For Each report In Reports.Values
            testCount += 1
            For Each group In report.Groups.Values
                If (group.DoPost) Then
                    For Each docCopy In group.DocCopies
                        CheckDocumentPosted(report, group, docCopy)
                        If (Me.ReplaceConfirmResult = ComfirmResult.Cancel) Then Return
                        checkedCount += 1
                        RaiseEvent DocumentExistChecked(checkedCount)
                    Next docCopy
                End If
            Next group
        Next report

    End Sub

    Public Sub Post()
        Dim report As ApbReport = Nothing
        Dim group As ApbGroup = Nothing
        Dim docCopy As ApbDocCopy = Nothing

        Try
            'Initalize
            mPostResult = PostStatus.Posting
            mPostedCount = 0
            mPostMessage = ""


            For Each report In Me.mReports.Values
                For Each group In report.Groups.Values
                    If (Not group.DoPost) Then GoTo NextLoopGroup
                    For Each docCopy In group.DocCopies
                        'Don't replace the existing doc
                        If (docCopy.DocumentExisting = ApbDocCopy.DocumentExistStatus.Exist AndAlso _
                            docCopy.ReplaceExistingDocument = False) Then GoTo NextLoopDocCopy

                        mPostMessage = "Posting " + report.DocumentName + " (" + report.ApID + ") to group " + group.GroupName + " ..."
                        'Thread.Sleep(200)

                        'Post a document
                        PostDocument(report, group, docCopy)

                        mPostedCount += 1
                        mPostMessage = report.DocumentName + " (" + report.ApID + ") is posted to group " + group.GroupName + "."

NextLoopDocCopy:
                    Next docCopy

NextLoopGroup:
                Next group
            Next report
            mPostResult = PostStatus.Succeed

        Catch ex As Exception
            mPostResult = PostStatus.Failed
            mPostMessage = "Error happened when posting " + report.DocumentName + " (" + report.ApID + ") to group " + group.GroupName + "." + vbCrLf _
                           + "doument ID = " & report.DocumentID & ", Start node ID = " & docCopy.StartNodeID & ", node ID = " & docCopy.NodeID & vbCrLf _
                           + "sub node path = '" & docCopy.SubNodePath & "'" & vbCrLf _
                           + ex.Message

        Finally
            If (mPostResult <> PostStatus.Succeed AndAlso mPostResult <> PostStatus.Failed) Then
                mPostResult = PostStatus.Failed
            End If
        End Try

    End Sub

#End Region

#Region " Private Methods"

    Private Function ConcateJobLists() As StringBuilder()
        Dim concateJobList(9) As StringBuilder
        Dim i As Integer
        Dim j As Integer

        'Concatenate job list into 10 strings. each string is less than 8000 chars
        For i = 0 To concateJobList.Length - 1
            concateJobList(i) = New StringBuilder
        Next
        i = 0
        For j = 0 To Me.mJobList.Length - 1
            If (concateJobList(i).Length >= 7990) Then i += 1
            concateJobList(i).Append(mJobList(j) & ",")
        Next
        'remove the last ","
        concateJobList(i).Remove(concateJobList(i).Length - 1, 1)

        Return concateJobList
    End Function

    Private Sub CreateSubPathName()
        Dim report As ApbReport
        Dim group As ApbGroup
        Dim docCopy As ApbDocCopy

        For Each report In Reports.Values
            For Each group In report.Groups.Values
                For Each docCopy In group.DocCopies
                    docCopy.SubNodePath = ApbDocument.BuildSubNodePath( _
                                                        report.DateRangeBegin, _
                                                        report.DateRangeEnd, _
                                                        docCopy.SubNodeNames)
                Next
            Next
        Next
    End Sub

    Private Sub CheckDocumentPosted(ByVal report As ApbReport, ByVal group As ApbGroup, ByVal docCopy As ApbDocCopy)
        Dim isExisting As Boolean
        Dim existNodeID As Integer
        Dim existDocumentID As Integer
        Dim existDocumentNodeID As Integer
        Dim authorMemberID As Integer
        Dim AuthorMemberName As String = Nothing
        Dim datePost As Date

        isExisting = Document.IsDocumentPosted(docCopy.StartNodeID, _
                                               docCopy.SubNodePath, _
                                               report.DocumentName, _
                                               existNodeID, _
                                               existDocumentID, _
                                               existDocumentNodeID, _
                                               authorMemberID, _
                                               AuthorMemberName, _
                                               datePost _
                                              )

        ''Mock up existing scenario
        'If (testCount = 3) Then
        '    IsExist = True
        '    existNodeID = 999999
        '    existDocumentID = 88888888
        'End If

        'Doc not exists
        If (Not isExisting) Then
            docCopy.DocumentExisting = ApbDocCopy.DocumentExistStatus.NotExist
            docCopy.NodeID = existNodeID
            Return
        End If

        'Doc already exists
        With docCopy
            .DocumentExisting = ApbDocCopy.DocumentExistStatus.Exist
            .ExistDocumentNodeID = existDocumentNodeID
            .ExistNodeID = existNodeID
            .ExistDocumentID = existDocumentID
        End With

        'Trigger UI to pop up dialog to ask user for the option
        If (mReplaceConfirmResult <> ComfirmResult.YesToAll _
            AndAlso mReplaceConfirmResult <> ComfirmResult.NoToAll) Then
            RaiseEvent DocumentExist(report, group, docCopy, existNodeID)
        End If

        'Decide what to do for existing doc
        Select Case Me.mReplaceConfirmResult
            Case ComfirmResult.Cancel
            Case ComfirmResult.Yes, ComfirmResult.YesToAll
                docCopy.ReplaceExistingDocument = True
            Case ComfirmResult.No, ComfirmResult.NoToAll
                docCopy.ReplaceExistingDocument = False
        End Select

    End Sub

    Private Sub PostDocument(ByVal report As ApbReport, ByVal group As ApbGroup, ByVal docCopy As ApbDocCopy)
        Dim nodeID As Integer
        Dim documentID As Integer
        Dim documentNodeID As Integer
        Dim memberID As Integer = CurrentUser.Member.MemberId

        If (docCopy.NodeID = 0 AndAlso report.DocumentID = 0) Then
            ApbDocument.PostApb(docCopy.StartNodeID, _
                                docCopy.SubNodePath + "\", _
                                group.GroupID, _
                                report.FilePath, _
                                report.DocumentName, _
                                group.TreeGroupID, _
                                memberID, _
                                nodeID, _
                                documentID, _
                                documentNodeID _
                               )
            docCopy.NodeID = nodeID
            docCopy.DocumentNodeID = documentNodeID
            report.DocumentID = documentID
            SetNodeID(group.GroupID, docCopy.FullNodePath, nodeID)

        ElseIf (docCopy.NodeID = 0 AndAlso report.DocumentID > 0) Then
            ApbDocument.PostApb(docCopy.StartNodeID, _
                                docCopy.SubNodePath + "\", _
                                group.GroupID, _
                                report.DocumentID, _
                                report.DocumentName, _
                                group.TreeGroupID, _
                                memberID, _
                                nodeID, _
                                documentNodeID _
                               )
            docCopy.NodeID = nodeID
            docCopy.DocumentNodeID = documentNodeID
            SetNodeID(group.GroupID, docCopy.FullNodePath, nodeID)

        ElseIf (docCopy.NodeID > 0 AndAlso report.DocumentID = 0) Then
            Document.Post(docCopy.NodeID, _
                          report.FilePath, _
                          report.DocumentName, _
                          group.TreeGroupID, _
                          memberID, _
                          Document.documentTypes.docTypeAutoPostAP, _
                          docCopy.ExistDocumentNodeID, _
                          documentID, _
                          documentNodeID _
                         )
            report.DocumentID = documentID
            docCopy.DocumentNodeID = documentNodeID

        ElseIf (docCopy.NodeID > 0 AndAlso report.DocumentID > 0) Then
            Document.Post(docCopy.NodeID, _
                          report.DocumentID, _
                          report.DocumentName, _
                          memberID, _
                          group.TreeGroupID, _
                          docCopy.ExistDocumentNodeID, _
                          documentNodeID _
                         )
            docCopy.DocumentNodeID = documentNodeID

        End If

        docCopy.Posted = True

        'MessageBox.Show("Document posted (Document_ID=" & report.DocumentID & " Node_ID=" & docCopy.NodeID, "Post Result", MessageBoxButtons.OK, MessageBoxIcon.Information)

        'Log posting
        DAL.LogApbPost(report.JobID, _
                       report.ApID, _
                       group.GroupID, _
                       docCopy.NodeID, _
                       report.DocumentID, _
                       docCopy.DocumentNodeID, _
                       report.DocumentName, _
                       report.DateRangeBegin, _
                       report.DateRangeEnd, _
                       memberID)

    End Sub

    Private Sub SetNodeID(ByVal groupID As Integer, ByVal nodeFullPath As String, ByVal nodeID As Integer)
        Dim report As ApbReport
        Dim group As ApbGroup
        Dim docCopy As ApbDocCopy

        nodeFullPath = nodeFullPath.ToUpper

        For Each report In Me.mReports.Values
            For Each group In report.Groups.Values
                If (groupID = group.GroupID) Then
                    For Each docCopy In group.DocCopies
                        If (docCopy.NodeID = 0 AndAlso docCopy.FullNodePath.ToUpper = nodeFullPath) Then
                            docCopy.NodeID = nodeID
                        End If
                    Next docCopy
                End If
            Next group
        Next report

    End Sub

#End Region

End Class
