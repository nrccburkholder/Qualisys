Imports System
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient


Namespace ODSDBDataAccess

    Public Class BaseSqlDataProvider
        Implements IDisposable



#Region "private members"

        Private _sqlDA As SqlDataAdapter
        Private _sqlConn As SqlConnection
        Private _sqlComm As SqlCommand
        Private _sqlTrans As SqlTransaction
        Private _commandTimeout As Integer = 0
        Private _currentConnectionString As String
        Protected disposed As Boolean = False


#End Region

#Region "properties"

        Private ReadOnly Property ConnectionString() As String
            Get
                Return _currentConnectionString
            End Get
        End Property

        Public Property CommandTimeOut() As Integer
            Get
                Return _commandTimeout
            End Get
            Set(value As Integer)
                _commandTimeout = value
            End Set
        End Property


#End Region

#Region "constructors"


        Public Sub New(ByVal connString As String)

            _currentConnectionString = connString

        End Sub


#End Region

#Region "public methods"

#Region "ExecuteScalar"

        Protected Function ExecuteScalar(ByVal commandText As String, ByVal commType As CommandType) As Object
            Return ExecuteScalar(commandText, commType, New SqlParameter() {})
        End Function

        Protected Function ExecuteScalar(ByVal commandText As String, ByVal commType As CommandType, ByVal param As SqlParameter()) As Object

            Dim oScalarVal As Object

            ResetDAOs()
            CreateConnection(ConnectionString)
            ValidateCommand(commandText)

            Try
                _sqlComm = New SqlCommand()
                _sqlComm.CommandText = commandText
                _sqlComm.CommandType = commType
                _sqlComm.CommandTimeout = _commandTimeout
                _sqlComm.Connection = _sqlConn

                If _sqlTrans IsNot Nothing Then
                    _sqlComm.Transaction = _sqlTrans
                End If

                For Each tempParam As SqlParameter In param
                    _sqlComm.Parameters.Add(tempParam)
                Next

                If _sqlConn.State <> ConnectionState.Open Then
                    _sqlConn.Open()
                End If

                oScalarVal = _sqlComm.ExecuteScalar()
                Return oScalarVal

            Catch ex As Exception
                _sqlConn.Close()
                Throw ex
            End Try

        End Function

#End Region

#Region "ExecuteReader"

        Protected Function ExecuteReader(ByVal commandText As String, ByVal commType As CommandType) As SqlDataReader

            Return ExecuteReader(commandText, commType, CommandBehavior.Default, New SqlParameter() {})

        End Function


        Protected Function ExecuteReader(ByVal commandText As String, ByVal commType As CommandType, ByVal commBehavior As CommandBehavior, ByVal param As SqlParameter()) As SqlDataReader

            Dim drReturn As SqlDataReader
            ResetDAOs()
            CreateConnection(ConnectionString)
            ValidateCommand(commandText)

            Try
                _sqlComm = New SqlCommand()
                _sqlComm.CommandText = commandText
                _sqlComm.CommandType = commType
                _sqlComm.CommandTimeout = _commandTimeout
                _sqlComm.Connection = _sqlConn

                If _sqlTrans IsNot Nothing Then
                    _sqlComm.Transaction = _sqlTrans
                End If

                For Each tempParam As SqlParameter In param
                    _sqlComm.Parameters.Add(tempParam)
                Next

                If _sqlConn.State <> ConnectionState.Open Then
                    _sqlConn.Open()
                End If

                drReturn = _sqlComm.ExecuteReader(commBehavior)
                Return drReturn

            Catch ex As Exception
                _sqlConn.Close()
                Throw ex
            End Try

        End Function


#End Region



#Region "Adapter Fill"

        Protected Function Fill(ByRef dt As DataTable, ByVal commandText As String, ByVal commType As CommandType) As Integer
            ResetDAOs()
            CreateConnection(ConnectionString)
            ValidateCommand(commandText)

            If dt Is Nothing Then
                dt = New DataTable()
            End If

            Try
                _sqlComm = New SqlCommand()
                _sqlComm.CommandText = commandText
                _sqlComm.CommandType = commType
                _sqlComm.CommandTimeout = _commandTimeout
                _sqlComm.Connection = _sqlConn

                If _sqlTrans IsNot Nothing Then
                    _sqlComm.Transaction = _sqlTrans
                End If

                If _sqlConn.State <> ConnectionState.Open Then
                    _sqlConn.Open()
                End If

                _sqlDA = New SqlDataAdapter(_sqlComm)
                Return _sqlDA.Fill(dt)

            Catch ex As Exception
                Throw ex
            Finally

            End Try
        End Function

        Protected Function Fill(ByRef dt As DataTable, ByVal commandText As String, ByVal commType As CommandType, ByVal param As SqlParameter()) As Integer
            ResetDAOs()
            CreateConnection(ConnectionString)
            ValidateCommand(commandText)

            If dt Is Nothing Then
                dt = New DataTable()
            End If

            Try
                _sqlComm = New SqlCommand()
                _sqlComm.CommandText = commandText
                _sqlComm.CommandType = commType
                _sqlComm.CommandTimeout = _commandTimeout
                _sqlComm.Connection = _sqlConn

                If _sqlTrans IsNot Nothing Then
                    _sqlComm.Transaction = _sqlTrans
                End If

                For Each tempParam As SqlParameter In param
                    _sqlComm.Parameters.Add(tempParam)
                Next

                If _sqlConn.State <> ConnectionState.Open Then
                    _sqlConn.Open()
                End If

                _sqlDA = New SqlDataAdapter(_sqlComm)
                Return _sqlDA.Fill(dt)

            Catch ex As Exception
                Throw ex
            Finally

            End Try
        End Function

#End Region

#End Region

#Region "private methods"

        Private Sub CreateConnection(ByVal connectionString As String)
            If _sqlConn IsNot Nothing Then
                If _currentConnectionString <> connectionString Then
                    If _sqlConn.State <> ConnectionState.Closed Then
                        If _sqlTrans IsNot Nothing Then
                            _sqlTrans.Dispose()
                        End If
                        _sqlConn.Close()
                        _sqlConn.Dispose()
                    End If
                    _sqlConn = New SqlConnection(connectionString)
                    _currentConnectionString = connectionString
                End If
            Else
                _sqlConn = New SqlConnection(connectionString)
                _currentConnectionString = connectionString
            End If
        End Sub

        Private Sub ResetDAOs()
            If _sqlComm IsNot Nothing Then
                _sqlComm.Parameters.Clear()
                _sqlComm.Dispose()
            End If
            If _sqlDA IsNot Nothing Then
                _sqlDA.Dispose()
            End If
        End Sub

        Private Sub ValidateCommand(ByVal commandText As String)
            If commandText = String.Empty Then
                Throw New ArgumentNullException("Empty Command Text")
            End If

        End Sub

#End Region


#Region "IDisposable and Deconstructor"
        ' Do not change or add Overridable to these methods. 
        ' Put cleanup code in Dispose(ByVal disposing As Boolean). 
        Public Overloads Sub Dispose() Implements IDisposable.Dispose
            Dispose(True)
            GC.SuppressFinalize(Me)
        End Sub

        Protected Overrides Sub Finalize()
            Dispose(False)
            MyBase.Finalize()
        End Sub

        Protected Overridable Overloads Sub Dispose( _
                ByVal disposing As Boolean)
            If Not Me.disposed Then
                If disposing Then
                    If _sqlConn IsNot Nothing Then
                        If _sqlConn.State <> ConnectionState.Closed Then
                            _sqlConn.Close()
                        End If
                    End If
                    If _sqlConn IsNot Nothing Then
                        _sqlConn.Dispose()
                    End If
                    If _sqlComm IsNot Nothing Then
                        _sqlComm.Dispose()
                    End If
                End If

            End If
            Me.disposed = True
        End Sub

#End Region

    End Class

End Namespace