'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class VoviciDownloadLogProvider
    Inherits QualiSys.Scanning.Library.VoviciDownloadLogProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property


#Region " VoviciDownloadLog Procs "

    Private Function PopulateVoviciDownloadLog(ByVal rdr As SafeDataReader) As VoviciDownloadLog

        Dim newObject As VoviciDownloadLog = VoviciDownloadLog.NewVoviciDownloadLog
        Dim privateInterface As IVoviciDownloadLog = newObject
        newObject.BeginPopulate()
        privateInterface.VoviciDownloadId = rdr.GetInteger("VoviciDownload_ID")
        newObject.VoviciSurveyId = rdr.GetString("VoviciSurvey_ID")
        newObject.datLastDownload = rdr.GetDate("datLastDownload")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectVoviciDownloadLog(ByVal voviciDownloadId As Integer) As VoviciDownloadLog

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVoviciDownloadLog, voviciDownloadId)

        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateVoviciDownloadLog(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectVoviciDownloadLogBySurveyID(ByVal voviciSurveyId As String) As VoviciDownloadLog

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectVoviciDownloadLogBySurveyID, voviciSurveyId)

        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateVoviciDownloadLog(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectAllVoviciDownloadLogs() As VoviciDownloadLogCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllVoviciDownloadLogs)

        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of VoviciDownloadLogCollection, VoviciDownloadLog)(rdr, AddressOf PopulateVoviciDownloadLog)
        End Using

    End Function

    Public Overrides Function InsertVoviciDownloadLog(ByVal instance As VoviciDownloadLog) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertVoviciDownloadLog, instance.VoviciSurveyId, SafeDataReader.ToDBValue(instance.datLastDownload))
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateVoviciDownloadLog(ByVal instance As VoviciDownloadLog)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateVoviciDownloadLog, instance.VoviciDownloadId, instance.VoviciSurveyId, SafeDataReader.ToDBValue(instance.datLastDownload))
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteVoviciDownloadLog(ByVal instance As VoviciDownloadLog)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteVoviciDownloadLog, instance.VoviciDownloadId)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

#End Region

End Class
