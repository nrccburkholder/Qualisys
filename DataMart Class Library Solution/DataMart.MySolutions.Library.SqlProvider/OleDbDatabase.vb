Option Strict On
Option Explicit On

Imports System.Data.OleDb

Namespace OleDb

    Public NotInheritable Class OleDbDatabase
        Inherits Microsoft.Practices.EnterpriseLibrary.Data.Database

        Public Sub New(ByVal connectionString As String)
            MyBase.New(connectionString, OleDbFactory.Instance)
        End Sub

        Protected Overrides Sub DeriveParameters(ByVal discoveryCommand As System.Data.Common.DbCommand)
            OleDbCommandBuilder.DeriveParameters(DirectCast(discoveryCommand, OleDbCommand))
        End Sub

    End Class

End Namespace
