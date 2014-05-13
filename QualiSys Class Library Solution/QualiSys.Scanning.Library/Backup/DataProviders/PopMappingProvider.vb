Imports NRC.Framework.BusinessLogic

Public MustInherit Class PopMappingProvider

#Region " Singleton Implementation "

    Private Shared mInstance As PopMappingProvider
    Private Const mProviderName As String = "PopMappingProvider"

    Public Shared ReadOnly Property Instance() As PopMappingProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of PopMappingProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()

    End Sub

    Public MustOverride Function SelectPopMapping(ByVal id As Integer) As PopMapping
    Public MustOverride Function SelectPopMappingsByLithoCodeId(ByVal lithoCodeId As Integer) As PopMappingCollection
    Public MustOverride Function InsertPopMapping(ByVal instance As PopMapping) As Integer
    Public MustOverride Sub UpdatePopMapping(ByVal instance As PopMapping)
    Public MustOverride Sub DeletePopMapping(ByVal instance As PopMapping)

End Class

