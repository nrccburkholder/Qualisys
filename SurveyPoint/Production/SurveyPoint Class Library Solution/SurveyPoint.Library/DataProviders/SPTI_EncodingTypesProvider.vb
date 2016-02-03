Namespace DataProviders

    Public MustInherit Class SPTI_EncodingTypesProvider

#Region " Singleton Implementation "
        Private Shared mInstance As SPTI_EncodingTypesProvider
        Private Const mProviderName As String = "SPTI_EncodingTypesProvider"
        Public Shared ReadOnly Property Instance() As SPTI_EncodingTypesProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SPTI_EncodingTypesProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectSPTI_EncodingType(ByVal encodingTypeID As Integer) As SPTI_EncodingType
        Public MustOverride Function SelectAllSPTI_EncodingTypes() As SPTI_EncodingTypeCollection
        Public MustOverride Function InsertSPTI_EncodingType(ByVal instance As SPTI_EncodingType) As Integer
        Public MustOverride Sub UpdateSPTI_EncodingType(ByVal instance As SPTI_EncodingType)
        Public MustOverride Sub DeleteSPTI_EncodingType(ByVal encodingTypeID As Integer)
    End Class
End Namespace