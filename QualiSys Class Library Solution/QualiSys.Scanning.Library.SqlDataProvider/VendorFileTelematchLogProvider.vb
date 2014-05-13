Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data

Friend Class VendorFileTelematchLogProvider
    Inherits QualiSys.Scanning.Library.VendorFileTelematchLogProvider

#Region " Private Properties "

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

#End Region

#Region " VendorFileTelematchLog Procs "

    Private Function PopulateVendorFileTelematchLog(ByVal rdr As SafeDataReader) As VendorFileTelematchLog

        Dim newObject As VendorFileTelematchLog = VendorFileTelematchLog.NewVendorFileTelematchLog
        Dim privateInterface As IVendorFileTelematchLog = newObject

        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("VendorFile_TelematchLog_ID")
        newObject.VendorFileId = rdr.GetInteger("VendorFile_ID")
        newObject.DateSent = rdr.GetDate("datSent")
        newObject.DateReturned = rdr.GetDate("datReturned")
        newObject.RecordsReturned = rdr.GetInteger("intRecordsReturned")
        newObject.DateOverdueNoticeSent = rdr.GetDate("datOverdueNoticeSent")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectVendorFileTelematchLog(ByVal id As Integer) As VendorFileTelematchLog

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorFileTelematchLog, id)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateVendorFileTelematchLog(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectAllVendorFileTelematchLogs() As VendorFileTelematchLogCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllVendorFileTelematchLogs)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorFileTelematchLogCollection, VendorFileTelematchLog)(rdr, AddressOf PopulateVendorFileTelematchLog)
        End Using

    End Function

    Public Overrides Function SelectVendorFileTelematchLogsByVendorFileId(ByVal vendorFileId As Integer) As VendorFileTelematchLogCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorFileTelematchLogsByVendorFileId, vendorFileId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorFileTelematchLogCollection, VendorFileTelematchLog)(rdr, AddressOf PopulateVendorFileTelematchLog)
        End Using

    End Function

    Public Overrides Function InsertVendorFileTelematchLog(ByVal instance As VendorFileTelematchLog) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertVendorFileTelematchLog, instance.VendorFileId, SafeDataReader.ToDBValue(instance.DateSent), SafeDataReader.ToDBValue(instance.DateReturned), instance.RecordsReturned, SafeDataReader.ToDBValue(instance.DateOverdueNoticeSent))
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateVendorFileTelematchLog(ByVal instance As VendorFileTelematchLog)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateVendorFileTelematchLog, instance.Id, instance.VendorFileId, SafeDataReader.ToDBValue(instance.DateSent), SafeDataReader.ToDBValue(instance.DateReturned), instance.RecordsReturned, SafeDataReader.ToDBValue(instance.DateOverdueNoticeSent))
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteVendorFileTelematchLog(ByVal instance As VendorFileTelematchLog)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteVendorFileTelematchLog, instance.Id)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

    Public Overrides Function SelectVendorFileTelematchLogByNotReturned() As VendorFileTelematchLogCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorFileTelematchLogsByNotReturned)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorFileTelematchLogCollection, VendorFileTelematchLog)(rdr, AddressOf PopulateVendorFileTelematchLog)
        End Using

    End Function

#End Region

End Class
