Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.Collections.ObjectModel

Friend Class UpdateMappingProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.UpdateMappingProvider

    Private Function Populate(ByVal rdr As SafeDataReader) As UpdateMapping

        Dim newObject As UpdateMapping = UpdateMapping.NewUpdateMapping
        Dim privateInterface As IUpdateMapping = newObject
        newObject.BeginPopulate()
        privateInterface.UpdateMappingID = rdr.GetInteger("UpdateMappingID")
        newObject.UpdateTypeID = rdr.GetInteger("UpdateTypeID")
        newObject.OldEventID = rdr.GetInteger("OldEventID", -1)
        newObject.NewEventID = rdr.GetInteger("NewEventID", -1)
        newObject.Order = rdr.GetInteger("intOrder", -1)
        newObject.EventType = rdr.GetEnum(Of EventTypesEnum)("bitComplete")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectByUpdateTypeID(ByVal updateTypeID As Integer) As UpdateMappingCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectUpdateMappingsByUpdateTypeID, updateTypeID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of UpdateMappingCollection, UpdateMapping)(rdr, AddressOf Populate)
        End Using

    End Function

End Class
