'********************************************************************'
' Created by Tom D. - Date unknown
' 
' Auggur - Added functionality to limit the size of the file to 1mb
' Elibad - Added overloads to the Write trace to accept write the details of an exception
'          and inner exception details, also created a TraceFlag property
' Elibad - 07/09/2009 Cleaned up a lot of repeated code, reorganize 
'
'  This class provides support to create log files with a size limit of 1mb
'*********************************************************************
Namespace Miscellaneous
    Public Class Tracer
#Region "Private variables"

        Private _TracePath As String = ""
        Private _ErrorPath As String = ""
        Private _TraceFlag As Boolean = False

#End Region

#Region "Public Properties"

        Public Property TraceFlag() As Boolean
            Get
                Return _TraceFlag
            End Get
            Set(ByVal value As Boolean)
                _TraceFlag = value
            End Set
        End Property

        Public Property FileName() As String
            Get
                Return _TracePath
            End Get
            Set(ByVal value As String)
                If Not System.IO.File.Exists(value) Then
                    Try
                        My.Computer.FileSystem.WriteAllText(value, "", True)
                        Kill(value)
                    Catch ex As Exception
                        Throw New System.Exception("Invalid FileName for LogFile", ex)
                    End Try
                End If
                _TracePath = value
            End Set
        End Property

        Public Property ErrorFileName() As String
            Get
                Return _ErrorPath
            End Get
            Set(ByVal value As String)
                If Not System.IO.File.Exists(value) Then
                    Try
                        My.Computer.FileSystem.WriteAllText(value, "", True)
                        Kill(value)
                    Catch ex As Exception
                        Throw New System.Exception("Invalid FileName for ErrorLog", ex)
                    End Try
                End If
                _ErrorPath = value
            End Set
        End Property

#End Region

#Region "Construtors"

        Public Sub New()
            Me.New(My.Application.Info.DirectoryPath & "\Trace.Log")
        End Sub

        Public Sub New(ByVal LogFile As String)
            Me.New(LogFile, System.IO.Path.GetDirectoryName(LogFile) & "\Trace_Errors.Log")
        End Sub

        Public Sub New(ByVal LogFile As String, ByVal ErrorFile As String)
            If Not Security.ValidateKey Then
                Throw New System.Exception("Not valid Security Key, Please provide a valid Security Key using the security class")
            End If

            Me.FileName = LogFile
            Me.ErrorFileName = ErrorFile
        End Sub

#End Region

        Public Sub CreateLineDivision()
            CreateLineDivision(_TraceFlag)
        End Sub

        Public Sub CreateLineDivision(ByVal TempTraceFlag As Boolean)
            CreateLineDivision(_TracePath, TempTraceFlag)
        End Sub

        Public Sub WriteTrace(ByVal TempTraceFlag As Boolean, ByVal Msg As String, ByVal Exception As System.Exception)
            WriteTrace(_TracePath, TempTraceFlag, Msg, Exception)
        End Sub

        Public Sub WriteTrace(ByVal TempTraceFlag As Boolean, ByVal Msg As String)
            WriteTrace(TempTraceFlag, Msg, Nothing)
        End Sub

        Public Sub WriteTrace(ByVal TempTraceFlag As Boolean, ByVal Exception As System.Exception)
            WriteTrace(TempTraceFlag, Nothing, Exception)
        End Sub

        Public Sub WriteTrace(ByVal Msg As String)
            WriteTrace(_TraceFlag, Msg)
        End Sub

        Public Sub WriteTrace(ByVal Exception As System.Exception)
            WriteTrace(_TraceFlag, Exception)
        End Sub

        Public Sub WriteTrace(ByVal Msg As String, ByVal Exception As System.Exception)
            WriteTrace(_TraceFlag, Msg, Exception)
        End Sub

        'Error methods
        Public Sub WriteError(ByVal TempTraceFlag As Boolean, ByVal Msg As String, ByVal Exception As System.Exception)
            WriteTrace(_ErrorPath, TempTraceFlag, Msg, Exception)
        End Sub

        Public Sub WriteError(ByVal TempTraceFlag As Boolean, ByVal Msg As String)
            WriteError(TempTraceFlag, Msg, Nothing)
        End Sub

        Public Sub WriteError(ByVal TempTraceFlag As Boolean, ByVal Exception As System.Exception)
            WriteError(TempTraceFlag, Nothing, Exception)
        End Sub

        Public Sub WriteError(ByVal Msg As String)
            WriteError(_TraceFlag, Msg)
        End Sub

        Public Sub WriteError(ByVal Exception As System.Exception)
            WriteError(_TraceFlag, Exception)
        End Sub

        Public Sub WriteError(ByVal Msg As String, ByVal Exception As System.Exception)
            WriteError(_TraceFlag, Msg, Exception)
        End Sub

#Region "Private Methods"

        Private Sub WriteLine(ByVal FileName As String, ByVal Msg As String, Optional ByVal WriteTimeStamp As Boolean = True)
            Dim sExtraText As String = ""
            '### auggur 10/13/2006 added check to see if the message passed has a newline
            'character at the end if it does then write to file as is if not then add it.

            If WriteTimeStamp Then
                sExtraText = "               Time: " & Now()
            End If

            If Right(Msg, 1) = vbCrLf _
                OrElse Right(Msg, 1) = vbCr _
                OrElse Right(Msg, 1) = vbLf Then

                Msg = Left(Msg, Msg.Length - 1)
            End If

            My.Computer.FileSystem.WriteAllText(FileName, Msg & sExtraText & vbCrLf, True)
        End Sub

        Private Sub VerifyFileSize(ByVal FileName As String, Optional ByVal SizeMB As Integer = 1)
            Dim sr As System.IO.StreamReader
            Dim StrArray() As String
            Dim sFileData As String
            Dim realFileSize As Double
            '_TracePath = My.Application.Info.DirectoryPath & "\Trace.Log"

            '### auggur 09/22/2006 only perform file size chekc if file exists.
            If My.Computer.FileSystem.FileExists(FileName) = True Then
                '### auggur 09/08/2006 get the file size in bytes and do math to get it to Megabites
                realFileSize = My.Computer.FileSystem.GetFileInfo(FileName).Length
                realFileSize = realFileSize / 1024 'KB'S
                realFileSize = realFileSize / 1024 'MBS
                '### auggur 09/08/2006added check for file size in order to limit 
                'it's growth to only one megabyte 
                If (realFileSize) > SizeMB Then
                    'read the file into array
                    sr = System.IO.File.OpenText(FileName)
                    'string = contents of file
                    sFileData = sr.ReadToEnd
                    'close stream
                    sr.Close()
                    'eliminate data at the begining of the string(old data)
                    sFileData = sFileData.Substring(CInt(sFileData.Length * 0.25), (sFileData.Length - CInt(sFileData.Length * 0.25)))
                    'fill array with data
                    StrArray = Split(sFileData, ControlChars.NewLine)
                    'drop the old file
                    Kill(FileName)
                    'write the truncated array to the file
                    System.IO.File.WriteAllLines(FileName, StrArray)
                End If
            End If

        End Sub

        Private Sub CreateLineDivision(ByVal FileName As String, ByVal TempTraceFlag As Boolean)
            If TempTraceFlag Then
                My.Computer.FileSystem.WriteAllText(FileName, "-----------------------------------------------------------------------------" & vbCrLf, True)
            End If
        End Sub

        Private Sub WriteException(ByVal FileName As String, ByVal Exception As System.Exception)

            Try
                VerifyFileSize(FileName)
                CreateLineDivision()
                WriteLine(FileName, "Exception.Message: " & Exception.Message, True)
                WriteLine(FileName, "Exception.Source: " & Exception.Source, False)
                WriteLine(FileName, "Exception.StackTrace: " & Exception.StackTrace, False)

                'write out any data related to the exception
                If Exception.Data.Count > 0 Then
                    WriteLine(FileName, "Exception.Data: ", False)
                    For Each de As DictionaryEntry In Exception.Data()
                        WriteLine(FileName, "     " & de.Key().ToString() & " ... " & de.Value().ToString(), False)
                    Next
                End If

                Dim iEx As System.Exception = Exception.InnerException

                Do While iEx IsNot Nothing
                    CreateLineDivision()
                    WriteLine(FileName, "Inner Exception.Message: " & Exception.InnerException.Message, False)
                    WriteLine(FileName, "Inner Exception.StackTrace: " & Exception.InnerException.StackTrace, False)
                    iEx = iEx.InnerException
                Loop

                CreateLineDivision()
            Catch ex As Exception
                'since this is an error resizing or writing to the trace log just create
                ' and write to a new file.
                Try
                    My.Computer.FileSystem.WriteAllText(My.Application.Info.DirectoryPath & "\Trace-ERROR-Ocurred.err" _
                                    , "ERROR: 2000 - Error trying to write to trace file at: " & FileName & " : Time:" & Now() & " : " & ex.Message & vbCrLf _
                                    , True)
                Catch ex2 As Exception

                End Try

            End Try
        End Sub

        Private Sub WriteTrace(ByVal FileName As String, ByVal TempTraceFlag As Boolean, ByVal Msg As String, ByVal Exception As System.Exception)
            Try
                'Me._TraceFlag = TraceFlag
                If TempTraceFlag Then
                    VerifyFileSize(FileName)
                    If Msg IsNot Nothing AndAlso Msg <> "" Then
                        WriteLine(FileName, Msg)
                    End If
                    If Exception IsNot Nothing Then
                        WriteException(FileName, Exception)
                    End If
                End If
            Catch ex As Exception
                'since this is an error resizing or writing to the trace log just create
                ' and write to a new file.
                Try
                    My.Computer.FileSystem.WriteAllText(My.Application.Info.DirectoryPath & "\Trace-ERROR-Ocurred.err" _
                                    , "ERROR: 2000 - Error trying to write to trace file at: " & FileName & " : Time:" & Now() & " : " & ex.Message & vbCrLf _
                                    , True)
                Catch ex2 As Exception

                End Try
            End Try
        End Sub
#End Region

    End Class

End Namespace

