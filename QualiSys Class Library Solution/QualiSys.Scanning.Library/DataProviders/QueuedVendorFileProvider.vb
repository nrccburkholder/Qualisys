Imports System.Data

Public MustInherit Class QueuedVendorFileProvider

#Region " Singleton Implementation "

    Private Shared mInstance As QueuedVendorFileProvider
    Private Const mProviderName As String = "QueuedVendorFileProvider"

    Public Shared ReadOnly Property Instance() As QueuedVendorFileProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of QueuedVendorFileProvider)(mProviderName)
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

    Public MustOverride Function GetDataTable(ByVal filename As String) As DataTable

#End Region

End Class
