Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.Collections.ObjectModel

Friend Class UpdateTypeProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.UpdateTypeProvider

    Private Function Populate(ByVal rdr As SafeDataReader) As UpdateType

        Dim newObject As UpdateType = UpdateType.NewUpdateType
        Dim privateInterface As IUpdateType = newObject
        newObject.BeginPopulate()
        privateInterface.UpdateTypeID = rdr.GetInteger("UpdateTypeID")
        newObject.Name = rdr.GetString("UpdateName")
        newObject.Order = rdr.GetInteger("intOrder")
        newObject.FromGroupID = rdr.GetEnum(Of UpdateTypeGroups)("FromGroupID")
        newObject.ToGroupID = rdr.GetEnum(Of UpdateTypeGroups)("ToGroupID")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectAll() As UpdateTypeCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllUpdateTypes)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of UpdateTypeCollection, UpdateType)(rdr, AddressOf Populate)
        End Using

    End Function

End Class
