
Public MustInherit Class LoadToLiveLookupProvider

#Region " Singleton Implementation "

    Private Shared mInstance As LoadToLiveLookupProvider
    Private Const mProviderName As String = "LoadToLiveLookupProvider"

    Public Shared ReadOnly Property Instance() As LoadToLiveLookupProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviders.DataProviderFactory.CreateInstance(Of LoadToLiveLookupProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property

#End Region

    Protected Sub New()

    End Sub

    Public MustOverride Function SelectLoadToLiveLookupsByStudyIDTableName(ByVal studyID As Integer, ByVal lookupTableName As String) As LoadToLiveLookupCollection

End Class

