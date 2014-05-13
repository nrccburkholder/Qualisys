Imports System.Collections.ObjectModel
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports Nrc.Framework.Data

<HideModuleName()> _
Module Globals

    Friend Delegate Function FillMethod(Of T)(ByVal rdr As SafeDataReader) As T
    Private mQP_CommentsDbInstance As Database = Nothing
    Private mNRCAuthDbInstance As Database = Nothing
    Private mLegacyConnection As IDbConnection

    Friend ReadOnly Property QP_CommentsDb() As Database
        Get
            If mQP_CommentsDbInstance Is Nothing Then
                mQP_CommentsDbInstance = New Sql.SqlDatabase(Config.QP_CommentsConnection)
            End If

            Return mQP_CommentsDbInstance
        End Get
    End Property

    Friend ReadOnly Property NRCAuthDb() As Database
        Get
            If mNRCAuthDbInstance Is Nothing Then
                mNRCAuthDbInstance = New Sql.SqlDatabase(Config.NRCAuthConnection)
            End If

            Return mNRCAuthDbInstance
        End Get
    End Property

#Region " Helper Functions "

    Friend Function ExecuteReader(ByVal db As Database, ByVal cmd As DbCommand) As IDataReader
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Return Db.ExecuteReader(cmd)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Function ExecuteReader(ByVal db As Database, ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As IDataReader
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Return Db.ExecuteReader(cmd, transaction)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Function ExecuteDataSet(ByVal db As Database, ByVal cmd As DbCommand) As DataSet
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Return Db.ExecuteDataSet(cmd)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Function ExecuteDataSet(ByVal db As Database, ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As DataSet
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Return Db.ExecuteDataSet(cmd, transaction)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Sub ExecuteNonQuery(ByVal db As Database, ByVal cmd As DbCommand)
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Db.ExecuteNonQuery(cmd)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Sub

    Friend Sub ExecuteNonQuery(ByVal db As Database, ByVal cmd As DbCommand, ByVal transaction As DbTransaction)
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Db.ExecuteNonQuery(cmd, transaction)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Sub

    Friend Function ExecuteScalar(ByVal db As Database, ByVal cmd As DbCommand) As Object
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Return Db.ExecuteScalar(cmd)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Function ExecuteScalar(ByVal db As Database, ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As Object
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Return Db.ExecuteScalar(cmd, transaction)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Function ExecuteInteger(ByVal db As Database, ByVal cmd As DbCommand) As Integer
        Return CType(ExecuteScalar(db, cmd), Integer)
    End Function

    Friend Function ExecuteInteger(ByVal db As Database, ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As Integer
        Return CType(ExecuteScalar(db, cmd, transaction), Integer)
    End Function

    Friend Function ExecuteBoolean(ByVal db As Database, ByVal cmd As DbCommand) As Boolean
        Return CType(ExecuteScalar(db, cmd), Boolean)
    End Function

    Friend Function ExecuteBoolean(ByVal db As Database, ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As Boolean
        Return CType(ExecuteScalar(db, cmd, transaction), Boolean)
    End Function

    Friend Class SqlCommandBuilder
        Private mSql As String
        Sub New()
            mSql = ""
        End Sub

        Public Sub AddLine(ByVal sql As String)
            mSql &= sql & Environment.NewLine
        End Sub
        Public Sub AddLine(ByVal sql As String, ByVal ParamArray args() As Object)
            mSql &= String.Format(sql, args) & Environment.NewLine
        End Sub

        Public Overrides Function ToString() As String
            Return mSql
        End Function
    End Class

    Friend Function PopulateCollection(Of T)(ByVal rdr As SafeDataReader, ByVal populateMethod As FillMethod(Of T)) As Collection(Of T)
        Dim list As New Collection(Of T)
        While rdr.Read
            list.Add(populateMethod(rdr))
        End While

        Return list
    End Function

    Friend Function PopulateCollection(Of C As {System.ComponentModel.BindingList(Of T), New}, T)(ByVal rdr As SafeDataReader, ByVal populateMethod As FillMethod(Of T)) As C
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

#End Region

End Module
