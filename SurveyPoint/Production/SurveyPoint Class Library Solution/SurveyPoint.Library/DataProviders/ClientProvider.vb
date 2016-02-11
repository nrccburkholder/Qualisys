Namespace DataProviders
    Public MustInherit Class ClientProvider

#Region " Singleton Implementation "
        Private Shared mInstance As ClientProvider
        Private Const mProviderName As String = "ClientProvider"
        Public Shared ReadOnly Property Instance() As ClientProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of ClientProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function GetSelectedClients(ByVal ExportGroupID As Integer, ByVal SurveyID As Integer) As ClientCollection
        Public MustOverride Function GetBySurveyID(ByVal SurveyID As Integer) As ClientCollection
    End Class
End Namespace
