Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Public Class Log
    Private Shared mDatabase As Database

#Region " Public Property "
    Private Shared ReadOnly Property Db() As Database
        Get
            If mDatabase Is Nothing Then
                mDatabase = New Sql.SqlDatabase(Config.QualisysConnection)
            End If

            Return mDatabase
        End Get
    End Property
#End Region

#Region " Constructors "
    Public Sub New()

    End Sub
    Public Sub New(ByVal logType As String, ByVal cmd As DbCommand)
        Me.Add(logType, cmd)
    End Sub
    Public Sub New(ByVal logType As String, ByVal logText As String)
        Me.Add(logType, logText)
    End Sub
#End Region

#Region " Public Methods "

    ''' <summary>Adds new entry to QDELog table via Proc</summary>
    ''' <param name="logType"></param>
    ''' <author>Steve Kennedy</author>
    ''' <revision>SK 09/24/2008 - Initial Creation</revision>
    Public Sub Add(ByVal logType As String, ByVal cmd As DbCommand)
        If Config.IsLoggingOn Then
            Dim logText As String = String.Empty
            Try
                'Store the Proc Name, and Parameters in a delimited string, in a new string
                logText = cmd.CommandText & " " 'proc name and space
                For Each parameter As SqlClient.SqlParameter In cmd.Parameters
                    'Do not try to log output or return value parameters
                    If parameter.Direction = ParameterDirection.Input Then
                        Select Case parameter.SqlDbType
                            Case SqlDbType.Int
                                logText += Str(parameter.Value) & ", "
                            Case Else
                                logText += parameter.Value.ToString & ", "
                        End Select
                    End If
                Next
                'Add Actual Proc name and remove last delimeter and space
                'but only if there were parameters added to the end of the string
                'Remember that the cmd object already has 1 parameter for the return value
                If cmd.Parameters.Count > 1 Then logText = Left(logText, logText.Length - 2)
            Catch ex As Exception
                logText = "Error while adding log entry: " & ex.Message.ToString
            End Try

            'Log that string, along with username and log type to QDELog via Proc
            Dim LogCmd As DbCommand = Db.GetStoredProcCommand("SP_QDE_LogEvent", Environment.UserName, logType, logText)
            LogCmd.CommandTimeout = Config.SqlTimeout
            Db.ExecuteNonQuery(LogCmd)
        End If
    End Sub

    ''' <summary>Adds new entry to QDELog table via Proc</summary>
    ''' <param name="logType"></param>
    ''' <author>Steve Kennedy</author>
    ''' <revision>SK 09/24/2008 - Initial Creation</revision>
    Public Sub Add(ByVal logType As String, ByVal logText As String)
        If Config.IsLoggingOn Then
            'Log that string, along with username and log type to QDELog via Proc
            Dim LogCmd As DbCommand = Db.GetStoredProcCommand("SP_QDE_LogEvent", Environment.UserName, logType, logText)
            LogCmd.CommandTimeout = Config.SqlTimeout
            Db.ExecuteNonQuery(LogCmd)
        End If
    End Sub


#End Region

End Class


