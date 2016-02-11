Namespace DataProviders
    Public MustInherit Class ExportClientAvailableProvider

#Region " Singleton Implementation "
        Private Shared mInstance As ExportClientAvailableProvider
        Private Const mProviderName As String = "ExportClientAvailableProvider"
        Public Shared ReadOnly Property Instance() As ExportClientAvailableProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of ExportClientAvailableProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function GetBySurveyID(ByVal SurveyID As Integer) As ExportClientAvailableCollection
        Public MustOverride Function GetClientByClientID(ByVal clientID As Integer) As ExportClientAvailable
        'TP 10/16/2008 Used in template importer to get a list of all clients.
        Public MustOverride Function SelectAllClients() As ExportClientAvailableCollection
    End Class
End Namespace
