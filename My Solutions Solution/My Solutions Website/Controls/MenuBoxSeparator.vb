Public Class MenuBoxSeparator
    Inherits MenuBoxItem

    Protected Overrides ReadOnly Property TagKey() As HtmlTextWriterTag
        Get
            Return HtmlTextWriterTag.Hr
        End Get
    End Property

End Class