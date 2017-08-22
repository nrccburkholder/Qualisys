Namespace DataProvider
    Public MustInherit Class MedicareSurveyTypeProvider

#Region " Singleton Implementation "

        Private Shared mInstance As MedicareSurveyTypeProvider
        Private Const mProviderName As String = "MedicareSurveyTypeProvider"

        Public Shared ReadOnly Property Instance() As MedicareSurveyTypeProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = MedicareSurveyTypeProvider.CreateInstance(Of MedicareSurveyTypeProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property

#End Region

        Protected Sub New()

        End Sub

        Public MustOverride Function [Select](ByVal medicareNumber As String, ByVal surveyTypeID As Integer) As MedicareSurveyType
        Public MustOverride Sub Insert(ByVal medicareSurveyType As MedicareSurveyType)
        Public MustOverride Sub Update(ByVal medicareSurveyType As MedicareSurveyType)
        Public MustOverride Sub Delete(ByVal medicareNumber As String, ByVal surveyTypeID As Integer)

    End Class

End Namespace
