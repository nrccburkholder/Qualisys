
Public Class PageSizeChangedEventArgs
    Inherits System.EventArgs

    Private ReadOnly mAllowPaging As Boolean
    Private ReadOnly mPageSize As Integer

    Public Sub New(ByVal pageSize As String)
        If pageSize = "-1" Then
            mAllowPaging = False
            mPageSize = Integer.MaxValue
        Else
            mAllowPaging = True
            mPageSize = CInt(pageSize)
        End If
    End Sub

    Public ReadOnly Property AllowPaging() As Boolean
        Get
            Return mAllowPaging
        End Get
    End Property

    Public ReadOnly Property PageSize() As Integer
        Get
            Return mPageSize
        End Get
    End Property

End Class

Partial Public Class ResultsPerPage
    Inherits System.Web.UI.UserControl

    Public Event PageSizeChanged As EventHandler(Of PageSizeChangedEventArgs)

    Private Sub ComboPageSize_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ComboPageSize.SelectedIndexChanged
        Dim psce As New PageSizeChangedEventArgs(ComboPageSize.SelectedValue)
        OnPageSizeChanged(psce)
    End Sub

    Protected Overridable Sub OnPageSizeChanged(ByVal e As PageSizeChangedEventArgs)
        RaiseEvent PageSizeChanged(Me, e)
    End Sub

End Class