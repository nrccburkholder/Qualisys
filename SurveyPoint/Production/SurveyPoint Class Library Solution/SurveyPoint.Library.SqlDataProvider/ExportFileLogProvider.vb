'********************************************************************************
' Concrete SqlProvider Class
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.ComponentModel


''' <summary>DataProvider class for ExportFileLog business class</summary>
''' <CreateBy>Arman Mnatsakanyan</CreateBy>
''' <RevisionList><list type="table">
''' <listheader>
''' <term>Date Modified - Modified By</term>
''' <description>Description</description></listheader>
''' <item>
''' <term>	</term>
''' <description>
''' <para></para></description></item>
''' <item>
''' <term>	</term>
''' <description>
''' <para></para></description></item></list></RevisionList>
Friend Class ExportFileLogProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.ExportFileLogProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SPU_ExportFileLog Procs "

    ''' <summary>Populates the log file object with values from the data
    ''' store.</summary>
    ''' <param name="rdr"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20080414 - Tony Piccoli</term>
    ''' <description>Changed data values to nullable.</description></item>
    ''' <item>
    ''' <term>	20080414 - Tony Piccoli</term>
    ''' <description>Changed MarkSubmitted to bool v alue.</description></item>
    ''' <item>
    ''' <term>	20080416 - Tony Piccoli</term>
    ''' <description>Added Mark2401 date
    ''' fields</description></item></list></RevisionList>
    Private Function PopulateExportFileLog(ByVal rdr As SafeDataReader) As ExportFileLog
        Dim newObject As ExportFileLog = ExportFileLog.NewExportFileLog
        Dim privateInterface As IExportFileLog = newObject
        newObject.BeginPopulate()
        privateInterface.ExportLogFileID = rdr.GetInteger("ExportLogFileID")
        newObject.ExportGroupID = rdr.GetInteger("ExportGroupID")
        newObject.ExportGroupName = rdr.GetString("Name")
        newObject.StartDate = rdr.GetNullableDate("StartDate")
        newObject.EndDate = rdr.GetNullableDate("EndDate")
        'TP 20080416 New Fields
        newObject.Mark2401RangeStartDate = rdr.GetNullableDate("Mark2401RangeStartDate")
        newObject.Mark2401RangeEndDate = rdr.GetNullableDate("Mark2401RangeEndDate")
        newObject.UserID = rdr.GetInteger("UserID")
        newObject.UserName = rdr.GetString("UserName")
        newObject.IsActive = CBool(rdr.GetByte("IsActive"))
        newObject.QuestionFileRecordsExported = rdr.GetInteger("QuestionFileRecordsExported")
        newObject.QuestionFileName = rdr.GetString("QuestionFileName")
        newObject.AnswerFileRecordsExported = rdr.GetInteger("AnswerFileRecordsExported")
        newObject.AnswerFileName = rdr.GetString("AnswerFileName")
        newObject.errorMessage = rdr.GetString("errorMessage")
        newObject.StackTrace = rdr.GetString("StackTrace")
        newObject.MarkSubmitted = CBool(rdr.Item("MarkSubmitted"))
        'SK 20080426 New Field
        newObject.RespondentsExported = rdr.GetInteger("RespondentsExported")
        newObject.EndPopulate()

        Return newObject
    End Function
    ''' <summary>
    ''' All of the [Get] functions use the same stored procedure with optional parameters.
    ''' </summary>
    ''' <param name="exportLogFileID"></param>
    ''' <returns>A populated ExportFileLog object</returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function SelectExportFileLog(ByVal exportLogFileID As Integer) As ExportFileLog
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectExportFileLog, _
            exportLogFileID, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value _
        )
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateExportFileLog(rdr)
            End If
        End Using
    End Function

    ''' <summary>Gets all Log records and populates them into a ExportFileLogCollection object for the given date range.</summary>
    ''' <param name="StartDate"></param>
    ''' <param name="EndDate"></param>
    ''' <returns>Populated ExportFileLogCollection</returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function SelectAllExportFileLogs(ByVal StartDate As Date, ByVal EndDate As Date) As ExportFileLogCollection
        'We have to pass -1 as the @ExportGroupID parameter to get all of the records in the date range

        '@ExportLogFileID INT = null,  
        '@ExportGroupID INT = null,  
        '@StartDate DATETIME = null,  
        '@EndDate DATETIME = null,  
        '@UserID INT = null,  
        '@UserName VARCHAR(50) = null,  
        '@IsActive int = null,  
        '@QuestionFileRecordsExported INT = null,  
        '@AnswerFileRecordsExported INT = null,  
        '@errorMessage VARCHAR(1000) = null,  
        '@StackTrace VARCHAR(8000) = null,  
        '@MarkSubmitted SMALLINT = null  )  

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectExportFileLog, _
            DBNull.Value, _
            DBNull.Value, _
            StartDate, _
            EndDate, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value _
        )
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ExportFileLogCollection, ExportFileLog)(rdr, AddressOf PopulateExportFileLog)
        End Using
    End Function
    ''' <summary>Gets all Log records and populates them into a ExportFileLogCollection
    ''' object for the given date range and given export group.</summary>
    ''' <param name="ExportGroupID"></param>
    ''' <param name="StartDate"></param>
    ''' <param name="EndDate"></param>
    ''' <returns>Populated ExportFileLogCollection</returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public Overrides Function SelectExportFileLogByExportGroupID(ByVal ExportGroupID As Integer, ByVal StartDate As Date, ByVal EndDate As Date) As ExportFileLogCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectExportFileLog, _
            DBNull.Value, _
            ExportGroupID, _
            StartDate, _
            EndDate, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value, _
            DBNull.Value _
        )

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ExportFileLogCollection, ExportFileLog)(rdr, AddressOf PopulateExportFileLog)
        End Using
    End Function


    ''' <summary>Inserts the New ExportFileLog object's data into the database.</summary>
    ''' <param name="instance"></param>
    ''' <returns>The ID of the new object from the database</returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function InsertExportFileLog(ByVal instance As ExportFileLog) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertExportFileLog, instance.ExportGroupID, SafeDataReader.ToDBValue(instance.StartDate), SafeDataReader.ToDBValue(instance.EndDate), instance.UserID, instance.UserName, instance.IsActive, instance.QuestionFileRecordsExported, instance.AnswerFileRecordsExported, instance.errorMessage, instance.StackTrace, instance.MarkSubmitted)
        Return ExecuteInteger(cmd)
    End Function

    ''' <summary>Updates the ExportFileLog object's data in the database to match the ExportFileLog values.</summary>
    ''' <param name="instance"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Sub UpdateExportFileLog(ByVal instance As ExportFileLog)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateExportFileLog, instance.ExportLogFileID, instance.ExportGroupID, SafeDataReader.ToDBValue(instance.StartDate), SafeDataReader.ToDBValue(instance.EndDate), instance.UserID, instance.UserName, instance.IsActive, instance.QuestionFileRecordsExported, instance.AnswerFileRecordsExported, instance.errorMessage, instance.StackTrace, instance.MarkSubmitted)
        ExecuteNonQuery(cmd)
    End Sub

    ''' <summary>Deletes an ExportFileLog row from the mapped table</summary>
    ''' <param name="exportLogFileID"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Sub DeleteExportFileLog(ByVal exportLogFileID As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteExportFileLog, exportLogFileID)
        ExecuteNonQuery(cmd)
    End Sub

    ''' <summary>Custom procedure used when creating a new log file.</summary>
    ''' <param name="exportGroupID"></param>
    ''' <param name="userID"></param>
    ''' <param name="userName"></param>
    ''' <param name="isActive"></param>
    ''' <param name="markSubmitted"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function CreateFileLog(ByVal exportGroupID As Integer, ByVal userID As Integer, ByVal userName As String, ByVal isActive As Boolean, ByVal markSubmitted As Boolean) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.CreateFileLog, exportGroupID, userID, userName, isActive, markSubmitted)
        Return ExecuteInteger(cmd)
    End Function
    ''' <summary>Custom Procedure used when finishing a log file (update).</summary>
    ''' <param name="logFile"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20080425 - Tony Piccoli</term>
    ''' <description>Added respondentsExported column value.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public Overrides Sub FinishLogFileEntry(ByVal logFile As ExportFileLog)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.FinishFileLog, logFile.ExportLogFileID, logFile.ExportGroupID, logFile.QuestionFileRecordsExported, logFile.AnswerFileRecordsExported, logFile.RespondentsExported, logFile.errorMessage, logFile.StackTrace)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub MarkExportFileLogInActive(ByVal exportGroupId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.MarkExportFileLogInActive, exportGroupId)
        ExecuteNonQuery(cmd)
    End Sub


#End Region


End Class
