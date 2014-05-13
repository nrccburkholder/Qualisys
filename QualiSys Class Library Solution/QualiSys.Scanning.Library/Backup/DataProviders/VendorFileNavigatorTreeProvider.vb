Imports NRC.Framework.BusinessLogic

'This class should go to your .Library project
Public MustInherit Class VendorFileNavigatorTreeProvider

#Region " Singleton Implementation "
    Private Shared mInstance As VendorFileNavigatorTreeProvider
    Private Const mProviderName As String = "VendorFileNavigatorTreeProvider"
    Public Shared ReadOnly Property Instance() As VendorFileNavigatorTreeProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of VendorFileNavigatorTreeProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()
    End Sub

    Public MustOverride Function SelectVendorFileNavigatorTreeByDateRange(ByVal statusID As Integer, ByVal startDate As Date) As VendorFileNavigatorTreeCollection

End Class

