Namespace DataProviders
    Public MustInherit Class SPTI_DeDupRuleClientIDProvider

#Region " Singleton Implementation "
        Private Shared mInstance As SPTI_DeDupRuleClientIDProvider
        Private Const mProviderName As String = "SPTI_DeDupRuleClientIDProvider"
        Public Shared ReadOnly Property Instance() As SPTI_DeDupRuleClientIDProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SPTI_DeDupRuleClientIDProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectSPTI_DeDupRuleClientID(ByVal iD As Integer) As SPTI_DeDupRuleClientID
        Public MustOverride Function SelectAllSPTI_DeDupRuleClientIDs() As SPTI_DeDupRuleClientIDCollection
        Public MustOverride Function SelectAllSPTI_DeDupRuleClientIDsByDeDupRuleID(ByVal deDupRuleID As Integer) As SPTI_DeDupRuleClientIDCollection
        Public MustOverride Function InsertSPTI_DeDupRuleClientID(ByVal instance As SPTI_DeDupRuleClientID) As Integer
        Public MustOverride Sub UpdateSPTI_DeDupRuleClientID(ByVal instance As SPTI_DeDupRuleClientID)
        Public MustOverride Sub DeleteSPTI_DeDupRuleClientID(ByVal iD As Integer)
        Public MustOverride Function GetClientName(ByVal clientID As Integer) As String
    End Class
End Namespace