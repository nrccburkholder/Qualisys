Namespace DataProvider
    Public MustInherit Class MailingStepMethodProvider

#Region " Singleton Implementation "

        Private Shared mInstance As MailingStepMethodProvider
        Private Const mProviderName As String = "MailingStepMethodProvider"

        Public Shared ReadOnly Property Instance() As MailingStepMethodProvider
            <DebuggerHidden()> _
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of MailingStepMethodProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property

#End Region

        Protected Sub New()

        End Sub

        Public MustOverride Function [Select](ByVal mailingStepMethodId As Integer) As MailingStepMethod
        Public MustOverride Function SelectBySurveyId(ByVal surveyId As Integer) As MailingStepMethodCollection



        Protected Shared Function CreateMailingStepMethod(ByVal id As Integer) As MailingStepMethod

            Dim methStep As New MailingStepMethod()

            methStep.Id = id

            Return methStep

        End Function
    End Class

End Namespace
