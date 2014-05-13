Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class VendorFileTrackingProvider
	Inherits QualiSys.Scanning.Library.VendorFileTrackingProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

#Region " VendorFileTracking Procs "

    Private Function PopulateVendorFileTracking(ByVal rdr As SafeDataReader) As VendorFileTracking

        Dim newObject As VendorFileTracking = VendorFileTracking.NewVendorFileTracking
        Dim privateInterface As IVendorFileTracking = newObject

        newObject.BeginPopulate()
        privateInterface.VendorFileTrackingId = rdr.GetInteger("VendorFileTracking_ID")
        newObject.MemberId = rdr.GetInteger("Member_ID")
        newObject.ActionDesc = rdr.GetString("ActionDesc")
        newObject.VendorFileID = rdr.GetInteger("VendorFile_ID")
        newObject.ActionDate = rdr.GetDate("ActionDate")
        newObject.EndPopulate()

        Return newObject

    End Function
	
    Public Overrides Function SelectVendorFileTracking(ByVal id As Integer) As VendorFileTracking

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorFileTracking, id)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateVendorFileTracking(rdr)
            End If
        End Using

    End Function

	Public Overrides Function SelectAllVendorFileTrackings() As VendorFileTrackingCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllVendorFileTrackings)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorFileTrackingCollection, VendorFileTracking)(rdr, AddressOf PopulateVendorFileTracking)
        End Using

    End Function

	Public Overrides Function SelectVendorFileTrackingsByVendorFileID(ByVal vendorFileID As Integer) As VendorFileTrackingCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorFileTrackingsByVendorFileID, vendorFileID)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorFileTrackingCollection, VendorFileTracking)(rdr, AddressOf PopulateVendorFileTracking)
        End Using

    End Function

	Public Overrides Function InsertVendorFileTracking(ByVal instance As VendorFileTracking) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertVendorFileTracking, instance.MemberId, instance.ActionDesc, instance.VendorFileID, SafeDataReader.ToDBValue(instance.ActionDate))
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

	Public Overrides Sub UpdateVendorFileTracking(ByVal instance As VendorFileTracking)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateVendorFileTracking, instance.VendorFileTrackingId, instance.MemberId, instance.ActionDesc, instance.VendorFileID, SafeDataReader.ToDBValue(instance.ActionDate))
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

	Public Overrides Sub DeleteVendorFileTracking(ByVal instance As VendorFileTracking)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteVendorFileTracking, instance.VendorFileTrackingId)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

#End Region

End Class
