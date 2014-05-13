Namespace Data
    Public Class DBNull
        Public Shared Value As System.DBNull = System.DBNull.Value

        Public Shared Function IsNull(ByVal expression As Object) As Object
            If IsDBNull(expression) Then
                Return Nothing
            Else
                Return expression
            End If
        End Function
        Public Shared Function IsNull(ByVal expression As Object, ByVal returnOnNull As Object) As Object
            If IsDBNull(expression) Then
                Return returnOnNull
            Else
                Return expression
            End If
        End Function


        ' define application encoded null values
        Private Shared ReadOnly Property NullInteger() As Integer
            Get
                Return Integer.MinValue
            End Get
        End Property
        Private Shared ReadOnly Property NullDate() As Date
            Get
                Return Date.MinValue
            End Get
        End Property
        Private Shared ReadOnly Property NullString() As String
            Get
                Return ""
            End Get
        End Property
        Private Shared ReadOnly Property NullBoolean() As Boolean
            Get
                Return False
            End Get
        End Property
        Private Shared ReadOnly Property NullGuid() As Guid
            Get
                Return Guid.Empty
            End Get
        End Property

        Public Shared Function GetInteger(ByVal dataValue As Object) As Integer
            If dataValue Is DBNull.Value Then
                Return NullInteger
            Else
                Return CType(dataValue, Integer)
            End If
        End Function
        Public Shared Function GetDate(ByVal dataValue As Object) As Date
            If dataValue Is DBNull.Value Then
                Return NullDate
            Else
                Return CType(dataValue, Date)
            End If
        End Function
        Public Shared Function GetString(ByVal dataValue As Object) As String
            If dataValue Is DBNull.Value Then
                Return NullString
            Else
                Return CType(dataValue, String)
            End If
        End Function
        Public Shared Function GetBoolean(ByVal dataValue As Object) As Boolean
            If dataValue Is DBNull.Value Then
                Return NullBoolean
            Else
                Return CType(dataValue, Boolean)
            End If
        End Function
        Public Shared Function GetGUID(ByVal dataValue As Object) As Guid
            If dataValue Is DBNull.Value Then
                Return NullGuid
            Else
                Return CType(dataValue, Guid)
            End If
        End Function

        Public Shared Function FromDBValue(ByVal dataValue As Object) As Object
            If Not dataValue Is Nothing Then
                If dataValue Is DBNull.Value Then
                    If TypeOf dataValue Is Integer Then
                        Return NullInteger
                    ElseIf TypeOf dataValue Is Single Then
                        Return NullInteger
                    ElseIf TypeOf dataValue Is Double Then
                        Return NullInteger
                    ElseIf TypeOf dataValue Is Decimal Then
                        Return NullInteger
                    ElseIf TypeOf dataValue Is Date Then
                        Return NullDate
                    ElseIf TypeOf dataValue Is String Then
                        Return NullString
                    ElseIf TypeOf dataValue Is Boolean Then
                        Return NullBoolean
                    ElseIf TypeOf dataValue Is Guid Then
                        Return NullGuid
                    Else
                        Throw New ArgumentException("Unknown data type.")
                    End If
                Else
                    Return dataValue
                End If
            Else
                Return Nothing
            End If
        End Function

        Public Shared Function ToDBValue(ByVal dataValue As Integer) As Object
            If dataValue = NullInteger Then
                Return DBNull.Value
            Else
                Return dataValue
            End If
        End Function
        Public Shared Function ToDBValue(ByVal dataValue As Single) As Object
            If dataValue = NullInteger Then
                Return DBNull.Value
            Else
                Return dataValue
            End If
        End Function
        Public Shared Function ToDBValue(ByVal dataValue As Double) As Object
            If dataValue = NullInteger Then
                Return DBNull.Value
            Else
                Return dataValue
            End If
        End Function
        Public Shared Function ToDBValue(ByVal dataValue As Decimal) As Object
            If dataValue = NullInteger Then
                Return DBNull.Value
            Else
                Return dataValue
            End If
        End Function
        Public Shared Function ToDBValue(ByVal dataValue As Date) As Object
            If dataValue = NullDate Then
                Return DBNull.Value
            Else
                Return dataValue
            End If
        End Function
        Public Shared Function ToDBValue(ByVal dataValue As String) As Object
            If dataValue Is Nothing OrElse dataValue = NullString Then
                Return DBNull.Value
            Else
                Return dataValue
            End If
        End Function
        Public Shared Function ToDBValue(ByVal dataValue As Boolean) As Object
            If dataValue = NullBoolean Then
                Return DBNull.Value
            Else
                Return dataValue
            End If
        End Function
        Public Shared Function ToDBValue(ByVal dataValue As Guid) As Object
            If dataValue.Equals(NullGuid) Then
                Return DBNull.Value
            Else
                Return dataValue
            End If
        End Function

    End Class


End Namespace
