Imports System.Data.SqlClient

Public Class ListOfServers
    Inherits List(Of ServerProperty)
    Public Function FindByServerName(ByVal pName) As ServerProperty
        For Each s As ServerProperty In Me
            If s.ServerName = pName Then
                Return s
            End If
        Next
        Return Nothing
    End Function
End Class