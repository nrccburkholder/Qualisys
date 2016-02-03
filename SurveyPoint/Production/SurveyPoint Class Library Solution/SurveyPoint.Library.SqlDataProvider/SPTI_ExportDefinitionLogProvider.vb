'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class SPTI_ExportDefinitionLogProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.SPTI_ExportDefinitionLogProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const DeleteSPTI_ExportDefinitionLog As String = "dbo.SPTI_DeleteSPTI_ExportDefinitionLog"
        Public Const InsertSPTI_ExportDefinitionLog As String = "dbo.SPTI_InsertSPTI_ExportDefinitionLog"
        Public Const SelectAllSPTI_ExportDefinitionLogs As String = "dbo.SPTI_SelectAllSPTI_ExportDefinitionLogs"
        Public Const SelectSPTI_ExportDefinitionLog As String = "dbo.SPTI_SelectSPTI_ExportDefinitionLog"
        Public Const UpdateSPTI_ExportDefinitionLog As String = "dbo.SPTI_UpdateSPTI_ExportDefinitionLog"
    End Class
#End Region

#Region " SPTI_ExportDefinitionLog Procs "

    Private Function PopulateSPTI_ExportDefinitionLog(ByVal rdr As SafeDataReader) As SPTI_ExportDefinitionLog
        Dim newObject As SPTI_ExportDefinitionLog = SPTI_ExportDefinitionLog.NewSPTI_ExportDefinitionLog
        Dim privateInterface As ISPTI_ExportDefinitionLog = newObject
        newObject.BeginPopulate()
        privateInterface.LogID = rdr.GetInteger("LogID")
        newObject.ExportDefinitionID = rdr.GetInteger("ExportDefinitionID")
        newObject.DateCreated = rdr.GetDate("DateCreated")
        newObject.DateCompleted = rdr.GetNullableDate("DateCompleted")
        newObject.NumberFileDupsRemoved = rdr.GetNullableInteger("NumberFileDupsRemoved")
        newObject.ErrorMessage = rdr.GetString("ErrorMessage")
        newObject.StackTrace = rdr.GetString("StackTrace")
        newObject.NumberQMSDeDupsRemoved = rdr.GetString("NumberQMSDeDupsRemoved")
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectSPTI_ExportDefinitionLog(ByVal logID As Integer) As SPTI_ExportDefinitionLog
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectSPTI_ExportDefinitionLog, logID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateSPTI_ExportDefinitionLog(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllSPTI_ExportDefinitionLogs() As SPTI_ExportDefinitionLogCollection
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllSPTI_ExportDefinitionLogs)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SPTI_ExportDefinitionLogCollection, SPTI_ExportDefinitionLog)(rdr, AddressOf PopulateSPTI_ExportDefinitionLog)
        End Using
    End Function

    Public Overrides Function InsertSPTI_ExportDefinitionLog(ByVal instance As SPTI_ExportDefinitionLog) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSPTI_ExportDefinitionLog, instance.ExportDefinitionID, SafeDataReader.ToDBValue(instance.DateCreated), SafeDataReader.ToDBValue(instance.DateCompleted), instance.NumberFileDupsRemoved, instance.ErrorMessage, instance.StackTrace, instance.NumberQMSDeDupsRemoved)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub UpdateSPTI_ExportDefinitionLog(ByVal instance As SPTI_ExportDefinitionLog)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateSPTI_ExportDefinitionLog, instance.LogID, instance.ExportDefinitionID, SafeDataReader.ToDBValue(instance.DateCreated), SafeDataReader.ToDBValue(instance.DateCompleted), instance.NumberFileDupsRemoved, instance.ErrorMessage, instance.StackTrace, instance.NumberQMSDeDupsRemoved)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteSPTI_ExportDefinitionLog(ByVal logID As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteSPTI_ExportDefinitionLog, logID)
        ExecuteNonQuery(cmd)
    End Sub

#End Region
End Class
