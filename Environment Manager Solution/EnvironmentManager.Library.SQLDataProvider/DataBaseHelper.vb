Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data
Imports NRC.Framework.BusinessLogic
Imports NRC.Framework.BusinessLogic.Configuration

Module DatabaseHelper
    Private mDBInstance As Database = Nothing
    Friend Delegate Function FillMethod(Of T)(ByVal rdr As SafeDataReader) As T

    Dim mQualisysConnectionString As String
    Friend Property QualisysConnectionString() As String
        Get
            Return mQualisysConnectionString
        End Get
        Set(ByVal value As String)
            If Not String.Equals(mQualisysConnectionString, value, StringComparison.CurrentCultureIgnoreCase) Then
                'This will allow to use the same Database object if the connection string didn't change.
                mDBInstance = Nothing
                mQualisysConnectionString = value
            End If
        End Set
    End Property

    Friend ReadOnly Property Db() As Database
        Get
            If mDBInstance Is Nothing Then
                mDBInstance = New Sql.SqlDatabase(QualisysConnectionString)
            End If
            Return mDBInstance
        End Get
    End Property

#Region " Helper Functions "

    Friend Function ExecuteReader(ByVal cmd As DbCommand) As IDataReader
        Try
            cmd.CommandTimeout = 600
            Return Db.ExecuteReader(cmd)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Function ExecuteReader(ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As IDataReader
        Try
            cmd.CommandTimeout = 600
            Return Db.ExecuteReader(cmd, transaction)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Function ExecuteDataSet(ByVal cmd As DbCommand) As DataSet
        Try
            cmd.CommandTimeout = 600
            Return Db.ExecuteDataSet(cmd)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Function ExecuteDataSet(ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As DataSet
        Try
            cmd.CommandTimeout = 600
            Return Db.ExecuteDataSet(cmd, transaction)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Sub ExecuteNonQuery(ByVal cmd As DbCommand)
        Try
            cmd.CommandTimeout = 600
            Db.ExecuteNonQuery(cmd)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Sub

    Friend Sub ExecuteNonQuery(ByVal cmd As DbCommand, ByVal transaction As DbTransaction)
        Try
            cmd.CommandTimeout = 600
            Db.ExecuteNonQuery(cmd, transaction)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Sub

    Friend Function ExecuteScalar(ByVal cmd As DbCommand) As Object
        Try
            cmd.CommandTimeout = 600
            Return Db.ExecuteScalar(cmd)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Function ExecuteScalar(ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As Object
        Try
            cmd.CommandTimeout = 600
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
    Friend Function PopulateCollection(Of C As {BusinessListBase(Of C, T), New}, _
                                 T As BusinessBase(Of T))(ByVal rdr As SafeDataReader, _
                                 ByVal populateMethod As FillMethod(Of T)) As C
        Dim list As New C
        While rdr.Read
            list.Add(populateMethod(rdr))
        End While

        Return list
    End Function

    Friend Function GetNullableParam(Of T As Structure)(ByVal paramValue As Nullable(Of T)) As Object
        If paramValue.HasValue Then
            Return paramValue.Value
        Else
            Return DBNull.Value
        End If
    End Function

    Friend Function GetStringValue(Of T As Structure)(ByVal paramValue As Nullable(Of T)) As String
        If paramValue.HasValue Then
            Return String.Format("'{0}'", paramValue.Value)
        Else
            Return "NULL"
        End If
    End Function
#End Region
End Module

