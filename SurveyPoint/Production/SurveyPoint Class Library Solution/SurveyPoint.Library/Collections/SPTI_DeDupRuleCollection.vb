Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class SPTI_DeDupRuleCollection
    Inherits BusinessListBase(Of SPTI_DeDupRuleCollection, SPTI_DeDupRule)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As SPTI_DeDupRule = SPTI_DeDupRule.NewSPTI_DeDupRule
        Me.Add(newObj)
        Return newObj
    End Function
End Class