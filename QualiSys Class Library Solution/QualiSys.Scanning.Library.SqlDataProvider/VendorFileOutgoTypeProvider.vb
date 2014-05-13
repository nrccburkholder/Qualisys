Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data

Friend Class VendorFileOutgoTypeProvider
	Inherits QualiSys.Scanning.Library.VendorFileOutgoTypeProvider

#Region " Private ReadOnly Properties "

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

#End Region

#Region " VendorFileOutgoType Procs "

    Private Function PopulateVendorFileOutgoType(ByVal rdr As SafeDataReader) As VendorFileOutgoType

        Dim newObject As VendorFileOutgoType = VendorFileOutgoType.NewVendorFileOutgoType
        Dim privateInterface As IVendorFileOutgoType = newObject

        newObject.BeginPopulate()
        privateInterface.VendorFileOutgoTypeId = rdr.GetInteger("VendorFileOutgoType_ID")
        newObject.OutgoTypeName = rdr.GetString("OutgoType_nm")
        newObject.OutgoTypeDescription = rdr.GetString("OutgoType_desc")
        newObject.FileExtension = rdr.GetString("FileExtension")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectVendorFileOutgoType(ByVal vendorFileOutgoTypeId As Integer) As VendorFileOutgoType

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorFileOutgoType, vendorFileOutgoTypeId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateVendorFileOutgoType(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectAllVendorFileOutgoTypes() As VendorFileOutgoTypeCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllVendorFileOutgoTypes)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorFileOutgoTypeCollection, VendorFileOutgoType)(rdr, AddressOf PopulateVendorFileOutgoType)
        End Using

    End Function

    Public Overrides Function InsertVendorFileOutgoType(ByVal instance As VendorFileOutgoType) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertVendorFileOutgoType, instance.OutgoTypeName, instance.OutgoTypeDescription, instance.FileExtension)
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateVendorFileOutgoType(ByVal instance As VendorFileOutgoType)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateVendorFileOutgoType, instance.VendorFileOutgoTypeId, instance.OutgoTypeName, instance.OutgoTypeDescription, instance.FileExtension)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteVendorFileOutgoType(ByVal instance As VendorFileOutgoType)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteVendorFileOutgoType, instance.VendorFileOutgoTypeId)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

#End Region

End Class
