Imports Nrc.QualiSys.Scanning.Library
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data

Friend Class DataEntryNavigatorTreeProvider
    Inherits QualiSys.Scanning.Library.DataEntryNavigatorTreeProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

#Region " VendorFileSurveyTree Procs "

    Private Function PopulateDataEntryNavigatorTree(ByVal rdr As SafeDataReader) As DataEntryNavigatorTree

        Dim newObject As DataEntryNavigatorTree = DataEntryNavigatorTree.NewDataEntryNavigatorTree
        Dim privateInterface As IDataEntryNavigatorTree = newObject

        newObject.BeginPopulate()
        privateInterface.BatchID = rdr.GetInteger("Batch_ID")
        newObject.BatchName = rdr.GetString("BatchName")
        newObject.TemplateName = rdr.GetString("TemplateName")
        newObject.Quantity = rdr.GetInteger("Qty")
        newObject.QuantityKeyed = rdr.GetInteger("QtyKeyed")
        newObject.QuantityVerified = rdr.GetInteger("QtyVerified")
        newObject.DataEntryMode = rdr.GetEnum(Of DataEntryModes)("DataEntryMode")
        newObject.Locked = rdr.GetBoolean("Locked")
        newObject.EndPopulate()

        Return newObject

    End Function

#End Region

    Public Overrides Function SelectDataEntryNavigatorTree(ByVal userName As String) As DataEntryNavigatorTreeCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectDataEntryNavigatorTree, userName)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of DataEntryNavigatorTreeCollection, DataEntryNavigatorTree)(rdr, AddressOf PopulateDataEntryNavigatorTree)
        End Using

    End Function

End Class
