Imports System.Windows.Forms
Imports Nrc.DataMart.Library

Public Class ExportHistoryDialog
    Private mExportSetListViewSorter As New ListViewColumnSorter
    Private mExportFileListViewSorter As New ListViewColumnSorter

#Region " Constructor "
    Sub New(ByVal es As ExportSet)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        'Set the custom sorter for the export list view
        Me.ExportFileList.ListViewItemSorter = Me.mExportFileListViewSorter
        Me.mExportFileListViewSorter.ColumnToSort = 1
        Me.mExportFileListViewSorter.SortOrder = SortOrder.Ascending

        'Set the custom sorter for the export list view
        Me.ExportSetList.ListViewItemSorter = Me.mExportSetListViewSorter
        Me.mExportSetListViewSorter.ColumnToSort = 4
        Me.mExportSetListViewSorter.SortOrder = SortOrder.Ascending

        'Populate the files list
        PopulateExportFileList(es)
    End Sub

#End Region

#Region " Sortable Listview Event Handlers "
    Private Sub ExportSetList_ColumnClick(ByVal sender As System.Object, ByVal e As System.Windows.Forms.ColumnClickEventArgs) Handles ExportSetList.ColumnClick, ExportFileList.ColumnClick
        Dim list As ListView
        Dim columnSorter As ListViewColumnSorter
        list = CType(sender, ListView)
        columnSorter = DirectCast(list.ListViewItemSorter, ListViewColumnSorter)

        'If the clicked colum is already the sort column then just reverse the sort order
        If e.Column = columnSorter.ColumnToSort Then
            If columnSorter.SortOrder = SortOrder.Ascending Then
                columnSorter.SortOrder = SortOrder.Descending
            Else
                columnSorter.SortOrder = SortOrder.Ascending
            End If
        Else
            'Make the clicked column the sort column and sort ascending
            columnSorter.ColumnToSort = e.Column
            columnSorter.SortOrder = SortOrder.Ascending
        End If

        'Sort the list view
        list.Sort()

        'Refresh to fix some rendering bug...
        list.Refresh()
    End Sub

    Private Sub ExportSetList_DrawColumnHeader(ByVal sender As Object, ByVal e As System.Windows.Forms.DrawListViewColumnHeaderEventArgs) Handles ExportSetList.DrawColumnHeader, ExportFileList.DrawColumnHeader
        Dim list As ListView
        Dim columnSorter As ListViewColumnSorter
        list = CType(sender, ListView)
        columnSorter = DirectCast(list.ListViewItemSorter, ListViewColumnSorter)

        'Only use custom rendering if the column is sorted
        If e.ColumnIndex = columnSorter.ColumnToSort AndAlso Not columnSorter.SortOrder = SortOrder.None Then
            'Get the position of the cursor
            Dim pt As Point = list.PointToClient(System.Windows.Forms.Cursor.Position)
            'Draw header as "HOT" if cursor is within bounds (e.State doesn't seem to work)
            Dim isHot As Boolean = e.Bounds.Contains(pt)

            'If visual styles is enabled then render background with VS
            If VisualStyles.VisualStyleInformation.IsSupportedByOS AndAlso VisualStyles.VisualStyleInformation.IsEnabledByUser Then
                Dim element As VisualStyles.VisualStyleElement

                'Get the right visual style element, hot/normal
                If isHot Then
                    element = VisualStyles.VisualStyleElement.Header.Item.Hot
                Else
                    element = VisualStyles.VisualStyleElement.Header.Item.Normal
                End If

                'Create the visual style render and draw the background
                Dim vr As New VisualStyles.VisualStyleRenderer(element)
                vr.DrawBackground(e.Graphics, e.Bounds)
            Else
                e.DrawBackground()
            End If

            'Create a rectangle for the text
            Dim textRect As New Rectangle(e.Bounds.X + 7, e.Bounds.Y, e.Bounds.Width - 7 - 16, e.Bounds.Height)
            'Create the text formating object
            Dim f As New StringFormat(StringFormatFlags.NoWrap)
            f.Alignment = StringAlignment.Near
            f.LineAlignment = StringAlignment.Center
            f.Trimming = StringTrimming.EllipsisCharacter

            'Draw the header text
            e.Graphics.DrawString(e.Header.Text, e.Font, Brushes.Black, textRect, f)

            'Measure the size of the text
            Dim textSize As SizeF = e.Graphics.MeasureString(e.Header.Text, e.Font, textRect.Width, f)

            'Render the correct sort image
            Dim sortImg As Image
            If columnSorter.SortOrder = SortOrder.Ascending Then
                sortImg = Me.ListViewImageList.Images("Ascending")
            Else
                sortImg = Me.ListViewImageList.Images("Descending")
            End If
            e.Graphics.DrawImage(sortImg, textRect.Left + textSize.Width + 4, 6, 11, 7)
        Else
            e.DrawDefault = True
        End If
    End Sub

    Private Sub ExportSetList_DrawItem(ByVal sender As Object, ByVal e As System.Windows.Forms.DrawListViewItemEventArgs) Handles ExportSetList.DrawItem, ExportFileList.DrawItem
        'Use default rendering
        e.DrawDefault = True
    End Sub

    Private Sub ExportSetList_DrawSubItem(ByVal sender As Object, ByVal e As System.Windows.Forms.DrawListViewSubItemEventArgs) Handles ExportSetList.DrawSubItem, ExportFileList.DrawSubItem
        'Use default rendering
        e.DrawDefault = True
    End Sub
#End Region

#Region " Event Handlers "

    Private Sub OK_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OK_Button.Click
        Me.DialogResult = System.Windows.Forms.DialogResult.OK
        Me.Close()
    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Me.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Close()
    End Sub

    Private Sub ExportFileList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ExportFileList.SelectedIndexChanged
        If ExportFileList.SelectedItems.Count > 0 Then
            Dim ef As ExportFile = CType(ExportFileList.SelectedItems(0).Tag, ExportFile)
            PopulateExportSetList(ef)
        End If
    End Sub
#End Region

#Region " Private Methods "
    Private Sub PopulateExportFileList(ByVal es As ExportSet)
        Me.ExportFileList.Items.Clear()
        Me.FillExportFileList(es.GetExportFiles)
    End Sub

    Private Sub FillExportFileList(ByVal exportFiles As Collection(Of ExportFile))
        Dim items(8) As String
        Dim item As ListViewItem

        For Each export As ExportFile In exportFiles
            items(0) = export.CreatedDate.ToString
            items(1) = export.CreatedEmployeeName
            items(2) = export.FileType.ToString
            items(3) = export.RecordCount.ToString
            items(4) = export.FilePath
            items(5) = export.FilePartsCount.ToString
            items(6) = export.IncludeOnlyDirects.ToString
            items(7) = export.IncludeOnlyReturns.ToString
            item = New ListViewItem(items)
            item.Tag = export

            Me.ExportFileList.Items.Add(item)
        Next

        If Me.ExportFileList.Items.Count > 0 Then
            Me.ExportFileList.AutoResizeColumns(ColumnHeaderAutoResizeStyle.HeaderSize)
            Me.ExportFileList.Items(0).Selected = True
        End If
    End Sub

    Private Sub PopulateExportSetList(ByVal file As ExportFile)
        Me.ExportSetList.Items.Clear()

        Me.FillExportSetList(file.ExportSets)
        Me.ExportSetList.Sort()
    End Sub

    Private Sub FillExportSetList(ByVal exportSets As Collection(Of ExportSet))
        Dim items(8) As String
        Dim srvy As Survey
        Dim unit As SampleUnit = Nothing
        Dim item As ListViewItem

        For Each export As ExportSet In exportSets
            If export.SampleUnitId > 0 Then unit = SampleUnit.Get(export.SampleUnitId)
            srvy = Survey.GetSurvey(export.SurveyId)
            items(0) = srvy.Study.Client.DisplayLabel
            items(1) = srvy.Study.DisplayLabel
            items(2) = srvy.DisplayLabel
            If unit IsNot Nothing Then
                items(3) = unit.DisplayLabel
            Else
                items(3) = "All"
            End If
            items(4) = export.Name
            items(5) = export.CreatedDate.ToString
            items(6) = export.StartDate.ToShortDateString
            items(7) = export.EndDate.ToShortDateString
            items(8) = export.ExportSetType.ToString
            item = New ListViewItem(items)
            item.Tag = export

            Me.ExportSetList.Items.Add(item)

            'Set unit back to nothing
            unit = Nothing
        Next

        If Me.ExportSetList.Items.Count > 0 Then
            Me.ExportSetList.AutoResizeColumns(ColumnHeaderAutoResizeStyle.HeaderSize)
        End If
    End Sub

#End Region


End Class
