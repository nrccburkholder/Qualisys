Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports PS.Framework.Data

Public Class RespondentImportFileLineLogProvider
    Inherits PS.ResponseImport.Library.RespondentImportFileLineLogProvider

    Private ReadOnly Property Db(ByVal connString As String) As Database
        Get
            Return DatabaseHelper.Db(connString)
        End Get
    End Property
    Private Function PopulateRespondentImportFileLineLog(ByVal rdr As SafeDataReader) As RespondentImportFileLineLog
        Dim obj As RespondentImportFileLineLog = RespondentImportFileLineLog.NewRespondentImportFileLineLog
        Dim privateInterface As IRespondentImportFileLineLog = obj
        obj.BeginPopulate()
        privateInterface.RespondentImportFileLineLogID = rdr.GetInteger("RespImportFileLineLogID")
        obj.RespondentImportFileID = rdr.GetString("RespImportFileID")
        obj.RespondentImportFileLineID = rdr.GetString("RespImportFileLineID")
        obj.FileIndex = rdr.GetInteger("FileIndex")
        obj.SurveyID = rdr.GetInteger("SurveyID")
        obj.ClientID = rdr.GetInteger("ClientID")
        obj.SurveyInstanceID = rdr.GetInteger("SurveyInstanceID")
        obj.TemplateID = rdr.GetInteger("TemplateID")
        obj.FileDefID = rdr.GetInteger("FileDefID")
        obj.BatchID = rdr.GetString("BatchID")
        obj.DateCreated = rdr.GetDate("DateCreated")
        obj.DateCompleted = rdr.GetNullableDate("DateCompleted")
        obj.Notes = rdr.GetString("Notes")
        obj.EndPopulate()
        Return obj
    End Function
    Public Overrides Function GetRespondentImportFileLineLogsByImportFileID(ByVal respImportFileID As String) As RespondentImportFileLineLogs
        Dim cmd As DbCommand = Db(Config.SurveyAdminConnection).GetStoredProcCommand(SP.GetRespondentImportFileLineLogsByImportFileID, respImportFileID)
        Dim lst As New RespondentImportFileLineLogs
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of RespondentImportFileLineLogs, RespondentImportFileLineLog)(rdr, AddressOf PopulateRespondentImportFileLineLog)
        End Using
    End Function
    Public Overrides Sub AddToLog(ByVal respImportFileID As String, ByVal respImportFileLineID As String, _
                                  ByVal fileIndex As Integer, ByVal surveyID As Integer, ByVal clientID As Integer, _
                                  ByVal surveyInstanceID As Integer, ByVal templateID As Integer, _
                                  ByVal fileDefID As Integer, ByVal batchID As String, ByVal dateCompleted As Date?, _
                                  ByVal notes As String, ByVal severity As LogSeverity)
        Dim cmd As DbCommand = Db(Config.SurveyAdminConnection).GetStoredProcCommand(SP.AddRespondentImportFileLineLog, respImportFileID, respImportFileLineID, _
                                                       fileIndex, surveyID, clientID, surveyInstanceID, templateID, fileDefID, _
                                                       batchID, dateCompleted, Left(Trim(notes), 7000), CInt(severity))
        ExecuteNonQuery(cmd)
    End Sub
End Class
