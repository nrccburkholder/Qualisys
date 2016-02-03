Namespace DataProviders
    Public MustInherit Class SPTI_DeDupRuleProvider

#Region " Singleton Implementation "
        Private Shared mInstance As SPTI_DeDupRuleProvider
        Private Const mProviderName As String = "SPTI_DeDupRuleProvider"
        Public Shared ReadOnly Property Instance() As SPTI_DeDupRuleProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SPTI_DeDupRuleProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectSPTI_DeDupRule(ByVal deDupRuleID As Integer) As SPTI_DeDupRule
        Public MustOverride Function SelectAllSPTI_DeDupRules() As SPTI_DeDupRuleCollection
        Public MustOverride Function SelectAllSPTI_DeDupRulesByFileID(ByVal fileID As Integer) As SPTI_DeDupRule
        Public MustOverride Function InsertSPTI_DeDupRule(ByVal instance As SPTI_DeDupRule) As Integer
        Public MustOverride Sub UpdateSPTI_DeDupRule(ByVal instance As SPTI_DeDupRule)
        Public MustOverride Sub DeleteSPTI_DeDupRule(ByVal deDupRuleID As Integer)
        Public MustOverride Sub DeleteDeDupRuleAndChildrenByFileID(ByVal fileID As Integer)
    End Class
End Namespace