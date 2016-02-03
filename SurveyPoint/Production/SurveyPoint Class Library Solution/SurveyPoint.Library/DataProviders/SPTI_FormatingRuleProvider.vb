Namespace DataProviders
    Public MustInherit Class SPTI_FormatingRuleProvider

#Region " Singleton Implementation "
        Private Shared mInstance As SPTI_FormatingRuleProvider
        Private Const mProviderName As String = "SPTI_FormatingRuleProvider"
        Public Shared ReadOnly Property Instance() As SPTI_FormatingRuleProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SPTI_FormatingRuleProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectSPTI_FormattingRule(ByVal formatingRuleID As Integer) As SPTI_FormattingRule
        Public MustOverride Function SelectAllSPTI_FormattingRules() As SPTI_FormattingRuleCollection
        Public MustOverride Function InsertSPTI_FormattingRule(ByVal instance As SPTI_FormattingRule) As Integer
        Public MustOverride Sub UpdateSPTI_FormattingRule(ByVal instance As SPTI_FormattingRule)
        Public MustOverride Sub DeleteSPTI_FormattingRule(ByVal formatingRuleID As Integer)
    End Class
End Namespace
