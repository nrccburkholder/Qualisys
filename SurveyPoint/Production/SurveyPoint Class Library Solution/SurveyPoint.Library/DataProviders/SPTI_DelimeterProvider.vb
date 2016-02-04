Namespace DataProviders

    Public MustInherit Class SPTI_DelimeterProvider

#Region " Singleton Implementation "
        Private Shared mInstance As SPTI_DelimeterProvider
        Private Const mProviderName As String = "SPTI_DelimeterProvider"
        Public Shared ReadOnly Property Instance() As SPTI_DelimeterProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SPTI_DelimeterProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectSPTI_Delimeter(ByVal delimeterID As Integer) As SPTI_Delimeter
        Public MustOverride Function SelectAllSPTI_Delimeters() As SPTI_DelimeterCollection
        Public MustOverride Function InsertSPTI_Delimeter(ByVal instance As SPTI_Delimeter) As Integer
        Public MustOverride Sub UpdateSPTI_Delimeter(ByVal instance As SPTI_Delimeter)
        Public MustOverride Sub DeleteSPTI_Delimeter(ByVal delimeterID As Integer)
    End Class

End Namespace
