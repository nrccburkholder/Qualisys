Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

''' <summary>Provider class for ExportSurvey</summary>
''' <CreateBy>Arman Mnatsakanyan</CreateBy>
''' <RevisionList><list type="table">
''' <listheader>
''' <term>Date Modified - Modified By</term>
''' <description>Description</description></listheader>
''' <item>
''' <term>2008-03-13 - Arman Mnatsakanyan</term>
''' <description>Implemented the population of the collection properties
''' here.</description></item>
''' <item>
''' <term>	</term>
''' <description>
''' <para></para></description></item></list></RevisionList>
Friend Class ExportSurveyProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.ExportSurveyProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property


#Region " ExportSurvey Procs "
    Private Function PopulateExportSurvey(ByVal rdr As SafeDataReader) As ExportSurvey
        Dim newObject As ExportSurvey = ExportSurvey.NewSurvey
        Dim privateInterface As ISurvey = newObject
        newObject.BeginPopulate()
        privateInterface.SurveyID = rdr.GetInteger("SurveyID")
        newObject.Name = rdr.GetString("Name")
        newObject.Description = rdr.GetString("Description")
        newObject.CreatedByUserID = rdr.GetInteger("CreatedByUserID")
        newObject.CreatedOnDate = rdr.GetDate("CreatedOnDate")
        newObject.Active = rdr.GetByte("Active")
        newObject.EndPopulate()
        Return newObject
    End Function
    Private Function PopulateSelectedClientsAndScripts(ByVal SelectedSurvey As ExportSurvey, ByVal LinkedGroup As ExportGroup) As ExportSurvey
        SelectedSurvey.BeginPopulate()
        SelectedSurvey.ExportClientSelectedCollection = ExportClientSelected.GetSelectedClients(LinkedGroup, SelectedSurvey)
        SelectedSurvey.ExportScriptSelectedCollection = ExportScriptSelected.GetScriptsByExportGroupAndSurvey(LinkedGroup, SelectedSurvey)
        SelectedSurvey.EndPopulate()
        Return SelectedSurvey
    End Function
    Public Overrides Function GetAllSurveies() As ExportSurveyCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SP_GetAllSurveies)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ExportSurveyCollection, ExportSurvey)(rdr, AddressOf PopulateExportSurvey)
        End Using
    End Function
    Public Overrides Function GetSelectedSurvey(ByVal SelectedExportGroup As ExportGroup) As ExportSurvey
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SP_GetSelectedSurvey, SelectedExportGroup.ExportGroupID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Dim SelectedSurveys As ExportSurveyCollection = _
            PopulateCollection(Of ExportSurveyCollection, ExportSurvey)(rdr, AddressOf PopulateExportSurvey)
            If SelectedSurveys.Count > 0 Then
                Return PopulateSelectedClientsAndScripts(SelectedSurveys(0), SelectedExportGroup)
            Else
                Return Nothing
            End If
        End Using
    End Function
    Public Overrides Function [Get](ByVal surveyID As Integer) As ExportSurvey
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SP_GetSurvey, surveyID)
        Dim retVal As ExportSurvey = Nothing
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                retVal = PopulateExportSurvey(rdr)
            End While
        End Using
        Return retVal
    End Function
#End Region


End Class
