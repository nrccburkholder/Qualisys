Imports System.Data.OleDb
Imports NRC.DataMart.Library
Public Class WeightsLoaderSection

    Const PreviewRows As Integer = 10
#Region "Private Fields"
    Private WithEvents mClientStudySurveyNavigator As ClientStudySurveyNavigator
    Private mColumns As New Collection(Of String)
    Private mDataFile As ExternalDataFile
#End Region

#Region "Overrides"
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        mClientStudySurveyNavigator = TryCast(navCtrl, ClientStudySurveyNavigator)
        If mClientStudySurveyNavigator Is Nothing Then
            Throw New Exception("WeightsLoaderSection expects a navigation control of type ClientStudySurveyNavigator")
        End If
    End Sub
#End Region

#Region "Private Methods"

    Private Sub PopulateColumnsLists()
        mColumns.Clear()
        For Each pair As KeyValuePair(Of String, System.Type) In mDataFile.Fields
            Dim dataType As String = pair.Value.Name
            Dim columnName As String = pair.Key
            Select Case dataType
                Case "Int32", "Int16", "Int64", "Decimal", "Double", "Single"
                    mColumns.Add(columnName)
                Case Else
                    'Don't add to list
            End Select
        Next
    End Sub

    Private Sub PopulatePreviewGrid()
        Me.PreviewDataGrid.DataSource = Nothing
        Me.PreviewDataGrid.DataSource = Me.mDataFile.previewTable
    End Sub

    Private Sub PopulateColumnComboBoxes()
        Me.SamplePopColumnComboBox.Items.Clear()
        Me.WeightColumnComboBox.Items.Clear()
        Me.SamplePopColumnComboBox.Text = Nothing
        Me.WeightColumnComboBox.Text = Nothing


        For Each item As String In mColumns
            Me.SamplePopColumnComboBox.Items.Add(item)
            Me.WeightColumnComboBox.Items.Add(item)

            If item.ToUpper = My.Settings.DefaultSamplePopColumnName.ToUpper Then
                Me.SamplePopColumnComboBox.SelectedItem = item
            End If

            If item.ToUpper = My.Settings.DefaultWeightColumnName.ToUpper Then
                Me.WeightColumnComboBox.SelectedItem = item
            End If
        Next
    End Sub

    Private Sub PopulateWeightTypesComboBox()
        Me.WeightTypeComboBox.Items.Clear()
        Me.WeightTypeComboBox.Text = Nothing
        If Me.mDataFile Is Nothing Then Exit Sub
        For Each type As WeightType In WeightType.GetWeightTypes
            Me.WeightTypeComboBox.Items.Add(type)
            Me.WeightTypeComboBox.ValueMember = "Name"
        Next
    End Sub

    Private Sub LoadWeightValue(ByVal replace As Boolean)
        Dim messages As Collection(Of String)
        Dim messageBoxText As String = ""

        Try
            Me.LoadWeightPanel.Cursor = Cursors.WaitCursor
            If replace Then
                messages = WeightType.LoadWeightValues(Me.mClientStudySurveyNavigator.SelectedStudies(0).Id, Me.mDataFile.GetReader(Me.SamplePopColumnComboBox.Text, Me.WeightColumnComboBox.Text), Me.SamplePopColumnComboBox.Text, Me.WeightColumnComboBox.Text, True, DirectCast(Me.WeightTypeComboBox.SelectedItem, WeightType).Id, CurrentUser.UserName)
            Else
                messages = WeightType.LoadWeightValues(Me.mClientStudySurveyNavigator.SelectedStudies(0).Id, Me.mDataFile.GetReader(Me.SamplePopColumnComboBox.Text, Me.WeightColumnComboBox.Text), Me.SamplePopColumnComboBox.Text, Me.WeightColumnComboBox.Text, False, DirectCast(Me.WeightTypeComboBox.SelectedItem, WeightType).Id, CurrentUser.UserName)
            End If

            For Each item As String In messages
                messageBoxText += item & vbCrLf
            Next

            MessageBox.Show(messageBoxText, "Load Complete", MessageBoxButtons.OK)
        Catch ex As NRC.Framework.Data.SqlCommandException
            Dim sqlEx As SqlClient.SqlException = DirectCast(ex.InnerException, SqlClient.SqlException)
            If sqlEx.Number = 50013 Then
                MessageBox.Show("Weights were not loaded because weights already exist for some samplepops in the database." + vbCrLf + "Please correct the file or choose load and replace", "Loading Error", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Else
                Main.ReportException(ex)
            End If
        Finally
            Me.LoadWeightPanel.Cursor = Cursors.Default
        End Try
    End Sub

    Private Sub ToggleLoadButtonEnabled()
        Me.LoadToolStripSplitButton.Enabled = (Me.mDataFile IsNot Nothing AndAlso Me.WeightTypeComboBox.SelectedItem IsNot Nothing AndAlso Me.SamplePopColumnComboBox.SelectedItem IsNot Nothing AndAlso Me.WeightColumnComboBox.SelectedItem IsNot Nothing)
    End Sub

    Private Sub ToggleWeightLoadingControlsEnabled()
        Me.WeightTypeComboBox.Enabled = (Me.mDataFile IsNot Nothing)
        Me.SamplePopColumnComboBox.Enabled = (Me.mDataFile IsNot Nothing)
        Me.WeightColumnComboBox.Enabled = (Me.mDataFile IsNot Nothing)
        Me.SamplePopColumnLabel.Enabled = (Me.mDataFile IsNot Nothing)
        Me.WeightColumnLabel.Enabled = (Me.mDataFile IsNot Nothing)
        Me.WeightTypeLabel.Enabled = (Me.mDataFile IsNot Nothing)
        Me.PreviewDataGrid.Enabled = (Me.mDataFile IsNot Nothing)
        Me.FootnoteLabel.Enabled = (Me.mDataFile IsNot Nothing)
        Me.PreviewGroupBox.Enabled = (Me.mDataFile IsNot Nothing)
        ToggleLoadButtonEnabled()
    End Sub
#End Region

#Region "Event Handlers"
    Private Sub OpenButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OpenButton.Click
        Dim path As String
        Try
            'Get the selected file path
            If Me.OpenWeightsFileDialog.ShowDialog() = DialogResult.OK Then
                path = Me.OpenWeightsFileDialog.FileName
                If System.IO.File.Exists(path) Then
                    My.Settings.LastImportPath = System.IO.Path.GetDirectoryName(path)
                Else
                    MessageBox.Show("The file path is invalid.", "Invalid Path", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Exit Sub
                End If
            Else : Exit Sub
            End If

            Me.LoadWeightPanel.Cursor = Cursors.WaitCursor

            mDataFile = New ExternalDataFile(path, ExternalDataFile.SupportedFileType.dbf, PreviewRows)
        Catch ex As Exception
            Me.LoadWeightPanel.Cursor = Cursors.Default
            Main.ReportException(ex)
            Exit Sub
        End Try

        Me.PopulatePreviewGrid()
        Me.PopulateColumnsLists()
        Me.PopulateColumnComboBoxes()
        Me.PopulateWeightTypesComboBox()
        ToggleWeightLoadingControlsEnabled()

        Me.LoadWeightPanel.Cursor = Cursors.Default
    End Sub

    Private Sub mClientStudySurveyNavigator_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles mClientStudySurveyNavigator.SelectionChanged
        If mClientStudySurveyNavigator.SelectedStudies.Count = 1 Then
            Me.LoadWeightPanel.Enabled = True
        Else : Me.LoadWeightPanel.Enabled = False
        End If
    End Sub

    Private Sub WeightsLoaderSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.OpenWeightsFileDialog.InitialDirectory = My.Settings.LastImportPath
        ToggleWeightLoadingControlsEnabled()
    End Sub


    Private Sub LoadToolStripSplitButton_ButtonClick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LoadToolStripSplitButton.ButtonClick
        LoadWeightValue(False)
    End Sub

    Private Sub LoadToolStripMenuItem_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles LoadToolStripMenuItem.Click
        LoadWeightValue(False)
    End Sub

    Private Sub LoadAndReplaceToolStripMenuItem_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles LoadAndReplaceToolStripMenuItem.Click
        LoadWeightValue(True)
    End Sub

    Private Sub SamplePopColumnComboBox_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles SamplePopColumnComboBox.SelectedIndexChanged
        ToggleLoadButtonEnabled()
    End Sub

    Private Sub WeightColumnComboBox_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles WeightColumnComboBox.SelectedIndexChanged
        ToggleLoadButtonEnabled()
    End Sub

    Private Sub WeightTypeComboBox_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles WeightTypeComboBox.SelectedIndexChanged
        ToggleLoadButtonEnabled()
    End Sub
#End Region
End Class
