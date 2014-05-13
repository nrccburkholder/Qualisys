Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data

Friend Class VendorFileCreationQueueProvider
	Inherits QualiSys.Scanning.Library.VendorFileCreationQueueProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

#Region " VendorFileCreationQueue Procs "

    Private Function PopulateVendorFileCreationQueue(ByVal rdr As SafeDataReader) As VendorFileCreationQueue

        Dim newObject As VendorFileCreationQueue = VendorFileCreationQueue.NewVendorFileCreationQueue
        Dim privateInterface As IVendorFileCreationQueue = newObject

        newObject.BeginPopulate()
        privateInterface.VendorFileId = rdr.GetInteger("VendorFile_ID")
        newObject.SamplesetId = rdr.GetInteger("Sampleset_ID")
        newObject.MailingStepId = rdr.GetInteger("MailingStep_ID")
        newObject.VendorFileStatusId = rdr.GetInteger("VendorFileStatus_ID")
        newObject.DateFileCreated = rdr.GetDate("DateFileCreated")
        newObject.DateDataCreated = rdr.GetDate("DateDataCreated")
        newObject.ArchiveFileName = rdr.GetString("ArchiveFileName")
        newObject.RecordsInFile = rdr.GetInteger("RecordsInFile")
        newObject.RecordsNoLitho = rdr.GetInteger("RecordsNoLitho")
        newObject.ShowInTree = rdr.GetBoolean("ShowInTree")
        newObject.ErrorDesc = rdr.GetString("ErrorDesc")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectVendorFileCreationQueue(ByVal vendorFileId As Integer) As VendorFileCreationQueue

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorFileCreationQueue, vendorFileId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateVendorFileCreationQueue(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectAllVendorFileCreationQueues() As VendorFileCreationQueueCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllVendorFileCreationQueues)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorFileCreationQueueCollection, VendorFileCreationQueue)(rdr, AddressOf PopulateVendorFileCreationQueue)
        End Using

    End Function

    Public Overrides Function SelectVendorFileCreationQueuesBySamplesetId(ByVal samplesetId As Integer) As VendorFileCreationQueueCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorFileCreationQueuesBySamplesetId, samplesetId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorFileCreationQueueCollection, VendorFileCreationQueue)(rdr, AddressOf PopulateVendorFileCreationQueue)
        End Using

    End Function

    Public Overrides Function SelectVendorFileCreationQueuesByMailingStepId(ByVal mailingStepId As Integer) As VendorFileCreationQueueCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorFileCreationQueuesByMailingStepId, mailingStepId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorFileCreationQueueCollection, VendorFileCreationQueue)(rdr, AddressOf PopulateVendorFileCreationQueue)
        End Using

    End Function

    Public Overrides Function SelectVendorFileCreationQueuesByVendorFileStatusId(ByVal vendorFileStatusId As VendorFileStatusCodes) As VendorFileCreationQueueCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorFileCreationQueuesByVendorFileStatusId, vendorFileStatusId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorFileCreationQueueCollection, VendorFileCreationQueue)(rdr, AddressOf PopulateVendorFileCreationQueue)
        End Using

    End Function

    Public Overrides Function InsertVendorFileCreationQueue(ByVal instance As VendorFileCreationQueue) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertVendorFileCreationQueue, instance.SamplesetId, instance.MailingStepId, instance.VendorFileStatusId, SafeDataReader.ToDBValue(instance.DateFileCreated), SafeDataReader.ToDBValue(instance.DateDataCreated), instance.ArchiveFileName, instance.RecordsInFile, instance.RecordsNoLitho, instance.ShowInTree, instance.ErrorDesc)
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateVendorFileCreationQueue(ByVal instance As VendorFileCreationQueue)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateVendorFileCreationQueue, instance.VendorFileId, instance.SamplesetId, instance.MailingStepId, instance.VendorFileStatusId, SafeDataReader.ToDBValue(instance.DateFileCreated), SafeDataReader.ToDBValue(instance.DateDataCreated), instance.ArchiveFileName, instance.RecordsInFile, instance.RecordsNoLitho, instance.ShowInTree, instance.ErrorDesc)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteVendorFileCreationQueue(ByVal instance As VendorFileCreationQueue)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteVendorFileCreationQueue, instance.VendorFileId)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

    Public Overrides Function SelectVendorFileData(ByVal vendorFileId As Integer) As System.Data.DataTable

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorFileData, vendorFileId)
        Return QualiSysDatabaseHelper.ExecuteDataSet(cmd).Tables(0)

    End Function

    Public Overrides Sub RemakeVendorFileData(ByVal vendorFileId As Integer, ByVal sampleSetId As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.RemakeVendorFileData, sampleSetId, 1, 1, vendorFileId, 0, 0)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

#End Region

End Class
