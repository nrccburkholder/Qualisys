Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports PS.Framework.Data

Public Class RespondentImportScheduleProvider
    Inherits PS.ResponseImport.Library.RespondentImportScheduleProvider

    Private ReadOnly Property Db(ByVal connString As String) As Database
        Get
            Return DatabaseHelper.Db(connString)
        End Get
    End Property
    Private Function PopulateRespondentImportSchedule(ByVal rdr As SafeDataReader) As RespondentImportSchedule
        Dim obj As RespondentImportSchedule = RespondentImportSchedule.NewRespondentImportSchedule
        Dim privateInterface As IRespondentImportSchedule = obj
        obj.BeginPopulate()
        privateInterface.RespondentImportScheduleID = rdr.GetInteger("RespondentImportScheduleID")
        obj.Day = rdr.GetInteger("Day")
        obj.StartTime = rdr.GetString("StartTime")
        obj.EndTime = rdr.GetString("EndTime")
        obj.Description = rdr.GetString("Description")
        obj.Allow = rdr.GetInteger("Allow")
        obj.EndPopulate()
        Return obj
    End Function
    Public Overrides Function GetRespondentImportSchedule(ByVal respondentImportScheduleID As Integer) As RespondentImportSchedule
        Dim cmd As DbCommand = Db(Config.SurveyAdminConnection).GetStoredProcCommand(SP.GetRespondentImportSchedule, respondentImportScheduleID)
        Dim sched As RespondentImportSchedule = Nothing
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                sched = PopulateRespondentImportSchedule(rdr)
            End While
        End Using
        Return sched
    End Function
    Public Overrides Function GetRespondentImportSchedules() As RespondentImportSchedules
        Dim cmd As DbCommand = Db(Config.SurveyAdminConnection).GetStoredProcCommand(SP.GetRespondentImportSchedules)
        Dim lst As New RespondentImportSchedules
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of RespondentImportSchedules, RespondentImportSchedule)(rdr, AddressOf PopulateRespondentImportSchedule)
        End Using
    End Function    
End Class