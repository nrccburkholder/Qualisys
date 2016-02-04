Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports PS.Framework.Data
Imports MailMergeQueue.Library
Public Class MailMergeQueueControllerProvider
    Inherits MailMergeQueue.Library.MailMergeQueueControllerProvider
    Private ReadOnly Property Db(ByVal connString As String) As Database
        Get
            Return DatabaseHelper.Db(connString)
        End Get
    End Property
    Private Function PopulateMailMergeQueueController(ByVal rdr As SafeDataReader) As MailMergeQueueController
        Dim obj As MailMergeQueueController = MailMergeQueueController.NewMailMergeQueueController
        Dim privateInterface As IMailMergeQueueController = obj
        obj.BeginPopulate()
        privateInterface.MailMergeQueueControllerID = rdr.GetInteger("QueueID")
        obj.MergeName = rdr.GetString("MergeName")
        obj.StatusMsg = rdr.GetString("StatusMsg")
        obj.TemplateID = rdr.GetInteger("TemplateID")
        obj.ProjectID = rdr.GetInteger("ProjectID")
        obj.FaqssID = rdr.GetString("FaqssID")
        obj.MailStep = rdr.GetInteger("MailStep")
        obj.PaperConfigID = rdr.GetInteger("PaperConfigID")
        obj.SurveyDataDirectory = rdr.GetString("SurveyDataDirectory")
        obj.MergeDirectory = rdr.GetString("MergeDirectory")
        obj.TotalRecordNumber = rdr.GetInteger("TotalRecordNum")
        If rdr.GetInteger("SaveMergedWordDocs") = 1 Then
            obj.SaveMergedWordDocs = True
        Else
            obj.SaveMergedWordDocs = False
        End If
        obj.SpecialInstructions = rdr.GetString("SpecialInstructions")
        obj.SMOperator = rdr.GetString("Operator")
        obj.MyMergeStatus = rdr.GetInteger("MergeStatusID")
        obj.DateCreated = rdr.GetDate("DateCreated")
        obj.DateModified = rdr.GetDate("DateModified")
        obj.StartDate = rdr.GetDate("StartDate")
        obj.EndDate = rdr.GetNullableDate("EndDate")
        obj.EndPopulate()
        Return obj
    End Function

#Region " Overrides "
    Public Overrides Function GetTop1PendingFromQueue() As MailMergeQueueController
        Dim cmd As DbCommand = Db(MailMergeQueue.Library.SqlDataProvider.Config.QMSConnection).GetStoredProcCommand(SP.GetTop1PendingFromQueue)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                Return PopulateMailMergeQueueController(rdr)
            End While
        End Using
        Return Nothing
    End Function
    Public Overrides Function PingMailMergeDB() As Boolean
        Dim cmd As DbCommand = Db(MailMergeQueue.Library.SqlDataProvider.Config.QMSConnection).GetStoredProcCommand(SP.PingMailMergeDB)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                Return True
            End While
        End Using
    End Function
    Public Overrides Function InsertMMFile(ByVal queueID As Integer, ByVal fileType As FileTypes, ByVal fileName As String) As Integer
        Dim cmd As DbCommand = Db(MailMergeQueue.Library.SqlDataProvider.Config.QMSConnection).GetStoredProcCommand(SP.InsertMMFile, queueID, CInt(fileType), fileName)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                Return CInt(rdr("ID"))
            End While
        End Using
    End Function
    Public Overrides Function CompleteQueueJob(ByVal queueID As Integer, ByVal statusMsg As String, ByVal mergeStatus As MergeStatuses, ByVal endDate As Nullable(Of DateTime)) As Object
        'TP 20100112
        'Row in SQL 2000 can't be greater than 8060 bytes, so truncate statusMsg to allow for this.
        Dim myMsg As String = statusMsg
        If myMsg.Length > 7000 Then
            myMsg = myMsg.Substring(0, 7000)
        End If
        Dim cmd As DbCommand = Db(MailMergeQueue.Library.SqlDataProvider.Config.QMSConnection).GetStoredProcCommand(SP.CompleteQueueJob, _
                                                                            queueID, myMsg, CInt(mergeStatus), NullDate(endDate))
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                Return CInt(rdr("ID"))
            End While
        End Using
    End Function
    Private Function NullDate(ByVal dte As Nullable(Of DateTime)) As Object
        If dte Is Nothing OrElse Not dte.HasValue Then
            Return DBNull.Value
        Else
            Return dte.Value
        End If
    End Function


#End Region
End Class
