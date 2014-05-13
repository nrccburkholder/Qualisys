Imports Nrc.DataMart.Library.ORYX

Partial Public Class OryxClientSettingsForm

    Private Settings As OryxClientSettings
    Private Sub OryxClientSettings_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Settings = New OryxClientSettings()
        LoadOryxClients()
        LoadAllMeasurements()
    End Sub
    Private Sub cbClient_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cbClient.SelectedIndexChanged
        CheckNeedSave()
        RefreshSettings()
    End Sub
    Private Sub btnAddClient_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAddClient.Click
        CheckNeedSave()
        Dim f As New AddOryxClient(Settings)
        f.ShowDialog()
        LoadOryxClients()
    End Sub
    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Close()
    End Sub
    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        Save()
        Close()
    End Sub
    Private Sub btnApply_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnApply.Click
        Save()
    End Sub
    Private Sub btnAddMeasure_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAddMeasure.Click
        If Not lbAllMeasures.SelectedItem Is Nothing Then
            Settings.AddMeasurement(Convert.ToInt32(lbAllMeasures.SelectedItem))
            RefreshSettings()
        End If
    End Sub
    Private Sub btnRemoveMeasure_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRemoveMeasure.Click
        If Not lbSelectedMeasures.SelectedItem Is Nothing Then
            Settings.RemoveMeasurement(Convert.ToInt32(lbSelectedMeasures.SelectedItem))
            RefreshSettings()
        End If
    End Sub

    Private Sub LoadOryxClients()
        cbClient.DataSource = Nothing
        cbClient.DisplayMember = "Value"
        cbClient.ValueMember = "Key"
        Dim AllOryxClients As Dictionary(Of Int32, String) = Settings.AllOryxClients(True)
        If AllOryxClients.Count > 0 Then
            cbClient.DataSource = New BindingSource(AllOryxClients, Nothing)
        End If
    End Sub
    Private Sub RefreshSettings()
        LoadClientMeasurements()
        LoadAllMeasurements()
        lblHCOID.Text = "HCOID: " + Settings.SelectedHCOID.ToString()
        btnApply.Enabled = Settings.NeedSaved
    End Sub
    Private Sub CheckNeedSave()
        If Settings.NeedSaved Then
            If MessageBox.Show("Do you want to save your changes?", _
                    "Save Changes", _
                    MessageBoxButtons.YesNo, _
                    MessageBoxIcon.Question, _
                    MessageBoxDefaultButton.Button1) = Windows.Forms.DialogResult.Yes Then
                Settings.SaveChanges()
            End If
        End If
    End Sub
    Private Sub LoadAllMeasurements()
        lbAllMeasures.DataSource = Nothing
        lbAllMeasures.DataSource = Settings.AllOryxMeasurements(False)
    End Sub
    Private Sub LoadClientMeasurements()
        lbSelectedMeasures.DataSource = Nothing
        lbSelectedMeasures.DataSource = Settings.HCOMeasurements(Convert.ToInt32(cbClient.SelectedValue))
    End Sub
    Private Sub Save()
        Settings.SaveChanges()
        RefreshSettings()
    End Sub

End Class