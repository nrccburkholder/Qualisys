Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class QuestionResultCollection
    Inherits BusinessListBase(Of QuestionResultCollection, QuestionResult)

#Region " Base Class Overrides "

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As QuestionResult = QuestionResult.NewQuestionResult
        Add(newObj)
        Return newObj

    End Function

#End Region

#Region " Public Methods "

    Public Function HasErrors() As Boolean

        For Each result As QuestionResult In Me
            If result.ErrorId <> TransferErrorCodes.None AndAlso result.ErrorId <> TransferErrorCodes.IgnoreQstnCore Then
                Return True
            End If
        Next

        Return False

    End Function

    Public Function ErrorCount() As Integer

        Dim count As Integer

        For Each result As QuestionResult In Me
            If result.ErrorId <> TransferErrorCodes.None AndAlso result.ErrorId <> TransferErrorCodes.IgnoreQstnCore Then
                count += 1
            End If
        Next

        Return count

    End Function

#End Region

#Region " Friend Methods "

    Friend Function HasValidResults(ByVal noResponseChar As String) As Boolean

        For Each result As QuestionResult In Me
            If result.IsValidQualiSysResult(noResponseChar) Then
                Return True
            End If
        Next

        Return False

    End Function

    Friend Function ValidResultCount(ByVal noResponseChar As String) As Integer

        Dim count As Integer

        For Each result As QuestionResult In Me
            If result.IsValidQualiSysResult(noResponseChar) Then
                count += 1
            End If
        Next

        Return count

    End Function

#End Region

End Class

