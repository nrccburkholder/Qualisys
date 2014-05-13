Option Explicit On 
Option Strict On

Imports System.Collections.Specialized
Imports System.Text

Public Class ApbDocument
    Inherits NRC.DataMart.WebDocumentManager.Library.Document

    ' Sample result:
    '   Jan 1 2004 - Mar 31 2005 Reports
    '   Jan 1 - Mar 31 2004 Reports
    Public Shared Function DateRangeNodeName(ByVal dateRangeBegin As Date, ByVal dateRangeEnd As Date) As String
        Static label As New StringBuilder
        Dim tmpDate As Date

        If (dateRangeBegin > dateRangeEnd) Then
            tmpDate = dateRangeBegin
            dateRangeBegin = dateRangeEnd
            dateRangeEnd = tmpDate
        End If

        label.Remove(0, label.Length)
        label.Append(dateRangeBegin.ToString("MMM d"))
        If (dateRangeBegin.Year <> dateRangeEnd.Year) Then
            label.Append(dateRangeBegin.ToString(" yyyy"))
        End If
        label.Append(" - ")
        label.Append(dateRangeEnd.ToString("MMM d yyyy"))
        label.Append(" Reports")

        Return label.ToString
    End Function

    Public Shared Function BuildSubNodePath(ByVal dateRangeBegin As Date, ByVal dateRangeEnd As Date, ByVal subNodeNames As StringCollection) As String
        Static path As New StringBuilder
        Dim nodeName As String

        path.Remove(0, path.Length)
        path.Append(DateRangeNodeName(dateRangeBegin, dateRangeEnd))

        For Each nodeName In subNodeNames
            path.Append("\")
            path.Append(nodeName)
        Next

        Return path.ToString
    End Function

    Public Shared Sub PostApb(ByVal startNodeId As Integer, _
                              ByVal subNodePath As String, _
                              ByVal groupID As Integer, _
                              ByVal filePath As String, _
                              ByVal documentName As String, _
                              ByVal treeGroupID As Integer, _
                              ByVal authorMemberID As Integer, _
                              ByRef nodeID As Integer, _
                              ByRef documentID As Integer, _
                              ByRef documentNodeId As Integer _
                             )

        'Make sure the node exists
        nodeID = DAL.InsertMissingNodes(startNodeId, subNodePath, authorMemberID)

        'Post this document
        Post(nodeID, filePath, documentName, treeGroupID, authorMemberID, Document.documentTypes.docTypeAutoPostAP, 0, documentID, documentNodeId)

    End Sub

    Public Shared Sub PostApb(ByVal startNodeId As Integer, _
                              ByVal subNodePath As String, _
                              ByVal groupID As Integer, _
                              ByVal documentID As Integer, _
                              ByVal documentName As String, _
                              ByVal treeGroupID As Integer, _
                              ByVal authorMemberID As Integer, _
                              ByRef nodeID As Integer, _
                              ByRef documentNodeId As Integer _
                             )

        'Make sure the node exists
        nodeID = DAL.InsertMissingNodes(startNodeId, subNodePath, authorMemberID)

        'Post the document
        Post(nodeID, documentID, documentName, authorMemberID, treeGroupID, 0, documentNodeId)

    End Sub

End Class
