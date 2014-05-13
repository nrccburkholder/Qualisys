Namespace WinForms
    Public Class SelectedTabChangedEventArgs
        Inherits EventArgs

        Private mOldTab As MultiPaneTab
        Private mNewTab As MultiPaneTab
        Public ReadOnly Property OldTab() As MultiPaneTab
            Get
                Return mOldTab
            End Get
        End Property
        Public ReadOnly Property NewTab() As MultiPaneTab
            Get
                Return mNewTab
            End Get
        End Property
        Sub New(ByVal oldTab As MultiPaneTab, ByVal newTab As MultiPaneTab)
            mOldTab = oldTab
            mNewTab = newTab
        End Sub
    End Class
End Namespace
