Imports NRC.Framework.BusinessLogic

'This class should go to your .Library project
Public MustInherit Class DataEntryNavigatorTreeProvider

#Region " Singleton Implementation "

    Private Shared mInstance As DataEntryNavigatorTreeProvider
    Private Const mProviderName As String = "DataEntryNavigatorTreeProvider"
    Public Shared ReadOnly Property Instance() As DataEntryNavigatorTreeProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of DataEntryNavigatorTreeProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property

#End Region

    Protected Sub New()

    End Sub

    Public MustOverride Function SelectDataEntryNavigatorTree(ByVal userName As String) As DataEntryNavigatorTreeCollection

End Class

