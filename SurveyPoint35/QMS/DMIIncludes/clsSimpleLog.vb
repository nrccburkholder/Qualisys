Imports System.IO

Public Class clsSimpleLog

    Private _FileInfo As FileInfo
    Private _LogFilename As String

    Public Sub New(ByVal sLogFilename As String)
        _LogFilename = sLogFilename
    End Sub

    Public ReadOnly Property LogFile() As FileInfo
        Get
            If IsNothing(_FileInfo) Then
                _FileInfo = New FileInfo(_LogFilename)
            End If
            Return _FileInfo
        End Get
    End Property

    Public Sub Log(ByVal sMsg As String)
        Dim sw As StreamWriter

        Try
            sw = New StreamWriter(LogFile.FullName, True)
            sw.WriteLine("{0:d} {0:t} - {1}", DateTime.Now, sMsg)
        Catch ex As Exception
            'do nothing
        Finally
            If Not IsNothing(sw) Then sw.Close()
        End Try

    End Sub

    Public Sub Log(ByVal sMsg As String, ByVal e As Exception)
        Dim sw As StreamWriter

        Try
            sw = LogFile.CreateText()
            sw.WriteLine("{0:d} {0:t} - {1}", DateTime.Now, sMsg)
            sw.WriteLine(e.Message)
            sw.WriteLine(e.Source)
            sw.WriteLine(e.StackTrace)
        Catch ex As Exception
            'do nothing
        Finally
            If Not IsNothing(sw) Then sw.Close()
        End Try

    End Sub

End Class
