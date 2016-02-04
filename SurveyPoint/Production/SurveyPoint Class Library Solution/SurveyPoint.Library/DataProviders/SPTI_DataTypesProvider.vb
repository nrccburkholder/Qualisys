Namespace DataProviders

    Public MustInherit Class SPTI_DataTypesProvider

#Region " Singleton Implementation "
        Private Shared mInstance As SPTI_DataTypesProvider
        Private Const mProviderName As String = "SPTI_DataTypesProvider"
        Public Shared ReadOnly Property Instance() As SPTI_DataTypesProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SPTI_DataTypesProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectSPTI_DataType(ByVal dateTypeID As Integer) As SPTI_DataType
        Public MustOverride Function SelectAllSPTI_DataTypes() As SPTI_DataTypeCollection
        Public MustOverride Function InsertSPTI_DataType(ByVal instance As SPTI_DataType) As Integer
        Public MustOverride Sub UpdateSPTI_DataType(ByVal instance As SPTI_DataType)
        Public MustOverride Sub DeleteSPTI_DataType(ByVal dateTypeID As Integer)
    End Class
End Namespace