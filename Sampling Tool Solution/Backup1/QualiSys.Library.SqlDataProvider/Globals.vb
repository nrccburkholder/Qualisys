Imports System.Collections.ObjectModel
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic.Configuration

<HideModuleName()> _
Module Globals

    Friend Delegate Function FillMethod(Of T)(ByVal rdr As SafeDataReader) As T
    Private mDbInstance As Database = Nothing
    Private mLegacyConnection As IDbConnection

    Friend ReadOnly Property Db() As Database
        Get
            If mDbInstance Is Nothing Then
                mDbInstance = New Sql.SqlDatabase(AppConfig.QualisysConnection)
            End If

            Return mDbInstance
        End Get
    End Property

#Region " Helper Functions "

    Friend Function ExecuteReader(ByVal cmd As DBCommand) As IDataReader
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

    Friend Sub ExecuteNonQuery(ByVal cmd As DbCommand)
        Try
            cmd.CommandTimeout = AppConfig.SqlTimeout
            Db.ExecuteNonQuery(cmd)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Sub

    Friend Sub ExecuteNonQuery(ByVal cmd As DbCommand, ByVal transaction As DbTransaction)
        Try
            cmd.CommandTimeout = AppConfig.SqlTimeout
            Db.ExecuteNonQuery(cmd, transaction)
        Catch ex As Exception
            Throw New SqlCommandException(cmd, ex)
        End Try
    End Sub

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

    ''' <summary>Need a scalar value that returns a decmial.</summary>
    ''' <param name="cmd"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Friend Function ExecuteDecimal(ByVal cmd As DbCommand) As Decimal
        Return CType(ExecuteScalar(cmd), Decimal)
    End Function

    Friend Function ExecuteBoolean(ByVal cmd As DbCommand) As Boolean
        Return CType(ExecuteScalar(cmd), Boolean)
    End Function

    Friend Function ExecuteBoolean(ByVal cmd As DbCommand, ByVal transaction As DbTransaction) As Boolean
        Return CType(ExecuteScalar(cmd, transaction), Boolean)
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
