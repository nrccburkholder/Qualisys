'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class DataLoadProvider
	Inherits QualiSys.Scanning.Library.DataLoadProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

	
#Region " DataLoad Procs "

    Private Function PopulateDataLoad(ByVal rdr As SafeDataReader) As DataLoad

        Dim newObject As DataLoad = DataLoad.NewDataLoad
        Dim privateInterface As IDataLoad = newObject

        newObject.BeginPopulate()
        privateInterface.DataLoadId = rdr.GetInteger("DataLoad_ID")
        newObject.VendorId = rdr.GetInteger("Vendor_ID")
        newObject.DisplayName = rdr.GetString("DisplayName")
        newObject.OrigFileName = rdr.GetString("OrigFileName")
        newObject.CurrentFilePath = rdr.GetString("CurrentFilePath")
        newObject.DateLoaded = rdr.GetDate("DateLoaded")
        newObject.ShowInTree = rdr.GetBoolean("bitShowInTree")
        newObject.TotalRecordsLoaded = rdr.GetInteger("TotalRecordsLoaded")
        newObject.TotalDispositionUpdateRecords = rdr.GetInteger("TotalDispositionUpdateRecords")
        newObject.DateCreated = rdr.GetDate("DateCreated")
        newObject.TranslationModuleId = rdr.GetInteger("TranslationModule_ID")
        newObject.EndPopulate()

        Return newObject

    End Function
	
    Public Overrides Function SelectDataLoad(ByVal dataLoadId As Integer) As DataLoad

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectDataLoad, dataLoadId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateDataLoad(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectDataLoadsByVendorId(ByVal vendorId As Integer) As DataLoadCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectDataLoadsByVendorId, vendorId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of DataLoadCollection, DataLoad)(rdr, AddressOf PopulateDataLoad)
        End Using

    End Function

    Public Overrides Function InsertDataLoad(ByVal instance As DataLoad) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertDataLoad, instance.VendorId, instance.DisplayName, instance.OrigFileName, instance.CurrentFilePath, SafeDataReader.ToDBValue(instance.DateLoaded), instance.ShowInTree, instance.TotalRecordsLoaded, instance.TotalDispositionUpdateRecords, SafeDataReader.ToDBValue(instance.DateCreated), instance.TranslationModuleId)
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateDataLoad(ByVal instance As DataLoad)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateDataLoad, instance.DataLoadId, instance.VendorId, instance.DisplayName, instance.OrigFileName, instance.CurrentFilePath, SafeDataReader.ToDBValue(instance.DateLoaded), instance.ShowInTree, instance.TotalRecordsLoaded, instance.TotalDispositionUpdateRecords, SafeDataReader.ToDBValue(instance.DateCreated), instance.TranslationModuleId)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteDataLoad(ByVal instance As DataLoad)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteDataLoad, instance.DataLoadId)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

#End Region

End Class
