'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class VendorFileStatusProvider
    Inherits QualiSys.Scanning.Library.VendorFileStatusProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property


#Region " VendorFileStatu Procs "

    Private Function PopulateVendorFileStatus(ByVal rdr As SafeDataReader) As VendorFileStatus

        Dim newObject As VendorFileStatus = VendorFileStatus.NewVendorFileStatus
        Dim privateInterface As IVendorFileStatus = newObject

        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("VendorFileStatus_ID")
        newObject.Name = rdr.GetString("VendorFileStatus_nm")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectVendorFileStatus(ByVal id As Integer) As VendorFileStatus

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorFileStatus, id)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateVendorFileStatus(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectAllVendorFileStatus() As VendorFileStatusCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllVendorFileStatus)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorFileStatusCollection, VendorFileStatus)(rdr, AddressOf PopulateVendorFileStatus)
        End Using

    End Function

    Public Overrides Function SelectVendorFileStatusById(ByVal id As Integer) As VendorFileStatusCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorFileStatusById, id)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorFileStatusCollection, VendorFileStatus)(rdr, AddressOf PopulateVendorFileStatus)
        End Using

    End Function

    Public Overrides Function InsertVendorFileStatus(ByVal instance As VendorFileStatus) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertVendorFileStatus, instance.Name)
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateVendorFileStatus(ByVal instance As VendorFileStatus)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateVendorFileStatus, instance.Id, instance.Name)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteVendorFileStatus(ByVal instance As VendorFileStatus)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteVendorFileStatus, instance.Id)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

#End Region

End Class
