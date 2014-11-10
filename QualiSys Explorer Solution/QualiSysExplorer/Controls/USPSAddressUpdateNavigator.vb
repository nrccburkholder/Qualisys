Public Class USPSAddressUpdateNavigator

    Public Enum SearchTypes
        Unprocessed = 0
        Updated = 1
        Ignored = 2
    End Enum

    Public Class USPSSearchEventArgs
        Inherits EventArgs

        Private mSearchType As SearchTypes

        Public ReadOnly Property SearchType() As SearchTypes
            Get
                Return mSearchType
            End Get
        End Property

        Private mFromDate As Object

        Public ReadOnly Property FromDate As Object
            Get
                Return mFromDate
            End Get
        End Property

        Private mToDate As Object
        Public ReadOnly Property ToDate As Object
            Get
                Return mToDate
            End Get
        End Property

        Public Sub New(ByVal _searchtype As SearchTypes)
            mSearchType = _searchtype
        End Sub

        Public Sub New(ByVal _searchtype As SearchTypes, ByVal _fromDate As Object)
            mSearchType = _searchtype
            mFromDate = _fromDate
        End Sub

        Public Sub New(ByVal _searchtype As SearchTypes, ByVal _fromDate As Object, ByVal _toDate As Object)
            mSearchType = _searchtype
            mFromDate = _fromDate
            mToDate = _toDate
        End Sub

    End Class


#Region "event handlers"

    Private Sub cmbStatus_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles cmbStatus.SelectedIndexChanged
        If cmbStatus.SelectedIndex > 0 Then
            If dtFrom.EditValue Is Nothing And dtFrom.EditValue Is Nothing Then
                dtFrom.EditValue = Date.Now.AddDays(-14)
                dtTo.EditValue = Date.Now
            ElseIf dtFrom.EditValue Is Nothing And dtFrom.EditValue IsNot Nothing Then
                dtFrom.EditValue = Convert.ToDateTime(dtTo.EditValue).AddDays(-14)
            ElseIf dtFrom.EditValue IsNot Nothing And dtFrom.EditValue Is Nothing Then
                dtTo.EditValue = Date.Now
            End If
        End If
    End Sub

    Private Sub btnReset_Click(sender As System.Object, e As System.EventArgs) Handles btnReset.Click
        Initialize()
    End Sub

    Public Delegate Sub USPSSearchEventHandler(ByVal sender As Object, ByVal e As USPSSearchEventArgs)
    Public Event USPSSearchClick As USPSSearchEventHandler

    Private Sub Button1_Click(sender As System.Object, e As System.EventArgs) Handles Button1.Click
        DoSearch()
    End Sub

    Private Shared Function GetSearchType(ByVal name As String) As SearchTypes
        Return DirectCast([Enum].Parse(GetType(SearchTypes), name), SearchTypes)
    End Function

    Private Sub USPSAddressUpdateNavigator_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Initialize()
    End Sub

#End Region
#Region "private methods"

    Private Sub Initialize()
        cmbStatus.SelectedIndex = 0
        dtFrom.EditValue = Nothing
        dtTo.EditValue = Nothing
    End Sub

    Private Sub DoSearch()

        If cmbStatus.SelectedIndex <> 0 AndAlso (dtFrom.EditValue Is Nothing Or dtTo.EditValue Is Nothing) Then

            MsgBox("Date Range required for this search type", MsgBoxStyle.Critical, "Search Criteria Error")

            Exit Sub

        End If


        RaiseEvent USPSSearchClick(Me, New USPSSearchEventArgs(GetSearchType(cmbStatus.Text), dtFrom.EditValue, dtTo.EditValue))
    End Sub
#End Region
End Class
