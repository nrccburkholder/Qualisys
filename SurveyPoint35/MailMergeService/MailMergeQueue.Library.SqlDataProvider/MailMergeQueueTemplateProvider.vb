Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports PS.Framework.Data
Imports MailMergeQueue.Library
Imports MailMergePrep.Library
Public Class MailMergeQueueTemplateProvider
    Inherits MailMergeQueue.Library.MailMergeQueueTemplateProvider
    Private ReadOnly Property Db(ByVal connString As String) As Database
        Get
            Return DatabaseHelper.Db(connString)
        End Get
    End Property

#Region " Overrides "
    Public Overrides Function InsertMMFile(ByVal queueID As Integer, ByVal fileType As FileTypes, ByVal fileName As String) As Integer
        Dim cmd As DbCommand = Db(MailMergeQueue.Library.SqlDataProvider.Config.QMSConnection).GetStoredProcCommand(SP.InsertMMFile, queueID, CInt(fileType), fileName)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                Return CInt(rdr("ID"))
            End While
        End Using
    End Function
    Public Overrides Function InsertMMSubJob(ByVal queueID As Integer, ByVal subJobIndex As Integer, ByVal totalRecs As Integer, ByVal startSeqNumber As Integer, ByVal endSeqNumber As Integer, ByVal startRespID As Integer, ByVal endRespID As Integer) As Integer
        Dim cmd As DbCommand = Db(MailMergeQueue.Library.SqlDataProvider.Config.QMSConnection).GetStoredProcCommand(SP.InsertMMSubJob, _
                                                                queueID, subJobIndex, totalRecs, startSeqNumber, endSeqNumber, startRespID, endRespID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                Return CInt(rdr("ID"))
            End While
        End Using
    End Function
#End Region
End Class
