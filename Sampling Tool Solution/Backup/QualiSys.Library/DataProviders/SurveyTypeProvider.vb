Imports NRC.Framework.BusinessLogic

Namespace DataProvider

    Public MustInherit Class SurveyTypeProvider

#Region " Singleton Implementation "

        Private Shared mInstance As SurveyTypeProvider
        Private Const mProviderName As String = "SurveyTypeProvider"

        Public Shared ReadOnly Property Instance() As SurveyTypeProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SurveyTypeProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

#Region " Constructors "

        Protected Sub New()

        End Sub

#End Region

#Region " Public MustOverride Methods "

        Public MustOverride Function SelectSurveyType(ByVal id As Integer) As SurveyType
        Public MustOverride Function SelectAllSurveyTypes() As SurveyTypeCollection
        Public MustOverride Function InsertSurveyType(ByVal instance As SurveyType) As Integer
        Public MustOverride Sub UpdateSurveyType(ByVal instance As SurveyType)
        Public MustOverride Sub DeleteSurveyType(ByVal SurveyType As SurveyType)

#End Region

    End Class

End Namespace
