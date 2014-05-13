Imports NRC.Framework.BusinessLogic

Public MustInherit Class ErrorCodeProvider

#Region " Singleton Implementation "

    Private Shared mInstance As ErrorCodeProvider
    Private Const mProviderName As String = "ErrorCodeProvider"

    Public Shared ReadOnly Property Instance() As ErrorCodeProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of ErrorCodeProvider)(mProviderName)
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

    Public MustOverride Function SelectErrorCode(ByVal dL_ErrorId As Integer) As ErrorCode
    Public MustOverride Function SelectAllErrorCodes() As ErrorCodeCollection

#End Region

End Class

