Imports Nrc.Qualisys.Library

Public Class ClientSection

#Region " Private Fields "

    Private mModule As ClientPropertiesModule
    Private mEndConfigCallBack As EndConfigCallBackMethod
    Private mIsLoading As Boolean
    Private mReinstating As Boolean
    Private mClientGroupSelectedIndex As Integer

#End Region

#Region " Constructors "

    Public Sub New(ByVal clientModule As ClientPropertiesModule, ByVal endConfigCallBack As EndConfigCallBackMethod)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.mModule = clientModule
        Me.mEndConfigCallBack = endConfigCallBack
    End Sub

#End Region

#Region " Event Handlers "

    Private Sub ClientSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        DisplayData()
        Me.ClientNameTextBox.Focus()

    End Sub

    Private Sub OKButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles OKButton.Click

        If (Not CheckValues()) Then Exit Sub

        SaveValues()

        Me.mEndConfigCallBack(ConfigResultActions.ClientRefresh, Nothing)
        Me.mEndConfigCallBack = Nothing
    End Sub

    Private Sub CancelButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles CancelButton.Click
        Me.mEndConfigCallBack(ConfigResultActions.None, Nothing)
        Me.mEndConfigCallBack = Nothing
    End Sub

#End Region

#Region " Private Methods "

    Private Sub DisplayData()

        mIsLoading = True

        'Information bar
        Me.InformationBar.Information = Me.mModule.Information

        Me.ClientNameTextBox.Text = Me.mModule.Client.Name

        'Get Client group list
        Me.ClientGroupBindingSource.DataSource = ClientGroup.GetAll
        Dim unassigned As New ClientGroup
        Dim privateInterface As IClientGroup = unassigned
        privateInterface.Id = -1
        unassigned.Name = "{Unassigned}"
        Me.ClientGroupBindingSource.Insert(0, unassigned)

        Me.ClientGroupComboBox.DataSource = Me.ClientGroupBindingSource
        Me.ClientGroupComboBox.DisplayMember = "DisplayStatusLabel"
        Me.ClientGroupComboBox.ValueMember = "Id"
        Me.ClientGroupComboBox.SelectedValue = Me.mModule.Client.ClientGroupID

        Me.ClientInActivateCheckBox.Checked = Not Me.mModule.Client.IsActive

        'Disable all the fields when viewing properties
        Me.WorkAreaPanel.Enabled = Me.mModule.IsEditable
        Me.OKButton.Enabled = Me.mModule.IsEditable

        mIsLoading = False

    End Sub

    Private Sub SaveValues()

        With Me.mModule.Client
            .Name = Me.ClientNameTextBox.Text
            .ClientGroupID = CInt(Me.ClientGroupComboBox.SelectedValue)
            .IsActive = Not Me.ClientInActivateCheckBox.Checked
        End With

    End Sub

    Private Function CheckValues() As Boolean

        Dim message As String = String.Empty

        If Me.ClientNameTextBox.Text.Trim = String.Empty Then
            message += String.Concat(vbTab, "Client Name is required!", vbCrLf)
        End If

        If message <> String.Empty Then
            MessageBox.Show(String.Concat("Unable to save study. Please correct the following error(s):", vbCrLf, message), "Save Client", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        Else
            Return True
        End If

    End Function
#End Region

    Private Sub ClientGroupComboBox_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ClientGroupComboBox.SelectedIndexChanged

        If Not mIsLoading Then
            If mReinstating Then
                Me.ClientGroupComboBox.SelectedIndex = mClientGroupSelectedIndex
            End If
        End If
        mClientGroupSelectedIndex = Me.ClientGroupComboBox.SelectedIndex

    End Sub

    Private Sub ClientGroupComboBox_SelectionChangeCommitted(ByVal sender As Object, ByVal e As System.EventArgs) Handles ClientGroupComboBox.SelectionChangeCommitted

        mReinstating = False
        If Not mIsLoading Then
            Dim clientGroup As ClientGroup = clientGroup.GetClientGroup(CInt(Me.ClientGroupComboBox.SelectedValue))
            If Not clientGroup.IsActive Then
                If MessageBox.Show("You are about to assign this client to an inactive Client Group. Are you sure you wish to do this?", "Client Group Change", MessageBoxButtons.YesNo, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button2) = DialogResult.No Then
                    mReinstating = True
                End If
            End If
        End If

    End Sub
End Class
