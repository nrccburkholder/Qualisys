Partial Public Class ExceptionTest
    Inherits WebErrorTrappingBaseClass


    Protected Overrides ReadOnly Property LogPageExceptions() As Boolean
        Get
            Return True
        End Get
    End Property

    Protected Sub ButtonPushed(ByVal sender As Object, ByVal e As System.EventArgs) Handles thrower.Click
        If ErrorToSend.Text = "" Then
            Throw New NullReferenceException("Test error")
        Else
            Throw New NullReferenceException(ErrorToSend.Text)
        End If
    End Sub

End Class