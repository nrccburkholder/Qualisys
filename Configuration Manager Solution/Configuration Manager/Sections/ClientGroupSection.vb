Imports Nrc.Qualisys.Library

Public Class ClientGroupSection

#Region " Private Fields "

    Private mModule As ClientGroupPropertiesModule
    Private mEndConfigCallBack As EndConfigCallBackMethod

#End Region

#Region " Constructors "

    Public Sub New(ByVal clientGroupModule As ClientGroupPropertiesModule, ByVal endConfigCallBack As EndConfigCallBackMethod)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.mModule = clientGroupModule
        Me.mEndConfigCallBack = endConfigCallBack
    End Sub

#End Region

#Region " Event Handlers "

    Private Sub ClientGroupSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        DisplayData()
        Me.ClientGroupNameTextBox.Focus()

    End Sub

    Private Sub OKButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles OKButton.Click

        If (Not CheckValues()) Then Exit Sub

        SaveValues()

        Me.mEndConfigCallBack(ConfigResultActions.ClientGroupRefresh, Nothing)
        Me.mEndConfigCallBack = Nothing
    End Sub

    Private Sub CancelButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles CancelButton.Click
        Me.mEndConfigCallBack(ConfigResultActions.None, Nothing)
        Me.mEndConfigCallBack = Nothing
    End Sub

#End Region

#Region " Private Methods "

    Private Sub DisplayData()

        'Information bar
        Me.InformationBar.Information = Me.mModule.Information
        Me.ClientGroupNameTextBox.Text = Me.mModule.ClientGroup.Name
        Me.ClientGroupReportNameTextBox.Text = Me.mModule.ClientGroup.ReportName
        Me.ClientGroupInActivateCheckBox.Checked = Not Me.mModule.ClientGroup.IsActive

        'Disable all the fields when viewing properties
        Me.WorkAreaPanel.Enabled = Me.mModule.IsEditable
        Me.OKButton.Enabled = Me.mModule.IsEditable

    End Sub

    Private Sub SaveValues()

        With Me.mModule.ClientGroup
            .Name = Me.ClientGroupNameTextBox.Text
            .ReportName = Me.ClientGroupReportNameTextBox.Text
            .IsActive = Not Me.ClientGroupInActivateCheckBox.Checked
        End With

    End Sub

    Private Function CheckValues() As Boolean

        Dim message As String = String.Empty

        If Me.ClientGroupNameTextBox.Text.Trim = String.Empty Then
            message += String.Concat(vbTab, "Client Group Name is required!", vbCrLf)
        End If

        If message <> String.Empty Then
            MessageBox.Show(String.Concat("Unable to save study. Please correct the following error(s):", vbCrLf, message), "Save Client Group", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        Else
            Return True
        End If

    End Function
#End Region

End Class
