Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class QSIDataBatchProvider
	Inherits NRC.QualiSys.Scanning.Library.QSIDataBatchProvider

#Region " Private ReadOnly Properties "

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

#End Region

#Region " QSIDataBatch Procs "

    Private Function PopulateQSIDataBatch(ByVal rdr As SafeDataReader) As QSIDataBatch

        Dim newObject As QSIDataBatch = QSIDataBatch.NewQSIDataBatch
        Dim privateInterface As IQSIDataBatch = newObject

        newObject.BeginPopulate()
        privateInterface.BatchId = rdr.GetInteger("Batch_ID")
        privateInterface.BatchName = rdr.GetString("BatchName")
        newObject.Locked = rdr.GetBoolean("Locked")
        newObject.DateEntered = rdr.GetDate("DateEntered")
        newObject.EnteredBy = rdr.GetString("EnteredBy")
        newObject.DateFinalized = rdr.GetDate("DateFinalized")
        newObject.FinalizedBy = rdr.GetString("FinalizedBy")
        newObject.EndPopulate()

        Return newObject

    End Function
	
    Public Overrides Function SelectQSIDataBatch(ByVal batchId As Integer) As QSIDataBatch

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectQSIDataBatch, batchId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateQSIDataBatch(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectAllQSIDataBatches() As QSIDataBatchCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllQSIDataBatches)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of QSIDataBatchCollection, QSIDataBatch)(rdr, AddressOf PopulateQSIDataBatch)
        End Using

    End Function

    Public Overrides Function InsertQSIDataBatch(ByVal instance As QSIDataBatch) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertQSIDataBatch, instance.Locked, SafeDataReader.ToDBValue(instance.DateEntered), instance.EnteredBy, SafeDataReader.ToDBValue(instance.DateFinalized), instance.FinalizedBy)
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateQSIDataBatch(ByVal instance As QSIDataBatch)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateQSIDataBatch, instance.BatchId, instance.Locked, SafeDataReader.ToDBValue(instance.DateEntered), instance.EnteredBy, SafeDataReader.ToDBValue(instance.DateFinalized), instance.FinalizedBy)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteQSIDataBatch(ByVal instance As QSIDataBatch)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteQSIDataBatch, instance.BatchId)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

    Public Overrides Function IsQSIDataBatchComplete(ByVal batchId As Integer) As Boolean

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.IsQSIDataBatchComplete, batchId)
        Return QualiSysDatabaseHelper.ExecuteBoolean(cmd)

    End Function

#End Region

End Class
