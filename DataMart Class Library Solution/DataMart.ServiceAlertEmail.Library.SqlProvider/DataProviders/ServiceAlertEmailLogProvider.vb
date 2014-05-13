Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class ServiceAlertEmailLogProvider
    Inherits Nrc.DataMart.ServiceAlertEmail.Library.ServiceAlertEmailLogProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " ServiceAlertEmailLog Procs "

    Private Function PopulateServiceAlertEmailLog(ByVal rdr As SafeDataReader) As ServiceAlertEmailLog

        Dim newObject As ServiceAlertEmailLog = ServiceAlertEmailLog.NewServiceAlertEmailLog
        Dim privateInterface As IServiceAlertEmailLog = newObject

        newObject.BeginPopulate()
        privateInterface.LogId = rdr.GetInteger("Log_id")
        newObject.Occurred = rdr.GetDate("datOccurred")
        newObject.Message = rdr.GetString("strMessage")
        newObject.QtyToSend = rdr.GetInteger("intQtyToSend")
        newObject.QtySuccessful = rdr.GetInteger("intQtySuccessful")
        newObject.QtyError = rdr.GetInteger("intQtyError")
        newObject.Exception = rdr.GetString("strException")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectAllServiceAlertEmailLogs() As ServiceAlertEmailLogCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllServiceAlertEmailLogs)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ServiceAlertEmailLogCollection, ServiceAlertEmailLog)(rdr, AddressOf PopulateServiceAlertEmailLog)
        End Using

    End Function

    Public Overrides Function InsertServiceAlertEmailLog(ByVal instance As ServiceAlertEmailLog) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertServiceAlertEmailLog, SafeDataReader.ToDBValue(instance.Occurred), instance.Message, instance.QtyToSend, instance.QtySuccessful, instance.QtyError, instance.Exception)
        Return ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateServiceAlertEmailLog(ByVal instance As ServiceAlertEmailLog)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateServiceAlertEmailLog, instance.LogId, SafeDataReader.ToDBValue(instance.Occurred), instance.Message, instance.QtyToSend, instance.QtySuccessful, instance.QtyError, instance.Exception)
        ExecuteNonQuery(cmd)

    End Sub

#End Region

End Class
