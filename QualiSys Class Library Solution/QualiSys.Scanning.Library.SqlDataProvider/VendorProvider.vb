Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data

Friend Class VendorProvider
    Inherits Nrc.QualiSys.Scanning.Library.VendorProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

#Region " Vendor Procs "

    Private Function PopulateVendor(ByVal rdr As SafeDataReader) As Vendor

        Dim newObject As Vendor = Vendor.NewVendor
        Dim privateInterface As IVendor = newObject

        newObject.BeginPopulate()
        privateInterface.VendorId = rdr.GetInteger("Vendor_ID")
        newObject.VendorCode = rdr.GetString("VendorCode")
        newObject.VendorName = rdr.GetString("Vendor_nm")
        newObject.Phone = rdr.GetString("Phone")
        newObject.Addr1 = rdr.GetString("Addr1")
        newObject.Addr2 = rdr.GetString("Addr2")
        newObject.City = rdr.GetString("City")
        newObject.StateCode = rdr.GetString("StateCode")
        newObject.Province = rdr.GetString("Province")
        newObject.Zip5 = rdr.GetString("Zip5")
        newObject.Zip4 = rdr.GetString("Zip4")
        newObject.DateCreated = rdr.GetDate("DateCreated")
        newObject.DateModified = rdr.GetDate("DateModified")
        newObject.AcceptFilesFromVendor = rdr.GetBoolean("bitAcceptFilesFromVendor")
        newObject.NoResponseChar = rdr.GetString("NoResponseChar")
        newObject.RefusedResponseChar = rdr.GetString("RefusedResponseChar")
        newObject.DontKnowResponseChar = rdr.GetString("DontKnowResponseChar")
        newObject.SkipResponseChar = rdr.GetString("SkipResponseChar")
        newObject.MultiRespItemNotPickedChar = rdr.GetString("MultiRespItemNotPickedChar")
        newObject.LocalFTPLoginName = rdr.GetString("LocalFTPLoginName")
        newObject.VendorFileOutgoTypeId = rdr.GetInteger("VendorFileOutgoType_ID")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectVendor(ByVal vendorId As Integer) As Vendor

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendor, vendorId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateVendor(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectVendorByVendorCode(ByVal vendorCode As String) As Vendor

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorByVendorCode, vendorCode)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateVendor(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectAllVendors() As VendorCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllVendors)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorCollection, Vendor)(rdr, AddressOf PopulateVendor)
        End Using

    End Function

    Public Overrides Function InsertVendor(ByVal instance As Vendor) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertVendor, instance.VendorCode, instance.VendorName, instance.Phone, instance.Addr1, instance.Addr2, instance.City, instance.StateCode, instance.Province, instance.Zip5, instance.Zip4, SafeDataReader.ToDBValue(instance.DateCreated), SafeDataReader.ToDBValue(instance.DateModified), instance.AcceptFilesFromVendor, instance.NoResponseChar, instance.SkipResponseChar, instance.MultiRespItemNotPickedChar, instance.LocalFTPLoginName, instance.VendorFileOutgoTypeId, instance.DontKnowResponseChar, instance.RefusedResponseChar)
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateVendor(ByVal instance As Vendor)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateVendor, instance.VendorId, instance.VendorCode, instance.VendorName, instance.Phone, instance.Addr1, instance.Addr2, instance.City, instance.StateCode, instance.Province, instance.Zip5, instance.Zip4, SafeDataReader.ToDBValue(instance.DateCreated), SafeDataReader.ToDBValue(instance.DateModified), instance.AcceptFilesFromVendor, instance.NoResponseChar, instance.SkipResponseChar, instance.MultiRespItemNotPickedChar, instance.LocalFTPLoginName, instance.VendorFileOutgoTypeId, instance.DontKnowResponseChar, instance.RefusedResponseChar)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteVendor(ByVal instance As Vendor)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteVendor, instance.VendorId)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

    Public Overrides Function IsUniqueVendorCode(ByVal vendorId As Integer, ByVal vendorCode As String) As Boolean

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.IsUniqueVendorCode, vendorId, vendorCode)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return True
            Else
                Return False
            End If
        End Using

    End Function

#End Region

End Class
