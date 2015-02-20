Namespace DataProvider
    Public MustInherit Class SampleUnitSectionMappingProvider

#Region " Singleton Implementation "
        Private Shared mInstance As SampleUnitSectionMappingProvider
        Private Const mProviderName As String = "SampleUnitSectionMappingProvider"

        Public Shared ReadOnly Property Instance() As SampleUnitSectionMappingProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SampleUnitSectionMappingProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectSampleUnitSectionMappingsBySampleUnitId(ByVal SampleUnitId As Integer) As SampleUnitSectionMappingCollection
        Public MustOverride Function InsertSampleUnitSectionMapping(ByVal instance As SampleUnitSectionMapping) As Integer
        Public MustOverride Sub DeleteSampleUnitSectionMapping(ByVal id As Integer)

    End Class

End Namespace
