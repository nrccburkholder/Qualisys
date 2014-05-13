Imports NRC.Framework.BusinessLogic

'This class should go to your .Library project
Public MustInherit Class EmailBlastOptionProvider

#Region " Singleton Implementation "
    Private Shared mInstance As EmailBlastOptionProvider
    Private Const mProviderName As String = "EmailBlastOptionProvider"
    Public Shared ReadOnly Property Instance() As EmailBlastOptionProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProvider.DataProviderFactory.CreateInstance(Of EmailBlastOptionProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()
    End Sub

    Public MustOverride Function SelectEmailBlastOption(ByVal emailBlastId As Integer) As EmailBlastOption
    Public MustOverride Function SelectAllEmailBlastOptions() As EmailBlastOptionCollection
    Public MustOverride Function InsertEmailBlastOption(ByVal instance As EmailBlastOption) As Integer
    Public MustOverride Sub UpdateEmailBlastOption(ByVal instance As EmailBlastOption)
    Public MustOverride Sub DeleteEmailBlastOption(ByVal instance As EmailBlastOption)
End Class

