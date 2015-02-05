Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data

Friend Class ReceiptTypeProvider
    Inherits Nrc.QualiSys.Library.ReceiptTypeProvider

    Private ReadOnly Property Db() As Database
        Get
            Return Globals.Db
        End Get
    End Property


#Region " ReceiptType Procs "

    Private Function PopulateReceiptType(ByVal rdr As SafeDataReader) As ReceiptType

        Dim newObject As ReceiptType = ReceiptType.NewReceiptType
        Dim privateInterface As IReceiptType = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("ReceiptType_id")
        newObject.Name = rdr.GetString("ReceiptType_nm")
        newObject.Description = rdr.GetString("ReceiptType_dsc")
        newObject.UIDisplay = rdr.GetBoolean("bitUIDisplay")
        newObject.TranslationCode = rdr.GetString("TranslationCode")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectAllReceiptTypes() As ReceiptTypeCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllReceiptTypes)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ReceiptTypeCollection, ReceiptType)(rdr, AddressOf PopulateReceiptType)
        End Using

    End Function

#End Region

End Class
