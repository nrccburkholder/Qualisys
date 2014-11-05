Imports Nrc.QualiSys.Library
Imports System.Collections.Generic
Imports DevExpress.XtraGrid.Views.Base
Imports DevExpress.XtraGrid.Views.Grid.ViewInfo
Imports DevExpress.Utils
Imports DevExpress.XtraGrid.Views.Grid
Imports DevExpress.XtraGrid.Columns
Imports DevExpress.XtraEditors.Repository

Public Class USPSAddressUpdateSection

#Region "private members"

    Private mUSPS_PartialMatchesList As New List(Of USPS_PartialMatch)
    Private mIsExpanded As Boolean = False
    Private newRepositoryItem As New DevExpress.XtraEditors.Repository.RepositoryItem
#End Region

#Region "event handlers"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks>Suppresses the RadioGroup column in the filterRow</remarks>
    Private Sub gvPartialMatches_CustomRowCellEdit(sender As Object, e As DevExpress.XtraGrid.Views.Grid.CustomRowCellEditEventArgs) Handles gvPartialMatches.CustomRowCellEdit
        If gvPartialMatches.IsFilterRow(e.RowHandle) AndAlso e.Column.FieldName = "Action" Then
            e.RepositoryItem = newRepositoryItem
        End If
    End Sub

    Private Sub btnExpandAll_Click(sender As System.Object, e As System.EventArgs) Handles btnExpandAll.Click
        If mIsExpanded Then
            CollapseAllRows()
        Else
            ExpandAllRows()
        End If
    End Sub


    Private Sub USPSAddressUpdateSection_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Initialize()
    End Sub


    Public Sub IdleEvent(ByVal sender As System.Object, ByVal e As System.EventArgs)

        Select Case mIsExpanded
            Case False
                btnExpandAll.Text = "Expand All"
            Case Else
                btnExpandAll.Text = "Collapse All"
        End Select

    End Sub
#End Region

#Region "constructors"

    Public Sub New()

        ' This call is required by the designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        AddHandler Application.Idle, AddressOf IdleEvent

    End Sub
#End Region

#Region "private methods"

    Private Sub Initialize()

        mUSPS_PartialMatchesList = USPS_PartialMatch.GetPartialMatches(0)

        gcPartialMatches.DataSource = USPS_PartialMatch.GetPartialMatchesDataSet(0).Tables(0)
        mIsExpanded = False

    End Sub


    Private Sub ExpandAllRows()
        gvPartialMatches.BeginUpdate()

        Try
            Dim dataRowCount As Integer = gvPartialMatches.DataRowCount
            For rHandle As Integer = 0 To dataRowCount - 1
                gvPartialMatches.SetMasterRowExpanded(rHandle, True)
            Next
            mIsExpanded = True
        Finally
            gvPartialMatches.EndUpdate()
        End Try
    End Sub

    Private Sub CollapseAllRows()
        gvPartialMatches.CollapseAllDetails()
        mIsExpanded = False
    End Sub
#End Region
End Class
