Imports Nrc.DataMart.Library.ORYX
Public Class AddOryxMeasurement

    Private Settings As OryxClientSettings
    Public Sub New(ByVal Settings As OryxClientSettings)
        InitializeComponent()
        Me.Settings = Settings
    End Sub
    Private Sub Button2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        DialogResult = Windows.Forms.DialogResult.Cancel
        Close()
    End Sub

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        If Settings.AllOryxMeasurements(True).Contains(Convert.ToInt32(txtMeasure.Text)) Then
            MessageBox.Show(String.Format("Measurement {0} already exists.", txtMeasure.Text), "Duplicate Measurement", MessageBoxButtons.OK, MessageBoxIcon.Hand)
        Else
            OryxMeasurementSettings.CreateNewMeasurement(Convert.ToInt32(txtMeasure.Text))
            DialogResult = Windows.Forms.DialogResult.OK
            Close()
        End If
    End Sub
End Class