Namespace DataProviders
    Public MustInherit Class ExportEventAvailableProvider

#Region " Singleton Implementation "
        Private Shared mInstance As ExportEventAvailableProvider
        Private Const mProviderName As String = "ExportEventAvailableProvider"
        Public Shared ReadOnly Property Instance() As ExportEventAvailableProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of ExportEventAvailableProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub


        Public MustOverride Function SelectAllExportEvents() As ExportEventAvailableCollection
        Public MustOverride Function [Get](ByVal eventID As Integer) As ExportEventAvailable


    End Class

End Namespace