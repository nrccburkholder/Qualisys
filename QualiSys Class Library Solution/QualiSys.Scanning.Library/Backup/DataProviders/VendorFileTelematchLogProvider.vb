Imports NRC.Framework.BusinessLogic

Public MustInherit Class VendorFileTelematchLogProvider

#Region " Singleton Implementation "

    Private Shared mInstance As VendorFileTelematchLogProvider
    Private Const mProviderName As String = "VendorFileTelematchLogProvider"

    Public Shared ReadOnly Property Instance() As VendorFileTelematchLogProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of VendorFileTelematchLogProvider)(mProviderName)
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

    Public MustOverride Function SelectVendorFileTelematchLog(ByVal id As Integer) As VendorFileTelematchLog
    Public MustOverride Function SelectAllVendorFileTelematchLogs() As VendorFileTelematchLogCollection
    Public MustOverride Function SelectVendorFileTelematchLogsByVendorFileId(ByVal vendorFileId As Integer) As VendorFileTelematchLogCollection
    Public MustOverride Function InsertVendorFileTelematchLog(ByVal instance As VendorFileTelematchLog) As Integer
    Public MustOverride Sub UpdateVendorFileTelematchLog(ByVal instance As VendorFileTelematchLog)
    Public MustOverride Sub DeleteVendorFileTelematchLog(ByVal VendorFile_TelematchLog As VendorFileTelematchLog)
    Public MustOverride Function SelectVendorFileTelematchLogByNotReturned() As VendorFileTelematchLogCollection

#End Region

End Class

