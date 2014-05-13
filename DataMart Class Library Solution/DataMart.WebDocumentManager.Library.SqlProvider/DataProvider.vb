
'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Datamart.WebDocumentManager.Library

Friend Class DataProvider
    Inherits NRC.DataMart.WebDocumentManager.Library.DataProvider

    Private ReadOnly Property QP_CommentsDb() As Database
        Get
            Return Globals.QP_CommentsDb
        End Get
    End Property

    Private ReadOnly Property NRCAuthDb() As Database
        Get
            Return Globals.NRCAuthDb
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const CheckIfBatchNameExists As String = "dbo.Auth_CheckIfBatchNameExists"
        Public Const DeleteDocumentBatch As String = "dbo.Auth_DeleteDocumentBatch"
        Public Const InsertDocumentBatch As String = "dbo.Auth_InsertDocumentBatch"
        Public Const SelectDocumentBatchesByDateRange As String = "dbo.Auth_SelectDocumentBatchesByDateRange"
        Public Const SelectDocumentBatch As String = "dbo.Auth_SelectDocumentBatch"
    End Class
#End Region

#Region " DocumentBatch Procs "

    Private Function PopulateDocumentBatch(ByVal rdr As SafeDataReader) As DocumentBatch
        Dim newObject As DocumentBatch = DocumentBatch.NewDocumentBatch
        Dim privateInterface As IDocumentBatch = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("Batch_id")
        newObject.Name = rdr.GetString("strBatch_Nm")
        privateInterface.AuthorId = rdr.GetInteger("Author")
        privateInterface.CreationDate = rdr.GetDate("datOccurred")
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectDocumentBatch(ByVal batchId As Integer) As DocumentBatch
        Dim cmd As DbCommand = NRCAuthDb.GetStoredProcCommand(SP.SelectDocumentBatch, batchId)
        Using rdr As New SafeDataReader(ExecuteReader(NRCAuthDb, cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateDocumentBatch(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectDocumentBatchesByDateRange(ByVal fromDate As Date, ByVal toDate As Date) As DocumentBatchCollection
        Dim cmd As DbCommand = NRCAuthDb.GetStoredProcCommand(SP.SelectDocumentBatchesByDateRange, fromDate, toDate)
        Using rdr As New SafeDataReader(ExecuteReader(NRCAuthDb, cmd))
            Return PopulateCollection(Of DocumentBatchCollection, DocumentBatch)(rdr, AddressOf PopulateDocumentBatch)
        End Using
    End Function

    Public Overrides Function InsertDocumentBatch(ByVal instance As DocumentBatch) As Integer
        Dim cmd As DbCommand = NRCAuthDb.GetStoredProcCommand(SP.InsertDocumentBatch, instance.Name, instance.AuthorId, SafeDataReader.ToDBValue(instance.CreationDate))
        Return ExecuteInteger(NRCAuthDb, cmd)
    End Function

    Public Overrides Sub DeleteDocumentBatch(ByVal batchId As Integer)
        Dim cmd As DbCommand = NRCAuthDb.GetStoredProcCommand(SP.DeleteDocumentBatch, batchId)
        ExecuteNonQuery(NRCAuthDb, cmd)
    End Sub

    Public Overrides Function CheckIfBatchNameInUse(ByVal name As String) As Boolean
        Dim cmd As DbCommand = NRCAuthDb.GetStoredProcCommand(SP.CheckIfBatchNameExists, name)
        Return ExecuteBoolean(NRCAuthDb, cmd)
    End Function

#End Region


End Class

