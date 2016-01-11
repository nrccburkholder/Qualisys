Imports Utilities

Namespace Miscellaneous

    Public Class Stubborn_SQL_Runner

        Private _iRetryThreshold As Integer
        Private _iRetryIntervalStart As Integer
        Private _iRetryIntervalEnd As Integer
        Private _aExceptionKeys As ArrayList
        Private _Tracer As NRC.Miscellaneous.Tracer

        Public Sub New()
            If Not Security.ValidateKey Then
                Throw New System.Exception("Not valid Security Key, Please provide a valid Security Key using the security class")
            End If
            Me._aExceptionKeys = New ArrayList
        End Sub

        ''' <summary>
        ''' The number of times to retry a SQL statement before sending a notification email.
        ''' </summary>
        Public Property RetryCount() As Integer
            Get
                Return Me._iRetryThreshold
            End Get
            Set(ByVal value As Integer)
                Me._iRetryThreshold = value
            End Set
        End Property

        ''' <summary>
        ''' This is the amount of time in seconds to wait between each execution of the SQL statement.
        ''' </summary>
        Public Property RetryIntervalStart() As Integer
            Get
                Return Me._iRetryIntervalStart
            End Get
            Set(ByVal value As Integer)
                Me._iRetryIntervalStart = value
            End Set
        End Property

        ''' <summary>
        ''' (not yet implemented)
        ''' </summary>
        Public Property RetryIntervalEnd() As Integer
            Get
                Return Me._iRetryIntervalEnd
            End Get
            Set(ByVal value As Integer)
                Me._iRetryIntervalEnd = value
            End Set
        End Property

        ''' <summary>
        ''' This object is used to write entries to the trace log after [RetryCount] number of errors have occured.
        ''' </summary>
        Public Property Tracer() As Tracer
            Get
                Return Me._Tracer
            End Get
            Set(ByVal value As Tracer)
                Me._Tracer = value
            End Set
        End Property

        ''' <summary>
        ''' If the word or phrase passed to this method is included in a SQL exception, that exception will be tolerated by the Stubborn SQL Runner.
        ''' </summary>
        Public Sub AddExceptionKey(ByVal ExceptionKey As String)
            Me._aExceptionKeys.Add(ExceptionKey)
        End Sub

        Public Sub RemoveExceptionKey(ByVal ExceptionKey As String)
            Me._aExceptionKeys.Remove(ExceptionKey)
        End Sub

        Private Function IsRetryable(ByVal ex As Exception) As Boolean

            For Each Key As String In Me._aExceptionKeys
                If ex.Message.Contains(Key) Then
                    Return True
                End If
            Next

            Return False

        End Function

        ''' <summary>
        ''' Executes a stubborn SQL statement that returns a scalar value.   Email notifications and trace entries will be created based on the property values provided.
        ''' </summary>
        Public Function ExecuteScalar(ByVal DBCommandObject As Data.Common.DbCommand) As Object

            Dim iRetryInterval As Integer = Me._iRetryIntervalStart
            Dim iCountFailures As Integer = 0

            While True
                Try
                    Return DBCommandObject.ExecuteScalar()
                Catch ex As Exception
                    If IsRetryable(ex) Then
                        System.Threading.Thread.Sleep(New TimeSpan(0, 0, iRetryInterval))

                        iCountFailures += 1

                        If iCountFailures Mod _iRetryThreshold = 0 Then
                            ' macbrown 10/13/2009: Removed SQL as it contained PHI.
                            Email.SendMail("There have been " & iCountFailures & " attempts made to run this SQL [<Sql Omitted>] in SmartLinkRaw. " & _
                                                         "The service will continue to retry until it succeeds!  Please address this issue ASAP." _
                                                         , ex)
                            Me._Tracer.WriteError("A timeout/permission error has repeatedly occured while executing an interpreter SQL statement.  " & vbCrLf & _
                                                  ex.Message & vbCrLf & _
                                                  "This error has now occurred " & iCountFailures & " times and a notification email has been sent. ")
                        End If
                    Else
                        Throw
                    End If
                End Try
            End While

            Return Nothing

        End Function

        ''' <summary>
        ''' Executes a stubborn SQL statement that does not return a value.   Email notifications and trace entries will be created based on the property values provided.
        ''' </summary>
        Public Function ExecuteNonQuery(ByVal DBCommandObject As Data.Common.DbCommand) As Integer

            Dim iRecordsAffected As Integer = 0
            Dim iRetryInterval As Integer = Me._iRetryIntervalStart
            Dim iCountFailures As Integer = 0

            While True
                Try
                    Return DBCommandObject.ExecuteNonQuery()
                Catch ex As Exception
                    If IsRetryable(ex) Then
                        System.Threading.Thread.Sleep(New TimeSpan(0, 0, iRetryInterval))

                        iCountFailures += 1

                        If iCountFailures Mod _iRetryThreshold = 0 Then
                            Email.SendMail("There have been " & iCountFailures & " attempts made to run this SQL [" & DBCommandObject.CommandText & "] in SmartLinkRaw. " & _
                                                         "The service will continue to retry until it succeeds!  Please address this issue ASAP." _
                                                         , ex)
                            Me._Tracer.WriteError("A timeout/permission error has repeatedly occured while executing an interpreter SQL statement.  " & vbCrLf & _
                                                  ex.Message & vbCrLf & _
                                                  "This error has now occurred " & iCountFailures & " times and a notification email has been sent. ")

                        End If

                    Else
                        Throw
                    End If
                End Try
            End While

            Return iRecordsAffected

        End Function


        Public Function Clone() As Stubborn_SQL_Runner

            Dim ClonedRunner As New Stubborn_SQL_Runner()
            Dim ClonedTracer As New Tracer()

            ClonedRunner.RetryCount = Me._iRetryThreshold
            ClonedRunner.RetryIntervalStart = Me._iRetryIntervalStart
            ClonedRunner.RetryIntervalEnd = Me._iRetryIntervalEnd

            For Each ExceptionKey As String In Me._aExceptionKeys
                ClonedRunner.AddExceptionKey(ExceptionKey)
            Next

            If Me._Tracer IsNot Nothing Then
                ClonedTracer.ErrorFileName = Me._Tracer.ErrorFileName
                ClonedTracer.FileName = Me._Tracer.FileName
                ClonedTracer.TraceFlag = Me._Tracer.TraceFlag
            End If

            Return ClonedRunner

        End Function


    End Class

End Namespace
