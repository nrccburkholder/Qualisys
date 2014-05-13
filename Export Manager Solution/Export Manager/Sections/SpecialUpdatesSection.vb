Imports Nrc.DataMart.Library
Imports System.ComponentModel
Imports System.Data.OleDb

Public Class SpecialUpdatesSection

#Region " Private Members"

    Private WithEvents mNavigator As ClientStudySurveyNavigator

    Private mSpecialUpdateDataTable As New System.Data.DataTable

#End Region

#Region " Base Class Overrides "

    Public Overrides Sub ActivateSection()

        If mNavigator IsNot Nothing Then
            AddHandler mNavigator.SelectionChanged, AddressOf mNavigator_SelectionChanged
        End If

    End Sub

    Public Overrides Sub InactivateSection()

        If mNavigator IsNot Nothing Then
            RemoveHandler mNavigator.SelectionChanged, AddressOf mNavigator_SelectionChanged
        End If

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        Return True

    End Function

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        mNavigator = TryCast(navCtrl, ClientStudySurveyNavigator)
        If mNavigator Is Nothing Then
            Throw New Exception("SpecialUpdatesSection expects a navigation control of type ClientStudySurveyNavigator")
        End If

    End Sub

#End Region

#Region " Event Handlers "

    Private Sub SpecialUpdatesSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        SetScreenDefaults()

    End Sub

    Private Sub SpecialUpdatesToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SpecialUpdatesToolStripButton.Click

        If MessageBox.Show("It is extremely important to select the right study/survey combination!" & vbCrLf & "Are you sure you want to update " & Me.mSpecialUpdateDataTable.Rows.Count & " records for " & Me.SurveyLabel.Text & "?", "Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button1) = DialogResult.Yes Then
            UpdateDatabaseRecords()
            SetScreenDefaults()
        End If

    End Sub

    Private Sub mNavigator_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles mNavigator.SelectionChanged

        SetScreenDefaults()

        If (mNavigator.SelectedSurveys.Count = 1) Then
            Me.SurveyLabel.Text = mNavigator.SelectedSurveys.Item(0).DisplayLabel
            SpecialUpdatesPanel.Enabled = True
            Me.SpecialUpdatesFileTextBox.BackColor = Color.FromKnownColor(KnownColor.Window)
        Else
            Me.SurveyLabel.Text = "No Single Survey Selected"
            SpecialUpdatesPanel.Enabled = False
            Me.SpecialUpdatesFileTextBox.BackColor = Color.FromKnownColor(KnownColor.Control)
        End If

    End Sub

    Private Sub SpecialUpdatesBrowseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SpecialUpdatesBrowseButton.Click

        If Me.OpenUpdateFileDialog.ShowDialog() = DialogResult.OK Then
            SetScreenDefaults()
            Me.SpecialUpdatesFileTextBox.Text = Me.OpenUpdateFileDialog.FileName.ToString
            Me.SpecialUpdatesFileTextBox.Enabled = True
            Me.SpecialUpdatesFileTextBox.BackColor = Color.FromKnownColor(KnownColor.Window)
            If OpenSpecialUpdateFile() Then
                PopulateColumnToUpdateComboBox()
                UpdateDisplayLabels()
            End If
        End If

    End Sub

    Private Sub MultipeItemEvent_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ColumnToUpdateComboBox.SelectedIndexChanged, YearComboBox.SelectedIndexChanged, QuarterComboBox.SelectedIndexChanged, SpecialUpdatesFileTextBox.TextChanged

        'Check all conditions are met to enable Update toolbar button
        Me.SpecialUpdatesToolStripButton.Enabled = (Not (SpecialUpdatesFileTextBox.Text = "") And Not (ColumnToUpdateComboBox.SelectedIndex < 0) And Not (YearComboBox.Text = "") And Not (Me.QuarterComboBox.Text = ""))

    End Sub

#End Region

#Region " Private Methods "
  
    Private Sub SetScreenDefaults()

        'Reset Screen Defaults
        Me.SamplePopLabel.Text = ""
        Me.HDispositionLabel.Text = ""
        Me.LangIdLabel.Text = ""
        Me.SpecialUpdatesFileTextBox.Text = ""
        Me.SpecialUpdatesFileTextBox.BackColor = Color.FromKnownColor(KnownColor.Control)
        Me.SpecialUpdatesToolStripButton.Enabled = False
        Me.ColumnToUpdateComboBox.SelectedIndex = -1
        Me.ColumnToUpdateComboBox.Items.Clear()
        Me.YearComboBox.Text = Date.Now.Year.ToString.Trim
        Me.QuarterComboBox.SelectedIndex = -1

    End Sub

    Public Function OpenSpecialUpdateFile() As Boolean

        Dim strConn As String = "Provider=Microsoft.Jet.OleDb.4.0;" _
                          & "data source=" & Me.SpecialUpdatesFileTextBox.Text.Trim & ";" _
                          & "Extended Properties=Excel 8.0;"

        Dim objConn As New OleDbConnection(strConn)
        objConn.Open()

        Dim ExcelWorksheetNames As DataTable = objConn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, Nothing)
        Dim ExcelWorksheetName As String = "[" & ExcelWorksheetNames.Rows.Item(0).Item("TABLE_NAME").ToString & "]"

        Dim strSql As String = "Select * From " & ExcelWorksheetName
        Dim da As New OleDbDataAdapter(strSql, objConn)

        Try
            Me.mSpecialUpdateDataTable.Reset()
            da.Fill(mSpecialUpdateDataTable)

        Catch exc As Exception
            MessageBox.Show("Error while opening file: " & exc.Message)
            Return False

        Finally
            objConn.Dispose()

        End Try

        Return True

    End Function

    Public Function GetHeaderRowItems() As Collection

        Dim HeaderRowItems As New Collection

        For Each column As DataColumn In Me.mSpecialUpdateDataTable.Columns
            HeaderRowItems.Add(column.ColumnName.Trim)
        Next

        Return HeaderRowItems

    End Function

    Private Sub PopulateColumnToUpdateComboBox()

        Me.ColumnToUpdateComboBox.Items.Clear()

        For Each datacolumn As DataColumn In Me.mSpecialUpdateDataTable.Columns
            If (datacolumn.ColumnName.Trim = "hdisposition" Or datacolumn.ColumnName.Trim = "langid") Then
                Me.ColumnToUpdateComboBox.Items.Add(datacolumn.ColumnName.Trim)
            End If
        Next

    End Sub

    Private Sub UpdateDisplayLabels()

        If Me.mSpecialUpdateDataTable.Columns.Count <> 2 Then
            MessageBox.Show("This file contains more then two columns. This file must only have samplepop_id, and one other column header!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Stop, MessageBoxDefaultButton.Button1)
            Me.SpecialUpdatesFileTextBox.Text = ""
            Me.SamplePopLabel.Text = ""
            Me.HDispositionLabel.Text = ""
            Me.LangIdLabel.Text = ""
            Exit Sub
        End If

        If Me.mSpecialUpdateDataTable.Columns.Contains("samplepop_id") Then
            Me.SamplePopLabel.Text = "....column labeled ""samplepop_id"" found!"
            Me.SamplePopLabel.ForeColor = Color.Green
        Else
            Me.SamplePopLabel.Text = "....column labeled ""samplepop_id"" not found! Assuming 1st column as samplepop_id."
            Me.SamplePopLabel.ForeColor = Color.Red
            Exit Sub
        End If

        If Me.mSpecialUpdateDataTable.Columns.Contains("hdisposition") Then
            Me.HDispositionLabel.Text = "....column labeled ""hdisposition"" found!"
            Me.HDispositionLabel.ForeColor = Color.Green
        Else
            Me.HDispositionLabel.Text = "....column labeled ""hdisposition"" not found!"
            Me.HDispositionLabel.ForeColor = Color.Red
        End If

        If Me.mSpecialUpdateDataTable.Columns.Contains("langid") Then
            Me.LangIdLabel.Text = "....column labeled ""langid"" found!"
            Me.LangIdLabel.ForeColor = Color.Green
        Else
            Me.LangIdLabel.Text = "....column labeled ""langid"" not found!"
            Me.LangIdLabel.ForeColor = Color.Red
        End If

    End Sub

    Private Sub UpdateDatabaseRecords()

        Dim errorFound As Boolean = False
        Dim errorMessage As String = String.Empty

        For Each row As DataRow In Me.mSpecialUpdateDataTable.Rows
            If Not DataProvider.Instance.SpecialSurveyUpdate(mNavigator.SelectedSurveys(0).StudyId, mNavigator.SelectedSurveyIds(0), CType(row.Item(0), Integer), Me.ColumnToUpdateComboBox.Text.Trim.ToString, row.Item(1).ToString, Me.YearComboBox.Text.Trim & "_" & Me.QuarterComboBox.Text.Trim.Substring(1, 1), errorMessage) Then
                'MessageBox.Show(errorMessage, "Error While Doing Special Update", MessageBoxButtons.OK, MessageBoxIcon.Error)
                ReportException(New Exception(errorMessage), "Special Updates Exception")
                errorFound = True
                Exit Sub
            End If
        Next

        If Not errorFound Then MessageBox.Show("Special Update Complete", "Special Updates", MessageBoxButtons.OK, MessageBoxIcon.Information)

    End Sub

#End Region

End Class
