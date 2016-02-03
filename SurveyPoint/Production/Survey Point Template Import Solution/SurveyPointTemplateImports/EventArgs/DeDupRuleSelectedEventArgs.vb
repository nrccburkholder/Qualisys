Public Class DeDupRuleSelectedEventArgs
    Inherits EventArgs

    Private mRuleChanged As Boolean    
    Public ReadOnly Property RuleChanged() As Boolean
        Get
            Return Me.mRuleChanged
        End Get
    End Property    
    Public Sub New(ByVal ruleChanged As Boolean)
        Me.mRuleChanged = ruleChanged        
    End Sub
End Class
