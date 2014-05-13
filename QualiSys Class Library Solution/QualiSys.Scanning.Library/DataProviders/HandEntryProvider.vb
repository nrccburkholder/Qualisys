Imports NRC.Framework.BusinessLogic

Public MustInherit Class HandEntryProvider

#Region " Singleton Implementation "

    Private Shared mInstance As HandEntryProvider
    Private Const mProviderName As String = "HandEntryProvider"

    Public Shared ReadOnly Property Instance() As HandEntryProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of HandEntryProvider)(mProviderName)
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

    Public MustOverride Function SelectHandEntry(ByVal handEntryId As Integer) As HandEntry
    Public MustOverride Function SelectHandEntriesByLithoCodeId(ByVal lithoCodeId As Integer) As HandEntryCollection
    Public MustOverride Function SelectHandEntryItemNumberFromResponseValue(ByVal lithoCode As String, ByVal qstnCore As Integer, ByVal itemVal As Integer) As Integer
    Public MustOverride Function InsertHandEntry(ByVal instance As HandEntry) As Integer
    Public MustOverride Sub UpdateHandEntry(ByVal instance As HandEntry)
    Public MustOverride Sub DeleteHandEntry(ByVal instance As HandEntry)

#End Region

End Class

