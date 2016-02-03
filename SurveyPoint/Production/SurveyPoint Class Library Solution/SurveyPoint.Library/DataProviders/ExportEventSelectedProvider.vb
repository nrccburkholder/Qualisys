Namespace DataProviders
    Public MustInherit Class ExportEventSelectedProvider

#Region " Singleton Implementation "
        Private Shared mInstance As ExportEventSelectedProvider
        Private Const mProviderName As String = "ExportEventSelectedProvider"
        Public Shared ReadOnly Property Instance() As ExportEventSelectedProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of ExportEventSelectedProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub



        Public MustOverride Function GetIncludedExportEvents(ByVal ExportGroupID As Integer) As ExportEventSelectedCollection
        Public MustOverride Function GetExcludedExportEvents(ByVal ExportGroupID As Integer) As ExportEventSelectedCollection
        Public MustOverride Function [Get](ByVal eventID As Integer) As ExportEventSelected
        Public MustOverride Sub InsertExcludeEvent(ByVal eventID As Integer, ByVal exportGroupID As Integer)
        Public MustOverride Sub InsertIncludeEvent(ByVal eventID As Integer, ByVal exportGroupID As Integer)

    End Class

End Namespace