Imports System.Data.Common
Imports NRC.Framework.Data

Friend Class LoadToLiveLookupProvider
    Inherits QualiSys.QLoader.Library20.LoadToLiveLookupProvider

#Region " Private Populate Method "

    Private Function PopulateLoadToLiveLookup(ByVal rdr As SafeDataReader) As LoadToLiveLookup

        Dim newObject As LoadToLiveLookup = LoadToLiveLookup.NewLoadToLiveLookup

        newObject.BeginPopulate()
        newObject.MasterTableName = rdr.GetString("MasterTableName")
        newObject.MasterFieldName = rdr.GetString("MasterFieldName")
        newObject.LookupTableName = rdr.GetString("LookupTableName")
        newObject.LookupFieldName = rdr.GetString("LookupFieldName")
        newObject.EndPopulate()

        Return newObject

    End Function

#End Region

#Region " Public Methods "

    Public Overrides Function SelectLoadToLiveLookupsByStudyIDTableName(ByVal studyID As Integer, ByVal lookupTableName As String) As LoadToLiveLookupCollection

        Dim cmd As DbCommand = QLoaderDatabaseHelper.Db.GetStoredProcCommand(SP.SelectLoadToLiveLookupsByStudyIDTableName, studyID, lookupTableName)

        Using rdr As New SafeDataReader(QLoaderDatabaseHelper.ExecuteReader(cmd))
            Return PopulateCollection(Of LoadToLiveLookupCollection, LoadToLiveLookup)(rdr, AddressOf PopulateLoadToLiveLookup)
        End Using

    End Function

#End Region

#Region " Private Methods "

#End Region

End Class
