Namespace DataProvider
    Public MustInherit Class SampleUnitLinkingProvider

#Region " Singleton Implementation "
        Private Shared mInstance As SampleUnitLinkingProvider
        Private Const mProviderName As String = "SampleUnitLinkingProvider"
        Public Shared ReadOnly Property Instance() As SampleUnitLinkingProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SampleUnitLinkingProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region
        Protected Sub New()

        End Sub
        Public MustOverride Function SelectByClientId(ByVal clientId As Integer) As SampleUnitLinkingCollection
        Public MustOverride Sub Insert(ByVal fromSampleUnitId As Integer, ByVal toSampleUnitId As Integer)
        Public MustOverride Sub DeleteByClientId(ByVal clientId As Integer)

    End Class
End Namespace
