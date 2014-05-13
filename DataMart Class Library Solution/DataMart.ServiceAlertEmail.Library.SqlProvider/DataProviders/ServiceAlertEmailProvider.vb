Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data

Friend Class ServiceAlertEmailProvider
    Inherits Nrc.DataMart.ServiceAlertEmail.Library.ServiceAlertEmailProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " ServiceAlertEmail Procs "

    Private Function PopulateServiceAlertEmail(ByVal rdr As SafeDataReader) As ServiceAlertEmail

        Dim newObject As ServiceAlertEmail = ServiceAlertEmail.NewServiceAlertEmail
        Dim privateInterface As IServiceAlertEmail = newObject

        newObject.BeginPopulate()
        privateInterface.ClientUserId = rdr.GetInteger("ClientUser_id")
        newObject.EmailList = rdr.GetString("strEmailList")
        newObject.AccountDirector = rdr.GetString("AD")
        newObject.EmailFormat = rdr.GetEnum(Of ServiceAlertEmailFormats)("intEmailFormat")
        newObject.LithoList = rdr.GetString("strLithoList")
        newObject.LoginName = rdr.GetString("strLoginName")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectAllServiceAlertEmails() As ServiceAlertEmailCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllServiceAlertEmails)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ServiceAlertEmailCollection, ServiceAlertEmail)(rdr, AddressOf PopulateServiceAlertEmail)
        End Using

    End Function

#End Region

End Class
