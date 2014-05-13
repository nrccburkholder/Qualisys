Imports NRC.Framework.BusinessLogic
Imports System.Data

Public MustInherit Class VendorFileCreationQueueProvider

#Region " Singleton Implementation "

    Private Shared mInstance As VendorFileCreationQueueProvider
    Private Const mProviderName As String = "VendorFileCreationQueueProvider"
    Public Shared ReadOnly Property Instance() As VendorFileCreationQueueProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of VendorFileCreationQueueProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()

    End Sub

    Public MustOverride Function SelectVendorFileCreationQueue(ByVal vendorFileId As Integer) As VendorFileCreationQueue
    Public MustOverride Function SelectAllVendorFileCreationQueues() As VendorFileCreationQueueCollection
    Public MustOverride Function SelectVendorFileCreationQueuesBySamplesetId(ByVal samplesetId As Integer) As VendorFileCreationQueueCollection
    Public MustOverride Function SelectVendorFileCreationQueuesByMailingStepId(ByVal mailingStepId As Integer) As VendorFileCreationQueueCollection
    Public MustOverride Function SelectVendorFileCreationQueuesByVendorFileStatusId(ByVal vendorFileStatusId As VendorFileStatusCodes) As VendorFileCreationQueueCollection
    Public MustOverride Function InsertVendorFileCreationQueue(ByVal instance As VendorFileCreationQueue) As Integer
    Public MustOverride Sub UpdateVendorFileCreationQueue(ByVal instance As VendorFileCreationQueue)
    Public MustOverride Sub DeleteVendorFileCreationQueue(ByVal instance As VendorFileCreationQueue)

    Public MustOverride Function SelectVendorFileData(ByVal vendorFileId As Integer) As DataTable
    Public MustOverride Sub RemakeVendorFileData(ByVal vendorFileId As Integer, ByVal sampleSetId As Integer)

End Class

