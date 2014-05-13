Imports System.Collections.ObjectModel
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports Nrc.Framework.Data

<HideModuleName()> _
Module DatabaseHelper

    Friend Delegate Function FillMethod(Of T)(ByVal rdr As SafeDataReader) As T
    Private mDataMartDbInstance As Database = Nothing
    Private mRscmDbInstance As Database = Nothing
    Private mNrcAuthDbInstance As Database = Nothing
    Private mIndexDbInstance As Database = Nothing

    Private mLegacyConnection As IDbConnection

    Friend ReadOnly Property DataMartDb() As Database
        Get
            If mDataMartDbInstance Is Nothing Then
                mDataMartDbInstance = New Sql.SqlDatabase(Config.DataMartConnection)
            End If

            Return mDataMartDbInstance
        End Get
    End Property
    Friend ReadOnly Property RscmDb() As Database
        Get
            If mRscmDbInstance Is Nothing Then
                mRscmDbInstance = New Sql.SqlDatabase(Config.RscmConnection)
            End If

            Return mRscmDbInstance
        End Get
    End Property

    Friend ReadOnly Property NrcAuthDb() As Database
        Get
            If mNrcAuthDbInstance Is Nothing Then
                mNrcAuthDbInstance = New Sql.SqlDatabase(Config.NrcAuthConnection)
            End If

            Return mNrcAuthDbInstance
        End Get
    End Property

    Friend ReadOnly Property IndexDb() As Database
        Get
            If mIndexDbInstance Is Nothing Then
                mIndexDbInstance = New OleDb.OleDbDatabase(Config.IndexConnection)
            End If
            Return mIndexDbInstance
        End Get
    End Property

#Region " Helper Functions "

    Friend Function UpdateDataSet(ByVal db As Database, ByVal dataSet As System.Data.DataSet, ByVal tableName As String, ByVal insertCommand As DbCommand, ByVal updateCommand As DbCommand, ByVal deleteCommand As DbCommand, ByVal updateBehavior As UpdateBehavior) As Integer
        Try
            If insertCommand IsNot Nothing Then insertCommand.CommandTimeout = Config.SqlTimeout
            If updateCommand IsNot Nothing Then updateCommand.CommandTimeout = Config.SqlTimeout
            If deleteCommand IsNot Nothing Then deleteCommand.CommandTimeout = Config.SqlTimeout
            Return db.UpdateDataSet(dataSet, tableName, insertCommand, updateCommand, deleteCommand, updateBehavior)
        Catch ex As Exception
            Throw New SqlCommandException(insertCommand, ex)
        End Try
    End Function

    Friend Function ExecuteReader(ByVal db As Database, ByVal cmd As DbCommand) As IDataReader
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Return db.ExecuteReader(cmd)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Function ExecuteReader(ByVal db As Database, ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As IDataReader
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Return db.ExecuteReader(cmd, transaction)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Function ExecuteDataSet(ByVal db As Database, ByVal cmd As DbCommand) As DataSet
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Return db.ExecuteDataSet(cmd)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Function ExecuteDataSet(ByVal db As Database, ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As DataSet
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Return db.ExecuteDataSet(cmd, transaction)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Sub ExecuteNonQuery(ByVal db As Database, ByVal cmd As DbCommand)
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            db.ExecuteNonQuery(cmd)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Sub

    Friend Sub ExecuteNonQuery(ByVal db As Database, ByVal cmd As DbCommand, ByVal transaction As DbTransaction)
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            db.ExecuteNonQuery(cmd, transaction)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Sub

    Friend Function ExecuteScalar(ByVal db As Database, ByVal cmd As DbCommand) As Object
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Return db.ExecuteScalar(cmd)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Function

    Friend Function ExecuteScalar(ByVal db As Database, ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As Object
        Try
            cmd.CommandTimeout = Config.SqlTimeout
            Return db.ExecuteScalar(cmd, transaction)
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


    Friend Function PopulateList(Of C As {System.ComponentModel.BindingList(Of T), New}, T)(ByVal rdr As SafeDataReader, ByVal populateMethod As FillMethod(Of T)) As C
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
