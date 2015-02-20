Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Nrc.Framework.Data
Public Class AuditLogProvider
    Inherits Nrc.QualiSys.Library.DataProvider.AuditLogProvider

    Public Overrides Sub InsertAuditLogChange(ByVal userName As String, ByVal objectId As Integer, ByVal objectType As AuditLogObject, ByVal propertyName As String, ByVal changeType As AuditLogChangeType, ByVal initialValue As String, ByVal finalValue As String)
        Dim changeTypeValue As Char
        Select Case changeType
            Case AuditLogChangeType.Add
                changeTypeValue = Char.Parse("A")
            Case AuditLogChangeType.Delete
                changeTypeValue = Char.Parse("D")
            Case AuditLogChangeType.Update
                changeTypeValue = Char.Parse("U")
        End Select

        'Trim to the maximum Length the table will except
        If initialValue IsNot Nothing AndAlso initialValue.Length > 3000 Then initialValue = initialValue.Substring(0, 2999)
        If finalValue IsNot Nothing AndAlso finalValue.Length > 3000 Then finalValue = finalValue.Substring(0, 2999)

        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.InsertAuditLogChange, objectId, objectType.ToString, propertyName, initialValue, finalValue, userName, changeTypeValue)
        ExecuteNonQuery(cmd)
    End Sub
End Class
