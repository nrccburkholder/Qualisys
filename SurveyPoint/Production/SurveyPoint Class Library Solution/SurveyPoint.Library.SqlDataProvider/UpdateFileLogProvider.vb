Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class UpdateFileLogProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.UpdateFileLogProvider

    Private Function Populate(ByVal rdr As SafeDataReader) As UpdateFileLog

        Dim newObject As UpdateFileLog = UpdateFileLog.NewUpdateFileLog
        Dim privateInterface As IUpdateFileLog = newObject
        newObject.BeginPopulate()
        privateInterface.FileLogID = rdr.GetInteger("FileLogID")
        newObject.FileName = rdr.GetString("FileName")
        newObject.DateLoaded = rdr.GetDate("DatFileLoaded")
        newObject.UserID = rdr.GetInteger("UserID")
        newObject.UserName = rdr.GetString("UserName")
        newObject.NumRecords = rdr.GetInteger("NumRecordsInFile")
        newObject.NumUpdated = rdr.GetInteger("NumRecordsUpdated")
        newObject.NumMissingCodes = rdr.GetInteger("NumMissingEventCodes")
        newObject.UpdateTypeID = rdr.GetInteger("UpdateTypeID")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectAll() As UpdateFileLogCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllUpdateFileLogs, Date.MinValue, Date.MaxValue)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of UpdateFileLogCollection, UpdateFileLog)(rdr, AddressOf Populate)
        End Using

    End Function

    Public Overrides Function SelectByDate(ByVal minDate As Date, ByVal maxDate As Date) As UpdateFileLogCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectUpdateFileLogsByDate, minDate, maxDate)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of UpdateFileLogCollection, UpdateFileLog)(rdr, AddressOf Populate)
        End Using

    End Function

    Public Overrides Function SelectAllUpdatedRespondents(ByVal fileLogID As Integer) As String()

        Dim updated As String() = {}
        Dim size As Integer = 0

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllUpdateFileLogRespondents, -1, fileLogID, CDate("1900-01-01 00:00:00"))
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                size += 1
                Array.Resize(updated, size)
                updated(size - 1) = rdr.GetInteger("RespondentID").ToString
            End While
        End Using

        Return updated

    End Function

    Public Overrides Sub Insert(ByVal obj As UpdateFileLog)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertUpdateFileLog, obj.FileName, obj.NumRecords, obj.NumUpdated, obj.NumMissingCodes, obj.UpdateTypeID, obj.UserID, obj.UserName)
        Dim newId As Integer = ExecuteInteger(cmd)
        Dim privateInterface As IUpdateFileLog = obj
        privateInterface.FileLogID = newId

    End Sub

    Public Overrides Sub InsertRespondent(ByVal respondentID As Integer, ByVal fileLogID As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertUpdateFileLogRespondent, respondentID, fileLogID)
        ExecuteNonQuery(cmd)

    End Sub
End Class
