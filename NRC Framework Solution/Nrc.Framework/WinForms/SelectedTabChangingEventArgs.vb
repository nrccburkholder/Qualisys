Namespace WinForms
    Public Class SelectedTabChangingEventArgs
        Inherits EventArgs

        Private mOldTab As MultiPaneTab
        Private mNewTab As MultiPaneTab
        Private mCancel As Boolean
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
        Public Property Cancel() As Boolean
            Get
                Return mCancel
            End Get
            Set(ByVal value As Boolean)
                mCancel = value
            End Set
        End Property
        Sub New(ByVal oldTab As MultiPaneTab, ByVal newTab As MultiPaneTab)
            mOldTab = oldTab
            mNewTab = newTab
        End Sub
    End Class

End Namespace
