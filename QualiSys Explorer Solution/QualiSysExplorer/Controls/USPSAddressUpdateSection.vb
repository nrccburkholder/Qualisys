Imports Nrc.QualiSys.Library
Imports System.Collections.Generic

Public Class USPSAddressUpdateSection

#Region "private members"

    Private mUSPS_PartialMatchesList As New List(Of USPS_PartialMatch)
    Private mIsExpanded As Boolean = False
#End Region

#Region "event handlers"


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
