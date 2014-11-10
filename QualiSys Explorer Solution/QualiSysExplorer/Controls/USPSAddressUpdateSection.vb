Imports Nrc.QualiSys.Library
Imports System.Collections.Generic
Imports DevExpress.XtraGrid.Views.Grid
Imports Nrc.Framework.AddressCleaning
Imports System.Drawing
Imports DevExpress.XtraPrinting




Public Class USPSAddressUpdateSection

#Region "private members"
    Private WithEvents mUpdateNav As USPSAddressUpdateNavigator
    Private mUSPS_PartialMatchesList As New List(Of USPS_PartialMatch)
    Private mIsExpanded As Boolean = False
    Private newRepositoryItem As New DevExpress.XtraEditors.Repository.RepositoryItem
    Private bIsToggling As Boolean = False
    Private mSearchStatus As USPSAddressUpdateNavigator.SearchTypes
    Private mFromDate As Object
    Private mToDate As Object

   
    Private Const DISPOSITIONID As Integer = 1
#End Region


#Region "properties"

    Private mReceiptTypes As New ReceiptTypeCollection

    Protected ReadOnly Property ReceiptType() As ReceiptType
        Get
            For Each recType As ReceiptType In mReceiptTypes
                If String.Compare(recType.Name, "USPS Address Change") = 0 Then
                    Return recType
                End If
            Next
            Return Nothing
        End Get
    End Property
#End Region
#Region "event handlers"

    Private Sub Button1_Click(sender As System.Object, e As System.EventArgs) Handles btnExportToExcel.Click
        ExportMappingsToExcel()
    End Sub

    Private Sub gvPartialMatches_CustomDrawCell(sender As Object, e As DevExpress.XtraGrid.Views.Base.RowCellCustomDrawEventArgs) Handles gvPartialMatches.CustomDrawCell


        ' changes the background color of the Updated and Ignored cells if they have already been updated to indicate editing is disabled
        ' need this here otherwise the grid blows up and the application closes.
        If e.RowHandle = DevExpress.XtraGrid.GridControl.AutoFilterRowHandle Then
            Exit Sub
        End If

        If e.Column.FieldName = "Updated" Or e.Column.FieldName = "Ignored" Then
            Dim status As Integer = Convert.ToInt32(gvPartialMatches.GetRowCellValue(e.RowHandle, "UpdateStatus"))
            Select Case status
                Case 1
                    e.Appearance.BackColor = SystemColors.Control
                Case Else
                    e.Appearance.BackColor = Color.White
            End Select

        End If

    End Sub

    Private Sub gvPartialMatches_ShowingEditor(sender As Object, e As System.ComponentModel.CancelEventArgs) Handles gvPartialMatches.ShowingEditor
        ' Disables Updated and Ignored checkboxes if it has already been updated.  In otherwords, once you'd updated the address, editing is disabled
        If (gvPartialMatches.FocusedColumn.FieldName = "Updated" Or gvPartialMatches.FocusedColumn.FieldName = "Ignored") And IsAllowingEdit(gvPartialMatches, gvPartialMatches.FocusedRowHandle) = False Then
            e.Cancel = True
        End If

    End Sub

    Private Shared Function IsAllowingEdit(ByVal view As GridView, ByVal rowHandle As Integer) As Boolean
        Try
            Dim val As Boolean = Convert.ToInt32(view.GetRowCellValue(rowHandle, "UpdateStatus")) <> 1
            Return val
        Catch ex As Exception
            Return False
        End Try
    End Function

    Private Sub btnUpdate_Click(sender As System.Object, e As System.EventArgs) Handles btnUpdate.Click
        SaveData()
    End Sub

    Private Sub chkIgnoreAll_CheckedChanged(sender As Object, e As System.EventArgs) Handles chkIgnoreAll.CheckedChanged
        For rowHandle As Integer = 0 To gvPartialMatches.RowCount - 1
            Dim targetValue As String = gvPartialMatches.GetRowCellValue(rowHandle, gvPartialMatches.Columns("Ignored")).ToString()

            Dim checkValue As String = IIf(chkIgnoreAll.Checked, "1", "0").ToString()

            gvPartialMatches.SetRowCellValue(rowHandle, gvPartialMatches.Columns("Ignored"), checkValue)

            If chkIgnoreAll.Checked Then
                ToggleCheckBox("Updated", rowHandle)
                chkUpdateAll.Checked = False
            End If
        Next
    End Sub

    Private Sub chkUpdateAll_CheckedChanged(sender As System.Object, e As System.EventArgs) Handles chkUpdateAll.CheckedChanged
        For rowHandle As Integer = 0 To gvPartialMatches.RowCount - 1
            Dim targetValue As String = gvPartialMatches.GetRowCellValue(rowHandle, gvPartialMatches.Columns("Updated")).ToString()

            Dim checkValue As String = IIf(chkUpdateAll.Checked, "1", "0").ToString()

            gvPartialMatches.SetRowCellValue(rowHandle, gvPartialMatches.Columns("Updated"), checkValue)

            If chkUpdateAll.Checked Then
                ToggleCheckBox("Ignored", rowHandle)
                chkIgnoreAll.Checked = False
            End If
        Next
    End Sub

    Private Sub gvPartialMatches_CellValueChanging(sender As Object, e As DevExpress.XtraGrid.Views.Base.CellValueChangedEventArgs) Handles gvPartialMatches.CellValueChanging
        If Not bIsToggling Then
            bIsToggling = True
            If e.Column.FieldName = "Updated" Then
                ToggleCheckBox("Ignored", e.RowHandle)
            ElseIf e.Column.FieldName = "Ignored" Then
                ToggleCheckBox("Updated", e.RowHandle)
            End If
            bIsToggling = False
        End If
    End Sub

    Private Sub gvPartialMatches_CustomUnboundColumnData(sender As Object, e As DevExpress.XtraGrid.Views.Base.CustomColumnDataEventArgs) Handles gvPartialMatches.CustomUnboundColumnData
        If String.Compare(e.Column.Name, "colStatusImage", False) = 0 AndAlso e.IsGetData Then
            Try

                Dim status As Integer = Convert.ToInt32(gvPartialMatches.GetRowCellValue(e.RowHandle, "UpdateStatus"))
                Select Case status
                    Case USPSAddressUpdateNavigator.SearchTypes.Ignored
                        e.Value = My.Resources.block
                    Case USPSAddressUpdateNavigator.SearchTypes.Updated
                        e.Value = My.Resources.greencheck
                    Case Else
                        e.Value = My.Resources.questionmark
                End Select

            Catch ex As Exception

            End Try
        End If
    End Sub

    Public Overrides Sub RegisterNavControl(ByVal navControl As System.Windows.Forms.Control)
        If Not TypeOf navControl Is USPSAddressUpdateNavigator Then
            Throw New ArgumentException("A control of type 'USPSAddressUpdateNavigator' was expected", "navControl")
        Else
            mUpdateNav = DirectCast(navControl, USPSAddressUpdateNavigator)
        End If
    End Sub

    Private Sub mUpdateNav_USPSSearchClick(ByVal sender As Object, ByVal e As USPSAddressUpdateNavigator.USPSSearchEventArgs) Handles mUpdateNav.USPSSearchClick
        mSearchStatus = e.SearchType
        mFromDate = e.FromDate
        mToDate = e.ToDate
        LoadData(mSearchStatus, mFromDate, mToDate)
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks>Suppresses the display of the control in the filter row of the specified columns</remarks>
    Private Sub gvPartialMatches_CustomRowCellEdit(sender As Object, e As DevExpress.XtraGrid.Views.Grid.CustomRowCellEditEventArgs) Handles gvPartialMatches.CustomRowCellEdit
        If gvPartialMatches.IsFilterRow(e.RowHandle) AndAlso (e.Column.FieldName = "Image" Or e.Column.FieldName = "Updated" Or e.Column.FieldName = "Ignored") Then
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

        'btnUpdate.Enabled = IsCheckBoxChecked()

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

        LoadData(0, Nothing, Nothing)
        LoadReceiptTypeList()

        mIsExpanded = False

    End Sub

    Private Sub LoadReceiptTypeList()

        mReceiptTypes.Clear()
        mReceiptTypes = ReceiptType.GetAll()

    End Sub

    Private Sub LoadData(ByVal status As Integer, ByVal fromDate As Object, ByVal toDate As Object)



        Dim sFromDate As String = String.Empty
        Dim sToDate As String = String.Empty

        If fromDate IsNot Nothing Then
            sFromDate = Convert.ToDateTime(fromDate).ToString("MM/dd/yyyy")
        End If

        If toDate IsNot Nothing Then
            sToDate = Convert.ToDateTime(toDate).ToString("MM/dd/yyyy")
        End If

        gcPartialMatches.DataSource = USPS_PartialMatch.GetPartialMatchesDataSet(status, sFromDate, sToDate).Tables(0)

        gvPartialMatches.RefreshData()
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

    Private Sub ToggleCheckBox(ByVal targetColumnName As String, ByVal rowHandle As Integer)

        Dim targetValue As String = gvPartialMatches.GetRowCellValue(rowHandle, gvPartialMatches.Columns(targetColumnName)).ToString()

        If targetValue = "1" Then
            gvPartialMatches.SetRowCellValue(rowHandle, gvPartialMatches.Columns(targetColumnName), "0")
        End If


    End Sub

    Private Sub SaveData()

        'Set the cursor
        ParentForm.Cursor = Cursors.WaitCursor
        Try
            For i As Integer = 0 To gvPartialMatches.DataRowCount - 1 ' loop through masterview

                Dim id As Integer = Convert.ToInt32(gvPartialMatches.GetRowCellValue(i, gvPartialMatches.Columns("Id")))
                Dim litho As String = gvPartialMatches.GetRowCellValue(i, gvPartialMatches.Columns("Lithocode")).ToString()
                Dim mail As Mailing = Nothing
                mail = Mailing.GetMailingByLitho(litho)

                Dim newStatus As Integer = USPSAddressUpdateNavigator.SearchTypes.Unprocessed
                Dim currentStatus As Integer = Convert.ToInt32(gvPartialMatches.GetRowCellValue(i, gvPartialMatches.Columns("UpdateStatus")))

                If currentStatus <> USPSAddressUpdateNavigator.SearchTypes.Updated Then

                    Dim isFlaggedForUpdate As Boolean = Convert.ToInt32(gvPartialMatches.GetRowCellValue(i, gvPartialMatches.Columns("Updated"))) = 1
                    Dim isFlaggedForIgnore As Boolean = Convert.ToInt32(gvPartialMatches.GetRowCellValue(i, gvPartialMatches.Columns("Ignored"))) = 1

                    ' masterview has to be expanded to get access to the detail view
                    gvPartialMatches.SetMasterRowExpanded(i, True)

                    Dim detailView As GridView = DirectCast(gvPartialMatches.GetDetailView(i, 0), GridView)

                    If isFlaggedForUpdate Then

                        For j As Integer = 0 To detailView.DataRowCount - 1  ' loop through detailView

                            If String.Compare(detailView.GetRowCellValue(j, "AddressType").ToString(), "USPS New", True) = 0 Then

                                Try

                                    'Dim addrCleaner As Cleaner = New Cleaner(CountryIDs.US, LoadDatabases.QPLoad)
                                    Dim addr As Address = Address.NewAddress
                                    'addrCleaner.Addresses.Add(addr)

                                    'Set the address objects values
                                    With addr
                                        .OriginalAddress.StreetLine1 = detailView.GetRowCellValue(j, "Addr").ToString()
                                        .OriginalAddress.StreetLine2 = detailView.GetRowCellValue(j, "Addr2").ToString()
                                        .OriginalAddress.City = detailView.GetRowCellValue(j, "City").ToString()
                                        .OriginalAddress.State = detailView.GetRowCellValue(j, "State").ToString()
                                        .OriginalAddress.Zip5 = detailView.GetRowCellValue(j, "Zip5").ToString()
                                    End With

                                    ''Determine if we need to use a web proxy
                                    'Dim forceProxy As Boolean = ((AppConfig.Params("WebServiceProxyRequiredClient").IntegerValue = 1) OrElse System.Diagnostics.Debugger.IsAttached)

                                    ''Clean the address
                                    'addrCleaner.Addresses.Clean(forceProxy)


                                    'Set the returned address
                                    With addr

                                        'Change address USA
                                        'Mailing.ChangeRespondentAddress(DISPOSITIONID, ReceiptType.Id, CurrentUser.UserName, .CleanedAddress.StreetLine1, .CleanedAddress.StreetLine2, .CleanedAddress.City, .CleanedAddress.DeliveryPoint, .CleanedAddress.State, .CleanedAddress.Zip5, .CleanedAddress.Zip4, .CleanedAddress.AddressStatus, .CleanedAddress.AddressError)
                                        mail.ChangeRespondentAddress(DISPOSITIONID, ReceiptType.Id, CurrentUser.UserName, .OriginalAddress.StreetLine1, .OriginalAddress.StreetLine2, .OriginalAddress.City, .OriginalAddress.DeliveryPoint, .OriginalAddress.State, .OriginalAddress.Zip5, .OriginalAddress.Zip4, .OriginalAddress.AddressStatus, .OriginalAddress.AddressError)

                                    End With

                                    newStatus = USPSAddressUpdateNavigator.SearchTypes.Updated

                                    Exit For

                                Catch ex As Exception

                                End Try

                            End If

                        Next

                    ElseIf isFlaggedForIgnore Then
                        newStatus = USPSAddressUpdateNavigator.SearchTypes.Ignored
                    End If

                    ' only update the status if it is different from the original
                    If currentStatus <> newStatus Then
                        USPS_PartialMatch.UpdatePartialMatchStatus(id, newStatus)
                    End If

                    ' collapse the master row after it has been evaluated
                    gvPartialMatches.SetMasterRowExpanded(i, False)

                End If
            Next

        Finally
            'Set the cursor
            ParentForm.Cursor = Cursors.Default

            LoadData(mSearchStatus, mFromDate, mToDate)
        End Try


    End Sub

    Private Sub ExportMappingsToExcel()
        SaveFileDialog1.Filter = "Excel 97-2003 (*.xls)|*.xls|Excel Files (*.xlsx)|*.xlsx"
        SaveFileDialog1.FilterIndex = 2
        If SaveFileDialog1.ShowDialog = DialogResult.OK Then

            gvPartialMatches.ExportToXlsx(SaveFileDialog1.FileName)

        End If
    End Sub

    'Private Function IsCheckBoxChecked() As Boolean
    '    Dim mIsCheckBoxChecked As Boolean = False

    '    Dim dataRowCount As Integer = gvPartialMatches.DataRowCount
    '    For i As Integer = 0 To dataRowCount - 1
    '        Dim isFlaggedForUpdate As Boolean = Convert.ToInt32(gvPartialMatches.GetRowCellValue(i, gvPartialMatches.Columns("Updated"))) = 1
    '        Dim isFlaggedForIgnore As Boolean = Convert.ToInt32(gvPartialMatches.GetRowCellValue(i, gvPartialMatches.Columns("Ignored"))) = 1

    '        If isFlaggedForIgnore Or isFlaggedForIgnore Then
    '            mIsCheckBoxChecked = True
    '            Exit For
    '        End If
    '    Next

    '    Return mIsCheckBoxChecked
    'End Function
#End Region
End Class
