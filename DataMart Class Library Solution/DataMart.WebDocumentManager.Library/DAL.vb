'TODO:  When one of these needs to be modified, the whole class should be refactored and moved to the 
'SQL data provider library.
Option Explicit On
Option Strict On

Imports System.Data.SqlClient
Imports System.text
Imports NRC.Data
Imports System.Data.Oledb

Public Class DAL

    Private Shared ReadOnly Property NRCAuthConnection() As String
        Get
            Return Config.NRCAuthConnection
        End Get
    End Property

    Private Shared ReadOnly Property QPCommentsConnection() As String
        Get
            Return Config.QP_CommentsConnection
        End Get
    End Property

    Public Shared Function SelectDocumentTree(ByVal groupId As Integer, _
                                              ByVal memberId As Integer, _
                                              ByVal showOnlyPosted As Boolean _
                                             ) As DataSet

        Return SqlHelper.ExecuteDataset(NRCAuthConnection, "Auth_SelectDocumentTree", _
                                        groupId, memberId, showOnlyPosted)

    End Function

    Public Shared Function SelectApbDocumentTree(ByVal groupId As Integer, _
                                          ByVal memberId As Integer, _
                                          ByVal periodNum As Integer _
                                         ) As DataSet

        Return SqlHelper.ExecuteDataset(NRCAuthConnection, "Auth_SelectApbDocTree", _
                                        groupId, memberId, periodNum)

    End Function

    Public Shared Function SelectApbNotifyList(ByVal orgUnitConcateString As String) As SqlDataReader

        Return SqlHelper.ExecuteReader(QPCommentsConnection, "Apb_DM_SelectPostMemberList", orgUnitConcateString)

    End Function

    Public Shared Function SelectGroupRootNodeID(ByVal groupId As Integer) As Integer
        Return CInt(SqlHelper.ExecuteScalar(NRCAuthConnection, "Auth_SelectGroupRootNodeID", groupId))
    End Function

    Public Shared Function SelectApbClientList( _
                                ByVal orgUnitConcateString As String, _
                                ByVal JobGenerateDateBegin As Date, _
                                ByVal JobGenerateDateEnd As Date, _
                                ByVal notify As String _
                            ) As SqlDataReader
        Return SqlHelper.ExecuteReader(QPCommentsConnection, "Apb_DM_SelectPostClientList", _
                                       orgUnitConcateString, _
                                       JobGenerateDateBegin, JobGenerateDateEnd, _
                                       notify)
    End Function

    Public Shared Function SelectPostableApbList( _
                                ByVal orgUnitConcateString As String, _
                                ByVal clientID As Integer, _
                                ByVal JobGenerateDateBegin As Date, _
                                ByVal JobGenerateDateEnd As Date, _
                                ByVal notify As String _
                            ) As SqlDataReader
        Return SqlHelper.ExecuteReader(QPCommentsConnection, "Apb_DM_SelectPostableApList", _
                                       orgUnitConcateString, clientID, _
                                       JobGenerateDateBegin, JobGenerateDateEnd, _
                                       notify)
    End Function

    Public Shared Function SelectApbReportGroupList(ByVal jobList() As StringBuilder) As SqlDataReader

        Return SqlHelper.ExecuteReader( _
                    QPCommentsConnection, _
                    "APB_DM_SelectPostReportGroupList", _
                    jobList(0).ToString, _
                    jobList(1).ToString, _
                    jobList(2).ToString, _
                    jobList(3).ToString, _
                    jobList(4).ToString, _
                    jobList(5).ToString, _
                    jobList(6).ToString, _
                    jobList(7).ToString, _
                    jobList(8).ToString, _
                    jobList(9).ToString _
               )
    End Function

    Public Shared Sub LogApbPost(ByVal jobID As Integer, _
                                 ByVal apID As String, _
                                 ByVal groupID As Integer, _
                                 ByVal nodeId As Integer, _
                                 ByVal documentId As Integer, _
                                 ByVal documentNode_ID As Integer, _
                                 ByVal documentName As String, _
                                 ByVal reportDateBegin As Date, _
                                 ByVal reportDateEnd As Date, _
                                 ByVal memberID As Integer)

        SqlHelper.ExecuteNonQuery(QPCommentsConnection, _
                                  "Apb_DM_LogPosting", _
                                  jobID, _
                                  apID, _
                                  groupID, _
                                  nodeId, _
                                  documentId, _
                                  documentNode_ID, _
                                  documentName, _
                                  reportDateBegin, _
                                  reportDateEnd, _
                                  memberID)
    End Sub

    Public Shared Function SelectApbRollbackMemberList(ByVal member_ID As Integer) As SqlDataReader
        Return SqlHelper.ExecuteReader(QPCommentsConnection, "Apb_DM_SelectRollbackMember", member_ID)
    End Function

    Public Shared Function SelectApbRollbackClientList(ByVal member_ID As Integer, ByVal postDateBegin As Date, ByVal postDateEnd As Date) As SqlDataReader
        Return SqlHelper.ExecuteReader(QPCommentsConnection, "Apb_DM_SelectRollbackClient", member_ID, postDateBegin, postDateEnd)
    End Function

    Public Shared Function SelectApbRollbackGroupList(ByVal member_ID As Integer, _
                                                      ByVal postDateBegin As Date, _
                                                      ByVal postDateEnd As Date, _
                                                      ByVal clientID As Integer, _
                                                      ByVal reportDateBegin As Date, _
                                                      ByVal reportDateEnd As Date _
                                                     ) As SqlDataReader
        Return SqlHelper.ExecuteReader(QPCommentsConnection, "Apb_DM_SelectRollbackGroup", member_ID, postDateBegin, postDateEnd, clientID, reportDateBegin, reportDateEnd)
    End Function

    Public Shared Function SelectApbRollbackDocList(ByVal member_ID As Integer, _
                                                    ByVal postDateBegin As Date, _
                                                    ByVal postDateEnd As Date, _
                                                    ByVal clientID As Integer, _
                                                    ByVal reportDateBegin As Date, _
                                                    ByVal reportDateEnd As Date, _
                                                    ByVal groupList() As StringBuilder, _
                                                    ByVal keywordInDocName As String _
                                                 ) As SqlDataReader

        Return SqlHelper.ExecuteReader(QPCommentsConnection, _
                                       "Apb_DM_SelectRollbackDocument", _
                                       member_ID, _
                                       postDateBegin, _
                                       postDateEnd, _
                                       clientID, _
                                       reportDateBegin, _
                                       reportDateEnd, _
                                       keywordInDocName, _
                                       groupList(0).ToString, _
                                       groupList(1).ToString, _
                                       groupList(2).ToString, _
                                       groupList(3).ToString, _
                                       groupList(4).ToString, _
                                       groupList(5).ToString, _
                                       groupList(6).ToString, _
                                       groupList(7).ToString, _
                                       groupList(8).ToString, _
                                       groupList(9).ToString _
                                      )
    End Function

    Public Shared Function AuthorizeDocumentDownload(ByVal documentId As Integer, _
                                                     ByVal groupId As Integer _
                                                    ) As Boolean

        Return CType(SqlHelper.ExecuteScalar(NRCAuthConnection, "Auth_AuthorizeDocumentDownload", _
                                             documentId, groupId), Boolean)

    End Function

    Public Shared Function SelectDocumentPath(ByVal documentId As Integer) As String

        Return CType(SqlHelper.ExecuteScalar(NRCAuthConnection, "Auth_SelectDocumentPath", documentId), String)

    End Function

    Public Shared Function SelectDocument(ByVal documentNodeId As Integer) As DataRow

        Return SqlHelper.ExecuteDataset(NRCAuthConnection, "Auth_SelectDocument", _
                                        documentNodeId).Tables(0).Rows(0)

    End Function

    Public Shared Function InsertDocument(ByVal sqlTrans As SqlTransaction, _
                                          ByVal origFileName As String, _
                                          ByVal documentPath As String, _
                                          ByVal extension As String, _
                                          ByVal fileSizeKB As Integer, _
                                          ByVal docType As Document.documentTypes, _
                                          ByVal authorMemberId As Integer _
                                         ) As Integer

        Return CType(SqlHelper.ExecuteScalar(sqlTrans, "Auth_InsertDocument", origFileName, _
                                             documentPath, extension, fileSizeKB, CInt(docType), _
                                             authorMemberId), Integer)

    End Function

    Public Shared Function InsertDocumentNode(ByVal sqlTrans As SqlTransaction, _
                                              ByVal documentId As Integer, _
                                              ByVal nodeId As Integer, _
                                              ByVal documentName As String, _
                                              ByVal treeGroupId As Integer, _
                                              ByVal order As Integer, _
                                              ByVal authorMemberId As Integer, _
                                              ByVal batchId As Integer _
                                             ) As Integer

        Dim nullableBatchId As Object
        If batchId = 0 Then
            nullableBatchId = DBNull.Value
        Else
            nullableBatchId = batchId
        End If

        Return CType(SqlHelper.ExecuteScalar(sqlTrans, "Auth_InsertDocumentNode", documentId, nodeId, _
                                             documentName, treeGroupId, order, authorMemberId, nullableBatchId), Integer)

    End Function

    Public Shared Function InsertDocumentNode(ByVal documentId As Integer, _
                                              ByVal nodeId As Integer, _
                                              ByVal documentName As String, _
                                              ByVal treeGroupId As Integer, _
                                              ByVal order As Integer, _
                                              ByVal authorMemberId As Integer, _
                                              ByVal batchId As Integer _
                                             ) As Integer

        Dim nullableBatchId As Object
        If batchId = 0 Then
            nullableBatchId = DBNull.Value
        Else
            nullableBatchId = batchId
        End If

        Return CType(SqlHelper.ExecuteScalar(NRCAuthConnection, "Auth_InsertDocumentNode", documentId, _
                                             nodeId, documentName, treeGroupId, order, authorMemberId, nullableBatchId), Integer)

    End Function

    Public Shared Sub DeleteDocument(ByVal documentNodeId As Integer, _
                                     ByVal authorMemberId As Integer, _
                                     ByVal deleteAll As Boolean _
                                    )

        SqlHelper.ExecuteNonQuery(NRCAuthConnection, "Auth_DeleteDocumentNode", _
                                  documentNodeId, authorMemberId, deleteAll)

    End Sub

    Public Shared Function UpdateDocument(ByVal documentNodeId As Integer, _
                                          ByVal nodeId As Integer, _
                                          ByVal documentName As String, _
                                          ByVal treeGroupId As Integer, _
                                          ByVal order As Integer, _
                                          ByVal authorMemberId As Integer _
                                         ) As Integer

        Return CType(SqlHelper.ExecuteScalar(NRCAuthConnection, "Auth_UpdateDocumentNode", _
                                             documentNodeId, nodeId, documentName, treeGroupId, _
                                             order, authorMemberId), Integer)

    End Function

    Public Shared Function SelectNode(ByVal nodeId As Integer) As DataRow

        Return SqlHelper.ExecuteDataset(NRCAuthConnection, "Auth_SelectNode", nodeId).Tables(0).Rows(0)

    End Function

    Public Shared Function InsertNode(ByVal groupId As Integer, _
                                      ByVal parentNodeId As Integer, _
                                      ByVal nodeName As String, _
                                      ByVal expanded As Boolean, _
                                      ByVal order As Integer, _
                                      ByVal authorMemberId As Integer _
                                     ) As Integer

        Return CType(SqlHelper.ExecuteScalar(NRCAuthConnection, "Auth_InsertNode", groupId, _
                     parentNodeId, nodeName, expanded, order, authorMemberId), Integer)

    End Function

    Public Shared Sub DeleteNode(ByVal nodeId As Integer, ByVal authorMemberId As Integer)

        SqlHelper.ExecuteNonQuery(NRCAuthConnection, "Auth_DeleteNode", nodeId, authorMemberId)

    End Sub

    Public Shared Sub UpdateNode(ByVal nodeId As Integer, _
                                 ByVal groupId As Integer, _
                                 ByVal parentNodeId As Integer, _
                                 ByVal nodeName As String, _
                                 ByVal expanded As Boolean, _
                                 ByVal order As Integer, _
                                 ByVal authorMemberId As Integer _
                                )

        SqlHelper.ExecuteNonQuery(NRCAuthConnection, "Auth_UpdateNode", nodeId, groupId, _
                                  parentNodeId, nodeName, expanded, order, authorMemberId)

    End Sub

    Public Shared Function IsDocumentPosted(ByVal startNodeId As Integer, _
                                            ByVal subFolderPath As String, _
                                            ByVal documentName As String _
                                           ) As SqlDataReader

        Return SqlHelper.ExecuteReader(NRCAuthConnection, "Auth_IsDocumentPosted", _
                                       startNodeId, subFolderPath, documentName)

    End Function

    Public Shared Function InsertMissingNodes(ByVal parentNodeId As Integer, _
                                              ByVal nodePath As String, _
                                              ByVal authorMemberId As Integer _
                                             ) As Integer

        Return CType(SqlHelper.ExecuteScalar(NRCAuthConnection, "Auth_InsertMissingNodes", _
                                             parentNodeId, nodePath, authorMemberId), Integer)

    End Function

    Public Shared Sub PostDocument(ByVal sqlTrans As SqlTransaction, ByVal documentId As Integer)

        SqlHelper.ExecuteNonQuery(sqlTrans, "Auth_PostDocument", documentId)

    End Sub

    Public Shared Function SelectTreeGroup(ByVal treeGroupId As Integer) As DataRow

        Return SqlHelper.ExecuteDataset(NRCAuthConnection, "Auth_SelectTreeGroup", _
                                        treeGroupId).Tables(0).Rows(0)

    End Function

    Public Shared Function SelectTreeGroups() As DataSet

        Return SqlHelper.ExecuteDataset(NRCAuthConnection, "Auth_SelectTreeGroup")

    End Function

    Public Shared Function SelectMassPostingDocs(ByVal filepath As String) As DataSet
        Dim myDataset As New DataSet
        Dim strConn As String = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + filepath + ";Extended Properties=""Excel 8.0;"""

        Dim myData As New OleDbDataAdapter("SELECT * FROM [Sheet1$] WHERE OrgUnitName is not null", strConn)
        myData.TableMappings.Add("Table", "MassPost")
        myData.Fill(myDataset)
        Return myDataset
    End Function

    Public Shared Sub DeleteNodeInApb(ByVal nodeId As Integer)
        SqlHelper.ExecuteNonQuery(QPCommentsConnection, "Apb_DM_DeleteNode", nodeId)
    End Sub

    Public Shared Function SelectMassPostedDocumentsByBatchId(ByVal batchId As Integer) As SqlDataReader
        Return SqlHelper.ExecuteReader(NRCAuthConnection, "Auth_SelectMassPostedDocumentsByBatchId", batchId)
    End Function

End Class
