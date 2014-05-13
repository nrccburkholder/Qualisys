Namespace Data
    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC Class Library
    ''' Class	 : Data.SqlCommandException
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Provides more detailed information when exceptions occur while trying to execute a SqlCommand.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	8/18/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Class SqlCommandException
        Inherits System.Exception

#Region " Private Members "
        Private mStoredProcedureName As String
        Private mParameterNames As New Specialized.StringCollection
        Private mParameterValues As New Specialized.StringCollection
        Private mCommandText As String = ""
#End Region

#Region " Public Properties "
        Public ReadOnly Property CommandText() As String
            Get
                If mCommandText = "" Then
                    mCommandText = GetCommandText()
                End If

                Return mCommandText
            End Get
        End Property
#End Region

#Region " Constructors "
        Sub New(ByVal cmd As IDbCommand, ByVal innerException As Exception)
            MyBase.New(innerException.Message, innerException)

            'Store the procedure name and parameters
            mStoredProcedureName = cmd.CommandText
            GetParams(cmd)
        End Sub

#End Region

#Region " Private Members "
        Private Sub GetParams(ByVal cmd As IDbCommand)
            'Get a list of all of the parameter names
            For Each param As Object In cmd.Parameters
                If Not param.ToString.ToUpper = "@RETURN_VALUE" Then
                    mParameterNames.Add(param.ToString)
                End If
            Next

            'Build a string of all the parameter names and their values
            Dim paramValue As Object
            For Each paramName As String In mParameterNames
                paramValue = GetParamValue(TryCast(cmd.Parameters(paramName), IDataParameter))
                If Not paramValue Is Nothing Then
                    'If it is a string put ' around it and replace ' with ''
                    'If it is DBNull.Value then put the text NULL
                    If TypeOf paramValue Is String Then
                        mParameterValues.Add("'" & paramValue.ToString.Replace("'", "''") & "'")
                    ElseIf TypeOf paramValue Is System.DBNull Then
                        mParameterValues.Add("NULL")
                    Else
                        mParameterValues.Add(paramValue.ToString)
                    End If
                Else
                    'Don't know what the value was...
                    mParameterValues.Add("<UNKNOWN>")
                End If
            Next
        End Sub

        Private Function GetParamValue(ByVal param As IDataParameter) As Object
            'We can only get the parameter value if this is a SqlParameter
            If TypeOf param Is SqlClient.SqlParameter Then
                Return DirectCast(param, SqlClient.SqlParameter).Value
            Else
                Return "<UNKNOWN>"
            End If
        End Function

        Private Function GetCommandText() As String
            Dim cmd As String = mStoredProcedureName & " "
            For i As Integer = 0 To mParameterNames.Count - 1
                If i = 0 Then
                    cmd &= mParameterNames(i)
                Else
                    cmd &= ", " & mParameterNames(i)
                End If
                cmd &= "=" & mParameterValues(i)
            Next

            Return cmd
        End Function
#End Region

#Region " Overrides "
        Public Overrides Function ToString() As String
            Dim errorMessage As String
            errorMessage = "SQL Exception: " & Me.Message & Environment.NewLine
            errorMessage &= "SQL Command: " & CommandText() & Environment.NewLine

            If (Not Me.InnerException Is Nothing) Then
                Dim textArray1 As String() = New String() {errorMessage, "Inner Exception: ", Me.InnerException.ToString, Environment.NewLine, "   ", "-- End of inner exception stack trace --"}
                errorMessage = String.Concat(textArray1)
            End If
            If (Not Me.StackTrace Is Nothing) Then
                errorMessage = (errorMessage & Environment.NewLine & Me.StackTrace)
            End If
            Return errorMessage
        End Function
#End Region

    End Class
End Namespace
