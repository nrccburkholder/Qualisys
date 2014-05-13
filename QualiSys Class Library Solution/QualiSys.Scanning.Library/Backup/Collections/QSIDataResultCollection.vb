Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class QSIDataResultCollection
	Inherits BusinessListBase(Of QSIDataResultCollection , QSIDataResult)
	
    Protected Overrides Function AddNewCore() As Object

        Dim newObj As  QSIDataResult = QSIDataResult.NewQSIDataResult
        Add(newObj)
        Return newObj

    End Function

    Public ReadOnly Property ResultString(ByVal qstnCore As Integer) As String
        Get
            Dim results As String = String.Empty

            For Each result As QSIDataResult In Me
                If result.QstnCore = qstnCore Then
                    If results.Length = 0 Then
                        results = result.ResponseValue.ToString
                    Else
                        results += String.Format(",{0}", result.ResponseValue)
                    End If
                End If
            Next

            Return results
        End Get
    End Property

    Public ReadOnly Property STRResult(ByVal qstnCore As Integer, ByVal width As Integer, ByVal readMethodId As Integer) As String
        Get
            Const kAvailableCharacters As String = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

            Dim strResults As String = String.Empty

            'Determine the question type
            If readMethodId = 1 Then
                'This is a multiple response question
                For Each result As QSIDataResult In Me
                    If result.QstnCore = qstnCore Then
                        If result.ResponseValue = -9 Then
                            'We can just skip anything that had a no response
                            Exit For
                        Else
                            strResults &= kAvailableCharacters.Substring(result.ResponseValue - 1, 1)
                        End If
                    End If
                Next

                'Now finish it up by padding the string with spaces
                strResults = strResults.PadRight(width, " "c)
            Else
                'This is a single response question
                For Each result As QSIDataResult In Me
                    If result.QstnCore = qstnCore Then
                        If result.ResponseValue = -9 Then
                            'For no response the STR file just gets spaces
                            strResults = strResults.PadLeft(width, " "c)
                        Else
                            'Pad the result with spaces
                            strResults = result.ResponseValue.ToString.PadLeft(width, " "c)
                        End If

                        'Exit the loop as there is only a single response
                        Exit For
                    End If
                Next
            End If

            Return strResults
        End Get
    End Property

End Class

