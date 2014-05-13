Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Nrc.Framework.BusinessLogic.Configuration

<HideModuleName()> _
Module QualiSysDatabaseHelper

    Friend Delegate Function FillMethod(Of T)(ByVal rdr As SafeDataReader) As T

    Private mDbInstance As Database = Nothing

    Friend ReadOnly Property Db() As Database
        Get
            If mDbInstance Is Nothing Then
                mDbInstance = New Sql.SqlDatabase(AppConfig.QualisysConnection)
            End If

            Return mDbInstance
        End Get
    End Property

#Region " Helper Functions "

    Friend Function ExecuteReader(ByVal cmd As DbCommand) As IDataReader

        Try
            cmd.CommandTimeout = AppConfig.SqlTimeout
            Return Db.ExecuteReader(cmd)

        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)

        End Try

    End Function

    Friend Function ExecuteReader(ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As IDataReader

        Try
            cmd.CommandTimeout = AppConfig.SqlTimeout
            Return Db.ExecuteReader(cmd, transaction)

        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)

        End Try

    End Function

    Friend Function ExecuteDataSet(ByVal cmd As DbCommand) As DataSet

        Try
            cmd.CommandTimeout = AppConfig.SqlTimeout
            Return Db.ExecuteDataSet(cmd)

        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)

        End Try

    End Function

    Friend Function ExecuteDataSet(ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As DataSet

        Try
            cmd.CommandTimeout = AppConfig.SqlTimeout
            Return Db.ExecuteDataSet(cmd, transaction)

        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)

        End Try

    End Function

    Friend Function ExecuteNonQuery(ByVal cmd As DbCommand) As Integer

        Try
            cmd.CommandTimeout = AppConfig.SqlTimeout
            Return Db.ExecuteNonQuery(cmd)

        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)

        End Try

    End Function

    Friend Function ExecuteNonQuery(ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As Integer

        Try
            cmd.CommandTimeout = AppConfig.SqlTimeout
            Return Db.ExecuteNonQuery(cmd, transaction)

        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)

        End Try

    End Function

    Friend Function ExecuteScalar(ByVal cmd As DbCommand) As Object

        Try
            cmd.CommandTimeout = AppConfig.SqlTimeout
            Return Db.ExecuteScalar(cmd)

        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)

        End Try

    End Function

    Friend Function ExecuteScalar(ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As Object

        Try
            cmd.CommandTimeout = AppConfig.SqlTimeout
            Return Db.ExecuteScalar(cmd, transaction)

        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)

        End Try

    End Function

    Friend Function ExecuteInteger(ByVal cmd As DbCommand) As Integer

        Return CType(ExecuteScalar(cmd), Integer)

    End Function

    Friend Function ExecuteInteger(ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As Integer

        Return CType(ExecuteScalar(cmd, transaction), Integer)

    End Function

    Friend Function ExecuteBoolean(ByVal cmd As DbCommand) As Boolean

        Return CType(ExecuteScalar(cmd), Boolean)

    End Function

    Friend Function ExecuteBoolean(ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As Boolean

        Return CType(ExecuteScalar(cmd, transaction), Boolean)

    End Function

    Friend Function ExecuteString(ByVal cmd As DbCommand) As String

        Return CType(ExecuteScalar(cmd), String)

    End Function

    Friend Function ExecuteString(ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As String

        Return CType(ExecuteScalar(cmd, transaction), String)

    End Function

    'Friend Function PopulateCollection(Of C As {BusinessListBase(Of C, T), New}, T As BusinessBase(Of T))(ByVal rdr As SafeDataReader, ByVal populateMethod As FillMethod(Of T)) As C

    '    Dim list As New C

    '    While rdr.Read
    '        list.Add(populateMethod(rdr))
    '    End While

    '    Return list

    'End Function

    'Friend Function GetNullableParam(Of T As Structure)(ByVal paramValue As Nullable(Of T)) As Object

    '    If paramValue.HasValue Then
    '        Return paramValue.Value
    '    Else
    '        Return DBNull.Value
    '    End If

    'End Function

#End Region

End Module
