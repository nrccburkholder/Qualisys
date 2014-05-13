Namespace Navigation

    Public MustInherit Class NavigationNode

        Public MustOverride ReadOnly Property NodeType() As NavigationNodeType
        Public MustOverride ReadOnly Property Nodes() As NavigationNodeList
        Public MustOverride Property Id() As Integer
        Public MustOverride Property Name() As String
        Public MustOverride Property IsActive() As Boolean

        Public Overridable ReadOnly Property DisplayLabel() As String
            Get
                If Id < 0 Then
                    Return String.Format("{0}", Name)
                Else
                    Return String.Format("{0} ({1})", Name, Id)
                End If
            End Get
        End Property

        Public Overridable ReadOnly Property ForeColor() As System.Drawing.Color
            Get
                If IsActive Then
                    Return System.Drawing.SystemColors.ControlText
                Else
                    Return System.Drawing.SystemColors.GrayText
                End If
            End Get
        End Property
    End Class

End Namespace
