Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class SPTI_FormattingRuleCollection
    Inherits BusinessListBase(Of SPTI_FormattingRuleCollection, SPTI_FormattingRule)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As SPTI_FormattingRule = SPTI_FormattingRule.NewSPTI_FormattingRule
        Me.Add(newObj)
        Return newObj
    End Function
End Class
