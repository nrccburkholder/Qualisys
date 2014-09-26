Namespace DataProvider

    Public MustInherit Class CoverLetterMappingProvider


#Region " Singleton Implementation "
        Private Shared mInstance As CoverLetterMappingProvider
        Private Const mProviderName As String = "CoverLetterMappingProvider"

        Public Shared ReadOnly Property Instance() As CoverLetterMappingProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of CoverLetterMappingProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region


        Public MustOverride Function SelectCoverLetterMappingsBySurveyId(ByVal SurveyId As Integer) As List(Of CoverLetterMapping) 'Collection
        Public MustOverride Function InsertCoverLetterMapping(ByVal instance As CoverLetterMapping) As Integer
        Public MustOverride Sub DeleteCoverLetterMapping(ByVal instance As CoverLetterMapping)
        Public MustOverride Sub UpdateCoverLetterMapping(ByVal instance As CoverLetterMapping)
        Public MustOverride Function [Select](ByVal Id As Integer) As CoverLetterMapping

    End Class

End Namespace


