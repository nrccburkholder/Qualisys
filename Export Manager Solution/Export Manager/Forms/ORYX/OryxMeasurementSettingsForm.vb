Imports Nrc.DataMart.Library.ORYX

Public Class OryxMeasurementSettingsForm

    Private CSettings As OryxClientSettings
    Private MSettings As OryxMeasurementSettings
    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        CSettings = New OryxClientSettings()
        MSettings = New OryxMeasurementSettings()
    End Sub
    Private Sub OryxMeasurementSettings_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        RefreshMeasurementList()
    End Sub
    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Close()
    End Sub
    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        MSettings.SaveChanges()
        Close()
    End Sub
    Private Sub btnApply_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnApply.Click
        MSettings.SaveChanges()
        LoadMeasurementQuestions(Convert.ToInt32(cbMeasurements.SelectedItem))
        If (IsNumeric(txtQstnCore.Text)) Then
            LoadScale(Convert.ToInt32(txtQstnCore.Text))
        End If
    End Sub
    Private Sub btnAddQuestion_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAddQuestion.Click
        MSettings.AddQuestion(Convert.ToInt32(txtQstnCore.Text))
        LoadMeasurementQuestions(Convert.ToInt32(cbMeasurements.SelectedItem))
    End Sub
    Private Sub btnRemoveQuestion_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRemoveQuestion.Click
        If lbSelectedQuestions.SelectedItem IsNot Nothing Then
            MSettings.RemoveQuestion(Convert.ToInt32(lbSelectedQuestions.SelectedItem))
            LoadMeasurementQuestions(Convert.ToInt32(cbMeasurements.SelectedItem))
        End If
    End Sub
    Private Sub btnAddMeasurement_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAddMeasurement.Click
        Dim x As AddOryxMeasurement = New AddOryxMeasurement(CSettings)
        x.ShowDialog()
        If x.DialogResult = Windows.Forms.DialogResult.OK Then
            RefreshMeasurementList()
        End If
    End Sub
    Private Sub cbMeasurements_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cbMeasurements.SelectedIndexChanged
        CheckNeedSave()
        LoadMeasurementQuestions(Convert.ToInt32(cbMeasurements.SelectedItem))
    End Sub
    Private Sub tbQstnCore_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtQstnCore.TextChanged
        CheckNeedScaleSave()
        CheckQuestionIDLength()
        If Not txtQstnCore.Text = String.Empty Then
            Dim questionID As Integer = Convert.ToInt32(txtQstnCore.Text)
            If lbSelectedQuestions.Items.Contains(questionID) Then
                lbSelectedQuestions.SelectedItem = questionID
            Else
                lbSelectedQuestions.ClearSelected()
            End If
            LoadQuestion(questionID)
        End If
    End Sub
    Private Sub CheckQuestionIDLength()
        If txtQstnCore.Text.Length > 9 Then
            txtQstnCore.Text = txtQstnCore.Text.Substring(0, 9)
            txtQstnCore.SelectionStart = 0
            txtQstnCore.SelectionLength = 9
        End If
    End Sub
    Private Sub lbSelectedQuestions_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lbSelectedQuestions.SelectedIndexChanged
        CheckNeedScaleSave()
        If lbSelectedQuestions.SelectedItem Is Nothing Then
            If txtQstnCore.Text = String.Empty Then
                ClearQuestionDetails()
            End If
        Else
            txtQstnCore.Text = lbSelectedQuestions.SelectedItem.ToString()
        End If
    End Sub
    Private Sub RefreshMeasurementList()
        cbMeasurements.DataSource = Nothing
        cbMeasurements.DataSource = CSettings.AllOryxMeasurements(True)
    End Sub
    Private Sub LoadMeasurementQuestions(ByVal MeasureID As Int32)
        lbSelectedQuestions.DataSource = Nothing
        lbSelectedQuestions.DataSource = MSettings.GetQuestionsByMeasure(MeasureID)
        If lbSelectedQuestions.SelectedIndex > -1 Then
            txtQstnCore.Text = lbSelectedQuestions.SelectedItem.ToString()
        Else
            txtQstnCore.Text = String.Empty
            lbQuestionText.Items.Clear()
            grdMapping.DataSource = Nothing
        End If
    End Sub
    Private Sub LoadQuestion(ByVal QstnCore As Int32)
        Cursor = Cursors.WaitCursor
        Try
            Dim none As Boolean = False
            lbQuestionText.Items.Clear()
            Dim Texts As List(Of String) = MSettings.GetQuestionText(QstnCore)
            If Texts.Count = 0 Then
                Texts.Add("This question core has not been used on any surveys.")
                none = True
            End If
            For Each q As String In Texts
                lbQuestionText.Items.Add(q)
            Next
            lbQuestionText.Font = New Font(lbQuestionText.Font, CType(IIf(none, FontStyle.Bold, FontStyle.Regular), FontStyle))
            LoadScale(QstnCore)
        Finally
            Cursor = Cursors.Default
        End Try
    End Sub
    Private Sub ClearQuestionDetails()
        txtQstnCore.Text = String.Empty
        lbQuestionText.Items.Clear()
        grdMapping.DataSource = Nothing
    End Sub
    Private Sub LoadScale(ByVal QstnCore As Int32)
        grdMapping.DataSource = Nothing
        grdMapping.AutoGenerateColumns = False
        grdMapping.DataSource = MSettings.GetQuestionScale(QstnCore)
    End Sub
    Public Sub CheckNeedScaleSave()
        If MSettings.NeedScaleSaved Then
            If GetSaveConfirmation() Then
                MSettings.SaveScaleChanges()
            Else
                MSettings.AbandonScaleChanges()
            End If
        End If
    End Sub
    Private Sub CheckNeedSave()
        If MSettings.NeedSaved Then
            If GetSaveConfirmation() Then
                MSettings.SaveChanges()
            Else
                MSettings.AbandonChangesAndRefresh()
            End If
        End If
    End Sub
    Private Shared Function GetSaveConfirmation() As Boolean
        Return MessageBox.Show("Do you want to save your changes?", _
                            "Save Changes", _
                            MessageBoxButtons.YesNo, _
                            MessageBoxIcon.Question, _
                            MessageBoxDefaultButton.Button1) = Windows.Forms.DialogResult.Yes
    End Function
    Private Sub grdMapping_CellValueChanged(ByVal sender As System.Object, ByVal e As System.Windows.Forms.DataGridViewCellEventArgs) Handles grdMapping.CellValueChanged
        If (grdMapping.DataSource IsNot Nothing) _
        AndAlso (e.ColumnIndex = grdMapping.Columns.IndexOf(grdMapping.Columns("ORYXValue"))) Then
            Dim ScaleValue As Int32 = Convert.ToInt32(grdMapping.Rows(e.RowIndex).Cells("NRCValue").Value)
            Dim NewValue As Nullable(Of Int32)
            If grdMapping.Rows(e.RowIndex).Cells("ORYXValue").Value Is System.DBNull.Value Then
                NewValue = Nothing
            Else
                NewValue = Convert.ToInt32(grdMapping.Rows(e.RowIndex).Cells("ORYXValue").Value)
            End If
            MSettings.EditQuestionMapping(Convert.ToInt32(txtQstnCore.Text), ScaleValue, NewValue)
        End If
    End Sub

    Private Sub txtQstnCore_KeyDown(ByVal sender As System.Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles txtQstnCore.KeyDown

        e.SuppressKeyPress = Not ((e.KeyValue >= 46 AndAlso e.KeyValue <= 58) Or (e.KeyValue >= 96 AndAlso e.KeyValue <= 105) Or e.KeyValue = 8 Or e.KeyValue = 37 Or e.KeyValue = 39)
    End Sub
End Class