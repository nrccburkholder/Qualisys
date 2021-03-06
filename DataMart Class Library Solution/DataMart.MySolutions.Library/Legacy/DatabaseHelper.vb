Imports System.Collections.ObjectModel
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports Nrc.Framework.Data

Namespace Legacy
    <HideModuleName()> _
    Module DatabaseHelper

        Friend Delegate Function FillMethod(Of T)(ByVal rdr As SafeDataReader) As T
        Private mDataMartDbInstance As Database = Nothing

        Friend ReadOnly Property DataMartDb() As Database
            Get
                If mDataMartDbInstance Is Nothing Then
                    mDataMartDbInstance = New Sql.SqlDatabase(Config.DataMartConnection)
                End If

                Return mDataMartDbInstance
            End Get
        End Property

#Region " Helper Functions "

        Friend Function ExecuteReader(ByVal cmd As DBCommand) As IDataReader
            Try
                cmd.CommandTimeout = Config.SqlTimeout
                Return DataMartDb.ExecuteReader(cmd)
            Catch ex As Exception
                Throw New SqlCommandException(cmd, ex)
            End Try
        End Function

        Friend Function ExecuteReader(ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As IDataReader
            Try
                cmd.CommandTimeout = Config.SqlTimeout
                Return DataMartDb.ExecuteReader(cmd, transaction)
            Catch ex As Exception
                Throw New SqlCommandException(cmd, ex)
            End Try
        End Function

        Friend Function ExecuteDataSet(ByVal cmd As DbCommand) As DataSet
            Try
                cmd.CommandTimeout = Config.SqlTimeout
                Return DataMartDb.ExecuteDataSet(cmd)
            Catch ex As Exception
                Throw New SqlCommandException(cmd, ex)
            End Try
        End Function

        Friend Function ExecuteDataSet(ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As DataSet
            Try
                cmd.CommandTimeout = Config.SqlTimeout
                Return DataMartDb.ExecuteDataSet(cmd, transaction)
            Catch ex As Exception
                Throw New SqlCommandException(cmd, ex)
            End Try
        End Function

        Friend Sub ExecuteNonQuery(ByVal cmd As DbCommand)
            Try
                cmd.CommandTimeout = Config.SqlTimeout
                DataMartDb.ExecuteNonQuery(cmd)
            Catch ex As Exception
                Throw New SqlCommandException(cmd, ex)
            End Try
        End Sub

        Friend Sub ExecuteNonQuery(ByVal cmd As DbCommand, ByVal transaction As DbTransaction)
            Try
                cmd.CommandTimeout = Config.SqlTimeout
                DataMartDb.ExecuteNonQuery(cmd, transaction)
            Catch ex As Exception
                Throw New SqlCommandException(cmd, ex)
            End Try
        End Sub

        Friend Function ExecuteScalar(ByVal cmd As DbCommand) As Object
            Try
                cmd.CommandTimeout = Config.SqlTimeout
                Return DataMartDb.ExecuteScalar(cmd)
            Catch ex As Exception
                Throw New SqlCommandException(cmd, ex)
            End Try
        End Function

        Friend Function ExecuteScalar(ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As Object
            Try
                cmd.CommandTimeout = Config.SqlTimeout
                Return DataMartDb.ExecuteScalar(cmd, transaction)
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

        Friend Function GetNullableParam(Of T As Structure)(ByVal paramValue As Nullable(Of T)) As Object
            If paramValue.HasValue Then
                Return paramValue.Value
            Else
                Return DBNull.Value
            End If
        End Function

#End Region

    End Module

End Namespace
