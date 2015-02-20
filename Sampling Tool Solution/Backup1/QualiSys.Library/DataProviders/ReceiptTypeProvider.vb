Imports NRC.Framework.BusinessLogic

    'This class should go to your .Library project
Public MustInherit Class ReceiptTypeProvider

#Region " Singleton Implementation "

    Private Shared mInstance As ReceiptTypeProvider
    Private Const mProviderName As String = "ReceiptTypeProvider"
    Public Shared ReadOnly Property Instance() As ReceiptTypeProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProvider.DataProviderFactory.CreateInstance(Of ReceiptTypeProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property

#End Region

    Protected Sub New()

    End Sub

    Public MustOverride Function SelectAllReceiptTypes() As ReceiptTypeCollection

End Class
