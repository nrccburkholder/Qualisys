Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports PS.Framework.Data

Public Class RespondentImportFileLogProvider
    Inherits PS.ResponseImport.Library.RespondentImportFileLogProvider

    Private ReadOnly Property Db(ByVal connString As String) As Database
        Get
            Return DatabaseHelper.Db(connString)
        End Get
    End Property
    Private Function PopulateRespondentImportFileLog(ByVal rdr As SafeDataReader) As RespondentImportFileLog
        Dim obj As RespondentImportFileLog = RespondentImportFileLog.NewRespondentImportFileLog
        Dim privateInterface As IRespondentImportFileLog = obj
        obj.BeginPopulate()
        privateInterface.RespondentImportFileLogID = rdr.GetInteger("RespondentImportFileLogID")
        obj.RespondentImportFileID = rdr.GetString("RespImportFileID")
        obj.FileName = rdr.GetString("FileName")
        obj.ProcessDirectory = rdr.GetString("ProcessDirectory")
        obj.RowsToProcess = rdr.GetInteger("RowsToProcess")
        obj.DateCreated = rdr.GetDate("DateCreated")
        obj.DateCompleted = rdr.GetNullableDate("DateCompleted")
        obj.Notes = rdr.GetString("Notes")
        Select Case rdr.GetInteger("SurveySystemTypeID")
            Case 1
                obj.SurveySystemType = SurveySystemType.VRT
            Case 2
                obj.SurveySystemType = SurveySystemType.MAIL
            Case 3
                obj.SurveySystemType = SurveySystemType.WEB
            Case 4
                obj.SurveySystemType = SurveySystemType.PHONE
        End Select
        obj.EndPopulate()
        Return obj
    End Function
    Public Overrides Function GetByRespImportFileID(ByVal respImportFileID As String) As RespondentImportFileLog
        Dim cmd As DbCommand = Db(Config.SurveyAdminConnection).GetStoredProcCommand(SP.GetRespImportFileLogByFileID, respImportFileID)
        Dim log As RespondentImportFileLog = Nothing
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                log = PopulateRespondentImportFileLog(rdr)
            End While
        End Using
        Return log
    End Function
    Public Overrides Function GetRespondentImportFileLogsByDate(ByVal startDate As Date, ByVal endDate As Date) As RespondentImportFileLogs
        Dim cmd As DbCommand = Db(Config.SurveyAdminConnection).GetStoredProcCommand(SP.GetRespondentImportFileLogsByDate, startDate, endDate)
        Dim lst As New RespondentImportFileLogs
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of RespondentImportFileLogs, RespondentImportFileLog)(rdr, AddressOf PopulateRespondentImportFileLog)
        End Using
    End Function
    Public Overrides Sub AddLogEntry(ByVal respImportFileID As String, ByVal fileName As String, _
                        ByVal processDirectory As String, ByVal rowsToProcess As Integer, ByVal dateCompleted As Date?, ByVal notes As String, ByVal surveySysType As SurveySystemType)
        Dim cmd As DbCommand = Db(Config.SurveyAdminConnection).GetStoredProcCommand(SP.AddRespondentImportFileLog, respImportFileID, fileName, _
                                    processDirectory, rowsToProcess, dateCompleted, Left(Trim(notes), 8000), CInt(surveySysType))
        ExecuteNonQuery(cmd)
    End Sub    
End Class
