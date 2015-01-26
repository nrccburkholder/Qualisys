Namespace DataProvider

    Public MustInherit Class SampleUnitServiceTypeProvider

#Region " Singleton Implementation "

        Private Shared mInstance As SampleUnitServiceTypeProvider
        Private Const mProviderName As String = "SampleUnitServiceTypeProvider"

        Public Shared ReadOnly Property Instance() As SampleUnitServiceTypeProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SampleUnitServiceTypeProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property

#End Region

        Protected Sub New()

        End Sub


        Public MustOverride Function SelectServiceTypes() As Collection(Of SampleUnitServiceType)
        Public MustOverride Function SelectServiceTypeBySampleUnitId(ByVal sampleUnitId As Integer) As SampleUnitServiceType

    End Class

End Namespace
