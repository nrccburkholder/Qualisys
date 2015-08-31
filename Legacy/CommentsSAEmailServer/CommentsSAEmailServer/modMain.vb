Imports Microsoft.VisualBasic.CompilerServices
Imports Microsoft.Win32
Imports System
Imports System.IO
Imports System.Windows.Forms

Namespace CommentsSAEmailServer
    <StandardModule> _
    Friend NotInheritable Class modMain
        ' Methods
        Friend Shared Function GetSQLConnectString(ByVal strApplication As String) As String
            Dim str2 As String
            Dim str3 As String
            Dim sLeft As String = strApplication.ToUpper
            If (StringType.StrCmp(sLeft, "COMMENTS", False) = 0) Then
                str3 = "Data Source=Medusa;UID=comments;PWD=821matt;Initial Catalog=QP_Comments"
            ElseIf (StringType.StrCmp(sLeft, "WEBACCOUNTS", False) = 0) Then
                str3 = "Data Source=Mercury;UID=qpsa;PWD=qpsa;Initial Catalog=WebAccounts"
            End If
            Try 
                str2 = StringType.FromObject(Registry.LocalMachine.OpenSubKey(("Software\National Research\" & strApplication)).GetValue("SQL Connect String", str3))
            Catch exception1 As Exception
                ProjectData.SetProjectError(exception1)
                str2 = str3
                ProjectData.ClearProjectError
            End Try
            Return str2
        End Function

        Private Shared Function IsLoggingEnabled() As Boolean
            Dim defaultValue As String = "no"
            If (StringType.StrCmp(modMain.gstrLoggingEnabled, String.Empty, False) = 0) Then
                Try 
                    modMain.gstrLoggingEnabled = StringType.FromObject(Registry.LocalMachine.OpenSubKey("Software\National Research\Comments").GetValue("Logging Enabled", defaultValue))
                Catch exception1 As Exception
                    ProjectData.SetProjectError(exception1)
                    modMain.gstrLoggingEnabled = defaultValue
                    ProjectData.ClearProjectError
                End Try
            End If
            Return (StringType.StrCmp(modMain.gstrLoggingEnabled.ToUpper, "YES", False) = 0)
        End Function

        Public Shared Sub WriteLogEntry(ByVal message As String)
            If modMain.IsLoggingEnabled Then
                Dim writer As StreamWriter = New FileInfo(Path.Combine(Application.StartupPath, (DateTime.Now.ToString("yyyy-MM-dd") & ".log"))).AppendText
                writer.WriteLine((DateTime.Now.ToString("HH:mm:ss") & " - " & message))
                writer.Flush
                writer.Close
            End If
        End Sub


        ' Fields
        Public Shared gobjEmailEntries As clsEmailEntries
        Public Shared gobjLogEntries As clsEmailEntries
        Public Shared gstrLoggingEnabled As String = String.Empty
    End Class
End Namespace

