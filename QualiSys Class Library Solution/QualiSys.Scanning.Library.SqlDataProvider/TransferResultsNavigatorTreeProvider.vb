Imports Nrc.QualiSys.Scanning.Library
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data

Friend Class TransferResultsNavigatorTreeProvider
    Inherits QualiSys.Scanning.Library.TransferResultsNavigatorTreeProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

#Region " VendorFileSurveyTree Procs "

    Private Function PopulateTransferResultsNavigatorTree(ByVal rdr As SafeDataReader) As TransferResultsNavigatorTree

        Dim newObject As TransferResultsNavigatorTree = TransferResultsNavigatorTree.NewTransferResultsNavigatorTree
        Dim privateInterface As ITransferResultsNavigatorTree = newObject

        newObject.BeginPopulate()
        privateInterface.VendorID = rdr.GetInteger("Vendor_ID")
        newObject.VendorName = rdr.GetString("Vendor_Nm")
        newObject.DataLoadID = rdr.GetInteger("DataLoad_ID")
        newObject.DataLoadName = rdr.GetString("DisplayName")
        newObject.ShowInTree = rdr.GetBoolean("bitShowInTree")
        newObject.DataLoadHasSurveyErrors = rdr.GetBoolean("bitDLHasSurveyErrors")
        newObject.DataLoadHasBadLithos = rdr.GetBoolean("bitDLHasBadLithos")
        newObject.SurveyDataLoadID = rdr.GetInteger("SurveyDataLoad_ID")
        newObject.SurveyID = rdr.GetInteger("Survey_ID")
        newObject.SurveyName = rdr.GetString("strSurvey_Nm")
        newObject.SurveyDataLoadHasErrors = rdr.GetBoolean("bitSDLHasErrors")
        newObject.EndPopulate()

        Return newObject

    End Function

#End Region

    Public Overrides Function SelectTransferResultsNavigatorTreeByDateRange(ByVal startDate As Date, ByVal endDate As Date, ByVal sortMode As TransferSortModes) As TransferResultsNavigatorTreeCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectTransferResultsNavigatorTreeByDateRange, startDate, endDate, sortMode)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of TransferResultsNavigatorTreeCollection, TransferResultsNavigatorTree)(rdr, AddressOf PopulateTransferResultsNavigatorTree)
        End Using

    End Function

End Class
