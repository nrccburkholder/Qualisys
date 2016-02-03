'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.ComponentModel

Friend Class ExportEventAvailableProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.ExportEventAvailableProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property


#Region " SPU_ExportEvent Procs "
    
    Private Function PopulateExportEvent(ByVal rdr As SafeDataReader) As ExportEventAvailable
        Dim newObject As ExportEventAvailable = ExportEventAvailable.NewExportEvent
        Dim privateInterface As IExportEventAvailable = newObject
        newObject.BeginPopulate()
        privateInterface.EventID = rdr.GetInteger("EventID")
        newObject.Name = rdr.GetString("Name")
        newObject.EndPopulate()
        Return newObject
    End Function
    Public Overrides Function [Get](ByVal eventID As Integer) As ExportEventAvailable
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectedEventByID, eventID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateExportEvent(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function


    Public Overrides Function SelectAllExportEvents() As ExportEventAvailableCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllExportEvents)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ExportEventAvailableCollection, ExportEventAvailable)(rdr, AddressOf PopulateExportEvent)
        End Using
    End Function



#End Region


End Class
