Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.ComponentModel

Friend Class ExportScriptAvailableProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.ExportScriptAvailableProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " TEMP_SPU_GetSelectedScript Procs "

    Public Overrides Function SelectAllScriptsBySurveyAndClients(ByVal surveyID As Integer, ByVal clientIDs As String) As ExportScriptAvailableCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectScriptsBySurveyAndClients, surveyID, clientIDs)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ExportScriptAvailableCollection, ExportScriptAvailable)(rdr, AddressOf PopulateExportScriptAvailable)
        End Using
    End Function
    Public Overrides Function SelectScriptByScriptID(ByVal scriptID As Integer) As ExportScriptAvailable
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectScriptByScriptID, scriptID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                Return PopulateExportScriptAvailable(rdr)
            End While
        End Using
        Return Nothing
    End Function
    Private Function PopulateExportScriptAvailable(ByVal rdr As SafeDataReader) As ExportScriptAvailable
        Dim newObject As ExportScriptAvailable = ExportScriptAvailable.NewExportScriptAvailable
        Dim privateInterface As IExportScriptAvailable = newObject
        newObject.BeginPopulate()
        privateInterface.ScriptID = rdr.GetInteger("ScriptID")
        newObject.SurveyID = rdr.GetInteger("SurveyID")
        newObject.ScriptTypeID = rdr.GetInteger("ScriptTypeID")
        newObject.Name = rdr.GetString("Name")
        newObject.Description = rdr.GetString("Description")
        newObject.CompletenessLevel = rdr.GetDecimal("CompletenessLevel")
        newObject.FollowSkips = CBool(rdr.GetByte("FollowSkips"))
        newObject.CalcCompleteness = CBool(rdr.GetByte("CalcCompleteness"))
        newObject.DefaultScript = CBool(rdr.GetByte("DefaultScript"))
        newObject.EndPopulate()

        Return newObject
    End Function
#End Region


End Class