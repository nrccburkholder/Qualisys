Imports Nrc.DataMart.Library.ORYX
Public Class AddOryxClient
    Private Settings As OryxClientSettings
    Public Sub New(ByVal Settings As OryxClientSettings)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.Settings = Settings
    End Sub
    Private Sub AddOryxClient_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        cbClient.ValueMember = "Key"
        cbClient.DisplayMember = "Value"
        cbClient.DataSource = New BindingSource(Settings.AllNonOryxClients, Nothing)
    End Sub

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        If (Not cbClient.SelectedValue Is Nothing) AndAlso Microsoft.VisualBasic.IsNumeric(tbHCOID.Text) Then
            If Not Settings.AddOryxClient(Convert.ToInt32(tbHCOID.Text), Convert.ToInt32(cbClient.SelectedValue)) Then
                MessageBox.Show("There was a conflict with an existing ORYX client.  Client not added.", "Client not added!", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
                DialogResult = Windows.Forms.DialogResult.None
            Else
                DialogResult = Windows.Forms.DialogResult.OK
            End If
        End If
    End Sub
End Class