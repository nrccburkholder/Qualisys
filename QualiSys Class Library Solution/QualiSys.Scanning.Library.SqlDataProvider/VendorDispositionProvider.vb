'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class VendorDispositionProvider
    Inherits NRC.QualiSys.Scanning.Library.VendorDispositionProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

#Region " VendorDisposition Procs "

    Private Function PopulateVendorDisposition(ByVal rdr As SafeDataReader) As VendorDisposition

        Dim newObject As VendorDisposition = VendorDisposition.NewVendorDisposition
        Dim privateInterface As IVendorDisposition = newObject

        newObject.BeginPopulate()
        privateInterface.VendorDispositionId = rdr.GetInteger("VendorDisposition_ID")
        newObject.VendorId = rdr.GetInteger("Vendor_ID")
        newObject.DispositionId = rdr.GetInteger("Disposition_ID")
        newObject.VendorDispositionCode = rdr.GetString("VendorDispositionCode")
        newObject.VendorDispositionLabel = rdr.GetString("VendorDispositionLabel")
        newObject.VendorDispositionDesc = rdr.GetString("VendorDispositionDesc")
        newObject.DateCreated = rdr.GetDate("DateCreated")
        newObject.isFinal = rdr.GetByte("isFinal")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectVendorDisposition(ByVal vendorDispositionId As Integer) As VendorDisposition

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorDisposition, vendorDispositionId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateVendorDisposition(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectVendorDispositionsByVendorId(ByVal vendorId As Integer) As VendorDispositionCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorDispositionsByVendorId, vendorId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorDispositionCollection, VendorDisposition)(rdr, AddressOf PopulateVendorDisposition)
        End Using

    End Function

    Public Overrides Function InsertVendorDisposition(ByVal instance As VendorDisposition) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertVendorDisposition, instance.VendorId, instance.DispositionId, instance.VendorDispositionCode, instance.VendorDispositionLabel, instance.VendorDispositionDesc, SafeDataReader.ToDBValue(instance.DateCreated))
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateVendorDisposition(ByVal instance As VendorDisposition)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateVendorDisposition, instance.VendorDispositionId, instance.VendorId, instance.DispositionId, instance.VendorDispositionCode, instance.VendorDispositionLabel, instance.VendorDispositionDesc, SafeDataReader.ToDBValue(instance.DateCreated))
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteVendorDisposition(ByVal instance As VendorDisposition)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteVendorDisposition, instance.VendorDispositionId)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

#End Region

End Class
