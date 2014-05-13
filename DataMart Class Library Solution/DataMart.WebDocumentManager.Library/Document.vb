Imports System.IO
Imports System.Data.SqlClient
Imports System.Collections.Specialized
Imports Microsoft.Web.Services2
Imports Microsoft.Web.Services2.Dime

Public Class Document

    Private mDocumentId As Integer
    Private mDocumentNodeId As Integer
    Private mNodeId As Integer
    Private mName As String
    Private mOrder As Integer
    Private mRelativeFilePath As String
    Private mFileSizeKB As Integer
    Private mTreePath As String
    Private mDateAdded As DateTime
    Private mDocumentType As documentTypes
    Private mTreeGroupId As Integer
    Private mSortOrder As Integer
    Private mPosted As Boolean
    Private mViewed As Boolean

    Private mTreeGroup As TreeGroup

    Public Enum documentTypes
        docTypeOther = 0
        docTypeAutoPostAP = 1
    End Enum

#Region " Public Properties "

    Public Property DocumentId() As Integer
        Get
            Return mDocumentId
        End Get
        Set(ByVal value As Integer)
            mDocumentId = value
        End Set
    End Property

    Public Property DocumentNodeId() As Integer
        Get
            Return mDocumentNodeId
        End Get
        Set(ByVal value As Integer)
            mDocumentNodeId = value
        End Set
    End Property

    Public Property NodeId() As Integer
        Get
            Return mNodeId
        End Get
        Set(ByVal value As Integer)
            mDocumentId = value
        End Set
    End Property

    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            mName = value
        End Set
    End Property

    Public Property Order() As Integer
        Get
            Return mOrder
        End Get
        Set(ByVal value As Integer)
            mOrder = value
        End Set
    End Property

    Public Property FilePath() As String
        Get
            Return mRelativeFilePath
        End Get
        Set(ByVal value As String)
            mRelativeFilePath = value
        End Set
    End Property

    Public ReadOnly Property FileSizeKB() As Integer
        Get
            Return mFileSizeKB
        End Get
    End Property

    Public ReadOnly Property TreePath() As String
        Get
            Return mTreePath
        End Get
    End Property

    Public Property DateAdded() As DateTime
        Get
            Return mDateAdded
        End Get
        Set(ByVal value As DateTime)
            mDateAdded = value
        End Set
    End Property

    Public Property DocumentType() As documentTypes
        Get
            Return mDocumentType
        End Get
        Set(ByVal Value As documentTypes)
            mDocumentType = Value
        End Set
    End Property

    Public Property TreeGroupId() As Integer
        Get
            Return mTreeGroupId
        End Get
        Set(ByVal value As Integer)
            mTreeGroupId = value
            mTreeGroup = Nothing
        End Set
    End Property

    Public ReadOnly Property TreeGroup() As TreeGroup
        Get
            If mTreeGroup Is Nothing Then
                mTreeGroup = TreeGroup.GetTreeGroup(mTreeGroupId)
            End If

            Return mTreeGroup
        End Get
    End Property

    Public ReadOnly Property SortOrder() As Integer
        Get
            Return mSortOrder
        End Get
    End Property

    Public ReadOnly Property Posted() As Boolean
        Get
            Return mPosted
        End Get
    End Property

    Public ReadOnly Property Viewed() As Boolean
        Get
            Return mViewed
        End Get
    End Property

    'Private Shared ReadOnly Property DocumentStagingPath() As String
    '    Get
    '        Return AppConfig.DocumentStagingPath & _
    '               CStr(IIf(AppConfig.DocumentStagingPath.EndsWith("\"), "", "\"))
    '    End Get
    'End Property
#End Region

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Verifies that a given group has access to download a document
    ''' </summary>
    ''' <param name="groupId">The id of the group being authorized</param>
    ''' <returns>Returns True if access is granted otherwise false</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	3/18/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Function AuthorizeMemberDownload(ByVal groupId As Integer) As Boolean
        Return DAL.AuthorizeDocumentDownload(mDocumentId, groupId)
    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Loads a document object from the database for the specified documentId
    ''' </summary>
    ''' <param name="documentNodeId">The ID of the document to load</param>
    ''' <returns></returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	3/18/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function GetDocument(ByVal documentNodeId As Integer) As Document
        Dim row As DataRow = DAL.SelectDocument(documentNodeId)
        Return GetDocumentFromRow(row)
    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Populates the document object from a datarow.
    ''' </summary>
    ''' <param name="row"></param>
    ''' <returns></returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	3/18/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Friend Shared Function GetDocumentFromRow(ByVal row As DataRow) As Document

        Dim doc As New Document

        doc.mDocumentId = CInt(row("Document_id"))
        doc.mDocumentNodeId = CInt(row("DocumentNode_id"))
        doc.mNodeId = CInt(row("Node_id"))
        doc.mName = row("strDocument_nm").ToString
        doc.mOrder = CInt(row("intOrder"))
        doc.mRelativeFilePath = row("strDocumentPath").ToString
        doc.mFileSizeKB = CInt(row("intFileSizeKB"))
        doc.mDocumentType = CType(row("DocumentType"), documentTypes)
        doc.mTreeGroupId = CInt(row("TreeGroup_id"))
        doc.mDateAdded = CDate(row("datAdded"))
        doc.mSortOrder = CInt(row("SortOrder"))
        doc.mPosted = CBool(row("bitPosted"))
        doc.mViewed = Not CBool(row("DocumentNotViewed"))

        If Not row.IsNull("strPath") Then
            doc.mTreePath = row("strPath").ToString
        End If

        Return doc

    End Function

    Public Shared Function CreateDocument(ByVal documentName As String, _
                                          ByVal filePath As String, _
                                          ByVal nodeId As Integer, _
                                          ByVal docType As Document.documentTypes, _
                                          ByVal treeGroupId As Integer, _
                                          ByVal authorMemberId As Integer, _
                                          Optional ByVal order As Integer = 0, _
                                          Optional ByVal batchId As Integer = 0 _
                                         ) As Document

        'Get a reference to the file
        Dim fileInfo As IO.FileInfo = New IO.FileInfo(filePath)

        'Make sure the file exists
        If Not fileInfo.Exists Then
            Throw New Exception("File Does Not Exist")
            Return Nothing
        End If

        'Get required info
        Dim origFileName As String = filePath.Substring(filePath.LastIndexOf("\") + 1)
        Dim extension As String = fileInfo.Extension
        Dim fileDate As DateTime = fileInfo.LastWriteTime
        Dim documentPath As String = fileDate.ToString("yyyy") & "\" & fileDate.ToString("MM") & _
                                     "\" & fileDate.ToString("dd") & "\"
        Dim fileSize As Integer = CType(fileInfo.Length / 1024, Integer)

        'Open the connection
        Dim sqlConn As SqlConnection = New SqlConnection(Config.NRCAuthConnection)
        sqlConn.Open()

        'Start a transaction
        Dim sqlTrans As SqlTransaction = sqlConn.BeginTransaction

        'Now let's try to add this puppy
        Dim newDocument As Document
        Try
            'Insert the document record
            Dim docId As Integer = DAL.InsertDocument(sqlTrans, origFileName, documentPath, extension, _
                                                      fileSize, docType, authorMemberId)

            'Insert the document node record
            Dim docNodeId As Integer = DAL.InsertDocumentNode(sqlTrans, docId, nodeId, documentName, _
                                                              treeGroupId, order, authorMemberId, batchId)

            'Copy the file to the staging area
            'fileInfo.CopyTo(DocumentStagingPath & docId.ToString & extension, True)

            Dim relativePath As String = String.Format("{0}{1}{2}", documentPath, docId, extension)
            Dim fileMan As New WebDocumentPoster.FileManagerWse
            fileMan.Url = Config.WebDocumentPosterUrl
            Dim attach As New Microsoft.Web.Services2.Dime.DimeAttachment("Document", Microsoft.Web.Services2.Dime.TypeFormat.MediaType, fileInfo.OpenRead)
            fileMan.RequestSoapContext.Attachments.Add(attach)
            fileMan.UploadDocument(relativePath)

            'Mark it as posted
            DAL.PostDocument(sqlTrans, docId)

            'Commit the transaction
            sqlTrans.Commit()

            'Get the new document
            newDocument = GetDocument(docNodeId)

        Catch ex As Exception
            'Bad things have obviously happened so roll back the transaction
            sqlTrans.Rollback()

            'Throw the exception
            Throw New Exception("An error occurred while posting.  Document was not posted!", ex)

        Finally
            'Close the connection
            sqlConn.Close()

        End Try

        Return newDocument

    End Function

    Public Function GetDocumentStream() As Stream
        Dim fileMan As New WebDocumentPoster.FileManagerWse
        fileMan.Url = Config.WebDocumentPosterUrl
        'Dim attach As New Microsoft.Web.Services2.Dime.DimeAttachment("Document", Microsoft.Web.Services2.Dime.TypeFormat.MediaType, FileInfo.OpenRead)
        'fileMan.RequestSoapContext.Attachments.Add(attach)
        fileMan.DownloadDocument(mRelativeFilePath)
        Return fileMan.ResponseSoapContext.Attachments(0).Stream
    End Function

    Public Sub DisplayFile()
        Dim folder As String = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + "\Web Document Manager"
        Dim file As New FileInfo(Me.FilePath)
        Dim FullPath As String = folder + "\" + CStr(Me.DocumentId) + file.Extension
        Dim dirInfo As New DirectoryInfo(folder)

        If Not dirInfo.Exists Then dirInfo.Create()

        'Write the file
        Dim sw As FileStream = New FileStream(FullPath, FileMode.Create)
        Dim strm As Stream = GetDocumentStream()
        Dim buffer(CInt(strm.Length) - 1) As Byte
        strm.Read(buffer, 0, CInt(strm.Length))
        sw.Write(buffer, 0, CInt(strm.Length))
        sw.Close()
        strm.Close()

        'Open the file
        System.Diagnostics.Process.Start(FullPath)

    End Sub

    Public Sub DeleteDocument(ByVal authorMemberId As Integer, Optional ByVal deleteAll As Boolean = False)

        DeleteDocument(mDocumentNodeId, authorMemberId, deleteAll)

    End Sub

    Public Shared Sub DeleteDocument(ByVal documentNodeId As Integer, _
                                     ByVal authorMemberId As Integer, _
                                     ByVal deleteAll As Boolean _
                                    )

        DAL.DeleteDocument(documentNodeId, authorMemberId, deleteAll)

    End Sub

    Public Sub UpdateDocument(ByVal authorMemberId As Integer)

        DAL.UpdateDocument(mDocumentNodeId, mNodeId, mName, mTreeGroupId, mOrder, authorMemberId)

    End Sub

    Public Shared Function UpdateDocument(ByVal documentNodeId As Integer, _
                                          ByVal nodeId As Integer, _
                                          ByVal documentName As String, _
                                          ByVal treeGroupId As Integer, _
                                          ByVal order As Integer, _
                                          ByVal authorMemberId As Integer _
                                         ) As Document

        'Update the document
        DAL.UpdateDocument(documentNodeId, nodeId, documentName, treeGroupId, order, authorMemberId)

        'Return a reference to the updated document
        Return GetDocument(documentNodeId)

    End Function

    Public Shared Function IsDocumentPosted(ByVal startNodeId As Integer, _
                                            ByVal subNodePath As String, _
                                            ByVal documentName As String, _
                                            ByRef nodeID As Integer, _
                                            ByRef documentID As Integer, _
                                            ByRef documentNodeID As Integer, _
                                            ByRef authorMemberID As Integer, _
                                            ByRef authorMemberName As String, _
                                            ByRef datePost As Date _
                                           ) As Boolean

        modCommon.AppendFolderLastSlash(subNodePath)
        Dim rdr As SqlDataReader = DAL.IsDocumentPosted(startNodeId, subNodePath, documentName)
        Dim posted As Boolean = False

        nodeID = 0
        documentID = 0
        documentNodeID = 0

        If (rdr.Read()) Then
            If (Not IsDBNull(rdr("Node_id"))) Then nodeID = CInt(rdr("Node_id"))
            If (Not IsDBNull(rdr("Document_id"))) Then
                documentID = CInt(rdr("Document_id"))
                posted = True
            End If
            If (Not IsDBNull(rdr("DocumentNode_id"))) Then documentNodeID = CInt(rdr("DocumentNode_id"))
            If (Not IsDBNull(rdr("Author"))) Then authorMemberID = CInt(rdr("Author"))
            If (Not IsDBNull(rdr("AuthorName"))) Then authorMemberName = CStr(rdr("AuthorName"))
            If (Not IsDBNull(rdr("datAdded"))) Then datePost = CDate(rdr("datAdded"))
        End If
        rdr.Close()

        Return posted

    End Function

    ''' <summary>
    ''' This method will create a new document and a new document Node.  It will also replace a document Node
    ''' if the replaceDocumentNodeId is specified.
    ''' </summary>
    ''' <param name="nodeId"></param>
    ''' <param name="filePath"></param>
    ''' <param name="documentName"></param>
    ''' <param name="treeGroupId"></param>
    ''' <param name="authorMemberID"></param>
    ''' <param name="docType"></param>
    ''' <param name="replaceDocumentNodeId"></param>
    ''' <param name="documentID"></param>
    ''' <param name="documentNodeId"></param>
    ''' <param name="order"></param>
    ''' <remarks></remarks>
    Public Shared Sub Post(ByVal nodeId As Integer, _
                           ByVal filePath As String, _
                           ByVal documentName As String, _
                           ByVal treeGroupId As Integer, _
                           ByVal authorMemberID As Integer, _
                           ByVal docType As documentTypes, _
                           ByVal replaceDocumentNodeId As Integer, _
                           ByRef documentID As Integer, _
                           ByRef documentNodeId As Integer, _
                           Optional ByVal order As Integer = 0, _
                           Optional ByVal batchId As Integer = 0 _
                          )

        'If we are to replace the existing then do so now
        If replaceDocumentNodeId > 0 Then
            DAL.DeleteDocument(replaceDocumentNodeId, authorMemberID, False)
        End If

        'Create the document
        Dim myDoc As Document = Document.CreateDocument(documentName, filePath, nodeId, docType, _
                                                        treeGroupId, authorMemberID, order, batchId)
        documentID = myDoc.DocumentId
        documentNodeId = myDoc.DocumentNodeId

    End Sub
    ''' <summary>
    ''' This method will add a document Node record for an existing Document.  It will also replace a document Node
    ''' if the replaceDocumentNodeId is specified.
    ''' </summary>
    ''' <param name="nodeId"></param>
    ''' <param name="documentID"></param>
    ''' <param name="documentName"></param>
    ''' <param name="authorMemberID"></param>
    ''' <param name="treeGroupId"></param>
    ''' <param name="replaceDocumentNodeId"></param>
    ''' <param name="documentNodeId"></param>
    ''' <param name="order"></param>
    ''' <remarks></remarks>
    Public Shared Sub Post(ByVal nodeId As Integer, _
                           ByVal documentID As Integer, _
                           ByVal documentName As String, _
                           ByVal authorMemberID As Integer, _
                           ByVal treeGroupId As Integer, _
                           ByVal replaceDocumentNodeId As Integer, _
                           ByRef documentNodeId As Integer, _
                           Optional ByVal order As Integer = 0, _
                           Optional ByVal batchId As Integer = 0 _
                          )

        'If we are to replace the existing then do so now
        If replaceDocumentNodeId > 0 Then
            DAL.DeleteDocument(replaceDocumentNodeId, authorMemberID, False)
        End If

        'Insert a document node record as this physical document already exists
        documentNodeId = DAL.InsertDocumentNode(documentID, nodeId, documentName, treeGroupId, order, authorMemberID, batchId)

    End Sub

End Class


