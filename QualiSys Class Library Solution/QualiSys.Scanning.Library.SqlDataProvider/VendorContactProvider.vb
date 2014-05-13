Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data

Friend Class VendorContactProvider
    Inherits QualiSys.Scanning.Library.VendorContactProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

#Region " VendorContact Procs "

    Private Function PopulateVendorContact(ByVal rdr As SafeDataReader) As VendorContact

        Dim newObject As VendorContact = VendorContact.NewVendorContact
        Dim privateInterface As IVendorContact = newObject

        newObject.BeginPopulate()
        privateInterface.VendorContactId = rdr.GetInteger("VendorContact_ID")
        newObject.VendorId = rdr.GetInteger("VendorID")
        newObject.Type = rdr.GetString("Type")
        newObject.FirstName = rdr.GetString("FirstName")
        newObject.LastName = rdr.GetString("LastName")
        newObject.emailAddr1 = rdr.GetString("emailAddr1")
        newObject.emailAddr2 = rdr.GetString("emailAddr2")
        newObject.SendFileArrivalEmail = rdr.GetBoolean("SendFileArrivalEmail")
        newObject.Phone1 = rdr.GetString("Phone1")
        newObject.Phone2 = rdr.GetString("Phone2")
        newObject.Notes = rdr.GetString("Notes")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectVendorContact(ByVal vendorContactId As Integer) As VendorContact

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVendorContact, vendorContactId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateVendorContact(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectAllVendorContacts() As VendorContactCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllVendorContacts)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorContactCollection, VendorContact)(rdr, AddressOf PopulateVendorContact)
        End Using

    End Function

    Public Overrides Function SelectAllVendorContactsByVendor(ByVal vendorId As Integer) As VendorContactCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllVendorContactsByVendor, vendorId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VendorContactCollection, VendorContact)(rdr, AddressOf PopulateVendorContact)
        End Using

    End Function

    Public Overrides Function InsertVendorContact(ByVal instance As VendorContact) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertVendorContact, instance.VendorId, instance.Type, instance.FirstName, instance.LastName, instance.emailAddr1, instance.emailAddr2, instance.SendFileArrivalEmail, instance.Phone1, instance.Phone2, instance.Notes)
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateVendorContact(ByVal instance As VendorContact)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateVendorContact, instance.VendorContactId, instance.VendorId, instance.Type, instance.FirstName, instance.LastName, instance.emailAddr1, instance.emailAddr2, instance.SendFileArrivalEmail, instance.Phone1, instance.Phone2, instance.Notes)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteVendorContact(ByVal instance As VendorContact)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteVendorContact, instance.VendorContactId)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

#End Region

End Class
