Imports Nrc.QualiSys.Library
Imports System.Collections.Generic

Public Class USPSAddressUpdateSection

#Region "private members"

    Private mUSPS_PartialMatchesList As New List(Of USPS_PartialMatch)

#End Region

#Region "event handlers"


    Private Sub USPSAddressUpdateSection_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Initialize()
    End Sub

#End Region

#Region "constructors"

    Public Sub New()

        ' This call is required by the designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

    End Sub
#End Region

#Region "private methods"

    Private Sub Initialize()

        mUSPS_PartialMatchesList = USPS_PartialMatch.GetPartialMatches(0)

        'gcPartialMatches.DataSource = mUSPS_PartialMatchesList

        gcPartialMatches.DataSource = USPS_PartialMatch.GetPartialMatchesDataSet(0).Tables(0)
        'ExpandAllRows()
    End Sub


    Private Sub ExpandAllRows()
        gvPartialMatches.BeginUpdate()

        Try
            Dim dataRowCount As Integer = gvPartialMatches.DataRowCount
            For rHandle As Integer = 0 To dataRowCount - 1
                gvPartialMatches.SetMasterRowExpanded(rHandle, True)
            Next
        Finally
            gvPartialMatches.EndUpdate()
        End Try
    End Sub
#End Region


End Class
