Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class ServiceAlertEmailsAttemptedProvider
    Inherits Nrc.DataMart.ServiceAlertEmail.Library.ServiceAlertEmailsAttemptedProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property


#Region " EmailLog Procs "

    Private Function PopulateEmailsAttempted(ByVal rdr As SafeDataReader) As ServiceAlertEmailsAttempted

        Dim newObject As ServiceAlertEmailsAttempted = ServiceAlertEmailsAttempted.NewServiceAlertEmailsAttempted
        Dim privateInterface As IServiceAlertEmailsAttempted = newObject

        newObject.BeginPopulate()
        privateInterface.LogId = rdr.GetInteger("Log_id")
        newObject.ClientUserId = rdr.GetInteger("ClientUser_id")
        newObject.LithoList = rdr.GetString("strLithoList")
        newObject.ToList = rdr.GetString("strToList")
        newObject.DateSent = rdr.GetDate("datDateSent_dt")
        newObject.EMailFormat = rdr.GetEnum(Of ServiceAlertEmailFormats)("intEMailFormat")
        newObject.Exception = rdr.GetString("strException")

        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectAllServiceAlertEmailsAttempted() As ServiceAlertEmailsAttemptedCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllServiceAlertEmailsAttempted)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ServiceAlertEmailsAttemptedCollection, ServiceAlertEmailsAttempted)(rdr, AddressOf PopulateEmailsAttempted)
        End Using

    End Function

    Public Overrides Function InsertServiceAlertEmailsAttempted(ByVal instance As ServiceAlertEmailsAttempted) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertServiceAlertEmailsAttempted, instance.ClientUserId, instance.LithoList, instance.ToList, SafeDataReader.ToDBValue(instance.DateSent), instance.EMailFormat, instance.Exception)
        Return ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateServiceAlertEmailsAttempted(ByVal instance As ServiceAlertEmailsAttempted)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateServiceAlertEmailsAttempted, instance.LogId, instance.ClientUserId, instance.LithoList, instance.ToList, SafeDataReader.ToDBValue(instance.DateSent), instance.EMailFormat, instance.Exception)
        ExecuteNonQuery(cmd)

    End Sub

#End Region

End Class
