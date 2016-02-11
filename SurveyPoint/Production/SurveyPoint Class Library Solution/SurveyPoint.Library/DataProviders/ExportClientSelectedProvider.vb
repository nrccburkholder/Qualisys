Namespace DataProviders
    Public MustInherit Class ExportClientSelectedProvider

#Region " Singleton Implementation "
        Private Shared mInstance As ExportClientSelectedProvider
        Private Const mProviderName As String = "ExportClientSelectedProvider"
        Public Shared ReadOnly Property Instance() As ExportClientSelectedProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of ExportClientSelectedProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function GetSelectedClients(ByVal ExportGroup As ExportGroup, ByVal Survey As ExportSurvey) As ExportClientSelectedCollection
        Public MustOverride Function GetSelectedClientByClientID(ByVal clientID As Integer) As ExportClientSelected
        Public MustOverride Sub InsertClient(ByVal client As ExportClientSelected, ByVal surveyID As Integer, ByVal exportGroupID As Integer)
    End Class
End Namespace
