Imports NRC.NRCAuthLib
Public Class MassPostDocument

    Public Enum PostOutcome
        Successful = 1
        Failed = 2
    End Enum

#Region "Private Members"
    Private mOrgUnitName As String
    Private mTreeGroupName As String
    Private mFolderPath As String
    Private mFileName As String
    Private mNodePath As String
    Private mGroupName As String
    Private mPostMessage As String = ""
    Private mWebLabel As String
    Private mDocumentNodeId As Integer
    Private mNodeId As Integer
    Private mIsDuplicate As Boolean
    Private mHaveCheckedForDuplicate As Boolean
    Private mMember As Member
    Private mHasAttemtedPost As Boolean
#End Region

#Region "Public Properties"
    Public Property DocumentNodeId() As Integer
        Get
            Return mDocumentNodeId
        End Get
        Set(ByVal value As Integer)
            mDocumentNodeId = value
        End Set
    End Property

    Public ReadOnly Property OrgUnitName() As String
        Get
            Return mOrgUnitName
        End Get
    End Property

    Public ReadOnly Property WebLabel() As String
        Get
            Return mWebLabel
        End Get
    End Property

    Public ReadOnly Property TreeGroupName() As String
        Get
            Return mTreeGroupName
        End Get
    End Property

    Public ReadOnly Property FolderPath() As String
        Get
            Return mFolderPath
        End Get
    End Property

    Public ReadOnly Property FileName() As String
        Get
            Return mFileName
        End Get
    End Property

    Public ReadOnly Property NodePath() As String
        Get
            Return mNodePath
        End Get
    End Property

    Public ReadOnly Property GroupName() As String
        Get
            Return mGroupName
        End Get
    End Property

    Public ReadOnly Property IsPostSuccessful() As Boolean
        Get
            Return String.IsNullOrEmpty(PostMessage) AndAlso mHasAttemtedPost
        End Get
    End Property

    Public ReadOnly Property PostingOutcome() As PostOutcome
        Get
            If mHasAttemtedPost = False Then Return Nothing
            If IsPostSuccessful Then
                Return PostOutcome.Successful
            Else
                Return PostOutcome.Failed
            End If
        End Get
    End Property

    Public ReadOnly Property PostingOutcomeLabel() As String
        Get
            If PostingOutcome = Nothing Then Return ""
            Return PostingOutcome.ToString
        End Get
    End Property

    Public ReadOnly Property HaveAttemptedToPost() As Boolean
        Get
            Return mHasAttemtedPost
        End Get
    End Property

    ''' <summary>
    ''' Displays the error message after posting
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks>This string should be set to "" when a successful post occurs.  This allows us to set a property
    ''' that indicates whether or not we have attempted to post this document.</remarks>
    Public Property PostMessage() As String
        Get
            Return mPostMessage
        End Get
        Set(ByVal Value As String)
            mHasAttemtedPost = True
            mPostMessage = Value
        End Set
    End Property

#End Region

#Region "Constructor"
    Public Sub New(ByVal member As Member)
        mMember = member
    End Sub
#End Region

#Region "Private Methods"
    Private Shared Function GetGroupRootNodeID(ByVal orgUnitName As String, ByVal GroupName As String, ByVal memberOrgUnits As Generic.List(Of OrgUnit)) As Integer
        Dim orgUnitId As Integer

        For Each ou As OrgUnit In memberOrgUnits
            If ou.Name.ToUpper = orgUnitName.ToUpper Then
                orgUnitId = ou.OrgUnitId
                Exit For
            End If
        Next

        If orgUnitId <> 0 Then
            Dim postGroup As Group
            postGroup = Group.GetGroup(GroupName, orgUnitId)
            If Not postGroup Is Nothing Then Return DocumentNode.GetGroupRootNodeID(postGroup.GroupId)
        End If
        Return Nothing
    End Function

#End Region

#Region "Public Methods"
    ''' <summary>
    ''' Gets the root node for the specified group name.  It will only check groups that are
    ''' part of the members orgUnits.  If the org unit specified is not a part of the members orgUnits,
    ''' it will return 0.
    ''' </summary>
    ''' <param name="memberOrgUnits"></param>
    ''' <param name="orgUnitName"></param>
    ''' <param name="groupName"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function StartNodeId(ByVal memberOrgUnits As Generic.List(Of OrgUnit), ByVal orgUnitName As String, ByVal groupName As String) As Integer
        Return GetGroupRootNodeID(orgUnitName, groupName, memberOrgUnits)
    End Function

    ''' <summary>
    ''' Creates a new node and returns the node ID
    ''' </summary>
    ''' <param name="startNodeId"></param>
    ''' <param name="nodePath"></param>
    ''' <param name="member"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function NodeId(ByVal startNodeId As Integer, ByVal nodePath As String, ByVal member As Member) As Integer
        Return DocumentNode.InsertMissingNodes(startNodeId, nodePath, member.MemberId)
    End Function

    ''' <summary>
    ''' Determines if a document with the same name already exists in the folder (if the folder exists) that the 
    ''' new document will be saved in.
    ''' </summary>
    ''' <param name="startNodeId"></param>
    ''' <param name="nodePath"></param>
    ''' <param name="webLabel"></param>
    ''' <param name="duplicateDocumentNodeId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function IsDuplicate(ByVal startNodeId As Integer, ByVal nodePath As String, ByVal webLabel As String, ByRef duplicateDocumentNodeId As Integer) As Boolean
        Dim duplicatePostedNodeID As Integer 'Dummy value for isDocumentPosted
        Dim duplicateDocID As Integer 'Dummy value for the IsDocument Posted call
        Dim duplicateDatposted As DateTime 'Dummy value for the IsDocument Posted call
        Dim duplicateMemberName As String = Nothing 'Dummy value for the IsDocument Posted call
        Dim duplicateMemberId As Integer 'Dummy value for the IsDocument Posted call
        Return Document.IsDocumentPosted(startNodeId, nodePath, webLabel, duplicatePostedNodeID, duplicateDocID, duplicateDocumentNodeId, duplicateMemberId, duplicateMemberName, duplicateDatposted)
    End Function

    ''' <summary>
    ''' This method will return all documents from a batch that the member has security privileges to rollback.
    ''' </summary>
    ''' <param name="batchId"></param>
    ''' <param name="memberOrgUnits"></param>
    ''' <remarks>A user can rollback a document if they have access to the orgunit the document comes from.</remarks>
    Public Shared Function FindAccessibleDocuments(ByVal batchId As Integer, ByVal memberOrgUnits As Generic.List(Of OrgUnit), ByVal member As Member) As MassPostDocumentCollection
        Dim documents As MassPostDocumentCollection = MassPostDocument.GetDocumentsByBatchId(batchId, member)
        Dim orgUnitNames As New Generic.List(Of String)

        For Each ou As OrgUnit In memberOrgUnits
            orgUnitNames.Add(ou.Name)
        Next

        If documents.Count > 0 Then
            'If the document has an orgunit that is not in the OrgUnits list, remove it
            For i As Integer = documents.Count - 1 To 0 Step -1
                If orgUnitNames.Contains(documents(i).OrgUnitName) = False Then documents.RemoveAt(i)
            Next
        End If
        Return documents
    End Function

    Public Shared Function GetDocuments(ByVal filePath As String, ByVal member As Member) As MassPostDocumentCollection
        Dim docs As New MassPostDocumentCollection
        For Each row As DataRow In DAL.SelectMassPostingDocs(filePath).Tables(0).Rows
            docs.Add(GetDocumentFromSpreadSheetRow(row, member))
        Next
        Return docs
    End Function

    Public Shared Function GetDocumentsByBatchId(ByVal batchId As Integer, ByVal member As Member) As MassPostDocumentCollection
        Dim docs As New MassPostDocumentCollection
        Using rdr As System.Data.SqlClient.SqlDataReader = DAL.SelectMassPostedDocumentsByBatchId(batchId)
            While rdr.Read
                docs.Add(GetDocumentFromReader(rdr, member))
            End While
            Return docs
        End Using
    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Populates the MassPostDocument object from a datarow.
    ''' </summary>
    ''' <param name="row"></param>
    ''' <returns></returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[DChristensen]	4/4/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Friend Shared Function GetDocumentFromSpreadSheetRow(ByVal row As DataRow, ByVal member As Member) As MassPostDocument

        Dim doc As New MassPostDocument(member)

        doc.mOrgUnitName = CStr(row("OrgUnitName"))
        doc.mTreeGroupName = CStr(row("TreeGroupName"))
        doc.mFolderPath = CStr(row("FolderPath"))
        doc.mFileName = CStr(row("FileName"))
        doc.mNodePath = CStr(row("NodePath"))
        doc.mGroupName = CStr(row("GroupName"))
        doc.mWebLabel = CStr(row("WebLabel"))

        'Cleanup bad node paths
        If doc.mNodePath.ToUpper.StartsWith("\MY DOCUMENTS") Then
            doc.mNodePath = doc.mNodePath.Substring(13)
        ElseIf doc.mNodePath.ToUpper.StartsWith("MY DOCUMENTS") Then
            doc.mNodePath = doc.mNodePath.Substring(12)
        End If

        If doc.mNodePath.StartsWith("\") Then doc.mNodePath = doc.mNodePath.Substring(1)

        Return doc

    End Function

    Friend Shared Function GetDocumentFromReader(ByVal rdr As IDataReader, ByVal member As Member) As MassPostDocument

        Dim doc As New MassPostDocument(member)

        doc.DocumentNodeId = rdr.GetInt32(rdr.GetOrdinal("documentnode_id"))
        doc.mOrgUnitName = rdr.GetString(rdr.GetOrdinal("strOrgUnit_Nm"))
        doc.mTreeGroupName = TreeGroup.GetTreeGroupName(rdr.GetInt32(rdr.GetOrdinal("TreeGroup_ID")))
        doc.mFileName = rdr.GetString(rdr.GetOrdinal("strOrigFileName"))
        doc.mNodePath = rdr.GetString(rdr.GetOrdinal("NodePath"))
        doc.mGroupName = rdr.GetString(rdr.GetOrdinal("strGroup_Nm"))
        doc.mWebLabel = rdr.GetString(rdr.GetOrdinal("strDocument_Nm"))

        Return doc
    End Function
#End Region

End Class
