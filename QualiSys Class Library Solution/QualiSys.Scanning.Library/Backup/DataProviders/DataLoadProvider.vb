Imports NRC.Framework.BusinessLogic

Public MustInherit Class DataLoadProvider

#Region " Singleton Implementation "

    Private Shared mInstance As DataLoadProvider
    Private Const mProviderName As String = "DataLoadProvider"

    Public Shared ReadOnly Property Instance() As DataLoadProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of DataLoadProvider)(mProviderName)
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

    Public MustOverride Function SelectDataLoad(ByVal dataLoadId As Integer) As DataLoad
    Public MustOverride Function SelectDataLoadsByVendorId(ByVal vendorId As Integer) As DataLoadCollection
    Public MustOverride Function InsertDataLoad(ByVal instance As DataLoad) As Integer
    Public MustOverride Sub UpdateDataLoad(ByVal instance As DataLoad)
    Public MustOverride Sub DeleteDataLoad(ByVal instance As DataLoad)

#End Region

End Class

