Namespace DataProvider
    Public MustInherit Class ModeSectionMappingProvider

#Region " Singleton Implementation "
        Private Shared mInstance As ModeSectionMappingProvider
        Private Const mProviderName As String = "ModeSectionMappingProvider"

        Public Shared ReadOnly Property Instance() As ModeSectionMappingProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of ModeSectionMappingProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectModeSectionMappingsBySurveyId(ByVal SurveyId As Integer) As List(Of ModeSectionMapping) 'Collection
        Public MustOverride Function InsertModeSectionMapping(ByVal instance As ModeSectionMapping) As Integer
        Public MustOverride Sub DeleteModeSectionMapping(ByVal instance As ModeSectionMapping)
        Public MustOverride Sub UpdateModeSectionMapping(ByVal instance As ModeSectionMapping)
        Public MustOverride Function [Select](ByVal Id As Integer, ByVal Survey_Id As Integer) As ModeSectionMapping

    End Class

End Namespace
