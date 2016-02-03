Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports PS.Framework.Data

Public Class RespondentImportControllerProvider
    Inherits PS.ResponseImport.Library.RespondentImportControllerProvider

    Private ReadOnly Property Db(ByVal connString As String) As Database
        Get
            Return DatabaseHelper.Db(connString)
        End Get
    End Property
    Public Overrides Function GetConfigVars(ByVal appName As String) As System.Collections.Hashtable
        Dim ht As New Hashtable()
        Dim cmd As DbCommand = Db(Config.SurveyAdminConnection).GetStoredProcCommand(SP.GetConfigVars, appName)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                ht.Add(rdr.GetString("ParameterName"), rdr.GetString("ParameterValue"))
            End While
        End Using
        Return ht
    End Function
End Class
