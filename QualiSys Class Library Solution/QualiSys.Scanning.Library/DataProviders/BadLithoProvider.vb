Imports NRC.Framework.BusinessLogic

Public MustInherit Class BadLithoProvider

#Region " Singleton Implementation "

    Private Shared mInstance As BadLithoProvider
    Private Const mProviderName As String = "BadLithoProvider"

    Public Shared ReadOnly Property Instance() As BadLithoProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of BadLithoProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property

#End Region

#Region " Constructors "

    Protected Sub New()

    End Sub

#End Region

#Region " Public MustOverride Methods "

    Public MustOverride Function SelectBadLitho(ByVal badLithoId As Integer) As BadLitho
    Public MustOverride Function SelectBadLithosByDataLoadId(ByVal dataLoadId As Integer) As BadLithoCollection
    Public MustOverride Function InsertBadLitho(ByVal instance As BadLitho) As Integer
    Public MustOverride Sub UpdateBadLitho(ByVal instance As BadLitho)
    Public MustOverride Sub DeleteBadLitho(ByVal instance As BadLitho)

#End Region

End Class

