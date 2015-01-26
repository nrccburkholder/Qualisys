Imports Nrc.Framework.Data

Public Class USPS_ACS_Provider
    Inherits Nrc.QualiSys.Library.DataProvider.USPS_ACS_Provider


    Public Overrides Function SelectPartialMatchesByStatus(ByVal status As Integer, ByVal fromDate As String, ByVal toDate As String) As DataSet

        Dim cmd As DbCommand = Db.GetStoredProcCommand("USPS_ACS_SelectPartialMatchesDataSetByStatus", status, fromDate, toDate)

        Try
            Return Db.ExecuteDataSet(cmd)
        Catch ex As Exception
            Throw (New SqlCommandException(cmd, ex))
        End Try

    End Function

    Public Overrides Sub UpdatePartialMatchStatus(ByVal id As Integer, ByVal status As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand("USPS_ACS_UpdatePartialMatchStatus", id, Convert.ToByte(status))

        Try
            Db.ExecuteNonQuery(cmd)
        Catch ex As Exception
            Throw (New SqlCommandException(cmd, ex))
        End Try

    End Sub
End Class
